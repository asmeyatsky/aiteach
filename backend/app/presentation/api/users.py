import os
from fastapi import APIRouter, Depends, HTTPException, Request
from app.application.dtos import user as user_dto
from app.domain.ports.repository_ports import UserRepositoryPort
from app.dependencies import get_user_repository
from app.infrastructure.auth import create_access_token, verify_password, verify_token, get_current_user, ACCESS_TOKEN_EXPIRE_MINUTES
from datetime import timedelta

router = APIRouter()

_limiter = None
if os.getenv("TESTING") != "True":
    try:
        from slowapi import Limiter
        from slowapi.util import get_remote_address
        _limiter = Limiter(key_func=get_remote_address)
    except ImportError:
        pass


def _rate_limit(limit_string):
    """Apply rate limit decorator if slowapi is available and not in test mode."""
    if _limiter is not None:
        return _limiter.limit(limit_string)
    def noop(func):
        return func
    return noop


@router.post("/register", response_model=user_dto.User)
@_rate_limit("5/minute")
def register(request: Request, user: user_dto.UserCreate, user_repo: UserRepositoryPort = Depends(get_user_repository)):
    db_user = user_repo.get_user_by_email(user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    db_user = user_repo.get_user_by_username(user.username)
    if db_user:
        raise HTTPException(status_code=400, detail="Username already registered")
    return user_repo.create_user(user)

@router.post("/login")
@_rate_limit("10/minute")
def login(request: Request, form_data: user_dto.UserLogin, user_repo: UserRepositoryPort = Depends(get_user_repository)):
    user = user_repo.get_user_by_username(form_data.username)
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=401,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username, "user_id": user.id}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer", "user_id": user.id}

@router.get("/me", response_model=user_dto.User)
def read_current_user(username: str = Depends(verify_token), user_repo: UserRepositoryPort = Depends(get_user_repository)):
    db_user = user_repo.get_user_by_username(username)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user

@router.delete("/username/{username}")
def delete_user_by_username(username: str, current_user: dict = Depends(get_current_user), user_repo: UserRepositoryPort = Depends(get_user_repository)):
    if current_user["username"] != username:
        raise HTTPException(status_code=403, detail="You can only delete your own account")
    success = user_repo.delete_user_by_username(username)
    if not success:
        raise HTTPException(status_code=404, detail="User not found")
    return {"message": f"User '{username}' has been deleted successfully"}

@router.get("/{user_id}", response_model=user_dto.User)
def get_user(user_id: int, user_repo: UserRepositoryPort = Depends(get_user_repository)):
    db_user = user_repo.get_user(user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user
