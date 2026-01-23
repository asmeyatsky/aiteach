from fastapi import APIRouter, Depends
from typing import List
from app.application.dtos import feed as feed_dto
from app.domain.ports.repository_ports import FeedRepositoryPort
from app.dependencies import get_feed_repository

router = APIRouter()

@router.get("/", response_model=List[feed_dto.FeedItem])
def read_feed(
    skip: int = 0,
    limit: int = 20, # Default to a smaller number for a feed
    feed_repo: FeedRepositoryPort = Depends(get_feed_repository)
):
    feed_items = feed_repo.get_feed_items(skip=skip, limit=limit)
    return feed_items
