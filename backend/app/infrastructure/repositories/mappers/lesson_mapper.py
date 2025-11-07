from app.domain.entities.lesson import Lesson as LessonDomain
from app.infrastructure.repositories.orm.lesson import Lesson as LessonORM

def to_domain(orm_lesson: LessonORM) -> LessonDomain:
    return LessonDomain(
        id=orm_lesson.id,
        course_id=orm_lesson.course_id,
        title=orm_lesson.title,
        content_type=orm_lesson.content_type,
        content_data=orm_lesson.content_data,
        order=orm_lesson.order
    )
