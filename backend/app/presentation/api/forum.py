from fastapi import APIRouter, Depends, HTTPException, Query
from typing import List
from app.application.dtos import forum as forum_dto
from app.domain.ports.repository_ports import ForumRepositoryPort
from app.dependencies import get_forum_repository
from app.infrastructure.auth import get_current_user

router = APIRouter()

@router.post("/posts/", response_model=forum_dto.ForumPost)
def create_post(post: forum_dto.ForumPostCreate, current_user: dict = Depends(get_current_user), forum_repo: ForumRepositoryPort = Depends(get_forum_repository)):
    user_id = current_user["user_id"]
    return forum_repo.create_post(post, user_id)

@router.get("/posts/", response_model=List[forum_dto.ForumPost])
def read_posts(skip: int = 0, limit: int = Query(default=20, le=100, ge=1), forum_repo: ForumRepositoryPort = Depends(get_forum_repository)):
    posts = forum_repo.get_posts(skip=skip, limit=limit)
    return posts

@router.get("/posts/{post_id}", response_model=forum_dto.ForumPost)
def read_post(post_id: int, forum_repo: ForumRepositoryPort = Depends(get_forum_repository)):
    db_post = forum_repo.get_post(post_id)
    if db_post is None:
        raise HTTPException(status_code=404, detail="Post not found")
    return db_post

@router.post("/posts/{post_id}/comments/", response_model=forum_dto.ForumComment)
def create_comment_for_post(
    post_id: int, comment: forum_dto.ForumCommentCreate, current_user: dict = Depends(get_current_user), forum_repo: ForumRepositoryPort = Depends(get_forum_repository)
):
    user_id = current_user["user_id"]
    db_post = forum_repo.get_post(post_id)
    if db_post is None:
        raise HTTPException(status_code=404, detail="Post not found")
    return forum_repo.create_comment(comment, post_id, user_id)

@router.get("/posts/{post_id}/comments/", response_model=List[forum_dto.ForumComment])
def read_comments_for_post(
    post_id: int, skip: int = 0, limit: int = Query(default=20, le=100, ge=1), forum_repo: ForumRepositoryPort = Depends(get_forum_repository)
):
    comments = forum_repo.get_comments_by_post(post_id, skip=skip, limit=limit)
    return comments
