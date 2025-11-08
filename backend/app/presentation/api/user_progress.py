from fastapi import APIRouter, Depends, HTTPException
from typing import List
from app.application.dtos import user_progress as user_progress_dto
from app.domain.ports.repository_ports import UserProgressRepositoryPort
from app.dependencies import get_user_progress_repository

router = APIRouter()

@router.get("/users/{user_id}/progress", response_model=List[user_progress_dto.UserProgress])
def get_user_progress(user_id: int, user_progress_repo: UserProgressRepositoryPort = Depends(get_user_progress_repository)):
    return user_progress_repo.get_all_user_progress(user_id=user_id)
