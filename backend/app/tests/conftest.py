import os

# Set testing environment variables before importing app
os.environ["TESTING"] = "True"
os.environ["DEBUG"] = "True"

from fastapi.testclient import TestClient
from app.main import app
from app.infrastructure.database import get_db
from app.infrastructure.repositories.orm.base import Base
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool
import pytest

# Use in-memory SQLite for tests
SQLALCHEMY_DATABASE_URL = "sqlite://"
engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture(name="db_session")
def db_session_fixture():
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)
    session = TestingSessionLocal()
    yield session
    session.close()
    Base.metadata.drop_all(bind=engine)

@pytest.fixture(name="client")
def client_fixture(db_session):
    def override_get_db():
        yield db_session
    app.dependency_overrides[get_db] = override_get_db
    yield TestClient(app)
    app.dependency_overrides.clear()

def get_auth_headers(client, username="testuser", email="test@example.com", password="password123"):
    """Register a user and return auth headers with a valid JWT token."""
    client.post("/users/register", json={
        "username": username,
        "email": email,
        "password": password,
    })
    resp = client.post("/users/login", json={
        "username": username,
        "password": password,
    })
    token = resp.json()["access_token"]
    user_id = resp.json()["user_id"]
    return {"Authorization": f"Bearer {token}"}, user_id
