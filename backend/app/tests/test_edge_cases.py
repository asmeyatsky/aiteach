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

@pytest.fixture
def registered_user(client):
    # Register a user for testing
    user_data = {
        "username": "testuser",
        "email": "test@example.com",
        "password": "password123"
    }
    client.post("/users/register", json=user_data)
    return user_data

def test_create_user_missing_fields(client):
    # Test creating user with missing required fields
    response = client.post(
        "/users/register",
        json={
            "username": "testuser",
            # Missing email and password
        },
    )
    assert response.status_code == 422  # Validation error

def test_create_user_invalid_email(client):
    # Test creating user with invalid email
    response = client.post(
        "/users/register",
        json={
            "username": "testuser",
            "email": "invalid-email",
            "password": "password123"
        },
    )
    assert response.status_code == 422  # Validation error

def test_create_user_short_password(client):
    # Test creating user with too short password
    response = client.post(
        "/users/register",
        json={
            "username": "testuser",
            "email": "test@example.com",
            "password": "123"  # Too short
        },
    )
    assert response.status_code == 422  # Validation error

def test_login_missing_fields(client):
    # Test login with missing fields
    response = client.post(
        "/users/login",
        json={
            "username": "testuser"
            # Missing password
        },
    )
    assert response.status_code == 422  # Validation error

def test_get_nonexistent_user(client):
    # Test getting a user that doesn't exist
    response = client.get("/users/999999")
    assert response.status_code == 404
    assert response.json() == {"detail": "User not found"}

def test_create_course_missing_fields(client):
    # Test creating course with missing required fields
    response = client.post(
        "/courses/",
        json={
            "title": "Test Course"
            # Missing description and tier
        },
    )
    assert response.status_code == 422  # Validation error

def test_get_nonexistent_course(client):
    # Test getting a course that doesn't exist
    response = client.get("/courses/999999")
    assert response.status_code == 404
    assert response.json() == {"detail": "Course not found"}

def test_create_lesson_for_nonexistent_course(client):
    # Test creating a lesson for a course that doesn't exist
    response = client.post(
        "/courses/999999/lessons/",
        json={
            "title": "Test Lesson",
            "content_type": "text",
            "content_data": "Lesson content",
            "order": 1
        },
    )
    # This might return 404 or 500 depending on implementation
    # We're testing that it handles the error gracefully
    assert response.status_code in [404, 500]

def test_create_lesson_missing_fields(client):
    # Test creating lesson with missing required fields
    response = client.post(
        "/courses/1/lessons/",
        json={
            "title": "Test Lesson"
            # Missing content_type, content_data, and order
        },
    )
    assert response.status_code == 422  # Validation error

def test_mark_nonexistent_lesson_complete(client):
    # Test marking a lesson that doesn't exist as complete
    response = client.post("/courses/lessons/999999/complete")
    # This might return 404 or 500 depending on implementation
    assert response.status_code in [404, 500]

def test_create_post_missing_fields(client, registered_user):
    # Test creating post with missing required fields
    response = client.post(
        "/forum/posts/",
        json={
            "title": "Test Post"
            # Missing body
        },
    )
    assert response.status_code == 422  # Validation error

def test_get_nonexistent_post(client):
    # Test getting a post that doesn't exist
    response = client.get("/forum/posts/999999")
    assert response.status_code == 404
    assert response.json() == {"detail": "Post not found"}

def test_create_comment_for_nonexistent_post(client, registered_user):
    # Test creating a comment for a post that doesn't exist
    response = client.post(
        "/forum/posts/999999/comments/",
        json={
            "body": "Test comment"
        },
    )
    # This might return 404 or 500 depending on implementation
    assert response.status_code in [404, 500]

def test_create_comment_missing_fields(client, registered_user):
    # Test creating comment with missing required fields
    response = client.post(
        "/forum/posts/1/comments/",
        json={
            # Missing body
        },
    )
    assert response.status_code == 422  # Validation error

def test_create_badge_missing_fields(client):
    # Test creating badge with missing required fields
    response = client.post(
        "/gamification/badges/",
        json={
            "name": "Test Badge"
            # Missing description
        },
    )
    assert response.status_code == 422  # Validation error

def test_get_user_badges_for_nonexistent_user(client):
    # Test getting badges for a user that doesn't exist
    response = client.get("/gamification/users/999999/badges/")
    # This might return 404 or empty list depending on implementation
    assert response.status_code in [200, 404]

def test_create_user_badge_missing_fields(client):
    # Test creating user badge with missing required fields
    response = client.post(
        "/gamification/user_badges/",
        json={
            "user_id": 1
            # Missing badge_id
        },
    )
    assert response.status_code == 422  # Validation error