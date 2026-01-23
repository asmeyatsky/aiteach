from sqlalchemy import Column, Integer, String, Text, Enum, ForeignKey, DateTime
from sqlalchemy.sql import func
from .base import Base

class SuggestedContent(Base):
    __tablename__ = "suggested_content"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    url = Column(String, nullable=False)
    comment = Column(Text)
    suggested_track = Column(String, nullable=False) # Corresponds to the Track enum
    status = Column(Enum('pending', 'approved', 'rejected', name='suggested_content_status'), nullable=False, default='pending')
    created_at = Column(DateTime(timezone=True), server_default=func.now())
