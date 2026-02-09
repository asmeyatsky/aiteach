from sqlalchemy.orm import Session
from sqlalchemy import func, cast, Date
from datetime import datetime, timedelta, timezone
from typing import List
from app.domain.ports.repository_ports import AnalyticsRepositoryPort
from app.infrastructure.repositories.orm.analytics import PageVisit
from app.application.dtos.analytics import AnalyticsSummary, DailyVisitCount

class AnalyticsRepository(AnalyticsRepositoryPort):
    def __init__(self, db: Session):
        self.db = db

    def record_visit(self, path: str, method: str, ip_address: str, user_agent: str, user_id: int = None):
        visit = PageVisit(
            path=path,
            method=method,
            ip_address=ip_address,
            user_agent=user_agent,
            user_id=user_id,
        )
        self.db.add(visit)
        self.db.commit()

    def get_summary(self, days: int = 30) -> AnalyticsSummary:
        now = datetime.now(timezone.utc)
        start_date = now - timedelta(days=days)
        today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)

        total_visits = self.db.query(func.count(PageVisit.id)).scalar() or 0
        unique_visitors = self.db.query(func.count(func.distinct(PageVisit.ip_address))).scalar() or 0

        visits_today = self.db.query(func.count(PageVisit.id)).filter(
            PageVisit.timestamp >= today_start
        ).scalar() or 0

        unique_today = self.db.query(func.count(func.distinct(PageVisit.ip_address))).filter(
            PageVisit.timestamp >= today_start
        ).scalar() or 0

        daily_rows = (
            self.db.query(
                cast(PageVisit.timestamp, Date).label("date"),
                func.count(PageVisit.id).label("count"),
            )
            .filter(PageVisit.timestamp >= start_date)
            .group_by(cast(PageVisit.timestamp, Date))
            .order_by(cast(PageVisit.timestamp, Date))
            .all()
        )

        visits_per_day: List[DailyVisitCount] = [
            DailyVisitCount(date=str(row.date), count=row.count)
            for row in daily_rows
        ]

        return AnalyticsSummary(
            total_visits=total_visits,
            unique_visitors=unique_visitors,
            visits_today=visits_today,
            unique_today=unique_today,
            visits_per_day=visits_per_day,
        )
