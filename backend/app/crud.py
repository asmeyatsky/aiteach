from sqlalchemy.orm import Session
from .auth import get_password_hash
from .schemas import user, course, lesson, forum, gamification, user_progress
from .models import user as user_model
from .models import course as course_model
from .models import lesson as lesson_model
from .models import forum as forum_model
from .models import gamification as gamification_model
from .models import user_progress as user_progress_model

# User CRUD
def get_user(db: Session, user_id: int):
    return db.query(user_model.User).filter(user_model.User.id == user_id).first()

def get_user_by_email(db: Session, email: str):
    return db.query(user_model.User).filter(user_model.User.email == email).first()

def get_user_by_username(db: Session, username: str):
    return db.query(user_model.User).filter(user_model.User.username == username).first()

def create_user(db: Session, user: user.UserCreate):
    hashed_password = get_password_hash(user.password)
    db_user = user_model.User(email=user.email, username=user.username, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

# Course CRUD
def get_course(db: Session, course_id: int):
    return db.query(course_model.Course).filter(course_model.Course.id == course_id).first()

def get_courses(db: Session, skip: int = 0, limit: int = 100):
    return db.query(course_model.Course).offset(skip).limit(limit).all()

def create_course(db: Session, course: course.CourseCreate):
    db_course = course_model.Course(**course.model_dump())
    db.add(db_course)
    db.commit()
    db.refresh(db_course)
    return db_course

# Lesson CRUD
def get_lesson(db: Session, lesson_id: int):
    return db.query(lesson_model.Lesson).filter(lesson_model.Lesson.id == lesson_id).first()

def get_lessons_by_course(db: Session, course_id: int, skip: int = 0, limit: int = 100):
    return db.query(lesson_model.Lesson).filter(lesson_model.Lesson.course_id == course_id).offset(skip).limit(limit).all()

def create_lesson(db: Session, lesson: lesson.LessonCreate, course_id: int):
    db_lesson = lesson_model.Lesson(**lesson.model_dump(), course_id=course_id)
    db.add(db_lesson)
    db.commit()
    db.refresh(db_lesson)
    return db_lesson

# Forum CRUD
def get_post(db: Session, post_id: int):
    return db.query(forum_model.ForumPost).filter(forum_model.ForumPost.id == post_id).first()

def get_posts(db: Session, skip: int = 0, limit: int = 100):
    return db.query(forum_model.ForumPost).offset(skip).limit(limit).all()

def create_post(db: Session, post: forum.ForumPostCreate, user_id: int):
    db_post = forum_model.ForumPost(**post.model_dump(), user_id=user_id)
    db.add(db_post)
    db.commit()
    db.refresh(db_post)
    return db_post

def get_comment(db: Session, comment_id: int):
    return db.query(forum_model.ForumComment).filter(forum_model.ForumComment.id == comment_id).first()

def get_comments_by_post(db: Session, post_id: int, skip: int = 0, limit: int = 100):
    return db.query(forum_model.ForumComment).filter(forum_model.ForumComment.post_id == post_id).offset(skip).limit(limit).all()

def create_comment(db: Session, comment: forum.ForumCommentCreate, post_id: int, user_id: int):
    db_comment = forum_model.ForumComment(**comment.model_dump(), post_id=post_id, user_id=user_id)
    db.add(db_comment)
    db.commit()
    db.refresh(db_comment)
    return db_comment

# Gamification CRUD
def get_badge(db: Session, badge_id: int):
    return db.query(gamification_model.Badge).filter(gamification_model.Badge.id == badge_id).first()

def get_badges(db: Session, skip: int = 0, limit: int = 100):
    return db.query(gamification_model.Badge).offset(skip).limit(limit).all()

def create_badge(db: Session, badge: gamification.BadgeCreate):
    db_badge = gamification_model.Badge(**badge.model_dump())
    db.add(db_badge)
    db.commit()
    db.refresh(db_badge)
    return db_badge

def get_user_badge(db: Session, user_badge_id: int):
    return db.query(gamification_model.UserBadge).filter(gamification_model.UserBadge.id == user_badge_id).first()

def get_user_badges_by_user(db: Session, user_id: int, skip: int = 0, limit: int = 100):
    return db.query(gamification_model.UserBadge).filter(gamification_model.UserBadge.user_id == user_id).offset(skip).limit(limit).all()

def create_user_badge(db: Session, user_badge: gamification.UserBadgeCreate):
    db_user_badge = gamification_model.UserBadge(**user_badge.model_dump())
    db.add(db_user_badge)
    db.commit()
    db.refresh(db_user_badge)
    return db_user_badge

# User Progress CRUD
def get_user_progress(db: Session, user_id: int, lesson_id: int):
    return db.query(user_progress_model.UserProgress).filter(user_progress_model.UserProgress.user_id == user_id, user_progress_model.UserProgress.lesson_id == lesson_id).first()

def create_user_progress(db: Session, user_id: int, lesson_id: int):
    db_user_progress = user_progress_model.UserProgress(user_id=user_id, lesson_id=lesson_id)
    db.add(db_user_progress)
    db.commit()
    db.refresh(db_user_progress)
    return db_user_progress

def get_all_user_progress(db: Session, user_id: int):
    return db.query(user_progress_model.UserProgress).filter(user_progress_model.UserProgress.user_id == user_id).all()
