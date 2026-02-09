from app.domain.entities.analytics import PageVisit as PageVisitDomain
from app.infrastructure.repositories.orm.analytics import PageVisit as PageVisitORM

def to_domain(orm_visit: PageVisitORM) -> PageVisitDomain:
    return PageVisitDomain(
        id=orm_visit.id,
        path=orm_visit.path,
        method=orm_visit.method,
        ip_address=orm_visit.ip_address,
        user_agent=orm_visit.user_agent,
        user_id=orm_visit.user_id,
        timestamp=orm_visit.timestamp,
    )
