from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime
from .user import User

class ForumCommentBase(BaseModel):
    body: str

class ForumCommentCreate(ForumCommentBase):
    pass

class ForumComment(ForumCommentBase):
    id: int
    post_id: int
    user_id: int
    created_at: datetime
    owner: User

    model_config = ConfigDict(from_attributes=True)

class ForumPostBase(BaseModel):
    title: str
    body: str

class ForumPostCreate(ForumPostBase):
    pass

class ForumPost(ForumPostBase):
    id: int
    user_id: int
    created_at: datetime
    owner: User
    comments: List["ForumComment"] = []

    model_config = ConfigDict(from_attributes=True)

ForumPost.model_rebuild()
