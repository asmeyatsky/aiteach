from sqlalchemy import Column, Integer, String, ForeignKey, Enum
from sqlalchemy.orm import relationship
from app.database import Base

class Lesson(Base):
    __tablename__ = "lessons"

    id = Column(Integer, primary_key=True, index=True)
    course_id = Column(Integer, ForeignKey("courses.id"))
    title = Column(String, index=True)
    content_type = Column(String) # text, video, quiz
    content_data = Column(String)
    order = Column(Integer)

    course = relationship("Course", back_populates="lessons")
