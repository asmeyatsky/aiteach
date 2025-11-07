from dataclasses import dataclass

@dataclass(frozen=True)
class Lesson:
    id: int
    course_id: int
    title: str
    content_type: str  # text, video, quiz
    content_data: str
    order: int
