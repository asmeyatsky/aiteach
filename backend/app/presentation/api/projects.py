from fastapi import APIRouter, Depends, HTTPException
from typing import List
from app.application.dtos import project as project_dto
from app.domain.ports.repository_ports import ProjectRepositoryPort
from app.dependencies import get_project_repository

router = APIRouter()

@router.get("/projects/", response_model=List[project_dto.Project])
def read_projects(
    skip: int = 0,
    limit: int = 100,
    project_repo: ProjectRepositoryPort = Depends(get_project_repository)
):
    projects = project_repo.get_projects(skip=skip, limit=limit)
    return projects

@router.get("/projects/{project_id}", response_model=project_dto.Project)
def read_project(project_id: int, project_repo: ProjectRepositoryPort = Depends(get_project_repository)):
    project = project_repo.get_project(project_id)
    if project is None:
        raise HTTPException(status_code=404, detail="Project not found")
    return project

@router.post("/projects/{project_id}/submit", response_model=project_dto.UserProject)
def submit_project(
    project_id: int, 
    submission: project_dto.UserProjectSubmit, 
    user_id: int = 1, # Hardcoded user_id
    project_repo: ProjectRepositoryPort = Depends(get_project_repository)
):
    user_project = project_repo.get_user_project(user_id=user_id, project_id=project_id)
    if not user_project:
        # Or create one if it doesn't exist
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

@router.get("/me/projects/", response_model=List[project_dto.UserProject])
def read_my_projects(
    user_id: int = 1, # Hardcoded user_id
    project_repo: ProjectRepositoryPort = Depends(get_project_repository)
):
    return project_repo.get_user_projects_by_user(user_id)
