from dataclasses import dataclass
from datetime import datetime
from typing import Optional

@dataclass(frozen=True)
class PageVisit:
    id: int
    path: str
    method: str
    ip_address: str
    user_agent: str
    user_id: Optional[int]
    timestamp: datetime
