from pydantic import BaseModel
from typing import List

class DailyVisitCount(BaseModel):
    date: str
    count: int

class AnalyticsSummary(BaseModel):
    total_visits: int
    unique_visitors: int
    visits_today: int
    unique_today: int
    visits_per_day: List[DailyVisitCount]
