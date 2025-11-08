from dataclasses import dataclass
from datetime import datetime
from typing import Optional

@dataclass(frozen=True)
class Badge:
    id: int
    name: str
    description: str
    icon_url: Optional[str]

@dataclass(frozen=True)
class UserBadge:
    id: int
    user_id: int
    badge_id: int
    awarded_at: datetime
    badge: Badge
