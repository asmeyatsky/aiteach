from fastapi import APIRouter, Depends, HTTPException
from typing import List
from app.application.dtos import forum as forum_dto
from app.domain.ports.repository_ports import ForumRepositoryPort
from app.dependencies import get_forum_repository

router = APIRouter()

@router.post("/posts/", response_model=forum_dto.ForumPost)
def create_post(post: forum_dto.ForumPostCreate, user_id: int = 1, forum_repo: ForumRepositoryPort = Depends(get_forum_repository)): # Assuming user_id 1 for now
    return forum_repo.create_post(post, user_id)

@router.get("/posts/", response_model=List[forum_dto.ForumPost])
def read_posts(skip: int = 0, limit: int = 100, forum_repo: ForumRepositoryPort = Depends(get_forum_repository)):
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
    post_id: int, comment: forum_dto.ForumCommentCreate, user_id: int = 1, forum_repo: ForumRepositoryPort = Depends(get_forum_repository) # Assuming user_id 1 for now
):
    # Check if post exists
    db_post = forum_repo.get_post(post_id)
    if db_post is None:
        raise HTTPException(status_code=404, detail="Post not found")
    return forum_repo.create_comment(comment, post_id, user_id)

@router.get("/posts/{post_id}/comments/", response_model=List[forum_dto.ForumComment])
def read_comments_for_post(
    post_id: int, skip: int = 0, limit: int = 100, forum_repo: ForumRepositoryPort = Depends(get_forum_repository)
):
    comments = forum_repo.get_comments_by_post(post_id, skip=skip, limit=limit)
    return comments
