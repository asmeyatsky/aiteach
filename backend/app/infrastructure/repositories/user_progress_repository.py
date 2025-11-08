"""
User Progress Repository Implementation

Architectural Intent:
- This module implements the UserProgressRepositoryPort interface defined in the domain layer.
- It acts as an adapter between the domain layer and the database, handling all user progress related data persistence.
- It uses SQLAlchemy ORM for database interactions and mappers to convert between domain entities and ORM models.

Key Design Decisions:
1. Inherits from UserProgressRepositoryPort to ensure adherence to the domain contract.
2. Depends on the database session (injected) for all operations.
3. Uses the user_progress_mapper to decouple the domain from the persistence model.
"""
from sqlalchemy.orm import Session
from typing import List, Optional
from app.domain.ports.repository_ports import UserProgressRepositoryPort
from app.domain.entities.user_progress import UserProgress
from app.infrastructure.repositories.orm import user_progress as user_progress_model
from app.infrastructure.repositories.mappers import user_progress_mapper

class UserProgressRepository(UserProgressRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def get_user_progress(self, user_id: int, lesson_id: int) -> Optional[UserProgress]:
        orm_user_progress = self.db.query(user_progress_model.UserProgress).filter(user_progress_model.UserProgress.user_id == user_id, user_progress_model.UserProgress.lesson_id == lesson_id).first()
        return user_progress_mapper.to_domain(orm_user_progress) if orm_user_progress else None

    def create_user_progress(self, user_id: int, lesson_id: int) -> UserProgress:
        db_user_progress = user_progress_model.UserProgress(user_id=user_id, lesson_id=lesson_id)
        self.db.add(db_user_progress)
        self.db.commit()
        self.db.refresh(db_user_progress)
        return user_progress_mapper.to_domain(db_user_progress)

    def get_all_user_progress(self, user_id: int) -> List[UserProgress]:
        orm_user_progresses = self.db.query(user_progress_model.UserProgress).filter(user_progress_model.UserProgress.user_id == user_id).all()
        return [user_progress_mapper.to_domain(up) for up in orm_user_progresses]
