import os
import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI, HTTPException, status, Request
from fastapi.responses import JSONResponse
from app.presentation.api import users, courses, forum, gamification, user_progress, projects, feed, suggestions, playground
from app.infrastructure.database import create_tables, check_db_connection
from app.infrastructure.middleware import setup_middleware
from app.infrastructure.monitoring import monitoring_middleware

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

    # Add monitoring middleware
    @app.middleware("http")
    async def monitoring_middleware_handler(request: Request, call_next):
        return await monitoring_middleware(request, call_next)

# Rate limiting for auth endpoints
try:
    from slowapi import Limiter
    from slowapi.util import get_remote_address
    from slowapi.errors import RateLimitExceeded

    limiter = Limiter(key_func=get_remote_address)
    app.state.limiter = limiter

    @app.exception_handler(RateLimitExceeded)
    async def rate_limit_handler(request, exc):
        return JSONResponse(
            status_code=429,
            content={"detail": "Rate limit exceeded. Please try again later."}
        )
except ImportError:
    limiter = None

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
app.include_router(projects.router, prefix="/projects", tags=["projects"])
app.include_router(feed.router, prefix="/feed", tags=["feed"])
app.include_router(suggestions.router, prefix="/suggestions", tags=["suggestions"])
app.include_router(playground.router, prefix="/playground", tags=["playground"])

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
