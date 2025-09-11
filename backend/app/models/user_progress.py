from sqlalchemy import Column, Integer, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.database import Base

class UserProgress(Base):
    __tablename__ = "user_progress"

    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True)
    lesson_id = Column(Integer, ForeignKey("lessons.id"), primary_key=True)
    completed_at = Column(DateTime(timezone=True), server_default=func.now())
