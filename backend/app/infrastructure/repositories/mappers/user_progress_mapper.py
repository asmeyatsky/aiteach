from app.domain.entities.user_progress import UserProgress as UserProgressDomain
from app.infrastructure.repositories.orm.user_progress import UserProgress as UserProgressORM

def to_domain(orm_user_progress: UserProgressORM) -> UserProgressDomain:
    return UserProgressDomain(
        user_id=orm_user_progress.user_id,
        lesson_id=orm_user_progress.lesson_id,
        completed_at=orm_user_progress.completed_at
    )
