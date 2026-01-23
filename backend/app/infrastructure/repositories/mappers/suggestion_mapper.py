from app.domain.entities.suggestion import SuggestedContent as SuggestedContentDomain
from app.infrastructure.repositories.orm.suggestion import SuggestedContent as SuggestedContentORM

def to_domain(orm_suggestion: SuggestedContentORM) -> SuggestedContentDomain:
    return SuggestedContentDomain(
        id=orm_suggestion.id,
        user_id=orm_suggestion.user_id,
        url=orm_suggestion.url,
        comment=orm_suggestion.comment,
        suggested_track=orm_suggestion.suggested_track,
        status=orm_suggestion.status
    )
