import json
import random
from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from database import get_db
from app.models.quran_league import QuranManager, QuranClass

router = APIRouter(prefix="/api/quran", tags=["لیگ قرآن هفتم (مدیران و کلاس‌ها)"])

class ManagerVerifyRequest(BaseModel):
    passcode: str

class ClassCreateRequest(BaseModel):
    passcode: str
    class_code: str
    teacher_code: str
    title: Optional[str] = "کلاس قرآن پایه هفتم"

class ClassSyncRequest(BaseModel):
    passcode: Optional[str] = None
    class_code: str
    title: Optional[str] = None
    students: list = []

@router.post("/manager/verify", summary="احراز هویت رمز مدیر اختصاصی در اپلیکیشن")
def verify_manager(req: ManagerVerifyRequest, db: Session = Depends(get_db)):
    code = req.passcode.strip()
    if not code:
        raise HTTPException(status_code=400, detail="رمز ورود مدیر نمی‌تواند خالی باشد")
    
    # کد ۱۰ تا ۱ دیگر منسوخ شده و معتبر نیست
    if code == "1111111111":
        raise HTTPException(status_code=403, detail="رمز پیش‌فرض منسوخ شده است. لطفاً رمز تعریف‌شده در پنل ادمین را وارد کنید.")

    manager = db.query(QuranManager).filter(QuranManager.passcode == code, QuranManager.is_active == True).first()
    if not manager:
        raise HTTPException(
            status_code=401,
            detail="رمز ورود مدیر نادرست است! ابتدا باید در پنل مدیریت سامانه (http://127.0.0.1:8000/admin) تعریف شود."
        )

    # کلاس‌های این مدیر
    classes = db.query(QuranClass).filter(QuranClass.manager_id == manager.id).all()
    
    # تمام کدهای ۵ رقمی استفاده شده در کل سامانه (در همه پنل‌های مدیران)
    all_codes = [c.class_code for c in db.query(QuranClass.class_code).all()]

    classes_data = []
    for c in classes:
        try:
            st_list = json.loads(c.students_json) if c.students_json else []
        except:
            st_list = []
        classes_data.append({
            "classCode": c.class_code,
            "teacherCode": c.teacher_code,
            "title": c.title,
            "createdAt": c.created_at.isoformat() if c.created_at else datetime.utcnow().isoformat(),
            "students": st_list
        })

    return {
        "status": "success",
        "manager": {
            "id": manager.id,
            "name": manager.name,
            "passcode": manager.passcode,
            "max_classes": manager.max_classes,
            "created_classes_count": len(classes_data)
        },
        "classes": classes_data,
        "all_existing_codes": all_codes
    }

@router.post("/classes/create", summary="ایجاد کلاس جدید توسط مدیر با رعایت سقف مجاز")
def create_class(req: ClassCreateRequest, db: Session = Depends(get_db)):
    code = req.passcode.strip()
    class_code = req.class_code.strip()
    teacher_code = req.teacher_code.strip()
    title = (req.title or "کلاس قرآن پایه هفتم").strip()

    # ۱. احراز هویت مدیر
    manager = db.query(QuranManager).filter(QuranManager.passcode == code, QuranManager.is_active == True).first()
    if not manager:
        raise HTTPException(status_code=401, detail="مجوز مدیر یافت نشد یا غیرفعال است")

    # ۲. بررسی سقف مجاز ایجاد کلاس
    current_count = db.query(QuranClass).filter(QuranClass.manager_id == manager.id).count()
    if current_count >= manager.max_classes:
        raise HTTPException(
            status_code=400,
            detail=f"سقف مجاز ایجاد کلاس برای شما ({manager.max_classes} کلاس) تکمیل شده است! امکان ایجاد کلاس بیشتر وجود ندارد."
        )

    # ۳. بررسی یکتا بودن کد کلاس در کل سامانه (در هیچ پنل مدیری نباید تکراری باشد)
    exists = db.query(QuranClass).filter(QuranClass.class_code == class_code).first()
    if exists:
        raise HTTPException(
            status_code=400,
            detail=f"کد کلاس {class_code} قبلاً در سامانه ثبت شده است. لطفاً یک کد ۵ رقمی دیگر انتخاب کنید."
        )

    # ۴. ذخیره کلاس جدید
    new_class = QuranClass(
        class_code=class_code,
        teacher_code=teacher_code,
        title=title,
        manager_id=manager.id,
        students_json="[]",
        created_at=datetime.utcnow()
    )
    db.add(new_class)
    db.commit()
    db.refresh(new_class)

    return {
        "status": "success",
        "message": "کلاس با موفقیت ایجاد شد",
        "class": {
            "classCode": new_class.class_code,
            "teacherCode": new_class.teacher_code,
            "title": new_class.title,
            "createdAt": new_class.created_at.isoformat(),
            "students": []
        },
        "created_classes_count": current_count + 1,
        "max_classes": manager.max_classes
    }

@router.get("/classes/all-codes", summary="دریافت تمام کدهای کلاس استفاده شده در کل دیتابیس")
def get_all_class_codes(db: Session = Depends(get_db)):
    codes = [c.class_code for c in db.query(QuranClass.class_code).all()]
    return {"status": "success", "codes": codes}

@router.post("/classes/sync", summary="همگام‌سازی اطلاعات و دانش‌آموزان کلاس")
def sync_class_data(req: ClassSyncRequest, db: Session = Depends(get_db)):
    q_class = db.query(QuranClass).filter(QuranClass.class_code == req.class_code.strip()).first()
    if not q_class:
        raise HTTPException(status_code=404, detail="کلاس مورد نظر یافت نشد")
    
    if req.title:
        q_class.title = req.title.strip()
    
    q_class.students_json = json.dumps(req.students, ensure_ascii=False)
    db.commit()
    return {"status": "success", "message": "اطلاعات کلاس همگام شد"}

@router.get("/classes/lookup/{code}", summary="جستجوی کلاس برای ورود دانش‌آموز یا معلم")
def lookup_class(code: str, db: Session = Depends(get_db)):
    c = code.strip()
    # ابتدا بررسی کد ۵ رقمی دانش‌آموز
    q_class = db.query(QuranClass).filter(QuranClass.class_code == c).first()
    # اگر نبود بررسی کد ۱۰ رقمی معلم
    if not q_class:
        q_class = db.query(QuranClass).filter(QuranClass.teacher_code == c).first()

    if not q_class:
        raise HTTPException(status_code=404, detail="کلاسی با این کد یافت نشد")

    try:
        st_list = json.loads(q_class.students_json) if q_class.students_json else []
    except:
        st_list = []

    return {
        "status": "success",
        "class": {
            "classCode": q_class.class_code,
            "teacherCode": q_class.teacher_code,
            "title": q_class.title,
            "createdAt": q_class.created_at.isoformat() if q_class.created_at else datetime.utcnow().isoformat(),
            "students": st_list
        }
    }
