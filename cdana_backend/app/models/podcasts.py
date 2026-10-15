from sqlalchemy import Column, Integer, String, Boolean, DateTime
from datetime import datetime
from database import Base

class Podcast(Base):
    """
    جدول پادکست‌های انگیزشی، مشاوره‌ای و آموزشی دانش‌آموزان
    """
    __tablename__ = "podcasts"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(150), nullable=False) # عنوان پادکست
    author = Column(String(100), default="استاد دانا") # گوینده یا مشاور
    audio_url = Column(String(255), nullable=False) # لینک فایل صوتی
    image_url = Column(String(255), nullable=True) # کاور پادکست
    duration_minutes = Column(Integer, default=5) # مدت زمان به دقیقه
    is_premium = Column(Boolean, default=False) # آیا نیازمند سکه است؟
    unlock_cost = Column(Integer, default=0) # هزینه باز کردن به سکه
    created_at = Column(DateTime, default=datetime.utcnow)
