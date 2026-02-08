"""
Gamification Repository Implementation

Architectural Intent:
- This module implements the GamificationRepositoryPort interface defined in the domain layer.
- It acts as an adapter between the domain layer and the database, handling all gamification-related data persistence.
- It uses SQLAlchemy ORM for database interactions and mappers to convert between domain entities and ORM models.

Key Design Decisions:
1. Inherits from GamificationRepositoryPort to ensure adherence to the domain contract.
2. Depends on the database session (injected) for all operations.
3. Uses the gamification_mapper to decouple the domain from the persistence model.
"""
from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
from app.domain.ports.repository_ports import GamificationRepositoryPort
from app.domain.entities.gamification import Badge, UserBadge
from app.application.dtos.gamification import BadgeCreate, UserBadgeCreate
from app.infrastructure.repositories.orm import gamification as gamification_model
from app.infrastructure.repositories.mappers import gamification_mapper

class GamificationRepository(GamificationRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def get_badge(self, badge_id: int) -> Optional[Badge]:
        orm_badge = self.db.query(gamification_model.Badge).filter(gamification_model.Badge.id == badge_id).first()
        return gamification_mapper.to_badge_domain(orm_badge) if orm_badge else None

    def get_badges(self, skip: int = 0, limit: int = 100) -> List[Badge]:
        orm_badges = self.db.query(gamification_model.Badge).offset(skip).limit(limit).all()
        return [gamification_mapper.to_badge_domain(b) for b in orm_badges]

    def create_badge(self, badge: BadgeCreate) -> Badge:
        db_badge = gamification_model.Badge(**badge.model_dump())
        self.db.add(db_badge)
        self.db.commit()
        self.db.refresh(db_badge)
        return gamification_mapper.to_badge_domain(db_badge)

    def get_user_badge(self, user_badge_id: int) -> Optional[UserBadge]:
        orm_user_badge = self.db.query(gamification_model.UserBadge).filter(gamification_model.UserBadge.id == user_badge_id).first()
        return gamification_mapper.to_user_badge_domain(orm_user_badge) if orm_user_badge else None

    def get_user_badges_by_user(self, user_id: int, skip: int = 0, limit: int = 100) -> List[UserBadge]:
        orm_user_badges = (
            self.db.query(gamification_model.UserBadge)
            .options(joinedload(gamification_model.UserBadge.badge))
            .filter(gamification_model.UserBadge.user_id == user_id)
            .offset(skip)
            .limit(limit)
            .all()
        )
        return [gamification_mapper.to_user_badge_domain(ub) for ub in orm_user_badges]

    def create_user_badge(self, user_badge: UserBadgeCreate) -> UserBadge:
        db_user_badge = gamification_model.UserBadge(**user_badge.model_dump())
        self.db.add(db_user_badge)
        self.db.commit()
        self.db.refresh(db_user_badge)
        return gamification_mapper.to_user_badge_domain(db_user_badge)
