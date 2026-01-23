from fastapi import Depends
from sqlalchemy.orm import Session
from app.infrastructure.database import get_db
from app.infrastructure.repositories.user_repository import UserRepository
from app.domain.ports.repository_ports import UserRepositoryPort
from app.infrastructure.repositories.course_repository import CourseRepository
from app.domain.ports.repository_ports import CourseRepositoryPort
from app.infrastructure.repositories.user_progress_repository import UserProgressRepository
from app.domain.ports.repository_ports import UserProgressRepositoryPort
from app.infrastructure.repositories.forum_repository import ForumRepository
from app.domain.ports.repository_ports import ForumRepositoryPort
from app.infrastructure.repositories.gamification_repository import GamificationRepository
from app.domain.ports.repository_ports import GamificationRepositoryPort
from app.infrastructure.repositories.project_repository import ProjectRepository
from app.domain.ports.repository_ports import ProjectRepositoryPort
from app.infrastructure.repositories.feed_repository import FeedRepository
from app.domain.ports.repository_ports import FeedRepositoryPort
from app.infrastructure.repositories.suggestion_repository import SuggestionRepository
from app.domain.ports.repository_ports import SuggestionRepositoryPort

def get_user_repository(db: Session = Depends(get_db)) -> UserRepositoryPort:
    return UserRepository(db)

def get_course_repository(db: Session = Depends(get_db)) -> CourseRepositoryPort:
    return CourseRepository(db)

def get_user_progress_repository(db: Session = Depends(get_db)) -> UserProgressRepositoryPort:
    return UserProgressRepository(db)

def get_forum_repository(db: Session = Depends(get_db)) -> ForumRepositoryPort:
    return ForumRepository(db)

def get_gamification_repository(db: Session = Depends(get_db)) -> GamificationRepositoryPort:
    return GamificationRepository(db)

def get_project_repository(db: Session = Depends(get_db)) -> ProjectRepositoryPort:
    return ProjectRepository(db)

def get_feed_repository(db: Session = Depends(get_db)) -> FeedRepositoryPort:
    return FeedRepository(db)

def get_suggestion_repository(db: Session = Depends(get_db)) -> SuggestionRepositoryPort:
    return SuggestionRepository(db)
