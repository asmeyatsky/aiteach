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
    # Register a user for testing gamification functionalities
    user_data = {
        "username": "gameuser",
        "email": "game@example.com",
        "password": "password123"
    }
    client.post("/users/register", json=user_data)
    return user_data

def test_create_badge(client):
    response = client.post(
        "/gamification/badges/",
        json={
            "name": "First Steps",
            "description": "Completed your first lesson.",
            "icon_url": "http://example.com/badge1.png"
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "First Steps"
    assert "id" in data

def test_get_badges(client):
    # Create a badge first
    client.post(
        "/gamification/badges/",
        json={
            "name": "Another Badge",
            "description": "Earned another badge.",
            "icon_url": "http://example.com/badge2.png"
        },
    )
    response = client.get("/gamification/badges/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert data[0]["name"] == "Another Badge"

def test_create_user_badge(client, registered_user):
    # Create a badge
    create_badge_response = client.post(
        "/gamification/badges/",
        json={
            "name": "New Badge",
            "description": "A new badge for a user.",
            "icon_url": "http://example.com/new_badge.png"
        },
    )
    badge_id = create_badge_response.json()["id"]

    # Get the user ID (hardcoded to 1 for now, will be dynamic with auth)
    user_id = 1 # Assuming the registered_user has ID 1 in the test db

    response = client.post(
        "/gamification/user_badges/",
        json={
            "user_id": user_id,
            "badge_id": badge_id
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["user_id"] == user_id
    assert data["badge_id"] == badge_id
    assert "id" in data
    assert "awarded_at" in data

def test_get_user_badges(client, registered_user):
    # Create a badge
    create_badge_response = client.post(
        "/gamification/badges/",
        json={
            "name": "User Specific Badge",
            "description": "Badge for a specific user.",
            "icon_url": "http://example.com/user_badge.png"
        },
    )
    badge_id = create_badge_response.json()["id"]

    # Get the user ID (hardcoded to 1 for now)
    user_id = 1

    # Award the badge to the user
    client.post(
        "/gamification/user_badges/",
        json={
            "user_id": user_id,
            "badge_id": badge_id
        },
    )

    response = client.get(f"/gamification/users/{user_id}/badges/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert data[0]["badge"]["name"] == "User Specific Badge"
