import os
import logging
import feedparser
import google.generativeai as genai
from datetime import datetime
from sqlalchemy.orm import Session
from app.infrastructure.database import SessionLocal
from app.infrastructure.repositories.orm.feed import FeedItem
from app.core.config import get_settings # Assuming a settings management file exists

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# List of RSS feeds to process
RSS_FEEDS = [
    {"name": "Google AI Blog", "url": "https://ai.googleblog.com/atom.xml"},
    # Add other feeds here
]

# --- Configuration ---
# It's better to manage settings in a centralized way.
# For now, we get it directly from os.environ but this should be improved.
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if not GEMINI_API_KEY:
    logger.warning("GEMINI_API_KEY not found. The feed worker will not be able to summarize content.")
else:
    genai.configure(api_key=GEMINI_API_KEY)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def summarize_text(text: str) -> str:
    """Summarizes the given text using the Gemini API."""
    if not GEMINI_API_KEY:
        return "Summary not available. API key is not configured."
        
    try:
        model = genai.GenerativeModel('gemini-pro')
        prompt = f"Summarize the following article in 2-3 concise sentences for a tech-savvy audience:\n\n{text}"
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        logger.error(f"Error while summarizing with Gemini: {e}")
        return "Summary could not be generated."


def run_feed_worker():
    """
    Fetches articles from RSS feeds, summarizes them, and stores them in the database.
    """
    logger.info("Starting feed worker...")
    db: Session = next(get_db())

    for feed_info in RSS_FEEDS:
        logger.info(f"Processing feed: {feed_info['name']}")
        feed = feedparser.parse(feed_info['url'])

        for entry in feed.entries:
            # Check if the article already exists in the DB by its URL
            exists = db.query(FeedItem).filter(FeedItem.original_url == entry.link).first()
            if exists:
                continue

            logger.info(f"Processing new article: {entry.title}")

            # Get content and summarize
            content_to_summarize = entry.get("summary", "")
            if 'content' in entry: # Often more detailed
                content_to_summarize = entry.content[0].value
            
            summary = summarize_text(content_to_summarize)
            
            # Get published date
            published_dt = datetime.now()
            if hasattr(entry, 'published_parsed'):
                published_dt = datetime(*entry.published_parsed[:6])

            # Create new FeedItem
            new_item = FeedItem(
                title=entry.title,
                source_name=feed_info['name'],
                original_url=entry.link,
                summary=summary,
                published_at=published_dt
            )
            db.add(new_item)

    try:
        db.commit()
        logger.info("Feed items successfully committed to the database.")
    except Exception as e:
        logger.error(f"Error committing feed items to the database: {e}")
        db.rollback()
    finally:
        db.close()


if __name__ == "__main__":
    run_feed_worker()
