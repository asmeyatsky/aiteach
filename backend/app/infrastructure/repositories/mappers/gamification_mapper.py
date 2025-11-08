from app.domain.entities.gamification import Badge as BadgeDomain, UserBadge as UserBadgeDomain
from app.infrastructure.repositories.orm.gamification import Badge as BadgeORM, UserBadge as UserBadgeORM

def to_badge_domain(orm_badge: BadgeORM) -> BadgeDomain:
    return BadgeDomain(
        id=orm_badge.id,
        name=orm_badge.name,
        description=orm_badge.description,
        icon_url=orm_badge.icon_url
    )

def to_user_badge_domain(orm_user_badge: UserBadgeORM) -> UserBadgeDomain:
    return UserBadgeDomain(
        id=orm_user_badge.id,
        user_id=orm_user_badge.user_id,
        badge_id=orm_user_badge.badge_id,
        awarded_at=orm_user_badge.awarded_at,
        badge=to_badge_domain(orm_user_badge.badge)
    )
