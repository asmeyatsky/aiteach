import pytest
from app.tests.conftest import get_auth_headers

def test_create_user_missing_fields(client):
    response = client.post(
        "/users/register",
        json={
            "username": "testuser",
        },
    )
    assert response.status_code == 422

def test_create_user_invalid_email(client):
    response = client.post(
        "/users/register",
        json={
            "username": "testuser",
            "email": "invalid-email",
            "password": "password123"
        },
    )
    assert response.status_code == 422

def test_create_user_short_password(client):
    response = client.post(
        "/users/register",
        json={
            "username": "testuser",
            "email": "test@example.com",
            "password": "123"
        },
    )
    assert response.status_code == 422

def test_login_missing_fields(client):
    response = client.post(
        "/users/login",
        json={
            "username": "testuser"
        },
    )
    assert response.status_code == 422

def test_get_nonexistent_user(client):
    response = client.get("/users/999999")
    assert response.status_code == 404
    assert response.json() == {"detail": "User not found"}

def test_create_course_missing_fields(client):
    response = client.post(
        "/courses/",
        json={
            "title": "Test Course"
        },
    )
    assert response.status_code == 422

def test_get_nonexistent_course(client):
    response = client.get("/courses/999999")
    assert response.status_code == 404
    assert response.json() == {"detail": "Course not found"}

def test_create_lesson_for_nonexistent_course(client):
    response = client.post(
        "/courses/999999/lessons/",
        json={
            "title": "Test Lesson",
            "content_type": "text",
            "content_data": "Lesson content",
            "order": 1
        },
    )
    assert response.status_code in [404, 500]

def test_create_lesson_missing_fields(client):
    response = client.post(
        "/courses/1/lessons/",
        json={
            "title": "Test Lesson"
        },
    )
    assert response.status_code == 422

def test_mark_nonexistent_lesson_complete(client):
    headers, user_id = get_auth_headers(client)
    response = client.post("/courses/lessons/999999/complete", headers=headers)
    assert response.status_code in [404, 500]

def test_create_post_missing_fields(client):
    headers, user_id = get_auth_headers(client, username="edgeuser", email="edge@example.com")
    response = client.post(
        "/forum/posts/",
        json={
            "title": "Test Post"
        },
        headers=headers,
    )
    assert response.status_code == 422

def test_get_nonexistent_post(client):
    response = client.get("/forum/posts/999999")
    assert response.status_code == 404
    assert response.json() == {"detail": "Post not found"}

def test_create_comment_for_nonexistent_post(client):
    headers, user_id = get_auth_headers(client, username="edgeuser2", email="edge2@example.com")
    response = client.post(
        "/forum/posts/999999/comments/",
        json={
            "body": "Test comment"
        },
        headers=headers,
    )
    assert response.status_code in [404, 500]

def test_create_comment_missing_fields(client):
    headers, user_id = get_auth_headers(client, username="edgeuser3", email="edge3@example.com")
    response = client.post(
        "/forum/posts/1/comments/",
        json={},
        headers=headers,
    )
    assert response.status_code == 422

def test_create_badge_missing_fields(client):
    response = client.post(
        "/gamification/badges/",
        json={
            "name": "Test Badge"
        },
    )
    assert response.status_code == 422

def test_get_user_badges_for_nonexistent_user(client):
    headers, user_id = get_auth_headers(client, username="edgeuser4", email="edge4@example.com")
    # Should be forbidden since you can only view your own badges
    response = client.get("/gamification/users/999999/badges/", headers=headers)
    assert response.status_code == 403

def test_create_user_badge_missing_fields(client):
    response = client.post(
        "/gamification/user_badges/",
        json={
            "user_id": 1
        },
    )
    assert response.status_code == 422
