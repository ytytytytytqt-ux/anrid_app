from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text, Boolean
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base

class QuranManager(Base):
    """
    مدل مدیران اختصاصی لیگ کلاسی قرآن هفتم.
    هر مدیر دارای یک رمز عبور اختصاصی و یک سقف مجاز برای تعداد کلاس‌های قابل ایجاد است.
    اطلاعات کلاس‌های هر مدیر به صورت کاملاً مجزا نگهداری می‌شود.
    """
    __tablename__ = "quran_managers"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(150), default="مدیر لیگ قرآن")
    passcode = Column(String(50), unique=True, index=True, nullable=False)
    max_classes = Column(Integer, default=3, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    classes = relationship("QuranClass", back_populates="manager", cascade="all, delete-orphan")


class QuranClass(Base):
    """
    کلاس‌های ایجاد شده در لیگ قرآن هفتم.
    کد ۵ رقمی کلاس در کل سامانه (در تمام پنل‌های مدیران) یکتاست.
    """
    __tablename__ = "quran_classes"

    id = Column(Integer, primary_key=True, index=True)
    class_code = Column(String(10), unique=True, index=True, nullable=False)
    teacher_code = Column(String(25), unique=True, index=True, nullable=False)
    title = Column(String(180), default="کلاس قرآن پایه هفتم")
    manager_id = Column(Integer, ForeignKey("quran_managers.id"), nullable=False, index=True)
    students_json = Column(Text, default="[]")
    created_at = Column(DateTime, default=datetime.utcnow)

    manager = relationship("QuranManager", back_populates="classes")
