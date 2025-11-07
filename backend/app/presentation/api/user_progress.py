from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.infrastructure.repositories import generic_crud
from app.application.dtos import user_progress as user_progress_dto
from app.infrastructure.database import get_db

router = APIRouter()

@router.get("/users/{user_id}/progress", response_model=List[user_progress_dto.UserProgress])
def get_user_progress(user_id: int, db: Session = Depends(get_db)):
    return generic_crud.get_all_user_progress(db=db, user_id=user_id)
