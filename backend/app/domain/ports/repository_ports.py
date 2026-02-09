"""
Repository Ports (Interfaces)

Architectural Intent:
- This module defines the abstract interfaces (ports) for interacting with data persistence mechanisms.
- These interfaces reside in the domain layer, ensuring that the business logic remains independent of infrastructure details.
- Concrete implementations of these ports (adapters) are provided in the infrastructure layer.

Key Design Decisions:
1. All repository ports inherit from ABC (Abstract Base Class) to enforce abstract methods.
2. Methods are defined to cover common CRUD (Create, Read, Update, Delete) operations for each aggregate or entity.
3. Return types and parameter types use domain entities, further decoupling from ORM models or DTOs.
"""
from abc import ABC, abstractmethod
from typing import List, Optional
from app.domain.entities.user import User
from app.domain.entities.course import Course
from app.domain.entities.lesson import Lesson
from app.domain.entities.user_progress import UserProgress
from app.domain.entities.forum import ForumPost, ForumComment
from app.domain.entities.gamification import Badge, UserBadge

class UserRepositoryPort(ABC):
    """
    Port for User data persistence.

    Defines the contract for any concrete implementation that handles User data.
    """
    @abstractmethod
    def get_user(self, user_id: int) -> Optional[User]:
        pass

    @abstractmethod
    def get_user_by_email(self, email: str) -> Optional[User]:
        pass

    @abstractmethod
    def get_user_by_username(self, username: str) -> Optional[User]:
        pass

    @abstractmethod
    def create_user(self, user) -> User:
        pass

    @abstractmethod
    def delete_user_by_username(self, username: str) -> bool:
        pass

class CourseRepositoryPort(ABC):
    """
    Port for Course and Lesson data persistence.

    Defines the contract for any concrete implementation that handles Course and Lesson data.
    """
    @abstractmethod
    def get_course(self, course_id: int) -> Optional[Course]:
        pass

    @abstractmethod
    def get_courses(self, skip: int = 0, limit: int = 100) -> List[Course]:
        pass

    @abstractmethod
    def create_course(self, course) -> Course:
        pass

    @abstractmethod
    def create_lesson(self, lesson, course_id: int) -> Lesson:
        pass

    @abstractmethod
    def get_lesson(self, lesson_id: int) -> Optional[Lesson]:
        pass

    @abstractmethod
    def get_lessons_by_course(self, course_id: int, skip: int = 0, limit: int = 100) -> List[Lesson]:
        pass

class UserProgressRepositoryPort(ABC):
    """
    Port for UserProgress data persistence.

    Defines the contract for any concrete implementation that handles UserProgress data.
    """
    @abstractmethod
    def get_user_progress(self, user_id: int, lesson_id: int) -> Optional[UserProgress]:
        pass

    @abstractmethod
    def create_user_progress(self, user_id: int, lesson_id: int) -> UserProgress:
        pass

    @abstractmethod
    def get_all_user_progress(self, user_id: int) -> List[UserProgress]:
        pass

class ForumRepositoryPort(ABC):
    """
    Port for ForumPost and ForumComment data persistence.

    Defines the contract for any concrete implementation that handles Forum data.
    """
    @abstractmethod
    def get_post(self, post_id: int) -> Optional[ForumPost]:
        pass

    @abstractmethod
    def get_posts(self, skip: int = 0, limit: int = 100) -> List[ForumPost]:
        pass

    @abstractmethod
    def create_post(self, post, user_id: int) -> ForumPost:
        pass

    @abstractmethod
    def get_comment(self, comment_id: int) -> Optional[ForumComment]:
        pass

    @abstractmethod
    def get_comments_by_post(self, post_id: int, skip: int = 0, limit: int = 100) -> List[ForumComment]:
        pass

    @abstractmethod
    def create_comment(self, comment, post_id: int, user_id: int) -> ForumComment:
        pass

class GamificationRepositoryPort(ABC):
    """
    Port for Badge and UserBadge data persistence.

    Defines the contract for any concrete implementation that handles Gamification data.
    """
    @abstractmethod
    def get_badge(self, badge_id: int) -> Optional[Badge]:
        pass

    @abstractmethod
    def get_badges(self, skip: int = 0, limit: int = 100) -> List[Badge]:
        pass

    @abstractmethod
    def create_badge(self, badge) -> Badge:
        pass

    @abstractmethod
    def get_user_badge(self, user_badge_id: int) -> Optional[UserBadge]:
        pass

    @abstractmethod
    def get_user_badges_by_user(self, user_id: int, skip: int = 0, limit: int = 100) -> List[UserBadge]:
        pass

    @abstractmethod
    def create_user_badge(self, user_badge) -> UserBadge:
        pass


from app.domain.entities.project import Project, UserProject
from app.domain.entities.feed import FeedItem
from app.domain.entities.suggestion import SuggestedContent

class ProjectRepositoryPort(ABC):
    @abstractmethod
    def get_project(self, project_id: int) -> Optional[Project]:
        pass

    @abstractmethod
    def get_projects(self, skip: int = 0, limit: int = 100) -> List[Project]:
        pass

    @abstractmethod
    def create_project(self, project) -> Project:
        pass
    
    @abstractmethod
    def get_user_project(self, user_id: int, project_id: int) -> Optional[UserProject]:
        pass

    @abstractmethod
    def create_user_project(self, user_project) -> UserProject:
        pass

    @abstractmethod
    def update_user_project(self, user_project) -> UserProject:
        pass

    @abstractmethod
    def get_user_projects_by_user(self, user_id: int) -> List[UserProject]:
        pass


class FeedRepositoryPort(ABC):
    @abstractmethod
    def get_feed_item(self, item_id: int) -> Optional[FeedItem]:
        pass

    @abstractmethod
    def get_feed_items(self, skip: int = 0, limit: int = 100) -> List[FeedItem]:
        pass
    
    @abstractmethod
    def create_feed_item(self, feed_item) -> FeedItem:
        pass
    
    @abstractmethod
    def get_feed_item_by_url(self, url: str) -> Optional[FeedItem]:
        pass


class SuggestionRepositoryPort(ABC):
    @abstractmethod
    def get_suggestion(self, suggestion_id: int) -> Optional[SuggestedContent]:
        pass

    @abstractmethod
    def get_suggestions(self, skip: int = 0, limit: int = 100) -> List[SuggestedContent]:
        pass

    @abstractmethod
    def create_suggestion(self, suggestion, user_id: int) -> SuggestedContent:
        pass


class AnalyticsRepositoryPort(ABC):
    @abstractmethod
    def record_visit(self, path: str, method: str, ip_address: str, user_agent: str, user_id: int = None):
        pass

    @abstractmethod
    def get_summary(self, days: int = 30):
        pass
