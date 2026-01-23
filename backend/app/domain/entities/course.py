from dataclasses import dataclass
from typing import Optional
from app.domain.value_objects.track import Track

@dataclass(frozen=True)
class Course:
    id: int
    title: str
    description: str
    tier: Track  # user, builder, innovator
    thumbnail_url: Optional[str]
