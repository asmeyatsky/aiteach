import pytest
from app.tests.conftest import get_auth_headers

def test_create_user(client):
    response = client.post(
        "/users/register",
        json={
            "username": "testuser",
            "email": "test@example.com",
            "password": "password123"
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["username"] == "testuser"
    assert data["email"] == "test@example.com"
    assert "id" in data
    assert "created_at" in data

def test_create_existing_user(client):
    client.post(
        "/users/register",
        json={
            "username": "testuser",
            "email": "test@example.com",
            "password": "password123"
        },
    )
    response = client.post(
        "/users/register",
        json={
            "username": "testuser",
            "email": "test@example.com",
            "password": "password123"
        },
    )
    assert response.status_code == 400
    assert response.json() == {"detail": "Email already registered"}

def test_login_user(client):
    client.post(
        "/users/register",
        json={
            "username": "testuser",
            "email": "test@example.com",
            "password": "password123"
        },
    )
    response = client.post(
        "/users/login",
        json={
            "username": "testuser",
            "password": "password123"
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["token_type"] == "bearer"
    assert "user_id" in data

def test_login_incorrect_password(client):
    client.post(
        "/users/register",
        json={
            "username": "testuser",
            "email": "test@example.com",
            "password": "password123"
        },
    )
    response = client.post(
        "/users/login",
        json={
            "username": "testuser",
            "password": "wrongpassword"
        },
    )
    assert response.status_code == 401
    assert response.json() == {"detail": "Incorrect username or password"}

def test_login_non_existent_user(client):
    response = client.post(
        "/users/login",
        json={
            "username": "nonexistent",
            "password": "password123"
        },
    )
    assert response.status_code == 401
    assert response.json() == {"detail": "Incorrect username or password"}

def test_get_current_user(client):
    headers, user_id = get_auth_headers(client)
    response = client.get("/users/me", headers=headers)
    assert response.status_code == 200
    data = response.json()
    assert data["username"] == "testuser"

def test_delete_own_user(client):
    headers, user_id = get_auth_headers(client)
    response = client.delete("/users/username/testuser", headers=headers)
    assert response.status_code == 200

def test_delete_other_user_forbidden(client):
    headers, user_id = get_auth_headers(client)
    # Try to delete a different user
    client.post("/users/register", json={
        "username": "otheruser",
        "email": "other@example.com",
        "password": "password123",
    })
    response = client.delete("/users/username/otheruser", headers=headers)
    assert response.status_code == 403
