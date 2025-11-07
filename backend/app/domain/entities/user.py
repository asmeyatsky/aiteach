from dataclasses import dataclass
from datetime import datetime
from typing import Optional

@dataclass(frozen=True)
class User:
    id: int
    username: str
    email: str
    hashed_password: str
    profile_picture_url: Optional[str]
    created_at: datetime
