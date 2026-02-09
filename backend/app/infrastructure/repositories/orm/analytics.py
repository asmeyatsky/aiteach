from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.sql import func
from .base import Base

class PageVisit(Base):
    __tablename__ = "page_visits"

    id = Column(Integer, primary_key=True, index=True)
    path = Column(String, index=True)
    method = Column(String)
    ip_address = Column(String, index=True)
    user_agent = Column(String)
    user_id = Column(Integer, nullable=True)
    timestamp = Column(DateTime(timezone=True), server_default=func.now(), index=True)
