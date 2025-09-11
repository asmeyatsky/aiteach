from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import users, courses, forum, gamification, user_progress
from app.database import create_tables

@asynccontextmanager
async def lifespan(app: FastAPI):
    create_tables()
    yield

app = FastAPI(
    title="AI Education Platform API",
    description="API for the AI Education Platform, providing user management, course content, forum, and gamification features.",
    version="1.0.0",
    lifespan=lifespan
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In a real app, restrict this to your frontend's domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(users.router, prefix="/users", tags=["users"])
app.include_router(courses.router, prefix="/courses", tags=["courses"])
app.include_router(forum.router, prefix="/forum", tags=["forum"])
app.include_router(gamification.router, prefix="/gamification", tags=["gamification"])
app.include_router(user_progress.router, prefix="/progress", tags=["progress"])

@app.get("/")
def read_root():
    return {"message": "Welcome to the AI Education Platform API"}
