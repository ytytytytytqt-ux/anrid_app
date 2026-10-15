import json
from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import HTMLResponse
from sqlalchemy.orm import Session
from sqlalchemy import func

from database import get_db
from app.models.users import User
from app.models.courses import Course, LessonProgress
from app.models.wallet import CoinTransaction
from app.models.store import UserInventory
from app.models.gamification import LeagueScore
from app.models.quran_league import QuranManager, QuranClass
from pydantic import BaseModel

class AddQuranManagerRequest(BaseModel):
    name: str
    passcode: str
    max_classes: int

router = APIRouter(prefix="/admin", tags=["پیشخوان مدیریت اختصاصی"])

@router.get("", response_class=HTMLResponse, summary="پیشخوان مدیریت آکادمی دانا")
def admin_dashboard(db: Session = Depends(get_db)):
    total_users = db.query(User).count()
    total_coins = db.query(func.sum(User.coins)).scalar() or 0
    total_progress = db.query(LessonProgress).count()
    total_inventory = db.query(UserInventory).count()

    quran_managers = db.query(QuranManager).order_by(QuranManager.id.desc()).all()
    quran_classes = db.query(QuranClass).order_by(QuranClass.id.desc()).all()
    total_quran_classes = len(quran_classes)

    users_list = db.query(User).order_by(User.id.desc()).all()
    transactions = db.query(CoinTransaction).order_by(CoinTransaction.id.desc()).limit(40).all()
    inventory_items = db.query(UserInventory).order_by(UserInventory.id.desc()).limit(40).all()
    league_scores = db.query(LeagueScore).order_by(LeagueScore.high_score.desc()).limit(30).all()

    html = f"""<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>پیشخوان مدیریت آکادمی سی دانا</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@300;400;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {{
            --bg-base: #0B0F19;
            --bg-card: rgba(17, 24, 39, 0.75);
            --bg-glass: rgba(30, 41, 59, 0.5);
            --border-glow: rgba(56, 189, 248, 0.25);
            --border-subtle: rgba(255, 255, 255, 0.08);
            --accent-cyan: #38BDF8;
            --accent-purple: #818CF8;
            --accent-emerald: #10B981;
            --accent-amber: #F59E0B;
            --accent-rose: #F43F5E;
            --text-main: #F8FAFC;
            --text-muted: #94A3B8;
        }}

        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Vazirmatn', -apple-system, BlinkMacSystemFont, Tahoma, sans-serif;
        }}

        body {{
            background: radial-gradient(circle at 10% 20%, rgba(30, 58, 138, 0.35) 0%, transparent 40%),
                        radial-gradient(circle at 90% 80%, rgba(88, 28, 135, 0.3) 0%, transparent 45%),
                        var(--bg-base);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            overflow-x: hidden;
        }}

        /* سایدبار ناوبری */
        .sidebar {{
            width: 270px;
            background: rgba(15, 23, 42, 0.85);
            backdrop-filter: blur(20px);
            border-left: 1px solid var(--border-subtle);
            padding: 24px 16px;
            display: flex;
            flex-direction: column;
            gap: 28px;
            position: fixed;
            top: 0;
            bottom: 0;
            right: 0;
            z-index: 100;
        }}

        .brand {{
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0 8px 16px 8px;
            border-bottom: 1px solid var(--border-subtle);
        }}

        .brand-icon {{
            width: 44px;
            height: 44px;
            border-radius: 14px;
            background: linear-gradient(135deg, #38BDF8, #818CF8);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            box-shadow: 0 0 20px rgba(56, 189, 248, 0.4);
        }}

        .brand-text h1 {{
            font-size: 17px;
            font-weight: 800;
            color: #fff;
            letter-spacing: -0.5px;
        }}

        .brand-text p {{
            font-size: 11px;
            color: var(--accent-cyan);
            font-weight: 600;
        }}

        .nav-list {{
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
        }}

        .nav-item {{
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            border-radius: 12px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 13.5px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.25s ease;
            border: 1px solid transparent;
        }}

        .nav-item:hover {{
            color: #fff;
            background: rgba(255, 255, 255, 0.05);
        }}

        .nav-item.active {{
            color: #fff;
            background: linear-gradient(135deg, rgba(56, 189, 248, 0.15), rgba(129, 140, 248, 0.15));
            border-color: rgba(56, 189, 248, 0.35);
            box-shadow: 0 4px 15px rgba(56, 189, 248, 0.15);
        }}

        .nav-item .icon {{
            font-size: 18px;
        }}

        /* محتوای اصلی */
        .main-content {{
            margin-right: 270px;
            flex: 1;
            padding: 32px 36px;
            display: flex;
            flex-direction: column;
            gap: 32px;
        }}

        /* هدر بالا */
        .top-bar {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--bg-card);
            backdrop-filter: blur(16px);
            padding: 18px 24px;
            border-radius: 20px;
            border: 1px solid var(--border-subtle);
        }}

        .top-title h2 {{
            font-size: 20px;
            font-weight: 800;
            color: #fff;
        }}

        .top-title p {{
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 2px;
        }}

        .status-badge {{
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(16, 185, 129, 0.12);
            border: 1px solid rgba(16, 185, 129, 0.35);
            padding: 8px 16px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            color: #10B981;
        }}

        .pulse-dot {{
            width: 8px;
            height: 8px;
            background: #10B981;
            border-radius: 50%;
            box-shadow: 0 0 10px #10B981;
            animation: pulse 1.6s infinite;
        }}

        @keyframes pulse {{
            0% {{ opacity: 0.4; transform: scale(0.9); }}
            50% {{ opacity: 1; transform: scale(1.2); }}
            100% {{ opacity: 0.4; transform: scale(0.9); }}
        }}

        /* کارت‌های آماری */
        .stats-grid {{
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }}

        .stat-card {{
            background: var(--bg-card);
            backdrop-filter: blur(16px);
            border: 1px solid var(--border-subtle);
            border-radius: 20px;
            padding: 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
            transition: transform 0.25s ease, border-color 0.25s ease;
        }}

        .stat-card:hover {{
            transform: translateY(-3px);
            border-color: var(--border-glow);
        }}

        .stat-info p {{
            font-size: 12.5px;
            color: var(--text-muted);
            font-weight: 600;
        }}

        .stat-info h3 {{
            font-size: 26px;
            font-weight: 900;
            color: #fff;
            margin-top: 6px;
        }}

        .stat-icon {{
            width: 52px;
            height: 52px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }}

        .icon-blue {{ background: rgba(56, 189, 248, 0.15); color: #38BDF8; border: 1px solid rgba(56, 189, 248, 0.3); }}
        .icon-gold {{ background: rgba(245, 158, 11, 0.15); color: #F59E0B; border: 1px solid rgba(245, 158, 11, 0.3); }}
        .icon-emerald {{ background: rgba(16, 185, 129, 0.15); color: #10B981; border: 1px solid rgba(16, 185, 129, 0.3); }}
        .icon-purple {{ background: rgba(129, 140, 248, 0.15); color: #818CF8; border: 1px solid rgba(129, 140, 248, 0.3); }}

        /* پنل محتوا و جدول‌ها */
        .content-panel {{
            background: var(--bg-card);
            backdrop-filter: blur(20px);
            border: 1px solid var(--border-subtle);
            border-radius: 24px;
            padding: 26px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
        }}

        .panel-header {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 22px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border-subtle);
        }}

        .panel-header h3 {{
            font-size: 17px;
            font-weight: 800;
            color: #fff;
        }}

        .search-box {{
            display: flex;
            align-items: center;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid var(--border-subtle);
            border-radius: 12px;
            padding: 8px 14px;
            width: 280px;
        }}

        .search-box input {{
            background: transparent;
            border: none;
            outline: none;
            color: #fff;
            font-size: 12.5px;
            width: 100%;
        }}

        .search-box input::placeholder {{
            color: #64748B;
        }}

        /* جدول استایل */
        table {{
            width: 100%;
            border-collapse: collapse;
            text-align: right;
        }}

        th {{
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 700;
            padding: 14px 16px;
            border-bottom: 1px solid var(--border-subtle);
            background: rgba(15, 23, 42, 0.4);
        }}

        td {{
            font-size: 13px;
            padding: 14px 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.04);
            color: #CBD5E1;
        }}

        tr:hover td {{
            background: rgba(255, 255, 255, 0.02);
            color: #fff;
        }}

        .badge {{
            display: inline-block;
            padding: 4px 10px;
            border-radius: 8px;
            font-size: 11px;
            font-weight: 700;
        }}

        .badge-cyan {{ background: rgba(56, 189, 248, 0.15); color: #38BDF8; }}
        .badge-emerald {{ background: rgba(16, 185, 129, 0.15); color: #10B981; }}
        .badge-gold {{ background: rgba(245, 158, 11, 0.15); color: #F59E0B; }}

        .action-btn {{
            background: rgba(56, 189, 248, 0.12);
            color: #38BDF8;
            border: 1px solid rgba(56, 189, 248, 0.3);
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 11.5px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
        }}

        .action-btn:hover {{
            background: #38BDF8;
            color: #0F172A;
            box-shadow: 0 0 12px rgba(56, 189, 248, 0.5);
        }}

        .tab-section {{
            display: none;
        }}

        .tab-section.active {{
            display: block;
        }}
    </style>
</head>
<body>
    <!-- سایدبار اختصاصی نرم‌افزار شما -->
    <div class="sidebar">
        <div class="brand">
            <div class="brand-icon">⚡</div>
            <div class="brand-text">
                <h1>آکادمی سی دانا</h1>
                <p>پیشخوان مدیریت مرکزی (CMS)</p>
            </div>
        </div>

        <ul class="nav-list">
            <li class="nav-item active" onclick="switchTab('users', this)">
                <span class="icon">👥</span>
                <span>دانش‌آموزان و کاربران</span>
            </li>
            <li class="nav-item" onclick="switchTab('courses', this)">
                <span class="icon">📚</span>
                <span>کتاب‌های درسی (۷، ۸، ۹)</span>
            </li>
            <li class="nav-item" onclick="switchTab('wallet', this)">
                <span class="icon">💰</span>
                <span>کیف پول و سکه‌ها</span>
            </li>
            <li class="nav-item" onclick="switchTab('store', this)">
                <span class="icon">🛍️</span>
                <span>فروشگاه (تم‌ها و آواتارها)</span>
            </li>
            <li class="nav-item" onclick="switchTab('league', this)">
                <span class="icon">🏎️</span>
                <span>لیگ نخبگان و ماشین‌بازی</span>
            </li>
            <li class="nav-item" onclick="switchTab('quran', this)">
                <span class="icon">👑</span>
                <span>مدیران لیگ قرآن هفتم</span>
            </li>
        </ul>

        <div style="padding: 12px; background: rgba(255,255,255,0.03); border-radius: 12px; font-size: 11px; color: var(--text-muted); text-align: center;">
            سیستم امن و زنده دیتابیس دانا<br>نسخه ۱.۰.۰ | محلی
        </div>
    </div>

    <!-- بدنه اصلی -->
    <div class="main-content">
        <!-- هدر -->
        <div class="top-bar">
            <div class="top-title">
                <h2>کنترل‌پنل مدیریت آموزشگاه دانا</h2>
                <p>مدیریت اطلاعات دانش‌آموزان، سکه‌ها، پایه‌ها و کتاب‌های درسی</p>
            </div>
            <div class="status-badge">
                <div class="pulse-dot"></div>
                <span>سرور دیتابیس فعال و زنده است</span>
            </div>
        </div>

        <!-- کارت‌های آماری بالا (دقیقاً بر اساس محتوای برنامه شما) -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-info">
                    <p>کل دانش‌آموزان ثبت‌نامی</p>
                    <h3>{total_users} نفر</h3>
                </div>
                <div class="stat-icon icon-blue">👥</div>
            </div>

            <div class="stat-card">
                <div class="stat-info">
                    <p>کل سکه‌های در گردش</p>
                    <h3>{total_coins:,} سکه</h3>
                </div>
                <div class="stat-icon icon-gold">🪙</div>
            </div>

            <div class="stat-card">
                <div class="stat-info">
                    <p>درس‌های پاس‌شده</p>
                    <h3>{total_progress} مرحله</h3>
                </div>
                <div class="stat-icon icon-emerald">📖</div>
            </div>

            <div class="stat-card">
                <div class="stat-info">
                    <p>آیتم‌های فروشگاه</p>
                    <h3>{total_inventory} خرید</h3>
                </div>
                <div class="stat-icon icon-purple">🛍️</div>
            </div>
        </div>

        <!-- تب ۱: کاربران -->
        <div id="tab-users" class="tab-section active content-panel">
            <div class="panel-header">
                <h3>لیست دانش‌آموزان و کیف پول‌ها ({len(users_list)} کاربر)</h3>
                <div class="search-box">
                    <input type="text" id="userSearch" placeholder="جستجوی شماره همراه یا نام..." onkeyup="filterUsers()">
                </div>
            </div>
            <table id="usersTable">
                <thead>
                    <tr>
                        <th>شناسه</th>
                        <th>شماره همراه</th>
                        <th>نام کاربر</th>
                        <th>پایه تحصیلی</th>
                        <th>موجودی سکه</th>
                        <th>پیشرفت درس‌ها</th>
                        <th>هدیه ثبت‌نام</th>
                        <th>عملیات مدیریت</th>
                    </tr>
                </thead>
                <tbody>"""
    
    for u in users_list:
        gift_status = '<span class="badge badge-emerald">دریافت شده ✅</span>' if u.has_received_welcome_gift else '<span class="badge badge-cyan">در انتظار ⏳</span>'
        html += f"""
                    <tr>
                        <td>#{u.id}</td>
                        <td style="font-weight: 700; color: #fff;">{u.phone_number}</td>
                        <td>{u.full_name}</td>
                        <td><span class="badge badge-cyan">پایه {u.selected_grade}</span></td>
                        <td style="color: #F59E0B; font-weight: 800;">{u.coins:,} 🪙</td>
                        <td><span class="badge badge-emerald">{u.total_xp} درس گذرانده 📚</span></td>
                        <td>{gift_status}</td>
                        <td>
                            <button class="action-btn" onclick="modifyCoins({u.id}, '{u.phone_number}', {u.coins})">تغییر موجودی سکه 🪙</button>
                        </td>
                    </tr>"""
    
    if not users_list:
        html += """<tr><td colspan="8" style="text-align: center; color: #94A3B8; padding: 30px;">هنوز کاربری ثبت‌نام نکرده است. با ورود شماره در اپلیکیشن اولین کاربر اضافه می‌شود!</td></tr>"""

    html += f"""
                </tbody>
            </table>
        </div>

        <!-- تب ۲: کتاب‌های درسی اپلیکیشن شما -->
        <div id="tab-courses" class="tab-section content-panel">
            <div class="panel-header">
                <h3>کتاب‌های درسی فعال در اپلیکیشن دانا</h3>
            </div>
            <p style="color: var(--text-muted); font-size: 13px; margin-bottom: 20px;">
                ۷ کتاب درسی اصلی دوره‌های هفتم، هشتم و نهم در این بخش مدیریت می‌شوند:
            </p>
            <table>
                <thead>
                    <tr>
                        <th>پایه</th>
                        <th>شناسه درس</th>
                        <th>عنوان کتاب درسی</th>
                        <th>تعداد فصل‌ها / درس‌ها</th>
                        <th>وضعیت</th>
                    </tr>
                </thead>
                <tbody>
                    <tr><td>پایه هفتم</td><td><span class="badge badge-cyan">riyazi7</span></td><td>ریاضی هفتم</td><td>۹ فصل کامل</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>
                    <tr><td>پایه هفتم</td><td><span class="badge badge-cyan">olom7</span></td><td>علوم تجربی هفتم</td><td>۱۵ درس کامل</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>
                    <tr><td>پایه هفتم</td><td><span class="badge badge-cyan">farsi7</span></td><td>فارسی هفتم</td><td>۱۷ درس</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>
                    <tr><td>پایه هفتم</td><td><span class="badge badge-cyan">motaleat7</span></td><td>مطالعات اجتماعی هفتم</td><td>۱۲ درس</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>
                    <tr><td>پایه هفتم</td><td><span class="badge badge-cyan">payam7</span></td><td>پیام‌های آسمان هفتم</td><td>۱۵ درس</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>
                    <tr><td>پایه هفتم</td><td><span class="badge badge-cyan">arabic7</span></td><td>عربی هفتم</td><td>۱۰ درس</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>
                    <tr><td>پایه هفتم</td><td><span class="badge badge-cyan">zaban7</span></td><td>زبان انگلیسی هفتم</td><td>۸ درس</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>

                    <tr><td>پایه هشتم</td><td><span class="badge badge-cyan">riyazi8</span></td><td>ریاضی هشتم</td><td>۹ فصل کامل</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>
                    <tr><td>پایه هشتم</td><td><span class="badge badge-cyan">olom8</span></td><td>علوم تجربی هشتم</td><td>۱۵ درس کامل</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>
                    <tr><td>پایه هشتم</td><td><span class="badge badge-cyan">farsi8</span></td><td>فارسی هشتم</td><td>۱۷ درس</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>

                    <tr><td>پایه نهم</td><td><span class="badge badge-cyan">riyazi9</span></td><td>ریاضی نهم</td><td>۸ فصل کامل</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>
                    <tr><td>پایه نهم</td><td><span class="badge badge-cyan">olom9</span></td><td>علوم تجربی نهم</td><td>۱۵ درس کامل</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>
                    <tr><td>پایه نهم</td><td><span class="badge badge-cyan">farsi9</span></td><td>فارسی نهم</td><td>۱۷ درس</td><td><span class="badge badge-emerald">فعال ✅</span></td></tr>
                </tbody>
            </table>
        </div>

        <!-- تب ۳: کیف پول و تراکنش‌ها -->
        <div id="tab-wallet" class="tab-section content-panel">
            <div class="panel-header">
                <h3>ریز تراکنش‌های سکه و کیف پول</h3>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>شناسه</th>
                        <th>کاربر</th>
                        <th>مقدار سکه</th>
                        <th>نوع تراکنش</th>
                        <th>توضیحات</th>
                        <th>تاریخ</th>
                    </tr>
                </thead>
                <tbody>"""
    
    for t in transactions:
        badge_class = "badge-emerald" if t.amount > 0 else "badge-gold"
        amount_sign = f"+{t.amount}" if t.amount > 0 else f"{t.amount}"
        html += f"""
                    <tr>
                        <td>#{t.id}</td>
                        <td>کاربر #{t.user_id}</td>
                        <td><span class="badge {badge_class}">{amount_sign} 🪙</span></td>
                        <td>{t.transaction_type}</td>
                        <td>{t.title}</td>
                        <td>{t.created_at.strftime('%Y/%m/%d %H:%M') if t.created_at else '-'}</td>
                    </tr>"""
    
    if not transactions:
        html += """<tr><td colspan="6" style="text-align: center; color: #94A3B8; padding: 30px;">هنوز تراکنشی ثبت نشده است.</td></tr>"""

    html += f"""
                </tbody>
            </table>
        </div>

        <!-- تب ۴: فروشگاه و دارایی‌ها -->
        <div id="tab-store" class="tab-section content-panel">
            <div class="panel-header">
                <h3>دارایی‌های آنلاک‌شده در فروشگاه (آواتارها، تم‌ها و VIP)</h3>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>شناسه</th>
                        <th>کاربر</th>
                        <th>نوع دارایی</th>
                        <th>شناسه آیتم</th>
                        <th>سکه پرداختی</th>
                    </tr>
                </thead>
                <tbody>"""
    for inv in inventory_items:
        html += f"""
                    <tr>
                        <td>#{inv.id}</td>
                        <td>کاربر #{inv.user_id}</td>
                        <td><span class="badge badge-cyan">{inv.item_type}</span></td>
                        <td>{inv.item_identifier}</td>
                        <td>{inv.cost_paid} 🪙</td>
                    </tr>"""
    if not inventory_items:
        html += """<tr><td colspan="5" style="text-align: center; color: #94A3B8; padding: 30px;">هنوز خریدی در فروشگاه انجام نشده است.</td></tr>"""

    html += f"""
                </tbody>
            </table>
        </div>

        <!-- تب ۵: لیگ نخبگان -->
        <div id="tab-league" class="tab-section content-panel">
            <div class="panel-header">
                <h3>جدول رتبه‌بندی لیگ نخبگان و ماشین‌بازی</h3>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>رتبه</th>
                        <th>کاربر</th>
                        <th>پایه</th>
                        <th>حالت بازی</th>
                        <th>بالاترین رکورد</th>
                        <th>سکه‌های برنده شده</th>
                    </tr>
                </thead>
                <tbody>"""
    rank = 1
    for ls in league_scores:
        html += f"""
                    <tr>
                        <td><span class="badge badge-gold">#{rank}</span></td>
                        <td>کاربر #{ls.user_id}</td>
                        <td>پایه {ls.grade}</td>
                        <td>{ls.game_mode}</td>
                        <td style="font-weight: 800; color: #38BDF8;">{ls.high_score:,} امتیاز</td>
                        <td>{ls.coins_won} 🪙</td>
                    </tr>"""
        rank += 1
    if not league_scores:
        html += """<tr><td colspan="6" style="text-align: center; color: #94A3B8; padding: 30px;">هنوز رکوردی در لیگ نخبگان ثبت نشده است.</td></tr>"""

    html += f"""
                </tbody>
            </table>
        </div>

        <!-- تب ۶: مدیریت مدیران لیگ قرآن هفتم -->
        <div id="tab-quran" class="tab-section content-panel">
            <div class="panel-header">
                <div>
                    <h3>👑 مدیریت مدیران و سهمیه کلاس‌ها (لیگ قرآن هفتم)</h3>
                    <p style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">
                        تعریف رمز ورود اختصاصی مدیران، تعیین سقف مجاز ایجاد کلاس و تفکیک کامل اطلاعات هر مدیر
                    </p>
                </div>
                <div style="display: flex; gap: 10px;">
                    <span class="badge badge-gold" style="font-size: 12px; padding: 6px 14px;">مدیران: {len(quran_managers)} نفر</span>
                    <span class="badge badge-cyan" style="font-size: 12px; padding: 6px 14px;">کل کلاس‌ها: {total_quran_classes} کلاس</span>
                </div>
            </div>

            <!-- فرم ایجاد مدیر جدید -->
            <div style="background: rgba(15, 23, 42, 0.7); border: 1px solid rgba(56, 189, 248, 0.25); border-radius: 18px; padding: 22px; margin-bottom: 26px;">
                <h4 style="font-size: 15px; font-weight: 800; color: #38BDF8; margin-bottom: 14px; display: flex; align-items: center; gap: 8px;">
                    <span>➕</span>
                    <span>صدور مجوز و تعریف مدیر جدید</span>
                </h4>
                <div style="display: grid; grid-template-columns: 2fr 2fr 1.5fr auto; gap: 14px; align-items: end;">
                    <div>
                        <label style="display: block; font-size: 11.5px; color: #94A3B8; margin-bottom: 6px; font-weight: 600;">نام یا عنوان مدیر / مدرسه:</label>
                        <input id="newManagerName" type="text" placeholder="مثلاً: مدیر دبیرستان شهید باهنر" style="width: 100%; background: #0B0F19; border: 1px solid rgba(255,255,255,0.12); border-radius: 12px; padding: 11px 14px; color: #fff; font-size: 13px; outline: none;">
                    </div>
                    <div>
                        <label style="display: block; font-size: 11.5px; color: #94A3B8; margin-bottom: 6px; font-weight: 600;">رمز ورود مدیر در اپ (فقط و فقط ۱۰ رقم):</label>
                        <input id="newManagerPasscode" type="text" maxlength="10" placeholder="دقیقاً ۱۰ رقم عددی" oninput="enforce10Digits(this)" onchange="enforce10Digits(this)" onkeyup="enforce10Digits(this)" onpaste="setTimeout(() => enforce10Digits(this), 0)" onkeypress="if((this.value.length >= 10 && this.selectionStart === this.selectionEnd) || event.charCode < 48 || event.charCode > 57) event.preventDefault();" autocomplete="off" style="width: 100%; background: #0B0F19; border: 1px solid rgba(255,255,255,0.12); border-radius: 12px; padding: 11px 14px; color: #FBBF24; font-weight: bold; letter-spacing: 2px; font-size: 14px; outline: none;">
                    </div>
                    <div>
                        <label style="display: block; font-size: 11.5px; color: #94A3B8; margin-bottom: 6px; font-weight: 600;">سقف مجاز ایجاد کلاس:</label>
                        <input id="newManagerMaxClasses" type="number" min="1" max="50" value="3" style="width: 100%; background: #0B0F19; border: 1px solid rgba(255,255,255,0.12); border-radius: 12px; padding: 11px 14px; color: #38BDF8; font-weight: bold; font-size: 14px; outline: none;">
                    </div>
                    <div>
                        <button onclick="addQuranManager()" class="action-btn" style="background: linear-gradient(135deg, #0284C7, #06B6D4); color: #fff; padding: 12px 24px; font-size: 13.5px; border-radius: 12px; border: none; cursor: pointer; font-weight: 800; box-shadow: 0 4px 15px rgba(2, 132, 199, 0.4);">
                            ✨ ثبت و صدور مجوز
                        </button>
                    </div>
                </div>
            </div>

            <!-- جدول لیست مدیران و سهمیه آن‌ها -->
            <h4 style="font-size: 15px; font-weight: 800; color: #fff; margin-bottom: 12px;">📋 فهرست مدیران فعال و وضعیت سهمیه کلاس‌ها</h4>
            <div style="overflow-x: auto; margin-bottom: 34px;">
                <table>
                    <thead>
                        <tr>
                            <th>شناسه</th>
                            <th>نام و عنوان مدیر</th>
                            <th>رمز ورود به اپلیکیشن</th>
                            <th>کلاس‌های ساخته‌شده</th>
                            <th>سقف مجاز کلاس</th>
                            <th>وضعیت سهمیه</th>
                            <th>تاریخ ثبت</th>
                            <th>عملیات مدیریت</th>
                        </tr>
                    </thead>
                    <tbody>"""

    for m in quran_managers:
        classes_count = len(m.classes)
        is_limit_reached = classes_count >= m.max_classes
        status_badge = f'<span class="badge" style="background: rgba(239, 68, 68, 0.15); color: #EF4444; border: 1px solid rgba(239,68,68,0.3);">تکمیل سقف ({classes_count}/{m.max_classes})</span>' if is_limit_reached else f'<span class="badge badge-emerald">مجاز برای ساخت کلاس ({classes_count}/{m.max_classes})</span>'

        created_str = m.created_at.strftime("%Y/%m/%d - %H:%M") if m.created_at else "---"

        html += f"""
                        <tr>
                            <td><span class="badge badge-gold">#{m.id}</span></td>
                            <td style="font-weight: 800; color: #F8FAFC;">{m.name}</td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <span style="font-family: monospace; font-size: 15px; color: #FBBF24; font-weight: 900; letter-spacing: 2px;">{m.passcode}</span>
                                    <button onclick="navigator.clipboard.writeText('{m.passcode}'); alert('رمز کپی شد: {m.passcode}');" style="background: rgba(251, 191, 36, 0.12); border: 1px solid rgba(251, 191, 36, 0.3); border-radius: 6px; color: #FBBF24; cursor: pointer; padding: 2px 6px; font-size: 10px;">کپی</button>
                                </div>
                            </td>
                            <td style="font-weight: 900; color: #38BDF8;">{classes_count} کلاس</td>
                            <td style="font-weight: 900; color: #fff;">{m.max_classes} کلاس</td>
                            <td>{status_badge}</td>
                            <td style="font-size: 11.5px; color: #94A3B8;">{created_str}</td>
                            <td>
                                <div style="display: flex; gap: 6px;">
                                    <button class="action-btn" onclick="updateManagerQuota({m.id}, {m.max_classes}, '{m.name}')">تغییر سقف</button>
                                    <button class="action-btn" style="background: rgba(239, 68, 68, 0.15); color: #EF4444; border-color: rgba(239, 68, 68, 0.3);" onclick="deleteQuranManager({m.id}, '{m.name}')">حذف</button>
                                </div>
                            </td>
                        </tr>"""

    if not quran_managers:
        html += """<tr><td colspan="8" style="text-align: center; color: #94A3B8; padding: 30px;">هنوز هیچ مدیری تعریف نشده است. از کادر بالا اولین مدیر را ثبت کنید.</td></tr>"""

    html += f"""
                    </tbody>
                </table>
            </div>

            <!-- جدول تمام کلاس‌های ساخته‌شده در کل سامانه -->
            <h4 style="font-size: 15px; font-weight: 800; color: #fff; margin-bottom: 12px;">🏫 تمام کلاس‌های ایجاد شده در سامانه (کدهای یکتای سراسری)</h4>
            <div style="overflow-x: auto;">
                <table>
                    <thead>
                        <tr>
                            <th>کد ۵ رقمی کلاس</th>
                            <th>عنوان کلاس</th>
                            <th>کد ۱۰ رقمی معلم</th>
                            <th>مدیر مربوطه</th>
                            <th>دانش‌آموزان</th>
                            <th>تاریخ ساخت</th>
                            <th>عملیات</th>
                        </tr>
                    </thead>
                    <tbody>"""

    for c in quran_classes:
        st_count = 0
        try:
            st_count = len(json.loads(c.students_json)) if c.students_json else 0
        except:
            st_count = 0
        m_name = c.manager.name if c.manager else "مدیر نامشخص"
        c_date = c.created_at.strftime("%Y/%m/%d - %H:%M") if c.created_at else "---"

        html += f"""
                        <tr>
                            <td><span style="font-family: monospace; font-size: 16px; color: #22D3EE; font-weight: 900; letter-spacing: 2px;">{c.class_code}</span></td>
                            <td style="font-weight: 700; color: #F8FAFC;">{c.title}</td>
                            <td><span style="font-family: monospace; font-size: 13px; color: #FBBF24; font-weight: 800;">{c.teacher_code}</span></td>
                            <td><span class="badge badge-gold">{m_name}</span></td>
                            <td style="color: #10B981; font-weight: 800;">{st_count} دانش‌آموز</td>
                            <td style="font-size: 11.5px; color: #94A3B8;">{c_date}</td>
                            <td>
                                <button class="action-btn" style="background: rgba(239, 68, 68, 0.15); color: #EF4444; border-color: rgba(239, 68, 68, 0.3);" onclick="deleteQuranClass({c.id}, '{c.class_code}')">حذف کلاس</button>
                            </td>
                        </tr>"""

    if not quran_classes:
        html += """<tr><td colspan="7" style="text-align: center; color: #94A3B8; padding: 25px;">تاکنون کلاسی توسط مدیران در سامانه ایجاد نشده است.</td></tr>"""

    html += f"""
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        function switchTab(tabId, el) {{
            document.querySelectorAll('.tab-section').forEach(e => e.classList.remove('active'));
            document.querySelectorAll('.nav-list .nav-item').forEach(e => e.classList.remove('active'));
            
            const target = document.getElementById('tab-' + tabId);
            if (target) target.classList.add('active');

            if (el) el.classList.add('active');
        }}

        function filterUsers() {{
            const query = document.getElementById('userSearch').value.toLowerCase();
            const rows = document.querySelectorAll('#usersTable tbody tr');
            rows.forEach(row => {{
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(query) ? '' : 'none';
            }});
        }}

        async function modifyCoins(userId, phone, currentCoins) {{
            const newCoins = prompt(`تغییر موجودی سکه برای شماره ${{phone}}\\nموجودی فعلی: ${{currentCoins}}\\nتعداد سکه جدید را وارد کنید:`, currentCoins);
            if (newCoins === null || isNaN(newCoins)) return;

            try {{
                const res = await fetch(`/admin/api/users/${{userId}}/coins?coins=${{parseInt(newCoins)}}`, {{ method: 'POST' }});
                if (res.ok) {{
                    alert('سکه کاربر با موفقیت تغییر کرد! 🎉');
                    window.location.reload();
                }} else {{
                    alert('خطا در تغییر سکه');
                }}
            }} catch(e) {{
                alert('خطا در برقراری ارتباط');
            }}
        }}

        function enforce10Digits(el) {{
            if (!el) return;
            let v = el.value || '';
            const persian = ['۰','۱','۲','۳','۴','۵','۶','۷','۸','۹'];
            const arabic = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
            for (let i = 0; i < 10; i++) {{
                v = v.split(persian[i]).join(String(i)).split(arabic[i]).join(String(i));
            }}
            v = v.replace(/[^0-9]/g, '');
            if (v.length > 10) {{
                v = v.slice(0, 10);
            }}
            if (el.value !== v) {{
                el.value = v;
            }}
        }}

        async function addQuranManager() {{
            const name = document.getElementById('newManagerName').value.trim();
            const passEl = document.getElementById('newManagerPasscode');
            enforce10Digits(passEl);
            const passcode = passEl.value.trim();
            const maxClasses = parseInt(document.getElementById('newManagerMaxClasses').value) || 3;

            if (!passcode) {{
                alert('لطفاً رمز ورود ۱۰ رقمی مدیر را وارد کنید.');
                return;
            }}

            if (passcode.length !== 10 || !/^[0-9]{{10}}$/.test(passcode)) {{
                alert('رمز ورود مدیر باید دقیقاً ۱۰ رقم عددی باشد! (نه کمتر و نه بیشتر)');
                return;
            }}

            if (passcode === '1111111111') {{
                alert('رمز ۱۰ تا ۱ منسوخ شده است. لطفاً یک رمز ۱۰ رقمی دیگر انتخاب کنید.');
                return;
            }}

            try {{
                const res = await fetch('/admin/api/quran-managers', {{
                    method: 'POST',
                    headers: {{ 'Content-Type': 'application/json' }},
                    body: JSON.stringify({{ name: name || 'مدیر لیگ قرآن', passcode: passcode, max_classes: maxClasses }})
                }});
                const data = await res.json();
                if (res.ok) {{
                    alert('مدیر با موفقیت ثبت شد و مجوز صادر گردید! 🎉');
                    window.location.reload();
                }} else {{
                    alert(data.detail || 'خطا در ثبت مدیر');
                }}
            }} catch(e) {{
                alert('خطا در برقراری ارتباط با سرور');
            }}
        }}

        async function updateManagerQuota(id, current, name) {{
            const newMax = prompt(`تغییر سقف مجاز کلاس برای مدیر "${{name}}":\\nسقف فعلی: ${{current}}\\nسقف جدید کلاس‌ها را وارد کنید:`, current);
            if (newMax === null || isNaN(newMax) || parseInt(newMax) <= 0) return;

            try {{
                const res = await fetch(`/admin/api/quran-managers/${{id}}/max-classes?max_classes=${{parseInt(newMax)}}`, {{ method: 'POST' }});
                if (res.ok) {{
                    alert('سقف کلاس مدیر با موفقیت به‌روزرسانی شد! ✅');
                    window.location.reload();
                }} else {{
                    alert('خطا در تغییر سقف کلاس');
                }}
            }} catch(e) {{
                alert('خطا در ارتباط');
            }}
        }}

        async function deleteQuranManager(id, name) {{
            if (!confirm(`آیا از حذف مدیر "${{name}}" و تمام کلاس‌های آن اطمینان دارید؟`)) return;

            try {{
                const res = await fetch(`/admin/api/quran-managers/${{id}}`, {{ method: 'DELETE' }});
                if (res.ok) {{
                    alert('مدیر با موفقیت حذف شد.');
                    window.location.reload();
                }} else {{
                    alert('خطا در حذف مدیر');
                }}
            }} catch(e) {{
                alert('خطا در برقراری ارتباط');
            }}
        }}

        async function deleteQuranClass(id, code) {{
            if (!confirm(`آیا از حذف کلاس با کد "${{code}}" اطمینان دارید؟`)) return;

            try {{
                const res = await fetch(`/admin/api/quran-classes/${{id}}`, {{ method: 'DELETE' }});
                if (res.ok) {{
                    alert('کلاس با موفقیت حذف شد.');
                    window.location.reload();
                }} else {{
                    alert('خطا در حذف کلاس');
                }}
            }} catch(e) {{
                alert('خطا در برقراری ارتباط');
            }}
        }}

        // قفل فیزیکی و نرم‌افزاری کادر رمز مدیر: حداکثر و دقیقاً ۱۰ رقم
        document.addEventListener('DOMContentLoaded', () => {{
            const passInp = document.getElementById('newManagerPasscode');
            if (passInp) {{
                ['input', 'change', 'keyup', 'paste', 'blur'].forEach(evt => {{
                    passInp.addEventListener(evt, () => enforce10Digits(passInp));
                }});
                passInp.addEventListener('keydown', function(e) {{
                    const allowedKeys = ['Backspace', 'Delete', 'ArrowLeft', 'ArrowRight', 'Tab', 'Home', 'End'];
                    if (allowedKeys.includes(e.key) || e.ctrlKey || e.metaKey) return;
                    if (this.value.length >= 10 && this.selectionStart === this.selectionEnd) {{
                        e.preventDefault();
                    }}
                }});
            }}
        }});
    </script>
</body>
</html>
"""
    return HTMLResponse(content=html)

@router.post("/api/users/{user_id}/coins")
def update_user_coins(user_id: int, coins: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="کاربر یافت نشد")
    
    diff = coins - user.coins
    user.coins = coins
    
    # ثبت در تراکنش‌ها
    transaction = CoinTransaction(
        user_id=user.id,
        amount=diff,
        transaction_type="admin_adjustment",
        title="تغییر دستی سکه توسط مدیریت CMS",
        description=f"موجودی جدید: {coins}"
    )
    db.add(transaction)
    db.commit()
    return {"status": "success", "coins": coins}

@router.post("/api/quran-managers", summary="تعریف مدیر جدید با رمز و سقف کلاس")
def create_quran_manager(req: AddQuranManagerRequest, db: Session = Depends(get_db)):
    passcode = req.passcode.strip()
    if not passcode:
        raise HTTPException(status_code=400, detail="رمز ورود مدیر نمی‌تواند خالی باشد")
    if len(passcode) != 10 or not passcode.isdigit():
        raise HTTPException(status_code=400, detail="رمز ورود مدیر باید دقیقاً ۱۰ رقم عددی باشد (نه کمتر و نه بیشتر)!")
    if passcode == "1111111111":
        raise HTTPException(status_code=400, detail="رمز ۱۰ تا ۱ منسوخ شده و مجاز نیست")

    existing = db.query(QuranManager).filter(QuranManager.passcode == passcode).first()
    if existing:
        raise HTTPException(status_code=400, detail="این رمز ورود قبلاً برای مدیر دیگری ثبت شده است!")

    manager = QuranManager(
        name=req.name.strip() or "مدیر لیگ قرآن",
        passcode=passcode,
        max_classes=max(1, req.max_classes),
        created_at=datetime.utcnow()
    )
    db.add(manager)
    db.commit()
    db.refresh(manager)
    return {"status": "success", "manager_id": manager.id}

@router.post("/api/quran-managers/{manager_id}/max-classes", summary="تغییر سقف مجاز ایجاد کلاس")
def update_manager_max_classes(manager_id: int, max_classes: int, db: Session = Depends(get_db)):
    m = db.query(QuranManager).filter(QuranManager.id == manager_id).first()
    if not m:
        raise HTTPException(status_code=404, detail="مدیر یافت نشد")
    m.max_classes = max(1, max_classes)
    db.commit()
    return {"status": "success", "max_classes": m.max_classes}

@router.delete("/api/quran-managers/{manager_id}", summary="حذف مدیر")
def delete_quran_manager(manager_id: int, db: Session = Depends(get_db)):
    m = db.query(QuranManager).filter(QuranManager.id == manager_id).first()
    if not m:
        raise HTTPException(status_code=404, detail="مدیر یافت نشد")
    db.delete(m)
    db.commit()
    return {"status": "success"}

@router.delete("/api/quran-classes/{class_id}", summary="حذف کلاس")
def delete_quran_class(class_id: int, db: Session = Depends(get_db)):
    c = db.query(QuranClass).filter(QuranClass.id == class_id).first()
    if not c:
        raise HTTPException(status_code=404, detail="کلاس یافت نشد")
    db.delete(c)
    db.commit()
    return {"status": "success"}

