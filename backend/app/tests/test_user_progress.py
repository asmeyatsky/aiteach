import pytest
from app.tests.conftest import get_auth_headers

def test_get_user_progress_nonexistent_user(client):
    headers, user_id = get_auth_headers(client)
    # Try to access progress for a different user - should be forbidden
    response = client.get("/progress/users/999999/progress", headers=headers)
    assert response.status_code == 403

def test_get_user_progress_empty(client):
    headers, user_id = get_auth_headers(client, username="progressuser", email="progress@example.com")

    response = client.get(f"/progress/users/{user_id}/progress", headers=headers)
    assert response.status_code == 200
    assert response.json() == []

def test_mark_same_lesson_complete_twice(client):
    headers, user_id = get_auth_headers(client, username="duplicateuser", email="duplicate@example.com")

    create_course_response = client.post(
        "/courses/",
        json={
            "title": "Course for Duplicate Completion",
            "description": "Course for testing duplicate completion.",
            "tier": "user",
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

    first_response = client.post(f"/courses/lessons/{lesson_id}/complete", headers=headers)
    assert first_response.status_code == 200

    second_response = client.post(f"/courses/lessons/{lesson_id}/complete", headers=headers)
    assert second_response.status_code == 400
