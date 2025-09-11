from pydantic import BaseModel, ConfigDict
from datetime import datetime

class UserProgressBase(BaseModel):
    user_id: int
    lesson_id: int

class UserProgressCreate(UserProgressBase):
    pass

class UserProgress(UserProgressBase):
    completed_at: datetime

    model_config = ConfigDict(from_attributes=True)
