import pytest
from app.tests.conftest import get_auth_headers

def test_create_post(client):
    headers, user_id = get_auth_headers(client, username="forumuser", email="forum@example.com")
    response = client.post(
        "/forum/posts/",
        json={
            "title": "Test Post",
            "body": "This is the content of the test post."
        },
        headers=headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Test Post"
    assert data["body"] == "This is the content of the test post."
    assert "id" in data
    assert "user_id" in data
    assert "created_at" in data
    assert data["owner"]["username"] == "forumuser"

def test_get_posts(client):
    headers, user_id = get_auth_headers(client, username="forumuser", email="forum@example.com")
    client.post(
        "/forum/posts/",
        json={
            "title": "Another Post",
            "body": "Content of another post."
        },
        headers=headers,
    )
    response = client.get("/forum/posts/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert data[0]["title"] == "Another Post"

def test_get_single_post(client):
    headers, user_id = get_auth_headers(client, username="forumuser", email="forum@example.com")
    create_response = client.post(
        "/forum/posts/",
        json={
            "title": "Single Post",
            "body": "Content of a single post."
        },
        headers=headers,
    )
    post_id = create_response.json()["id"]
    response = client.get(f"/forum/posts/{post_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Single Post"

def test_create_comment(client):
    headers, user_id = get_auth_headers(client, username="forumuser", email="forum@example.com")
    create_post_response = client.post(
        "/forum/posts/",
        json={
            "title": "Post for Comment",
            "body": "This post will have comments."
        },
        headers=headers,
    )
    post_id = create_post_response.json()["id"]

    response = client.post(
        f"/forum/posts/{post_id}/comments/",
        json={
            "body": "This is a test comment."
        },
        headers=headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["body"] == "This is a test comment."
    assert "id" in data
    assert "post_id" in data
    assert "user_id" in data
    assert "created_at" in data
    assert data["owner"]["username"] == "forumuser"

def test_get_comments_by_post(client):
    headers, user_id = get_auth_headers(client, username="forumuser", email="forum@example.com")
    create_post_response = client.post(
        "/forum/posts/",
        json={
            "title": "Post with Comments",
            "body": "This post has multiple comments."
        },
        headers=headers,
    )
    post_id = create_post_response.json()["id"]

    client.post(
        f"/forum/posts/{post_id}/comments/",
        json={"body": "Comment 1."},
        headers=headers,
    )
    client.post(
        f"/forum/posts/{post_id}/comments/",
        json={"body": "Comment 2."},
        headers=headers,
    )

    response = client.get(f"/forum/posts/{post_id}/comments/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 2
    assert data[0]["body"] == "Comment 1."
    assert data[1]["body"] == "Comment 2."

def test_create_post_without_auth(client):
    response = client.post(
        "/forum/posts/",
        json={
            "title": "Unauthorized Post",
            "body": "Should fail."
        },
    )
    assert response.status_code == 403
