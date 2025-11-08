"""
User Repository Implementation

Architectural Intent:
- This module implements the UserRepositoryPort interface defined in the domain layer.
- It acts as an adapter between the domain layer and the database, handling all user-related data persistence.
- It uses SQLAlchemy ORM for database interactions and mappers to convert between domain entities and ORM models.

Key Design Decisions:
1. Inherits from UserRepositoryPort to ensure adherence to the domain contract.
2. Depends on the database session (injected) for all operations.
3. Uses the user_mapper to decouple the domain from the persistence model.
"""
from sqlalchemy.orm import Session
from typing import Optional
from app.domain.ports.repository_ports import UserRepositoryPort
from app.domain.entities.user import User
from app.application.dtos.user import UserCreate
from app.infrastructure.repositories.orm import user as user_model
from app.infrastructure.repositories.mappers import user_mapper
from app.infrastructure.auth import get_password_hash

class UserRepository(UserRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def get_user(self, user_id: int) -> Optional[User]:
        orm_user = self.db.query(user_model.User).filter(user_model.User.id == user_id).first()
        return user_mapper.to_domain(orm_user) if orm_user else None

    def get_user_by_email(self, email: str) -> Optional[User]:
        orm_user = self.db.query(user_model.User).filter(user_model.User.email == email).first()
        return user_mapper.to_domain(orm_user) if orm_user else None

    def get_user_by_username(self, username: str) -> Optional[User]:
        orm_user = self.db.query(user_model.User).filter(user_model.User.username == username).first()
        return user_mapper.to_domain(orm_user) if orm_user else None

    def create_user(self, user: UserCreate) -> User:
        hashed_password = get_password_hash(user.password)
        db_user = user_model.User(email=user.email, username=user.username, hashed_password=hashed_password)
        self.db.add(db_user)
        self.db.commit()
        self.db.refresh(db_user)
        return user_mapper.to_domain(db_user)

    def delete_user_by_username(self, username: str) -> bool:
        db_user = self.db.query(user_model.User).filter(user_model.User.username == username).first()
        if db_user:
            self.db.delete(db_user)
            self.db.commit()
            return True
        return False
