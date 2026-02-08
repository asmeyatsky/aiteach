"""
Forum Repository Implementation

Architectural Intent:
- This module implements the ForumRepositoryPort interface defined in the domain layer.
- It acts as an adapter between the domain layer and the database, handling all forum-related data persistence.
- It uses SQLAlchemy ORM for database interactions and mappers to convert between domain entities and ORM models.

Key Design Decisions:
1. Inherits from ForumRepositoryPort to ensure adherence to the domain contract.
2. Depends on the database session (injected) for all operations.
3. Uses the forum_mapper to decouple the domain from the persistence model.
"""
from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
from app.domain.ports.repository_ports import ForumRepositoryPort
from app.domain.entities.forum import ForumPost, ForumComment
from app.application.dtos.forum import ForumPostCreate, ForumCommentCreate
from app.infrastructure.repositories.orm import forum as forum_model
from app.infrastructure.repositories.mappers import forum_mapper

class ForumRepository(ForumRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def get_post(self, post_id: int) -> Optional[ForumPost]:
        orm_post = (
            self.db.query(forum_model.ForumPost)
            .options(joinedload(forum_model.ForumPost.owner), joinedload(forum_model.ForumPost.comments))
            .filter(forum_model.ForumPost.id == post_id)
            .first()
        )
        return forum_mapper.to_post_domain(orm_post) if orm_post else None

    def get_posts(self, skip: int = 0, limit: int = 100) -> List[ForumPost]:
        orm_posts = (
            self.db.query(forum_model.ForumPost)
            .options(joinedload(forum_model.ForumPost.owner))
            .offset(skip)
            .limit(limit)
            .all()
        )
        return [forum_mapper.to_post_domain(p) for p in orm_posts]

    def create_post(self, post: ForumPostCreate, user_id: int) -> ForumPost:
        db_post = forum_model.ForumPost(**post.model_dump(), user_id=user_id)
        self.db.add(db_post)
        self.db.commit()
        self.db.refresh(db_post)
        return forum_mapper.to_post_domain(db_post)

    def get_comment(self, comment_id: int) -> Optional[ForumComment]:
        orm_comment = self.db.query(forum_model.ForumComment).filter(forum_model.ForumComment.id == comment_id).first()
        return forum_mapper.to_comment_domain(orm_comment) if orm_comment else None

    def get_comments_by_post(self, post_id: int, skip: int = 0, limit: int = 100) -> List[ForumComment]:
        orm_comments = (
            self.db.query(forum_model.ForumComment)
            .options(joinedload(forum_model.ForumComment.owner))
            .filter(forum_model.ForumComment.post_id == post_id)
            .offset(skip)
            .limit(limit)
            .all()
        )
        return [forum_mapper.to_comment_domain(c) for c in orm_comments]

    def create_comment(self, comment: ForumCommentCreate, post_id: int, user_id: int) -> ForumComment:
        db_comment = forum_model.ForumComment(**comment.model_dump(), post_id=post_id, user_id=user_id)
        self.db.add(db_comment)
        self.db.commit()
        self.db.refresh(db_comment)
        return forum_mapper.to_comment_domain(db_comment)
