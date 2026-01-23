from pydantic import BaseModel, ConfigDict
from datetime import datetime

class FeedItemBase(BaseModel):
    title: str
    source_name: str
    original_url: str
    summary: str
    published_at: datetime

class FeedItemCreate(FeedItemBase):
    pass

class FeedItem(FeedItemBase):
    id: int
    model_config = ConfigDict(from_attributes=True)
