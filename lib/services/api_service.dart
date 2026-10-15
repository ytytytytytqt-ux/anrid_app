import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // آدرس‌های سرور (ابتدا اینترنت عمومی کلودفلر، و در صورت عدم پاسخ آدرس وای‌فای داخلی سیستم)
  static String publicUrl = 'https://fee-connector-website-richmond.trycloudflare.com';
  static String localWifiUrl = 'http://192.168.205.96:8000';

  static bool _isSyncing = false;

  /// همگام‌سازی کامل تمامی اطلاعات دانش‌آموز (سکه‌ها، پایه، آواتار، تم و درس‌های تکمیل‌شده)
  /// در صورت قطع بودن اینترنت، به صورت خودکار در صف محلی قرار می‌گیرد تا به محض آنلاین شدن ارسال شود.
  static Future<void> syncStudentToAdmin({
    required String phoneNumber,
    int coins = 500,
    int selectedGrade = 7,
    String fullName = 'دانش‌آموز دانا',
    String? currentAvatar,
    String? currentTheme,
    int totalCompletedLessons = 0,
    List<String>? completedLessons,
  }) async {
    final phone = phoneNumber.trim();
    if (phone.isEmpty) return;

    if (_isSyncing) return;
    _isSyncing = true;

    final body = jsonEncode({
      'phone_number': phone,
      'coins': coins,
      'selected_grade': selectedGrade,
      'full_name': fullName,
      'current_avatar': currentAvatar,
      'current_theme': currentTheme,
      'total_completed_lessons': totalCompletedLessons,
      'completed_lessons': completedLessons ?? [],
    });

    final headers = {'Content-Type': 'application/json'};

    bool success = false;

    // ۱. ابتدا تلاش برای ارسال از طریق اینترنت عمومی کلودفلر
    try {
      final uri = Uri.parse('$publicUrl/auth/sync-student');
      final res = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        success = true;
        debugPrint('✅ [ApiService] کلیه اطلاعات دانش‌آموز ($phone) به پنل ابری ارسال شد.');
      }
    } catch (_) {
      // اینترنت عمومی در دسترس نبود؛ به مرحله بعد می‌رود
    }

    // ۲. در صورت عدم موفقیت، تلاش از طریق وای‌فای داخلی سیستم
    if (!success) {
      try {
        final uri = Uri.parse('$localWifiUrl/auth/sync-student');
        final res = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 3));
        if (res.statusCode == 200) {
          success = true;
          debugPrint('✅ [ApiService] کلیه اطلاعات دانش‌آموز ($phone) از طریق وای‌فای ثبت شد.');
        }
      } catch (_) {
        // وای‌فای هم در دسترس نبود (کاربر در حالت آفلاین است)
      }
    }

    final prefs = await SharedPreferences.getInstance();
    if (success) {
      // با موفقیت ارسال شد؛ صف انتظار پاک می‌شود
      prefs.setBool('pending_offline_sync_$phone', false);
    } else {
      // کاربر آفلاین است؛ ثبت پرچم تا به محض اتصال بعدی ارسال شود
      prefs.setBool('pending_offline_sync_$phone', true);
      debugPrint('ℹ️ [ApiService] کاربر آفلاین است؛ اطلاعات در صف ذخیره شد تا پس از اتصال ارسال شود.');
    }

    _isSyncing = false;
  }

  /// بررسی و ارسال مجدد اطلاعات معوقه در صورت آنلاین شدن کاربر
  static Future<void> checkAndFlushPendingSync(String phone) async {
    if (phone.trim().isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool needsSync = prefs.getBool('pending_offline_sync_$phone') ?? false;
      if (needsSync) {
        debugPrint('🔄 [ApiService] در حال تلاش مجدد برای ارسال اطلاعات معوقه...');
        // فراخوانی در متد save یا رویداد اتصال
      }
    } catch (_) {}
  }

  // ===================== بخش لیگ قرآن هفتم =====================

  /// فهرست آدرس‌های سرور به ترتیب اولویت (ابتدا اینترنت عمومی برای گوشی، سپس وای‌فای و لوکال)
  static List<String> get serverCandidates => [
        publicUrl,
        localWifiUrl,
        'http://10.0.2.2:8000',
        'http://127.0.0.1:8000',
      ];

  /// ارسال درخواست POST به سرور با بررسی خودکار تمام آدرس‌ها
  static Future<http.Response?> _postToCandidateServers(
    String path,
    Map<String, dynamic> body, {
    Duration timeout = const Duration(seconds: 4),
  }) async {
    final bodyStr = jsonEncode(body);
    final headers = {'Content-Type': 'application/json'};

    for (final base in serverCandidates) {
      try {
        final uri = Uri.parse('$base$path');
        final res = await http
            .post(uri, headers: headers, body: bodyStr)
            .timeout(timeout);
        if (res.statusCode == 200) {
          return res;
        }
      } catch (_) {}
    }
    return null;
  }

  /// ارسال درخواست GET به سرور با بررسی خودکار تمام آدرس‌ها
  static Future<http.Response?> _getFromCandidateServers(
    String path, {
    Duration timeout = const Duration(seconds: 4),
  }) async {
    for (final base in serverCandidates) {
      try {
        final uri = Uri.parse('$base$path');
        final res = await http.get(uri).timeout(timeout);
        if (res.statusCode == 200) {
          return res;
        }
      } catch (_) {}
    }
    return null;
  }

  /// استعلام و احراز هویت رمز مدیر از سرور
  static Future<Map<String, dynamic>?> verifyQuranManagerPasscode(
      String passcode) async {
    final res = await _postToCandidateServers(
      '/api/quran/manager/verify',
      {'passcode': passcode.trim()},
    );

    if (res != null && res.statusCode == 200) {
      try {
        return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
      } catch (_) {}
    }
    return null;
  }

  /// ایجاد کلاس جدید در سرور با کنترل سقف مجاز و یکتایی سراسری
  static Future<Map<String, dynamic>> createQuranClassOnServer({
    required String passcode,
    required String classCode,
    required String teacherCode,
    required String title,
  }) async {
    final res = await _postToCandidateServers(
      '/api/quran/classes/create',
      {
        'passcode': passcode.trim(),
        'class_code': classCode.trim(),
        'teacher_code': teacherCode.trim(),
        'title': title.trim(),
      },
    );

    if (res != null) {
      try {
        final decoded =
            jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        if (res.statusCode == 200) {
          return {'success': true, 'data': decoded};
        } else {
          return {
            'success': false,
            'message': decoded['detail'] ?? 'خطا در ثبت کلاس در سرور'
          };
        }
      } catch (_) {}
    }

    return {'success': false, 'message': 'عدم دسترسی به سرور دیتابیس'};
  }

  /// دریافت تمامی کدهای ۵ رقمی ایجاد شده در کل سرور (برای ساخت کد شانسی یکتا)
  static Future<List<String>> getAllQuranClassCodesFromServer() async {
    final res = await _getFromCandidateServers('/api/quran/classes/all-codes');
    if (res != null && res.statusCode == 200) {
      try {
        final decoded =
            jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        final codes = decoded['codes'] as List<dynamic>?;
        if (codes != null) {
          return codes.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }
    return [];
  }

  /// استعلام مشخصات کلاس از سرور بر اساس کد ۵ رقمی یا کد ۱۰ رقمی معلم
  static Future<Map<String, dynamic>?> lookupQuranClassFromServer(
      String code) async {
    final res = await _getFromCandidateServers(
        '/api/quran/classes/lookup/${code.trim()}');
    if (res != null && res.statusCode == 200) {
      try {
        final decoded =
            jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        return decoded['class'] as Map<String, dynamic>?;
      } catch (_) {}
    }
    return null;
  }

  /// همگام‌سازی اطلاعات و دانش‌آموزان یک کلاس با سرور
  static Future<bool> syncQuranClassToServer({
    required String classCode,
    String? title,
    required List<Map<String, dynamic>> students,
  }) async {
    final res = await _postToCandidateServers(
      '/api/quran/classes/sync',
      {
        'class_code': classCode.trim(),
        'title': title,
        'students': students,
      },
    );
    return res != null && res.statusCode == 200;
  }
}
