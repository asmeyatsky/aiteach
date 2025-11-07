from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.infrastructure.repositories import generic_crud
from app.application.dtos import forum as forum_dto
from app.infrastructure.database import get_db

router = APIRouter()

@router.post("/posts/", response_model=forum_dto.ForumPost)
def create_post(post: forum_dto.ForumPostCreate, db: Session = Depends(get_db), user_id: int = 1): # Assuming user_id 1 for now
    return generic_crud.create_post(db=db, post=post, user_id=user_id)

@router.get("/posts/", response_model=List[forum_dto.ForumPost])
def read_posts(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    posts = generic_crud.get_posts(db, skip=skip, limit=limit)
    return posts

@router.get("/posts/{post_id}", response_model=forum_dto.ForumPost)
def read_post(post_id: int, db: Session = Depends(get_db)):
    db_post = generic_crud.get_post(db, post_id=post_id)
    if db_post is None:
        raise HTTPException(status_code=404, detail="Post not found")
    return db_post

@router.post("/posts/{post_id}/comments/", response_model=forum_dto.ForumComment)
def create_comment_for_post(
    post_id: int, comment: forum_dto.ForumCommentCreate, db: Session = Depends(get_db), user_id: int = 1 # Assuming user_id 1 for now
):
    # Check if post exists
    db_post = generic_crud.get_post(db, post_id=post_id)
    if db_post is None:
        raise HTTPException(status_code=404, detail="Post not found")
    return generic_crud.create_comment(db=db, comment=comment, post_id=post_id, user_id=user_id)

@router.get("/posts/{post_id}/comments/", response_model=List[forum_dto.ForumComment])
def read_comments_for_post(
    post_id: int, skip: int = 0, limit: int = 100, db: Session = Depends(get_db)
):
    comments = generic_crud.get_comments_by_post(db, post_id=post_id, skip=skip, limit=limit)
    return comments
