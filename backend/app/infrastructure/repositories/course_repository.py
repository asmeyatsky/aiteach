"""
Course Repository Implementation

Architectural Intent:
- This module implements the CourseRepositoryPort interface defined in the domain layer.
- It acts as an adapter between the domain layer and the database, handling all course-related data persistence.
- It uses SQLAlchemy ORM for database interactions and mappers to convert between domain entities and ORM models.

Key Design Decisions:
1. Inherits from CourseRepositoryPort to ensure adherence to the domain contract.
2. Depends on the database session (injected) for all operations.
3. Uses the course_mapper and lesson_mapper to decouple the domain from the persistence model.
"""
from sqlalchemy.orm import Session
from typing import List, Optional
from app.domain.ports.repository_ports import CourseRepositoryPort
from app.domain.entities.course import Course
from app.domain.entities.lesson import Lesson
from app.application.dtos.course import CourseCreate
from app.application.dtos.lesson import LessonCreate
from app.infrastructure.repositories.orm import course as course_model
from app.infrastructure.repositories.orm import lesson as lesson_model
from app.infrastructure.repositories.mappers import course_mapper, lesson_mapper

class CourseRepository(CourseRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def get_course(self, course_id: int) -> Optional[Course]:
        orm_course = self.db.query(course_model.Course).filter(course_model.Course.id == course_id).first()
        return course_mapper.to_domain(orm_course) if orm_course else None

    def get_courses(self, skip: int = 0, limit: int = 100) -> List[Course]:
        orm_courses = self.db.query(course_model.Course).offset(skip).limit(limit).all()
        return [course_mapper.to_domain(c) for c in orm_courses]

    def create_course(self, course: CourseCreate) -> Course:
        db_course = course_model.Course(**course.model_dump())
        self.db.add(db_course)
        self.db.commit()
        self.db.refresh(db_course)
        return course_mapper.to_domain(db_course)

    def create_lesson(self, lesson: LessonCreate, course_id: int) -> Lesson:
        db_lesson = lesson_model.Lesson(**lesson.model_dump(), course_id=course_id)
        self.db.add(db_lesson)
        self.db.commit()
        self.db.refresh(db_lesson)
        return lesson_mapper.to_domain(db_lesson)

    def get_lesson(self, lesson_id: int) -> Optional[Lesson]:
        orm_lesson = self.db.query(lesson_model.Lesson).filter(lesson_model.Lesson.id == lesson_id).first()
        return lesson_mapper.to_domain(orm_lesson) if orm_lesson else None

    def get_lessons_by_course(self, course_id: int, skip: int = 0, limit: int = 100) -> List[Lesson]:
        orm_lessons = self.db.query(lesson_model.Lesson).filter(lesson_model.Lesson.course_id == course_id).offset(skip).limit(limit).all()
        return [lesson_mapper.to_domain(l) for l in orm_lessons]
