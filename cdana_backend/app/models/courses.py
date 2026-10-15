from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base

class Course(Base):
    __tablename__ = "courses"

    id = Column(Integer, primary_key=True, index=True)
    grade = Column(Integer, nullable=False, index=True) # ۷، ۸، یا ۹
    subject_code = Column(String(50), nullable=False) # riyazi, olom, farsi, motaleat, payam, arabic, zaban
    title = Column(String(100), nullable=False) # عنوان کتاب (مثلاً: ریاضی هفتم)
    icon_path = Column(String(100), nullable=True) # آیکون یا تصویر جلد کتاب
    total_lessons = Column(Integer, default=0) # کل تعداد درس‌ها / فصول

class LessonProgress(Base):
    """
    جدول ثبت پیشرفت دقیق درس‌ها برای هر دانش‌آموز بر اساس شماره کاربری و پایه.
    این جدول منطبق بر کلیدهای واقعی برنامه (مانند riyazi7Chapter1Completed و lesson1Part1Completed) عمل می‌کند.
    """
    __tablename__ = "lesson_progress"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    grade = Column(Integer, nullable=False) # پایه ۷، ۸، ۹
    subject_code = Column(String(50), nullable=False) # riyazi, olom, ...
    lesson_key = Column(String(100), nullable=False, index=True) # نام شناسه درس (مثلاً: riyazi8Chapter2Completed)
    is_completed = Column(Boolean, default=True)
    stars = Column(Integer, default=3) # تعداد ستاره‌های کسب شده در این مرحله
    score = Column(Integer, default=100) # امتیاز کسب شده در مرحله
    completed_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="progress_records")
