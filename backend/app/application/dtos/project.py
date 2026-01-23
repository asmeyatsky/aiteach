from pydantic import BaseModel, ConfigDict
from typing import Optional
from app.domain.value_objects.project import ProjectDifficulty, UserProjectStatus
from app.domain.value_objects.track import Track

class ProjectBase(BaseModel):
    track: Track
    title: str
    description: str
    starter_code_url: Optional[str] = None
    difficulty: ProjectDifficulty

class ProjectCreate(ProjectBase):
    pass

class Project(ProjectBase):
    id: int
    model_config = ConfigDict(from_attributes=True)

class UserProjectBase(BaseModel):
    user_id: int
    project_id: int
    status: UserProjectStatus
    submission_url: Optional[str] = None

class UserProjectCreate(UserProjectBase):
    pass

class UserProject(UserProjectBase):
    id: int
    model_config = ConfigDict(from_attributes=True)

class UserProjectSubmit(BaseModel):
    submission_url: str
