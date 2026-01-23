from sqlalchemy import Column, Integer, String, Enum, ForeignKey, UniqueConstraint
from sqlalchemy.orm import relationship
from .base import Base

class Project(Base):
    __tablename__ = "projects"

    id = Column(Integer, primary_key=True, index=True)
    track = Column(String, nullable=False) # Corresponds to the Track enum: user, builder, innovator
    title = Column(String, nullable=False, index=True)
    description = Column(String, nullable=False)
    starter_code_url = Column(String, nullable=True)
    difficulty = Column(Enum('easy', 'medium', 'hard', name='project_difficulty'), nullable=False)

    user_projects = relationship("UserProject", back_populates="project")


class UserProject(Base):
    __tablename__ = "user_projects"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    project_id = Column(Integer, ForeignKey("projects.id"), nullable=False)
    status = Column(Enum('not_started', 'in_progress', 'completed', name='user_project_status'), nullable=False, default='not_started')
    submission_url = Column(String, nullable=True)

    user = relationship("User", back_populates="user_projects")
    project = relationship("Project", back_populates="user_projects")

    __table_args__ = (UniqueConstraint('user_id', 'project_id', name='_user_project_uc'),)
