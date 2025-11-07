from dataclasses import dataclass
from typing import Optional

@dataclass(frozen=True)
class Course:
    id: int
    title: str
    description: str
    tier: str  # free, premium
    thumbnail_url: Optional[str]
