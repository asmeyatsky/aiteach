from fastapi import APIRouter, Depends, Query
from app.domain.ports.repository_ports import AnalyticsRepositoryPort
from app.dependencies import get_analytics_repository
from app.application.dtos.analytics import AnalyticsSummary

router = APIRouter()

@router.get("/summary", response_model=AnalyticsSummary)
def get_analytics_summary(
    days: int = Query(default=30, ge=1, le=365),
    analytics_repo: AnalyticsRepositoryPort = Depends(get_analytics_repository),
):
    return analytics_repo.get_summary(days=days)
