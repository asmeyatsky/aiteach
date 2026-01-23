from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from .lesson import Lesson
from app.domain.value_objects.track import Track

class CourseBase(BaseModel):
    title: str
    description: str
    tier: Track
    thumbnail_url: Optional[str] = None

class CourseCreate(CourseBase):
    pass

class Course(CourseBase):
    id: int
    lessons: List["Lesson"] = []

    model_config = ConfigDict(from_attributes=True)

Course.model_rebuild()
