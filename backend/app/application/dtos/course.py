from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from .lesson import Lesson

class CourseBase(BaseModel):
    title: str
    description: str
    tier: str
    thumbnail_url: Optional[str] = None

class CourseCreate(CourseBase):
    pass

class Course(CourseBase):
    id: int
    lessons: List["Lesson"] = []

    model_config = ConfigDict(from_attributes=True)

Course.model_rebuild()
