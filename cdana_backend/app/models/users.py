from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    phone_number = Column(String(15), unique=True, index=True, nullable=False)
    full_name = Column(String(100), default="دانش‌آموز دانا")
    selected_grade = Column(Integer, default=7) # پایه تحصیلی: ۷، ۸، ۹
    coins = Column(Integer, default=0) # تعداد سکه‌های کیف پول
    current_avatar = Column(String(100), default="image/avatar/1.webp") # آواتار فعال
    current_theme = Column(String(50), default="royal_purple") # تم رنگی فعال
    
    level = Column(Integer, default=1) # لول دانش‌آموز
    streak_count = Column(Integer, default=1) # روزهای متوالی فعالیت
    total_xp = Column(Integer, default=0) # کل امتیاز تجربه

    # اعتبارسنجی پیامکی
    otp_code = Column(String(6), nullable=True)
    otp_expires_at = Column(DateTime, nullable=True)

    # وضعیت دریافت هدیه ۵۰۰ سکه خوش‌آمدگویی (فقط یک‌بار برای هر شماره)
    has_received_welcome_gift = Column(Boolean, default=False)

    created_at = Column(DateTime, default=datetime.utcnow)
    last_activity_date = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # ارتباط با سایر جداول
    progress_records = relationship("LessonProgress", back_populates="user", cascade="all, delete-orphan")
    inventory_items = relationship("UserInventory", back_populates="user", cascade="all, delete-orphan")
    wallet_transactions = relationship("CoinTransaction", back_populates="user", cascade="all, delete-orphan")
    league_records = relationship("LeagueScore", back_populates="user", cascade="all, delete-orphan")
