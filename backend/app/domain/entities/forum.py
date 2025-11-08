from dataclasses import dataclass
from datetime import datetime
from app.domain.entities.user import User

@dataclass(frozen=True)
class ForumPost:
    id: int
    user_id: int
    title: str
    body: str
    created_at: datetime
    owner: User

@dataclass(frozen=True)
class ForumComment:
    id: int
    post_id: int
    user_id: int
    body: str
    created_at: datetime
    owner: User
