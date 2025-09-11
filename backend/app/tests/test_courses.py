from fastapi.testclient import TestClient
from app.main import app
from app.database import get_db, Base
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import pytest

# Setup a test database
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture(name="db_session")
def db_session_fixture():
    Base.metadata.create_all(bind=engine)
    yield TestingSessionLocal()
    Base.metadata.drop_all(bind=engine)

@pytest.fixture(name="client")
def client_fixture(db_session):
    def override_get_db():
        yield db_session
    app.dependency_overrides[get_db] = override_get_db
    yield TestClient(app)
    app.dependency_overrides.clear()

def test_create_course(client):
    response = client.post(
        "/courses/",
        json={
            "title": "Test Course",
            "description": "This is a test course.",
            "tier": "free",
            "thumbnail_url": "http://example.com/thumbnail.jpg"
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Test Course"
    assert data["description"] == "This is a test course."
    assert data["tier"] == "free"
    assert "id" in data

def test_get_courses(client):
    # Create a course first
    client.post(
        "/courses/",
        json={
            "title": "Another Course",
            "description": "Another test course.",
            "tier": "premium",
            "thumbnail_url": "http://example.com/another_thumbnail.jpg"
        },
    )
    response = client.get("/courses/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert data[0]["title"] == "Another Course"

def test_get_single_course(client):
    # Create a course first
    create_response = client.post(
        "/courses/",
        json={
            "title": "Single Course",
            "description": "Single test course.",
            "tier": "free",
            "thumbnail_url": "http://example.com/single_thumbnail.jpg"
        },
    )
    course_id = create_response.json()["id"]
    response = client.get(f"/courses/{course_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Single Course"

def test_create_lesson(client):
    # Create a course first
    create_course_response = client.post(
        "/courses/",
        json={
            "title": "Course for Lesson",
            "description": "Course for lesson testing.",
            "tier": "free",
            "thumbnail_url": "http://example.com/lesson_course.jpg"
        },
    )
    course_id = create_course_response.json()["id"]

    response = client.post(
        f"/courses/{course_id}/lessons/",
        json={
            "title": "Test Lesson",
            "content_type": "text",
            "content_data": "Lesson content here.",
            "order": 1
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Test Lesson"
    assert data["course_id"] == course_id

def test_get_lessons_by_course(client):
    # Create a course and lessons first
    create_course_response = client.post(
        "/courses/",
        json={
            "title": "Course with Lessons",
            "description": "Course for lesson listing.",
            "tier": "free",
            "thumbnail_url": "http://example.com/lessons_course.jpg"
        },
    )
    course_id = create_course_response.json()["id"]

    client.post(
        f"/courses/{course_id}/lessons/",
        json={
            "title": "Lesson 1",
            "content_type": "text",
            "content_data": "Content 1.",
            "order": 1
        },
    )
    client.post(
        f"/courses/{course_id}/lessons/",
        json={
            "title": "Lesson 2",
            "content_type": "video",
            "content_data": "Video URL.",
            "order": 2
        },
    )

    response = client.get(f"/courses/{course_id}/lessons/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 2
    assert data[0]["title"] == "Lesson 1"
    assert data[1]["title"] == "Lesson 2"

def test_mark_lesson_complete(client):
    # Create a user
    client.post(
        "/users/register",
        json={
            "username": "completer",
            "email": "completer@example.com",
            "password": "password123"
        },
    )
    # Create a course and lesson
    create_course_response = client.post(
        "/courses/",
        json={
            "title": "Course for Completion",
            "description": "Course for completion testing.",
            "tier": "free",
            "thumbnail_url": "http://example.com/completion_course.jpg"
        },
    )
    course_id = create_course_response.json()["id"]

    create_lesson_response = client.post(
        f"/courses/{course_id}/lessons/",
        json={
            "title": "Completable Lesson",
            "content_type": "text",
            "content_data": "Content to complete.",
            "order": 1
        },
    )
    lesson_id = create_lesson_response.json()["id"]

    response = client.post(f"/courses/lessons/{lesson_id}/complete")
    assert response.status_code == 200
    data = response.json()
    assert data["lesson_id"] == lesson_id
    assert "completed_at" in data

def test_get_user_progress(client):
    # Create a user
    client.post(
        "/users/register",
        json={
            "username": "progressuser",
            "email": "progress@example.com",
            "password": "password123"
        },
    )
    # Create a course and lesson
    create_course_response = client.post(
        "/courses/",
        json={
            "title": "Course for Progress",
            "description": "Course for progress testing.",
            "tier": "free",
            "thumbnail_url": "http://example.com/progress_course.jpg"
        },
    )
    course_id = create_course_response.json()["id"]

    create_lesson_response = client.post(
        f"/courses/{course_id}/lessons/",
        json={
            "title": "Progress Lesson",
            "content_type": "text",
            "content_data": "Content for progress.",
            "order": 1
        },
    )
    lesson_id = create_lesson_response.json()["id"]

    # Mark lesson complete
    client.post(f"/courses/lessons/{lesson_id}/complete")

    # Get user progress (hardcoded user_id=1 for now)
    response = client.get("/progress/users/1/progress")
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert data[0]["lesson_id"] == lesson_id
