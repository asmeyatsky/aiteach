from fastapi import APIRouter, Depends
from app.application.dtos import suggestion as suggestion_dto
from app.domain.ports.repository_ports import SuggestionRepositoryPort
from app.dependencies import get_suggestion_repository
from app.infrastructure.auth import get_current_user

router = APIRouter()

@router.post("/", response_model=suggestion_dto.SuggestedContent)
def create_suggestion(
    suggestion: suggestion_dto.SuggestedContentCreate,
    current_user: dict = Depends(get_current_user),
    suggestion_repo: SuggestionRepositoryPort = Depends(get_suggestion_repository)
):
    user_id = current_user["user_id"]
    db_suggestion = suggestion_repo.create_suggestion(suggestion=suggestion, user_id=user_id)
    return db_suggestion
