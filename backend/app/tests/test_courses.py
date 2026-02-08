import pytest
from app.tests.conftest import get_auth_headers

def test_create_course(client):
    response = client.post(
        "/courses/",
        json={
            "title": "Test Course",
            "description": "This is a test course.",
            "tier": "user",
            "thumbnail_url": "http://example.com/thumbnail.jpg"
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Test Course"
    assert data["description"] == "This is a test course."
    assert data["tier"] == "user"
    assert "id" in data

def test_get_courses(client):
    client.post(
        "/courses/",
        json={
            "title": "Another Course",
            "description": "Another test course.",
            "tier": "builder",
            "thumbnail_url": "http://example.com/another_thumbnail.jpg"
        },
    )
    response = client.get("/courses/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert data[0]["title"] == "Another Course"

def test_get_single_course(client):
    create_response = client.post(
        "/courses/",
        json={
            "title": "Single Course",
            "description": "Single test course.",
            "tier": "user",
            "thumbnail_url": "http://example.com/single_thumbnail.jpg"
        },
    )
    course_id = create_response.json()["id"]
    response = client.get(f"/courses/{course_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Single Course"

def test_create_lesson(client):
    create_course_response = client.post(
        "/courses/",
        json={
            "title": "Course for Lesson",
            "description": "Course for lesson testing.",
            "tier": "user",
            "thumbnail_url": "http://example.com/lesson_course.jpg"
        },
    )
    course_id = create_course_response.json()["id"]

    response = client.post(
        f"/courses/{course_id}/lessons/",
        json={
            "title": "Test Lesson",
            "content_type": "text",
            "content_data": "Lesson content here.",
            "order": 1
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Test Lesson"
    assert data["course_id"] == course_id

def test_get_lessons_by_course(client):
    create_course_response = client.post(
        "/courses/",
        json={
            "title": "Course with Lessons",
            "description": "Course for lesson listing.",
            "tier": "user",
            "thumbnail_url": "http://example.com/lessons_course.jpg"
        },
    )
    course_id = create_course_response.json()["id"]

    client.post(
        f"/courses/{course_id}/lessons/",
        json={
            "title": "Lesson 1",
            "content_type": "text",
            "content_data": "Content 1.",
            "order": 1
        },
    )
    client.post(
        f"/courses/{course_id}/lessons/",
        json={
            "title": "Lesson 2",
            "content_type": "video",
            "content_data": "Video URL.",
            "order": 2
        },
    )

    response = client.get(f"/courses/{course_id}/lessons/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 2
    assert data[0]["title"] == "Lesson 1"
    assert data[1]["title"] == "Lesson 2"

def test_mark_lesson_complete(client):
    headers, user_id = get_auth_headers(client, username="completer", email="completer@example.com")

    create_course_response = client.post(
        "/courses/",
        json={
            "title": "Course for Completion",
            "description": "Course for completion testing.",
            "tier": "user",
            "thumbnail_url": "http://example.com/completion_course.jpg"
        },
    )
    course_id = create_course_response.json()["id"]

    create_lesson_response = client.post(
        f"/courses/{course_id}/lessons/",
        json={
            "title": "Completable Lesson",
            "content_type": "text",
            "content_data": "Content to complete.",
            "order": 1
        },
    )
    lesson_id = create_lesson_response.json()["id"]

    response = client.post(f"/courses/lessons/{lesson_id}/complete", headers=headers)
    assert response.status_code == 200
    data = response.json()
    assert data["lesson_id"] == lesson_id
    assert "completed_at" in data

def test_get_user_progress(client):
    headers, user_id = get_auth_headers(client, username="progressuser", email="progress@example.com")

    create_course_response = client.post(
        "/courses/",
        json={
            "title": "Course for Progress",
            "description": "Course for progress testing.",
            "tier": "user",
            "thumbnail_url": "http://example.com/progress_course.jpg"
        },
    )
    course_id = create_course_response.json()["id"]

    create_lesson_response = client.post(
        f"/courses/{course_id}/lessons/",
        json={
            "title": "Progress Lesson",
            "content_type": "text",
            "content_data": "Content for progress.",
            "order": 1
        },
    )
    lesson_id = create_lesson_response.json()["id"]

    client.post(f"/courses/lessons/{lesson_id}/complete", headers=headers)

    response = client.get(f"/progress/users/{user_id}/progress", headers=headers)
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert data[0]["lesson_id"] == lesson_id
