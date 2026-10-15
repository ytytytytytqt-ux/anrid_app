import random
from datetime import datetime, timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from database import get_db
from app.models.users import User
from app.models.courses import LessonProgress
from app.schemas.users import (
    SendOTPRequest,
    SendOTPResponse,
    VerifyOTPRequest,
    VerifyOTPResponse,
    UserResponse,
    SyncStudentRequest
)
from app.services.sms import send_otp_sms
from app.services.security import create_access_token, get_current_user

router = APIRouter(prefix="/auth", tags=["ورود و ثبت‌نام (Authentication)"])

@router.post("/send-otp", response_model=SendOTPResponse, summary="ارسال کد تأیید پیامکی")
def send_otp(req: SendOTPRequest, db: Session = Depends(get_db)):
    phone = req.phone_number.strip()
    if not phone or len(phone) < 10:
        raise HTTPException(status_code=400, detail="شماره تلفن معتبر نیست")

    # تولید کد تصادفی ۴ رقمی
    code = str(random.randint(1000, 9999))
    # اعتبار دقیقاً ۲ دقیقه (۱۲۰ ثانیه)
    expires_at = datetime.utcnow() + timedelta(minutes=2)

    user = db.query(User).filter(User.phone_number == phone).first()
    if not user:
        user = User(
            phone_number=phone,
            otp_code=code,
            otp_expires_at=expires_at,
            coins=500,
            full_name="دانش‌آموز دانا"
        )
        db.add(user)
    else:
        user.otp_code = code
        user.otp_expires_at = expires_at

    db.commit()
    db.refresh(user)

    # ارسال کد از طریق سرویس پیامکی (شبیه‌ساز فعلی یا سامانه واقعی در آینده)
    send_otp_sms(phone, code)

    return SendOTPResponse(
        status="success",
        message=f"کد تأیید برای شماره {phone} ارسال شد (اعتبار ۲ دقیقه)",
        debug_code=code,
        expires_in_seconds=120
    )

@router.post("/verify-otp", response_model=VerifyOTPResponse, summary="تأیید کد و ورود به برنامه")
def verify_otp(req: VerifyOTPRequest, db: Session = Depends(get_db)):
    phone = req.phone_number.strip()
    code = req.code.strip()

    user = db.query(User).filter(User.phone_number == phone).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="کاربری با این شماره یافت نشد. ابتدا درخواست کد بدهید."
        )

    # پذیرش کد مستر تستی 1111 یا کد تولید شده
    is_master_code = (code == "1111")
    is_valid_code = (user.otp_code == code)

    if not (is_master_code or is_valid_code):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="کد وارد شده اشتباه است ❌"
        )

    # بررسی منقضی شدن کد (۲ دقیقه) - برای کد مستر ۱۱۱۱ همیشه معتبر است
    if not is_master_code:
        if not user.otp_expires_at or datetime.utcnow() > user.otp_expires_at:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="کد منقضی شده است! مهلت ۲ دقیقه‌ای به پایان رسیده است ⏳"
            )

    # کد با موفقیت تایید شد؛ پاک‌سازی کد موقت
    user.otp_code = None
    user.otp_expires_at = None
    db.commit()
    db.refresh(user)

    # صدور توکن امنیتی ورود دیجیتال (JWT)
    access_token = create_access_token(data={"sub": user.phone_number, "user_id": user.id})

    return VerifyOTPResponse(
        status="success",
        message="ورود با موفقیت انجام شد! خوش آمدید 🎉",
        user=UserResponse.model_validate(user),
        access_token=access_token,
        token_type="bearer"
    )

@router.get("/me", response_model=UserResponse, summary="دریافت اطلاعات کاربر با کارت ورود امنیتی (JWT)")
def get_current_user_profile(current_user: User = Depends(get_current_user)):
    """این اندپوینت فقط در صورتی پاسخ می‌دهد که توکن معتبر ارسال شده باشد"""
    return UserResponse.model_validate(current_user)

@router.post("/sync-student", response_model=UserResponse, summary="همگام‌سازی و ثبت دانش‌آموز در پنل ادمین")
def sync_student(req: SyncStudentRequest, db: Session = Depends(get_db)):
    """ثبت یا به‌روزرسانی کامل اطلاعات دانش‌آموز اعم از سکه، آواتار، تم و درس‌های تکمیل‌شده"""
    phone = req.phone_number.strip()
    user = db.query(User).filter(User.phone_number == phone).first()
    if not user:
        user = User(
            phone_number=phone,
            coins=req.coins if req.coins is not None else 500,
            selected_grade=req.selected_grade or 7,
            full_name=req.full_name or "دانش‌آموز دانا",
            current_avatar=req.current_avatar or "image/avatar/1.webp",
            current_theme=req.current_theme or "royal_purple",
            total_xp=req.total_completed_lessons or 0
        )
        db.add(user)
    else:
        if req.coins is not None:
            user.coins = req.coins
        if req.selected_grade is not None:
            user.selected_grade = req.selected_grade
        if req.full_name:
            user.full_name = req.full_name
        if req.current_avatar:
            user.current_avatar = req.current_avatar
        if req.current_theme:
            user.current_theme = req.current_theme
        if req.total_completed_lessons is not None:
            user.total_xp = req.total_completed_lessons

    db.commit()
    db.refresh(user)

    # ثبت درس‌های انجام‌شده در جدول سوابق درس‌ها (LessonProgress)
    if req.completed_lessons:
        existing_keys = {
            res[0] for res in db.query(LessonProgress.lesson_key).filter(LessonProgress.user_id == user.id).all()
        }
        for l_key in req.completed_lessons:
            if l_key not in existing_keys:
                progress = LessonProgress(
                    user_id=user.id,
                    grade=user.selected_grade,
                    subject_code="general",
                    lesson_key=l_key,
                    is_completed=True,
                    stars=3,
                    score=100
                )
                db.add(progress)
        db.commit()

    return UserResponse.model_validate(user)

