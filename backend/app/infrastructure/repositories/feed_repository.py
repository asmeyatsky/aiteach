from sqlalchemy.orm import Session
from typing import List, Optional
from app.domain.ports.repository_ports import FeedRepositoryPort
from app.domain.entities.feed import FeedItem
from app.application.dtos.feed import FeedItemCreate
from app.infrastructure.repositories.orm import feed as feed_model
from app.infrastructure.repositories.mappers import feed_mapper

class FeedRepository(FeedRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def get_feed_item(self, item_id: int) -> Optional[FeedItem]:
        orm_item = self.db.query(feed_model.FeedItem).filter(feed_model.FeedItem.id == item_id).first()
        return feed_mapper.to_domain(orm_item) if orm_item else None

    def get_feed_items(self, skip: int = 0, limit: int = 100) -> List[FeedItem]:
        orm_items = self.db.query(feed_model.FeedItem).order_by(feed_model.FeedItem.published_at.desc()).offset(skip).limit(limit).all()
        return [feed_mapper.to_domain(item) for item in orm_items]

    def create_feed_item(self, feed_item: FeedItemCreate) -> FeedItem:
        db_item = feed_model.FeedItem(**feed_item.model_dump())
        self.db.add(db_item)
        self.db.commit()
        self.db.refresh(db_item)
        return feed_mapper.to_domain(db_item)

    def get_feed_item_by_url(self, url: str) -> Optional[FeedItem]:
        orm_item = self.db.query(feed_model.FeedItem).filter(feed_model.FeedItem.original_url == url).first()
        return feed_mapper.to_domain(orm_item) if orm_item else None
