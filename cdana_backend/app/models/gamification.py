from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base

class LeagueScore(Base):
    """
    جدول لیگ نخبگان، رکورد ماشین‌بازی و رتبه‌بندی دانش‌آموزان هر پایه.
    """
    __tablename__ = "league_scores"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    grade = Column(Integer, nullable=False, index=True) # ۷، ۸، ۹
    game_mode = Column(String(50), default="car_racing") # ماشین‌بازی، چالش ریاضی و...
    high_score = Column(Integer, default=0) # بالاترین امتیاز کسب شده
    coins_won = Column(Integer, default=0) # کل سکه‌های برنده شده از لیگ
    matches_played = Column(Integer, default=0) # تعداد بازی‌ها
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship("User", back_populates="league_records")
