import os
import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI, HTTPException, status
from fastapi.responses import JSONResponse
from app.presentation.api import users, courses, forum, gamification, user_progress
from app.infrastructure.database import create_tables, check_db_connection
from app.infrastructure.middleware import setup_middleware

# Configure logging
logging.basicConfig(
    level=getattr(logging, os.getenv("LOG_LEVEL", "INFO")),
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("Starting AI Education Platform API")

    if os.getenv("TESTING") != "True":
        # Check database connection
        if not check_db_connection():
            logger.error("Database connection failed!")
            raise Exception("Database connection failed")

        # Create tables
        create_tables()
        logger.info("Database tables created/verified")

    yield

    logger.info("Shutting down AI Education Platform API")

app = FastAPI(
    title="AI Education Platform API",
    description="API for the AI Education Platform, providing user management, course content, forum, and gamification features.",
    version="1.0.0",
    lifespan=lifespan,
    docs_url="/docs" if os.getenv("DEBUG", "False").lower() == "true" else None,
    redoc_url="/redoc" if os.getenv("DEBUG", "False").lower() == "true" else None,
)

# Setup middleware
if os.getenv("TESTING") != "True":
    setup_middleware(app)

# Global exception handler
@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    logger.error(f"Global exception: {exc}")
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={"detail": "Internal server error"}
    )

# Include routers
app.include_router(users.router, prefix="/users", tags=["users"])
app.include_router(courses.router, prefix="/courses", tags=["courses"])
app.include_router(forum.router, prefix="/forum", tags=["forum"])
app.include_router(gamification.router, prefix="/gamification", tags=["gamification"])
app.include_router(user_progress.router, prefix="/progress", tags=["progress"])

@app.get("/")
async def read_root():
    return {"message": "Welcome to the AI Education Platform API", "status": "healthy"}

@app.get("/health")
async def health_check():
    """Health check endpoint for load balancer"""
    db_status = check_db_connection()
    return {
        "status": "healthy" if db_status else "unhealthy",
        "database": "connected" if db_status else "disconnected",
        "version": "1.0.0"
    }
