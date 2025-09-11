from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import crud, schemas
from app.database import get_db

router = APIRouter()

@router.post("/badges/", response_model=schemas.gamification.Badge)
def create_badge(badge: schemas.gamification.BadgeCreate, db: Session = Depends(get_db)):
    return crud.create_badge(db=db, badge=badge)

@router.get("/badges/", response_model=List[schemas.gamification.Badge])
def read_badges(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    badges = crud.get_badges(db, skip=skip, limit=limit)
    return badges

@router.get("/users/{user_id}/badges/", response_model=List[schemas.gamification.UserBadge])
def read_user_badges(user_id: int, skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    user_badges = crud.get_user_badges_by_user(db, user_id=user_id, skip=skip, limit=limit)
    return user_badges

@router.post("/user_badges/", response_model=schemas.gamification.UserBadge)
def create_user_badge(user_badge: schemas.gamification.UserBadgeCreate, db: Session = Depends(get_db)):
    return crud.create_user_badge(db=db, user_badge=user_badge)
