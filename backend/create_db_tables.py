import logging
from app.infrastructure.database import create_tables

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

if __name__ == "__main__":
    logger.info("Creating database tables...")
    create_tables()
    logger.info("Database tables creation process finished.")
