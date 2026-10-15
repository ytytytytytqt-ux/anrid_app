from fastapi import FastAPI
from database import engine, Base
from app.models import users, courses, podcasts, wallet, gamification, store, quran_league
from app.routers import auth, admin, quran_league as quran_router

# ساخت خودکار تمام جداول در فایل دیتابیس cdana.db
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="سامانه جامع آموزشی دانا (CDana Backend)",
    description="سرور و API اختصاصی اپلیکیشن دانا - احراز هویت پیامکی، سکه‌ها، لیگ نخبگان و لیگ کلاسی قرآن",
    version="1.0.0"
)

# اضافه کردن مسیرهای احراز هویت و ورود پیامکی
app.include_router(auth.router)

# اضافه کردن پنل مدیریت اختصاصی و گرافیکی (CMS)
app.include_router(admin.router)

# اضافه کردن مسیرهای اختصاصی لیگ کلاسی قرآن هفتم
app.include_router(quran_router.router)

# صفحه اصلی سرور
@app.get("/", tags=["صفحه اصلی"])
def home():
    return {
        "status": "online",
        "message": "سلام به آکادمی دانا! سرور و دیتابیس با موفقیت فعال هستند! 🚀",
        "database": "SQLite (cdana.db)",
        "docs_url": "/docs"
    }
