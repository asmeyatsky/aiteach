from dataclasses import dataclass
from typing import Optional
from app.domain.value_objects.project import ProjectDifficulty, UserProjectStatus
from app.domain.value_objects.track import Track

@dataclass(frozen=True)
class Project:
    id: int
    track: Track
    title: str
    description: str
    starter_code_url: Optional[str]
    difficulty: ProjectDifficulty

@dataclass(frozen=True)
class UserProject:
    id: int
    user_id: int
    project_id: int
    status: UserProjectStatus
    submission_url: Optional[str]
