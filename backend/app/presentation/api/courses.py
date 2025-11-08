from fastapi import APIRouter, Depends, HTTPException
from typing import List
from app.application.dtos import course as course_dto
from app.application.dtos import lesson as lesson_dto
from app.application.dtos import user_progress as user_progress_dto
from app.domain.ports.repository_ports import CourseRepositoryPort, UserProgressRepositoryPort
from app.dependencies import get_course_repository, get_user_progress_repository

router = APIRouter()

@router.post("/", response_model=course_dto.Course)
def create_course(course: course_dto.CourseCreate, course_repo: CourseRepositoryPort = Depends(get_course_repository)):
    return course_repo.create_course(course)

@router.get("/", response_model=List[course_dto.Course])
def read_courses(skip: int = 0, limit: int = 100, course_repo: CourseRepositoryPort = Depends(get_course_repository)):
    courses = course_repo.get_courses(skip=skip, limit=limit)
    return courses

@router.get("/{course_id}", response_model=course_dto.Course)
def read_course(course_id: int, course_repo: CourseRepositoryPort = Depends(get_course_repository)):
    db_course = course_repo.get_course(course_id)
    if db_course is None:
        raise HTTPException(status_code=404, detail="Course not found")
    return db_course

@router.post("/{course_id}/lessons/", response_model=lesson_dto.Lesson)
def create_lesson_for_course(
    course_id: int, lesson: lesson_dto.LessonCreate, course_repo: CourseRepositoryPort = Depends(get_course_repository)
):
    # Check if course exists
    db_course = course_repo.get_course(course_id)
    if db_course is None:
        raise HTTPException(status_code=404, detail="Course not found")
    return course_repo.create_lesson(lesson, course_id)

@router.get("/{course_id}/lessons/", response_model=List[lesson_dto.Lesson])
def read_lessons_for_course(
    course_id: int, skip: int = 0, limit: int = 100, course_repo: CourseRepositoryPort = Depends(get_course_repository)
):
    lessons = course_repo.get_lessons_by_course(course_id, skip=skip, limit=limit)
    return lessons

@router.post("/lessons/{lesson_id}/complete", response_model=user_progress_dto.UserProgress)
def mark_lesson_complete(lesson_id: int, user_id: int = 1, course_repo: CourseRepositoryPort = Depends(get_course_repository), user_progress_repo: UserProgressRepositoryPort = Depends(get_user_progress_repository)): # Hardcoded user_id for now
    db_lesson = course_repo.get_lesson(lesson_id)
    if db_lesson is None:
        raise HTTPException(status_code=404, detail="Lesson not found")
    
    db_user_progress = user_progress_repo.get_user_progress(user_id=user_id, lesson_id=lesson_id)
    if db_user_progress:
        raise HTTPException(status_code=400, detail="Lesson already completed")

    return user_progress_repo.create_user_progress(user_id=user_id, lesson_id=lesson_id)
