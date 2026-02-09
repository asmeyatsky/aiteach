import os
import logging
from sqlalchemy import create_engine, event, text
from sqlalchemy.orm import sessionmaker
from app.infrastructure.repositories.orm.base import Base
from app.infrastructure.repositories.orm import user, course, lesson, forum, gamification, user_progress, project, feed, suggestion, analytics
from sqlalchemy.pool import StaticPool

logger = logging.getLogger(__name__)

# Database URL with fallback for development
SQLALCHEMY_DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://devuser:devpassword@db:5432/aiteach_dev")

# Connection pool settings
MAX_CONNECTIONS = int(os.getenv("MAX_CONNECTIONS_COUNT", "10"))
MIN_CONNECTIONS = int(os.getenv("MIN_CONNECTIONS_COUNT", "5"))

# Configure engine based on environment
if SQLALCHEMY_DATABASE_URL.startswith("postgresql://"):
    # Production/Cloud SQL configuration
    engine = create_engine(
        SQLALCHEMY_DATABASE_URL,
        pool_size=MAX_CONNECTIONS,
        max_overflow=20,
        pool_pre_ping=True,
        pool_recycle=3600,
        pool_timeout=30,
        echo=os.getenv("DEBUG", "False").lower() == "true"
    )
else:
    # Development configuration
    engine = create_engine(
        SQLALCHEMY_DATABASE_URL,
        poolclass=StaticPool,
        connect_args={"check_same_thread": False} if "sqlite" in SQLALCHEMY_DATABASE_URL else {},
        echo=os.getenv("DEBUG", "False").lower() == "true"
    )

# Add connection event listeners for Cloud SQL
@event.listens_for(engine, "connect")
def set_sqlite_pragma(dbapi_connection, connection_record):
    if "sqlite" in SQLALCHEMY_DATABASE_URL:
        cursor = dbapi_connection.cursor()
        cursor.execute("PRAGMA foreign_keys=ON")
        cursor.close()

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_db():
    """Dependency to get database session"""
    db = SessionLocal()
    try:
        yield db
    except Exception as e:
        logger.error(f"Database session error: {e}")
        db.rollback()
        raise
    finally:
        db.close()

def create_tables():
    """Create all database tables"""
    try:
        Base.metadata.create_all(bind=engine)
        logger.info("Database tables created successfully")
    except Exception as e:
        logger.error(f"Error creating database tables: {e}")
        raise

def check_db_connection():
    """Check if database connection is working"""
    try:
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))
            logger.info("Database connection successful")
            return True
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        return False
