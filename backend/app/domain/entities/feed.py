from dataclasses import dataclass
from datetime import datetime

@dataclass(frozen=True)
class FeedItem:
    id: int
    title: str
    source_name: str
    original_url: str
    summary: str
    published_at: datetime
