from pydantic import BaseModel, ConfigDict
from typing import Optional
from app.domain.value_objects.suggestion import SuggestionStatus
from app.domain.value_objects.track import Track

class SuggestedContentBase(BaseModel):
    url: str
    comment: Optional[str] = None
    suggested_track: Track

class SuggestedContentCreate(SuggestedContentBase):
    pass

class SuggestedContent(SuggestedContentBase):
    id: int
    user_id: int
    status: SuggestionStatus
    model_config = ConfigDict(from_attributes=True)
