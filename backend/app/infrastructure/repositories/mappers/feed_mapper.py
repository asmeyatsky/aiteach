from app.domain.entities.feed import FeedItem as FeedItemDomain
from app.infrastructure.repositories.orm.feed import FeedItem as FeedItemORM

def to_domain(orm_feed_item: FeedItemORM) -> FeedItemDomain:
    return FeedItemDomain(
        id=orm_feed_item.id,
        title=orm_feed_item.title,
        source_name=orm_feed_item.source_name,
        original_url=orm_feed_item.original_url,
        summary=orm_feed_item.summary,
        published_at=orm_feed_item.published_at
    )
