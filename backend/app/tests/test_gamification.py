import pytest
from app.tests.conftest import get_auth_headers

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

def test_create_user_badge(client):
    headers, user_id = get_auth_headers(client, username="gameuser", email="game@example.com")

    create_badge_response = client.post(
        "/gamification/badges/",
        json={
            "name": "New Badge",
            "description": "A new badge for a user.",
            "icon_url": "http://example.com/new_badge.png"
        },
    )
    badge_id = create_badge_response.json()["id"]

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

def test_get_user_badges(client):
    headers, user_id = get_auth_headers(client, username="gameuser", email="game@example.com")

    create_badge_response = client.post(
        "/gamification/badges/",
        json={
            "name": "User Specific Badge",
            "description": "Badge for a specific user.",
            "icon_url": "http://example.com/user_badge.png"
        },
    )
    badge_id = create_badge_response.json()["id"]

    client.post(
        "/gamification/user_badges/",
        json={
            "user_id": user_id,
            "badge_id": badge_id
        },
    )

    response = client.get(f"/gamification/users/{user_id}/badges/", headers=headers)
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert data[0]["badge"]["name"] == "User Specific Badge"
