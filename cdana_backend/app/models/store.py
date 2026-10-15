from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base

class UserInventory(Base):
    """
    جدول آیتم‌های خریداری شده و آنلاک شده توسط کاربر از فروشگاه
    (آواتارها، تم‌های رنگی مانند royal_purple، و بسته‌های VIP)
    """
    __tablename__ = "user_inventories"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    item_type = Column(String(50), nullable=False) # 'avatar', 'theme', 'vip'
    item_identifier = Column(String(100), nullable=False) # e.g. 'image/avatar/5.webp', 'neon_emerald', 'vip_grade_7'
    cost_paid = Column(Integer, default=0) # مقدار سکه‌ای که پرداخت شده
    unlocked_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="inventory_items")
