from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.infrastructure.repositories import generic_crud
from app.application.dtos import gamification as gamification_dto
from app.infrastructure.database import get_db

router = APIRouter()

@router.post("/badges/", response_model=gamification_dto.Badge)
def create_badge(badge: gamification_dto.BadgeCreate, db: Session = Depends(get_db)):
    return generic_crud.create_badge(db=db, badge=badge)

@router.get("/badges/", response_model=List[gamification_dto.Badge])
def read_badges(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    badges = generic_crud.get_badges(db, skip=skip, limit=limit)
    return badges

@router.get("/users/{user_id}/badges/", response_model=List[gamification_dto.UserBadge])
def read_user_badges(user_id: int, skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    user_badges = generic_crud.get_user_badges_by_user(db, user_id=user_id, skip=skip, limit=limit)
    return user_badges

@router.post("/user_badges/", response_model=gamification_dto.UserBadge)
def create_user_badge(user_badge: gamification_dto.UserBadgeCreate, db: Session = Depends(get_db)):
    return generic_crud.create_user_badge(db=db, user_badge=user_badge)
