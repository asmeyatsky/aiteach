from sqlalchemy.orm import Session
from app.infrastructure.auth import get_password_hash
from app.application.dtos import user, course, lesson, forum, gamification, user_progress
from app.infrastructure.repositories.orm import user as user_model
from app.infrastructure.repositories.orm import course as course_model
from app.infrastructure.repositories.orm import lesson as lesson_model
from app.infrastructure.repositories.orm import forum as forum_model
from app.infrastructure.repositories.orm import gamification as gamification_model
from app.infrastructure.repositories.orm import user_progress as user_progress_model
from app.infrastructure.repositories.mappers import user_mapper, course_mapper, lesson_mapper, forum_mapper, gamification_mapper, user_progress_mapper

# User CRUD
def get_user(db: Session, user_id: int):
    orm_user = db.query(user_model.User).filter(user_model.User.id == user_id).first()
    return user_mapper.to_domain(orm_user) if orm_user else None

def get_user_by_email(db: Session, email: str):
    orm_user = db.query(user_model.User).filter(user_model.User.email == email).first()
    return user_mapper.to_domain(orm_user) if orm_user else None

def get_user_by_username(db: Session, username: str):
    orm_user = db.query(user_model.User).filter(user_model.User.username == username).first()
    return user_mapper.to_domain(orm_user) if orm_user else None

def create_user(db: Session, user: user.UserCreate):
    hashed_password = get_password_hash(user.password)
    db_user = user_model.User(email=user.email, username=user.username, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return user_mapper.to_domain(db_user)

def delete_user(db: Session, user_id: int):
    db_user = db.query(user_model.User).filter(user_model.User.id == user_id).first()
    if db_user:
        db.delete(db_user)
        db.commit()
        return True
    return False

def delete_user_by_username(db: Session, username: str):
    db_user = db.query(user_model.User).filter(user_model.User.username == username).first()
    if db_user:
        db.delete(db_user)
        db.commit()
        return True
    return False

# Course CRUD
def get_course(db: Session, course_id: int):
    orm_course = db.query(course_model.Course).filter(course_model.Course.id == course_id).first()
    return course_mapper.to_domain(orm_course) if orm_course else None

def get_courses(db: Session, skip: int = 0, limit: int = 100):
    orm_courses = db.query(course_model.Course).offset(skip).limit(limit).all()
    return [course_mapper.to_domain(c) for c in orm_courses]

def create_course(db: Session, course: course.CourseCreate):
    db_course = course_model.Course(**course.model_dump())
    db.add(db_course)
    db.commit()
    db.refresh(db_course)
    return course_mapper.to_domain(db_course)

# Lesson CRUD
def get_lesson(db: Session, lesson_id: int):
    orm_lesson = db.query(lesson_model.Lesson).filter(lesson_model.Lesson.id == lesson_id).first()
    return lesson_mapper.to_domain(orm_lesson) if orm_lesson else None

def get_lessons_by_course(db: Session, course_id: int, skip: int = 0, limit: int = 100):
    orm_lessons = db.query(lesson_model.Lesson).filter(lesson_model.Lesson.course_id == course_id).offset(skip).limit(limit).all()
    return [lesson_mapper.to_domain(l) for l in orm_lessons]

def create_lesson(db: Session, lesson: lesson.LessonCreate, course_id: int):
    db_lesson = lesson_model.Lesson(**lesson.model_dump(), course_id=course_id)
    db.add(db_lesson)
    db.commit()
    db.refresh(db_lesson)
    return lesson_mapper.to_domain(db_lesson)

# Forum CRUD
def get_post(db: Session, post_id: int):
    orm_post = db.query(forum_model.ForumPost).filter(forum_model.ForumPost.id == post_id).first()
    return forum_mapper.to_post_domain(orm_post) if orm_post else None

def get_posts(db: Session, skip: int = 0, limit: int = 100):
    orm_posts = db.query(forum_model.ForumPost).offset(skip).limit(limit).all()
    return [forum_mapper.to_post_domain(p) for p in orm_posts]

def create_post(db: Session, post: forum.ForumPostCreate, user_id: int):
    db_post = forum_model.ForumPost(**post.model_dump(), user_id=user_id)
    db.add(db_post)
    db.commit()
    db.refresh(db_post)
    return forum_mapper.to_post_domain(db_post)

def get_comment(db: Session, comment_id: int):
    orm_comment = db.query(forum_model.ForumComment).filter(forum_model.ForumComment.id == comment_id).first()
    return forum_mapper.to_comment_domain(orm_comment) if orm_comment else None

def get_comments_by_post(db: Session, post_id: int, skip: int = 0, limit: int = 100):
    orm_comments = db.query(forum_model.ForumComment).filter(forum_model.ForumComment.post_id == post_id).offset(skip).limit(limit).all()
    return [forum_mapper.to_comment_domain(c) for c in orm_comments]

def create_comment(db: Session, comment: forum.ForumCommentCreate, post_id: int, user_id: int):
    db_comment = forum_model.ForumComment(**comment.model_dump(), post_id=post_id, user_id=user_id)
    db.add(db_comment)
    db.commit()
    db.refresh(db_comment)
    return forum_mapper.to_comment_domain(db_comment)

# Gamification CRUD
def get_badge(db: Session, badge_id: int):
    orm_badge = db.query(gamification_model.Badge).filter(gamification_model.Badge.id == badge_id).first()
    return gamification_mapper.to_badge_domain(orm_badge) if orm_badge else None

def get_badges(db: Session, skip: int = 0, limit: int = 100):
    orm_badges = db.query(gamification_model.Badge).offset(skip).limit(limit).all()
    return [gamification_mapper.to_badge_domain(b) for b in orm_badges]

def create_badge(db: Session, badge: gamification.BadgeCreate):
    db_badge = gamification_model.Badge(**badge.model_dump())
    db.add(db_badge)
    db.commit()
    db.refresh(db_badge)
    return gamification_mapper.to_badge_domain(db_badge)

def get_user_badge(db: Session, user_badge_id: int):
    orm_user_badge = db.query(gamification_model.UserBadge).filter(gamification_model.UserBadge.id == user_badge_id).first()
    return gamification_mapper.to_user_badge_domain(orm_user_badge) if orm_user_badge else None

def get_user_badges_by_user(db: Session, user_id: int, skip: int = 0, limit: int = 100):
    orm_user_badges = db.query(gamification_model.UserBadge).filter(gamification_model.UserBadge.user_id == user_id).offset(skip).limit(limit).all()
    return [gamification_mapper.to_user_badge_domain(ub) for ub in orm_user_badges]

def create_user_badge(db: Session, user_badge: gamification.UserBadgeCreate):
    db_user_badge = gamification_model.UserBadge(**user_badge.model_dump())
    db.add(db_user_badge)
    db.commit()
    db.refresh(db_user_badge)
    return gamification_mapper.to_user_badge_domain(db_user_badge)

# User Progress CRUD
def get_user_progress(db: Session, user_id: int, lesson_id: int):
    orm_user_progress = db.query(user_progress_model.UserProgress).filter(user_progress_model.UserProgress.user_id == user_id, user_progress_model.UserProgress.lesson_id == lesson_id).first()
    return user_progress_mapper.to_domain(orm_user_progress) if orm_user_progress else None

def create_user_progress(db: Session, user_id: int, lesson_id: int):
    db_user_progress = user_progress_model.UserProgress(user_id=user_id, lesson_id=lesson_id)
    db.add(db_user_progress)
    db.commit()
    db.refresh(db_user_progress)
    return user_progress_mapper.to_domain(db_user_progress)

def get_all_user_progress(db: Session, user_id: int):
    orm_user_progresses = db.query(user_progress_model.UserProgress).filter(user_progress_model.UserProgress.user_id == user_id).all()
    return [user_progress_mapper.to_domain(up) for up in orm_user_progresses]
