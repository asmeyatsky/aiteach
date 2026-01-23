from sqlalchemy.orm import Session
from typing import List, Optional
from app.domain.ports.repository_ports import ProjectRepositoryPort
from app.domain.entities.project import Project, UserProject
from app.application.dtos.project import ProjectCreate, UserProjectCreate
from app.infrastructure.repositories.orm import project as project_model
from app.infrastructure.repositories.mappers import project_mapper

class ProjectRepository(ProjectRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def get_project(self, project_id: int) -> Optional[Project]:
        orm_project = self.db.query(project_model.Project).filter(project_model.Project.id == project_id).first()
        return project_mapper.to_domain(orm_project) if orm_project else None

    def get_projects(self, skip: int = 0, limit: int = 100) -> List[Project]:
        orm_projects = self.db.query(project_model.Project).offset(skip).limit(limit).all()
        return [project_mapper.to_domain(p) for p in orm_projects]

    def create_project(self, project: ProjectCreate) -> Project:
        db_project = project_model.Project(**project.model_dump())
        self.db.add(db_project)
        self.db.commit()
        self.db.refresh(db_project)
        return project_mapper.to_domain(db_project)
    
    def get_user_project(self, user_id: int, project_id: int) -> Optional[UserProject]:
        orm_user_project = self.db.query(project_model.UserProject).filter_by(user_id=user_id, project_id=project_id).first()
        return project_mapper.to_domain_user_project(orm_user_project) if orm_user_project else None

    def create_user_project(self, user_project: UserProjectCreate) -> UserProject:
        db_user_project = project_model.UserProject(**user_project.model_dump())
        self.db.add(db_user_project)
        self.db.commit()
        self.db.refresh(db_user_project)
        return project_mapper.to_domain_user_project(db_user_project)

    def update_user_project(self, user_project: UserProject) -> UserProject:
        db_user_project = self.db.query(project_model.UserProject).filter_by(id=user_project.id).first()
        if db_user_project:
            db_user_project.status = user_project.status
            db_user_project.submission_url = user_project.submission_url
            self.db.commit()
            self.db.refresh(db_user_project)
        return project_mapper.to_domain_user_project(db_user_project)

    def get_user_projects_by_user(self, user_id: int) -> List[UserProject]:
        orm_user_projects = self.db.query(project_model.UserProject).filter_by(user_id=user_id).all()
        return [project_mapper.to_domain_user_project(p) for p in orm_user_projects]
