from pydantic import BaseModel, Field
from typing import Optional

class SendOTPRequest(BaseModel):
    phone_number: str = Field(..., example="09123456789", description="شماره موبایل کاربر")

class SendOTPResponse(BaseModel):
    status: str
    message: str
    debug_code: str
    expires_in_seconds: int = 120

class VerifyOTPRequest(BaseModel):
    phone_number: str = Field(..., example="09123456789")
    code: str = Field(..., example="2821", description="کد ۴ رقمی پیامکی")

class UserResponse(BaseModel):
    id: int
    phone_number: str
    full_name: str
    selected_grade: int
    coins: int
    current_avatar: str
    current_theme: str
    level: int
    streak_count: int
    total_xp: int
    has_received_welcome_gift: bool

    class Config:
        from_attributes = True

class VerifyOTPResponse(BaseModel):
    status: str
    message: str
    user: UserResponse
    access_token: Optional[str] = None
    token_type: Optional[str] = "bearer"

class SyncStudentRequest(BaseModel):
    phone_number: str = Field(..., example="09123456789")
    coins: Optional[int] = 500
    selected_grade: Optional[int] = 7
    full_name: Optional[str] = "دانش‌آموز دانا"
    current_avatar: Optional[str] = None
    current_theme: Optional[str] = None
    total_completed_lessons: Optional[int] = 0
    completed_lessons: Optional[list[str]] = None
