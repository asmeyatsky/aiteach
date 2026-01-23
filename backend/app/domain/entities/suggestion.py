from dataclasses import dataclass
from typing import Optional
from app.domain.value_objects.suggestion import SuggestionStatus
from app.domain.value_objects.track import Track

@dataclass(frozen=True)
class SuggestedContent:
    id: int
    user_id: int
    url: str
    comment: Optional[str]
    suggested_track: Track
    status: SuggestionStatus
