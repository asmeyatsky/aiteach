from fastapi import APIRouter, Depends, HTTPException
from typing import List
from app.application.dtos import user_progress as user_progress_dto
from app.domain.ports.repository_ports import UserProgressRepositoryPort
from app.dependencies import get_user_progress_repository
from app.infrastructure.auth import get_current_user

router = APIRouter()

@router.get("/users/{user_id}/progress", response_model=List[user_progress_dto.UserProgress])
def get_user_progress(user_id: int, current_user: dict = Depends(get_current_user), user_progress_repo: UserProgressRepositoryPort = Depends(get_user_progress_repository)):
    if current_user["user_id"] != user_id:
        raise HTTPException(status_code=403, detail="You can only view your own progress")
    return user_progress_repo.get_all_user_progress(user_id=user_id)
