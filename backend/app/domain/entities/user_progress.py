from dataclasses import dataclass
from datetime import datetime

@dataclass(frozen=True)
class UserProgress:
    user_id: int
    lesson_id: int
    completed_at: datetime
