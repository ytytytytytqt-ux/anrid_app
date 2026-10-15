import os
from datetime import datetime, timedelta
from typing import Optional
import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session

from database import get_db
from app.models.users import User

# تنظیمات کلید رمزنگاری امنیتی توکن
SECRET_KEY = os.getenv("JWT_SECRET_KEY", "cdana_secure_token_secret_salt_educational_app_2026")
ALGORITHM = "HS256"
# دائمی (۱۰ سال / ۳۶۵۰ روز) تا زمانی که خود کاربر دکمه خروج را نزند هرگز منقضی نشود
ACCESS_TOKEN_EXPIRE_DAYS = 3650

security_scheme = HTTPBearer(auto_error=False)

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """تولید کارت ورود دیجیتال (JWT Token) دائمی تا خروج دستی کاربر"""
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(days=ACCESS_TOKEN_EXPIRE_DAYS)
    
    to_encode.update({"exp": expire, "iat": datetime.utcnow()})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def decode_access_token(token: str) -> Optional[dict]:
    """بررسی و بازگشایی توکن و اطمینان از اصالت و معتبر بودن آن"""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except jwt.PyJWTError:
        return None

def get_current_user(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(security_scheme),
    db: Session = Depends(get_db)
) -> Optional[User]:
    """وابستگی احراز هویت برای APIهای محافظت‌شده سرور"""
    if not credentials:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="توکن امنیتی یافت نشد. لطفاً ابتدا وارد شوید.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    token = credentials.credentials
    payload = decode_access_token(token)
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="توکن ورود نامعتبر یا منقضی شده است.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    phone: str = payload.get("sub")
    if not phone:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="اطلاعات کاربری در توکن یافت نشد.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    user = db.query(User).filter(User.phone_number == phone).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="کاربر مربوط به این توکن یافت نشد.",
        )
    return user
