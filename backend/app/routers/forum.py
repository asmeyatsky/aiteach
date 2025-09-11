from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import crud, schemas
from app.database import get_db

router = APIRouter()

@router.post("/posts/", response_model=schemas.forum.ForumPost)
def create_post(post: schemas.forum.ForumPostCreate, db: Session = Depends(get_db), user_id: int = 1): # Assuming user_id 1 for now
    return crud.create_post(db=db, post=post, user_id=user_id)

@router.get("/posts/", response_model=List[schemas.forum.ForumPost])
def read_posts(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    posts = crud.get_posts(db, skip=skip, limit=limit)
    return posts

@router.get("/posts/{post_id}", response_model=schemas.forum.ForumPost)
def read_post(post_id: int, db: Session = Depends(get_db)):
    db_post = crud.get_post(db, post_id=post_id)
    if db_post is None:
        raise HTTPException(status_code=404, detail="Post not found")
    return db_post

@router.post("/posts/{post_id}/comments/", response_model=schemas.forum.ForumComment)
def create_comment_for_post(
    post_id: int, comment: schemas.forum.ForumCommentCreate, db: Session = Depends(get_db), user_id: int = 1 # Assuming user_id 1 for now
):
    # Check if post exists
    db_post = crud.get_post(db, post_id=post_id)
    if db_post is None:
        raise HTTPException(status_code=404, detail="Post not found")
    return crud.create_comment(db=db, comment=comment, post_id=post_id, user_id=user_id)

@router.get("/posts/{post_id}/comments/", response_model=List[schemas.forum.ForumComment])
def read_comments_for_post(
    post_id: int, skip: int = 0, limit: int = 100, db: Session = Depends(get_db)
):
    comments = crud.get_comments_by_post(db, post_id=post_id, skip=skip, limit=limit)
    return comments
