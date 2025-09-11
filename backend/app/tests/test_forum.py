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

@pytest.fixture
def registered_user(client):
    # Register a user for testing forum functionalities
    user_data = {
        "username": "forumuser",
        "email": "forum@example.com",
        "password": "password123"
    }
    client.post("/users/register", json=user_data)
    return user_data

def test_create_post(client, registered_user):
    response = client.post(
        "/forum/posts/",
        json={
            "title": "Test Post",
            "body": "This is the content of the test post."
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Test Post"
    assert data["body"] == "This is the content of the test post."
    assert "id" in data
    assert "user_id" in data
    assert "created_at" in data
    assert data["owner"]["username"] == "forumuser"

def test_get_posts(client, registered_user):
    # Create a post first
    client.post(
        "/forum/posts/",
        json={
            "title": "Another Post",
            "body": "Content of another post."
        },
    )
    response = client.get("/forum/posts/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert data[0]["title"] == "Another Post"

def test_get_single_post(client, registered_user):
    # Create a post first
    create_response = client.post(
        "/forum/posts/",
        json={
            "title": "Single Post",
            "body": "Content of a single post."
        },
    )
    post_id = create_response.json()["id"]
    response = client.get(f"/forum/posts/{post_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Single Post"

def test_create_comment(client, registered_user):
    # Create a post first
    create_post_response = client.post(
        "/forum/posts/",
        json={
            "title": "Post for Comment",
            "body": "This post will have comments."
        },
    )
    post_id = create_post_response.json()["id"]

    response = client.post(
        f"/forum/posts/{post_id}/comments/",
        json={
            "body": "This is a test comment."
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["body"] == "This is a test comment."
    assert "id" in data
    assert "post_id" in data
    assert "user_id" in data
    assert "created_at" in data
    assert data["owner"]["username"] == "forumuser"

def test_get_comments_by_post(client, registered_user):
    # Create a post and comments first
    create_post_response = client.post(
        "/forum/posts/",
        json={
            "title": "Post with Comments",
            "body": "This post has multiple comments."
        },
    )
    post_id = create_post_response.json()["id"]

    client.post(
        f"/forum/posts/{post_id}/comments/",
        json={
            "body": "Comment 1."
        },
    )
    client.post(
        f"/forum/posts/{post_id}/comments/",
        json={
            "body": "Comment 2."
        },
    )

    response = client.get(f"/forum/posts/{post_id}/comments/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 2
    assert data[0]["body"] == "Comment 1."
    assert data[1]["body"] == "Comment 2."
