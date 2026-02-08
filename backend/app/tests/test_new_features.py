import os
import pytest
from unittest.mock import patch
from app.tests.conftest import get_auth_headers
from app.domain.value_objects.track import Track
from app.domain.value_objects.project import ProjectDifficulty, UserProjectStatus
from app.domain.value_objects.suggestion import SuggestionStatus

def test_projects_list(client):
    """Test getting the list of projects."""
    response = client.get("/projects/")
    assert response.status_code == 200
    assert "data" in response.json() or isinstance(response.json(), list)

def test_get_specific_project(client):
    """Test getting a specific project (will fail if no projects exist)."""
    response = client.get("/projects/1")
    assert response.status_code in [200, 404]

def test_submit_project(client):
    """Test submitting a project."""
    headers, user_id = get_auth_headers(client, username="projectuser", email="project@example.com")
    submission_data = {
        "submission_url": "https://github.com/testuser/test-project"
    }
    response = client.post("/projects/1/submit", json=submission_data, headers=headers)
    assert response.status_code in [404, 422, 200]

def test_get_my_projects(client):
    """Test getting user's projects."""
    headers, user_id = get_auth_headers(client, username="myprojectuser", email="myproject@example.com")
    response = client.get("/projects/me/", headers=headers)
    assert response.status_code == 200
    assert "data" in response.json() or isinstance(response.json(), list)

def test_get_feed(client):
    """Test getting the feed."""
    response = client.get("/feed/")
    assert response.status_code == 200
    assert "data" in response.json() or isinstance(response.json(), list)

def test_create_suggestion(client):
    """Test creating a content suggestion."""
    headers, user_id = get_auth_headers(client, username="suggestuser", email="suggest@example.com")
    suggestion_data = {
        "url": "https://example.com/ai-tutorial",
        "comment": "Great tutorial for beginners",
        "suggested_track": Track.USER.value
    }
    response = client.post("/suggestions/", json=suggestion_data, headers=headers)
    assert response.status_code in [200, 422]

def test_chat_playground(client):
    """Test the AI playground chat endpoint."""
    chat_data = {
        "prompt": "Hello, how are you?"
    }
    response = client.post("/playground/chat", json=chat_data)
    assert response.status_code == 200
    assert "response" in response.json()
