from pydantic import BaseModel, ConfigDict

class LessonBase(BaseModel):
    title: str
    content_type: str
    content_data: str
    order: int

class LessonCreate(LessonBase):
    pass

class Lesson(LessonBase):
    id: int
    course_id: int

    model_config = ConfigDict(from_attributes=True)
