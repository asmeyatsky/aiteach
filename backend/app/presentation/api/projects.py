from fastapi import APIRouter, Depends, HTTPException, Query
from typing import List
from app.application.dtos import project as project_dto
from app.domain.ports.repository_ports import ProjectRepositoryPort
from app.dependencies import get_project_repository
from app.infrastructure.auth import get_current_user

router = APIRouter()

@router.get("/", response_model=List[project_dto.Project])
def read_projects(
    skip: int = 0,
    limit: int = Query(default=20, le=100, ge=1),
    project_repo: ProjectRepositoryPort = Depends(get_project_repository)
):
    projects = project_repo.get_projects(skip=skip, limit=limit)
    return projects

@router.get("/me/", response_model=List[project_dto.UserProject])
def read_my_projects(
    current_user: dict = Depends(get_current_user),
    project_repo: ProjectRepositoryPort = Depends(get_project_repository)
):
    user_id = current_user["user_id"]
    return project_repo.get_user_projects_by_user(user_id)

@router.get("/{project_id}", response_model=project_dto.Project)
def read_project(project_id: int, project_repo: ProjectRepositoryPort = Depends(get_project_repository)):
    project = project_repo.get_project(project_id)
    if project is None:
        raise HTTPException(status_code=404, detail="Project not found")
    return project

@router.post("/{project_id}/submit", response_model=project_dto.UserProject)
def submit_project(
    project_id: int,
    submission: project_dto.UserProjectSubmit,
    current_user: dict = Depends(get_current_user),
    project_repo: ProjectRepositoryPort = Depends(get_project_repository)
):
    user_id = current_user["user_id"]
    user_project = project_repo.get_user_project(user_id=user_id, project_id=project_id)
    if not user_project:
        user_project_create = project_dto.UserProjectCreate(
            user_id=user_id,
            project_id=project_id,
            status="completed",
            submission_url=submission.submission_url
        )
        user_project = project_repo.create_user_project(user_project_create)
    else:
        user_project.status = "completed"
        user_project.submission_url = submission.submission_url
        user_project = project_repo.update_user_project(user_project)

    return user_project
