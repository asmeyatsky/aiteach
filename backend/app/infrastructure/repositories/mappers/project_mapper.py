from app.domain.entities.project import Project as ProjectDomain, UserProject as UserProjectDomain
from app.infrastructure.repositories.orm.project import Project as ProjectORM, UserProject as UserProjectORM

def to_domain(orm_project: ProjectORM) -> ProjectDomain:
    return ProjectDomain(
        id=orm_project.id,
        track=orm_project.track,
        title=orm_project.title,
        description=orm_project.description,
        starter_code_url=orm_project.starter_code_url,
        difficulty=orm_project.difficulty
    )

def to_domain_user_project(orm_user_project: UserProjectORM) -> UserProjectDomain:
    return UserProjectDomain(
        id=orm_user_project.id,
        user_id=orm_user_project.user_id,
        project_id=orm_user_project.project_id,
        status=orm_user_project.status,
        submission_url=orm_user_project.submission_url
    )
