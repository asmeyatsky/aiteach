from fastapi import APIRouter, Depends, HTTPException
from typing import List
from app.application.dtos import gamification as gamification_dto
from app.domain.ports.repository_ports import GamificationRepositoryPort
from app.dependencies import get_gamification_repository

router = APIRouter()

@router.post("/badges/", response_model=gamification_dto.Badge)
def create_badge(badge: gamification_dto.BadgeCreate, gamification_repo: GamificationRepositoryPort = Depends(get_gamification_repository)):
    return gamification_repo.create_badge(badge)

@router.get("/badges/", response_model=List[gamification_dto.Badge])
def read_badges(skip: int = 0, limit: int = 100, gamification_repo: GamificationRepositoryPort = Depends(get_gamification_repository)):
    badges = gamification_repo.get_badges(skip=skip, limit=limit)
    return badges

@router.get("/users/{user_id}/badges/", response_model=List[gamification_dto.UserBadge])
def read_user_badges(user_id: int, skip: int = 0, limit: int = 100, gamification_repo: GamificationRepositoryPort = Depends(get_gamification_repository)):
    user_badges = gamification_repo.get_user_badges_by_user(user_id=user_id, skip=skip, limit=limit)
    return user_badges

@router.post("/user_badges/", response_model=gamification_dto.UserBadge)
def create_user_badge(user_badge: gamification_dto.UserBadgeCreate, gamification_repo: GamificationRepositoryPort = Depends(get_gamification_repository)):
    return gamification_repo.create_user_badge(user_badge)
