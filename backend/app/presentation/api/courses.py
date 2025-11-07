from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.infrastructure.repositories import generic_crud
from app.application.dtos import course as course_dto
from app.application.dtos import lesson as lesson_dto
from app.application.dtos import user_progress as user_progress_dto
from app.infrastructure.database import get_db

router = APIRouter()

@router.post("/", response_model=course_dto.Course)
def create_course(course: course_dto.CourseCreate, db: Session = Depends(get_db)):
    return generic_crud.create_course(db=db, course=course)

@router.get("/", response_model=List[course_dto.Course])
def read_courses(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    courses = generic_crud.get_courses(db, skip=skip, limit=limit)
    return courses

@router.get("/{course_id}", response_model=course_dto.Course)
def read_course(course_id: int, db: Session = Depends(get_db)):
    db_course = generic_crud.get_course(db, course_id=course_id)
    if db_course is None:
        raise HTTPException(status_code=404, detail="Course not found")
    return db_course

@router.post("/{course_id}/lessons/", response_model=lesson_dto.Lesson)
def create_lesson_for_course(
    course_id: int, lesson: lesson_dto.LessonCreate, db: Session = Depends(get_db)
):
    # Check if course exists
    db_course = generic_crud.get_course(db, course_id=course_id)
    if db_course is None:
        raise HTTPException(status_code=404, detail="Course not found")
    return generic_crud.create_lesson(db=db, lesson=lesson, course_id=course_id)

@router.get("/{course_id}/lessons/", response_model=List[lesson_dto.Lesson])
def read_lessons_for_course(
    course_id: int, skip: int = 0, limit: int = 100, db: Session = Depends(get_db)
):
    lessons = generic_crud.get_lessons_by_course(db, course_id=course_id, skip=skip, limit=limit)
    return lessons

@router.post("/lessons/{lesson_id}/complete", response_model=user_progress_dto.UserProgress)
def mark_lesson_complete(lesson_id: int, db: Session = Depends(get_db), user_id: int = 1): # Hardcoded user_id for now
    db_lesson = generic_crud.get_lesson(db, lesson_id=lesson_id)
    if db_lesson is None:
        raise HTTPException(status_code=404, detail="Lesson not found")
    
    db_user_progress = generic_crud.get_user_progress(db, user_id=user_id, lesson_id=lesson_id)
    if db_user_progress:
        raise HTTPException(status_code=400, detail="Lesson already completed")

    return generic_crud.create_user_progress(db=db, user_id=user_id, lesson_id=lesson_id)
