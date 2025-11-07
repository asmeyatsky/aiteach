from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime

class BadgeBase(BaseModel):
    name: str
    description: str
    icon_url: Optional[str] = None

class BadgeCreate(BadgeBase):
    pass

class Badge(BadgeBase):
    id: int

    model_config = ConfigDict(from_attributes=True)

class UserBadgeBase(BaseModel):
    user_id: int
    badge_id: int

class UserBadgeCreate(UserBadgeBase):
    pass

class UserBadge(UserBadgeBase):
    id: int
    awarded_at: datetime
    badge: "Badge"

    model_config = ConfigDict(from_attributes=True)

UserBadge.model_rebuild()
