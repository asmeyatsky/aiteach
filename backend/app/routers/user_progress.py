from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import crud, schemas
from app.database import get_db

router = APIRouter()

@router.get("/users/{user_id}/progress", response_model=List[schemas.user_progress.UserProgress])
def get_user_progress(user_id: int, db: Session = Depends(get_db)):
    return crud.get_all_user_progress(db=db, user_id=user_id)
