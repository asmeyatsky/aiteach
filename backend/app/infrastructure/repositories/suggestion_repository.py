from sqlalchemy.orm import Session
from typing import List, Optional
from app.domain.ports.repository_ports import SuggestionRepositoryPort
from app.domain.entities.suggestion import SuggestedContent
from app.application.dtos.suggestion import SuggestedContentCreate
from app.infrastructure.repositories.orm import suggestion as suggestion_model
from app.infrastructure.repositories.mappers import suggestion_mapper

class SuggestionRepository(SuggestionRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def get_suggestion(self, suggestion_id: int) -> Optional[SuggestedContent]:
        orm_suggestion = self.db.query(suggestion_model.SuggestedContent).filter(suggestion_model.SuggestedContent.id == suggestion_id).first()
        return suggestion_mapper.to_domain(orm_suggestion) if orm_suggestion else None

    def get_suggestions(self, skip: int = 0, limit: int = 100) -> List[SuggestedContent]:
        orm_suggestions = self.db.query(suggestion_model.SuggestedContent).offset(skip).limit(limit).all()
        return [suggestion_mapper.to_domain(s) for s in orm_suggestions]

    def create_suggestion(self, suggestion: SuggestedContentCreate, user_id: int) -> SuggestedContent:
        db_suggestion = suggestion_model.SuggestedContent(**suggestion.model_dump(), user_id=user_id)
        self.db.add(db_suggestion)
        self.db.commit()
        self.db.refresh(db_suggestion)
        return suggestion_mapper.to_domain(db_suggestion)
