from fastapi import APIRouter, Depends
from app.application.dtos import suggestion as suggestion_dto
from app.domain.ports.repository_ports import SuggestionRepositoryPort
from app.dependencies import get_suggestion_repository

router = APIRouter()

@router.post("/suggestions/", response_model=suggestion_dto.SuggestedContent)
def create_suggestion(
    suggestion: suggestion_dto.SuggestedContentCreate,
    user_id: int = 1, # Hardcoded user_id
    suggestion_repo: SuggestionRepositoryPort = Depends(get_suggestion_repository)
):
    # In a real app, user_id would come from the auth token
    db_suggestion = suggestion_repo.create_suggestion(suggestion=suggestion, user_id=user_id)
    return db_suggestion
