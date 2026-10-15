@echo off
chcp 65001 > nul
title CDana Backend Admin Server
echo ========================================================
echo       سامانه جامع آموزشی دانا - سرور و پنل مدیریت
echo ========================================================
echo.
echo در حال اجرای سرور روی پورت 8000...
echo آدرس پیشخوان مدیریت: http://127.0.0.1:8000/admin
echo.

cd /d "%~dp0"
venv\Scripts\python.exe -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
pause
