from sqlalchemy import Column, Integer, String, Enum
from sqlalchemy.orm import relationship
from .base import Base

class Course(Base):
    __tablename__ = "courses"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(String)
    tier = Column(String) # free, premium
    thumbnail_url = Column(String, nullable=True)

    lessons = relationship("Lesson", back_populates="course")
