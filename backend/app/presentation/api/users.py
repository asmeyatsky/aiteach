from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.application.dtos import user as user_dto
from app.infrastructure.repositories import generic_crud
from app.infrastructure.database import get_db
from app.infrastructure.auth import create_access_token, verify_password, verify_token
from datetime import timedelta

router = APIRouter()

ACCESS_TOKEN_EXPIRE_MINUTES = 30

@router.post("/register", response_model=user_dto.User)
def register(user: user_dto.UserCreate, db: Session = Depends(get_db)):
    db_user = generic_crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    db_user = generic_crud.get_user_by_username(db, username=user.username)
    if db_user:
        raise HTTPException(status_code=400, detail="Username already registered")
    return generic_crud.create_user(db=db, user=user)

@router.post("/login")
def login(form_data: user_dto.UserLogin, db: Session = Depends(get_db)):
    user = generic_crud.get_user_by_username(db, username=form_data.username)
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=401,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}

@router.get("/me", response_model=user_dto.User)
def get_current_user(username: str = Depends(verify_token), db: Session = Depends(get_db)):
    db_user = generic_crud.get_user_by_username(db, username=username)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user

@router.delete("/username/{username}")
def delete_user_by_username(username: str, db: Session = Depends(get_db)):
    success = generic_crud.delete_user_by_username(db, username=username)
    if not success:
        raise HTTPException(status_code=404, detail="User not found")
    return {"message": f"User '{username}' has been deleted successfully"}

@router.get("/{user_id}", response_model=user_dto.User)
def get_user(user_id: int, db: Session = Depends(get_db)):
    db_user = generic_crud.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user
