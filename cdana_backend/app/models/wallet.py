from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base

class CoinTransaction(Base):
    """
    جدول تاریخچه سکه‌ها و تراکنش‌های کیف پول دانش‌آموز.
    (شامل هدیه ثبت‌نام ۵۰۰ سکه، جوایز بردن درس‌ها و لیگ، و خریدهای فروشگاه)
    """
    __tablename__ = "coin_transactions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    amount = Column(Integer, nullable=False) # مثبت برای واریز (+500)، منفی برای خرید (-150)
    transaction_type = Column(String(50), nullable=False) # welcome_gift, lesson_reward, league_prize, theme_purchase, avatar_purchase
    title = Column(String(100), nullable=False) # عنوان تراکنش برای نمایش در تاریخچه
    description = Column(String(255), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="wallet_transactions")
