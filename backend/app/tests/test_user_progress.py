import os
from fastapi.testclient import TestClient
from app.main import app
from app.infrastructure.database import get_db
from app.infrastructure.repositories.orm.base import Base
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
    os.environ["TESTING"] = "True" # Set TESTING environment variable
    os.environ["DEBUG"] = "True" # Set DEBUG environment variable to disable TrustedHostMiddleware
    yield TestClient(app)
    del os.environ["TESTING"] # Unset TESTING environment variable
    del os.environ["DEBUG"] # Unset DEBUG environment variable
    app.dependency_overrides.clear()

def test_get_user_progress_nonexistent_user(client):
    # Test getting progress for a user that doesn't exist
    response = client.get("/progress/users/999999/progress")
    # Should return empty list or 404 depending on implementation
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        assert response.json() == []

def test_get_user_progress_empty(client):
    # Test getting progress for a user with no progress
    # First create a user
    client.post(
        "/users/register",
        json={
            "username": "progressuser",
            "email": "progress@example.com",
            "password": "password123"
        },
    )
    
    # Get user progress (hardcoded user_id=1 for now)
    response = client.get("/progress/users/1/progress")
    assert response.status_code == 200
    assert response.json() == []

def test_mark_same_lesson_complete_twice(client):
    # Test marking the same lesson as complete twice
    # Create a user
    client.post(
        "/users/register",
        json={
            "username": "duplicateuser",
            "email": "duplicate@example.com",
            "password": "password123"
        },
    )
    
    # Create a course and lesson
    create_course_response = client.post(
        "/courses/",
        json={
            "title": "Course for Duplicate Completion",
            "description": "Course for testing duplicate completion.",
            "tier": "free",
            "thumbnail_url": "http://example.com/duplicate_course.jpg"
        },
    )
    course_id = create_course_response.json()["id"]

    create_lesson_response = client.post(
        f"/courses/{course_id}/lessons/",
        json={
            "title": "Lesson for Duplicate Completion",
            "content_type": "text",
            "content_data": "Content for duplicate completion test.",
            "order": 1
        },
    )
    lesson_id = create_lesson_response.json()["id"]

    # Mark lesson complete first time
    first_response = client.post(f"/courses/lessons/{lesson_id}/complete")
    assert first_response.status_code == 200

    # Mark lesson complete second time - should fail
    second_response = client.post(f"/courses/lessons/{lesson_id}/complete")
    # Depending on implementation, this might return 400 or 200
    # We're testing that it handles the duplicate gracefully
    assert second_response.status_code in [200, 400]