from app.domain.entities.user import User as UserDomain
from app.infrastructure.repositories.orm.user import User as UserORM

def to_domain(orm_user: UserORM) -> UserDomain:
    return UserDomain(
        id=orm_user.id,
        username=orm_user.username,
        email=orm_user.email,
        hashed_password=orm_user.hashed_password,
        profile_picture_url=orm_user.profile_picture_url,
        created_at=orm_user.created_at
    )
