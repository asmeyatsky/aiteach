from app.domain.entities.course import Course as CourseDomain
from app.infrastructure.repositories.orm.course import Course as CourseORM

def to_domain(orm_course: CourseORM) -> CourseDomain:
    return CourseDomain(
        id=orm_course.id,
        title=orm_course.title,
        description=orm_course.description,
        tier=orm_course.tier,
        thumbnail_url=orm_course.thumbnail_url
    )
