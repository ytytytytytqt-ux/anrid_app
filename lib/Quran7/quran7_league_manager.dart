import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../managers/auth_manager.dart';

// تبدیل اعداد به فارسی
String toPersianDigits(dynamic input) {
  if (input == null) return '';
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  String text = input.toString();
  for (int i = 0; i < english.length; i++) {
    text = text.replaceAll(english[i], persian[i]);
  }
  return text;
}

// فرمت سه‌رقمی اعداد با ارقام فارسی
String formatPersianNumber(int number) {
  final str = number.toString();
  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  final formatted = str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  return toPersianDigits(formatted);
}

// مدل دانش‌آموز در لیگ کلاسی
class QuranStudentModel {
  final String id;
  final String name;
  final int coins;
  final int level;
  final String? avatar;
  final String? phoneNumber; // شماره تلفن دانش‌آموز
  final bool isCurrentUser;
  final int joinedAt; // زمان ورود به میلی‌ثانیه برای تعیین رتبه در صورت برابری سکه‌ها
  final Map<String, bool> completedParts; // مثلاً "L1_P1": true, "L1_P2": true, "L1_P3": true
  final Map<String, List<String>> wrongWords; // کلمات اشتباه هر درس در قسمت سوم: "1": ["لیل (شب)"]

  QuranStudentModel({
    required this.id,
    required this.name,
    required this.coins,
    required this.level,
    this.avatar,
    this.phoneNumber,
    this.isCurrentUser = false,
    int? joinedAt,
    Map<String, bool>? completedParts,
    Map<String, List<String>>? wrongWords,
  })  : joinedAt = joinedAt ?? DateTime.now().millisecondsSinceEpoch,
        completedParts = completedParts ?? {},
        wrongWords = wrongWords ?? {};

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'coins': coins,
        'level': level,
        'avatar': avatar,
        'phoneNumber': phoneNumber,
        'isCurrentUser': isCurrentUser,
        'joinedAt': joinedAt,
        'completedParts': completedParts,
        'wrongWords': wrongWords,
      };

  factory QuranStudentModel.fromJson(Map<String, dynamic> json) {
    final Map<String, bool> parsedParts = {};
    if (json['completedParts'] != null && json['completedParts'] is Map) {
      (json['completedParts'] as Map).forEach((k, v) {
        parsedParts[k.toString()] = v == true;
      });
    }

    final Map<String, List<String>> parsedWrongs = {};
    if (json['wrongWords'] != null && json['wrongWords'] is Map) {
      (json['wrongWords'] as Map).forEach((k, v) {
        if (v is List) {
          parsedWrongs[k.toString()] = v.map((e) => e.toString()).toList();
        }
      });
    }

    final rawId = json['id'] as String? ?? 'id_${Random().nextInt(99999)}';
    String? rawPhone = json['phoneNumber'] as String?;
    if (rawPhone == null || rawPhone.isEmpty) {
      if (rawId.startsWith('09') || RegExp(r'^\d{11}$').hasMatch(rawId)) {
        rawPhone = rawId;
      }
    }

    return QuranStudentModel(
      id: rawId,
      name: json['name'] as String? ?? 'دانش‌آموز',
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      avatar: json['avatar'] as String?,
      phoneNumber: rawPhone,
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
      joinedAt: (json['joinedAt'] as num?)?.toInt() ??
          DateTime.now().millisecondsSinceEpoch,
      completedParts: parsedParts,
      wrongWords: parsedWrongs,
    );
  }

  QuranStudentModel copyWith({
    String? name,
    int? coins,
    int? level,
    String? avatar,
    String? phoneNumber,
    bool? isCurrentUser,
    int? joinedAt,
    Map<String, bool>? completedParts,
    Map<String, List<String>>? wrongWords,
  }) {
    return QuranStudentModel(
      id: id,
      name: name ?? this.name,
      coins: coins ?? this.coins,
      level: level ?? this.level,
      avatar: avatar ?? this.avatar,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      joinedAt: joinedAt ?? this.joinedAt,
      completedParts: completedParts ?? this.completedParts,
      wrongWords: wrongWords ?? this.wrongWords,
    );
  }
}

// مدل کلاس قرآن هفتم
class QuranClassModel {
  final String classCode; // کد ۵ رقمی کلاس
  final String teacherCode; // کد ۱۰ رقمی معلم (۵ رقم کد کلاس + ۵ رقم تصادفی)
  final String title;
  final String createdAt;
  final List<QuranStudentModel> students;

  QuranClassModel({
    required this.classCode,
    required this.teacherCode,
    required this.title,
    required this.createdAt,
    required this.students,
  });

  Map<String, dynamic> toJson() => {
        'classCode': classCode,
        'teacherCode': teacherCode,
        'title': title,
        'createdAt': createdAt,
        'students': students.map((s) => s.toJson()).toList(),
      };

  factory QuranClassModel.fromJson(Map<String, dynamic> json) =>
      QuranClassModel(
        classCode: json['classCode'] as String? ?? '00000',
        teacherCode: json['teacherCode'] as String? ?? '0000000000',
        title: json['title'] as String? ?? 'کلاس قرآن هفتم',
        createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        students: (json['students'] as List<dynamic>?)
                ?.map((e) => QuranStudentModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

// مدل پروفایل مدیر مدرسه تعریف‌شده توسط ابرمُدیر
class QuranManagerProfile {
  final String name;
  final String passcode; // دقیقاً ۱۰ رقم عددی
  final int maxClasses; // سهمیه تعداد کلاس
  final String createdAt;

  QuranManagerProfile({
    required this.name,
    required this.passcode,
    required this.maxClasses,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'passcode': passcode,
        'maxClasses': maxClasses,
        'createdAt': createdAt,
      };

  factory QuranManagerProfile.fromJson(Map<String, dynamic> json) =>
      QuranManagerProfile(
        name: json['name'] as String? ?? 'مدیر مدرسه',
        passcode: json['passcode'] as String? ?? '',
        maxClasses: (json['maxClasses'] as num?)?.toInt() ?? 3,
        createdAt:
            json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      );
}

// مدل نگهداری مدیر حذف‌شده در سطل زباله همراه با تمامی کلاس‌ها و اطلاعاتش
class QuranTrashManagerItem {
  final QuranManagerProfile manager;
  final List<QuranClassModel> classes;
  final String deletedAt;

  QuranTrashManagerItem({
    required this.manager,
    required this.classes,
    required this.deletedAt,
  });

  Map<String, dynamic> toJson() => {
        'manager': manager.toJson(),
        'classes': classes.map((c) => c.toJson()).toList(),
        'deletedAt': deletedAt,
      };

  factory QuranTrashManagerItem.fromJson(Map<String, dynamic> json) {
    QuranManagerProfile mgr;
    try {
      final m = json['manager'];
      if (m is Map) {
        mgr = QuranManagerProfile.fromJson(Map<String, dynamic>.from(m));
      } else {
        mgr = QuranManagerProfile(
          name: 'مدیر حذف‌شده',
          passcode: '',
          maxClasses: 3,
          createdAt: DateTime.now().toIso8601String(),
        );
      }
    } catch (_) {
      mgr = QuranManagerProfile(
        name: 'مدیر حذف‌شده',
        passcode: '',
        maxClasses: 3,
        createdAt: DateTime.now().toIso8601String(),
      );
    }

    final rawClasses = json['classes'] as List<dynamic>? ?? [];
    final List<QuranClassModel> classes = [];
    for (final c in rawClasses) {
      try {
        if (c is Map) {
          classes.add(QuranClassModel.fromJson(Map<String, dynamic>.from(c)));
        }
      } catch (_) {}
    }

    return QuranTrashManagerItem(
      manager: mgr,
      classes: classes,
      deletedAt: json['deletedAt'] as String? ??
          DateTime.now().toIso8601String(),
    );
  }
}

// مدیریت سراسری لیگ کلاسی قرآن هفتم
class Quran7LeagueManager {
  static const String _prefKey = 'quran7_classes_data_v1';
  static const String _lastClassKey = 'quran7_last_joined_class';
  static const String _keyLocalManagers = 'quran7_local_managers_v2';
  static const String _keyTrashManagers = 'quran7_trash_managers_v1';

  // رمز عبور اختصاصی ابرمُدیر سیستم
  static const String superAdminPasscode = '8327183141';

  // چهار شماره تلفن مجاز ابرمُدیر
  static const List<String> superAdminPhones = [
    '09154989945',
    '09360492069',
    '09151632069',
    '09388663325',
  ];

  /// بررسی مجاز بودن شماره تلفن جاری به عنوان ابرمُدیر سیستم
  static bool isSuperAdminPhone(String? rawPhone) {
    if (rawPhone == null || rawPhone.trim().isEmpty) return false;
    final digits = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
    for (final p in superAdminPhones) {
      final pClean = p.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits == pClean) return true;
      if (digits.length >= 10 &&
          pClean.endsWith(digits.substring(digits.length - 10))) {
        return true;
      }
      final withoutZero =
          pClean.startsWith('0') ? pClean.substring(1) : pClean;
      if (digits.endsWith(withoutZero)) return true;
    }
    return false;
  }

  // متغیرهای مدیر جاری لاگین‌شده
  static String? currentManagerPasscode;
  static String currentManagerName = 'مدیر لیگ قرآن';
  static int currentManagerMaxClasses = 3;

  // تمام کدهای ۵ رقمی کلاس‌های شناخته‌شده در سراسر سامانه
  static final Set<String> _globalUsedClassCodes = {};

  static List<QuranClassModel> _classes = [];
  static bool _initialized = false;

  // مخزن مشترک تمامی کلاس‌های تمامی مدیران برای دسترسی سریع دبیران و دانش‌آموزان
  static final Map<String, QuranClassModel> _allKnownClasses = {};
  static final Map<String, String> _classToManagerMap = {}; // classCode -> managerPasscode

  // ===================== مدیریت ابرمُدیر (Super Admin CRUD) =====================

  /// دریافت تمامی مدیران تعریف‌شده
  static Future<List<QuranManagerProfile>> getAllManagers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyLocalManagers);
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list
          .map((e) => QuranManagerProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveAllManagers(List<QuranManagerProfile> managers) async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(managers.map((m) => m.toJson()).toList());
    await prefs.setString(_keyLocalManagers, str);
  }

  /// تعریف مدیر جدید توسط ابرمُدیر با رمز ۱۰ رقمی اختصاصی و سهمیه کلاس
  static Future<Map<String, dynamic>> addManager({
    required String name,
    required String passcode,
    required int maxClasses,
  }) async {
    final trimmedPass = passcode.trim();
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return {'success': false, 'message': 'نام مدیر / مدرسه را وارد کنید.'};
    }
    if (trimmedPass.length != 10 || int.tryParse(trimmedPass) == null) {
      return {
        'success': false,
        'message': 'رمز ورود مدیر باید دقیقاً ۱۰ رقم عددی باشد.',
      };
    }
    if (trimmedPass == superAdminPasscode) {
      return {
        'success': false,
        'message':
            'این رمز مخصوص ابرمُدیر سیستم است و نمی‌تواند به مدیران دیگر اختصاص یابد.',
      };
    }

    final managers = await getAllManagers();
    if (managers.any((m) => m.passcode == trimmedPass)) {
      return {
        'success': false,
        'message':
            'مدیری با این رمز ۱۰ رقمی قبلاً ثبت شده است! لطفاً رمز دیگری انتخاب کنید.',
      };
    }

    final newManager = QuranManagerProfile(
      name: trimmedName,
      passcode: trimmedPass,
      maxClasses: maxClasses > 0 ? maxClasses : 3,
      createdAt: DateTime.now().toIso8601String(),
    );

    managers.add(newManager);
    await _saveAllManagers(managers);

    // کش نام و سهمیه برای لود آفلاین سریع
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quran7_manager_name_$trimmedPass', trimmedName);
    await prefs.setInt('quran7_manager_max_$trimmedPass', newManager.maxClasses);

    return {'success': true, 'manager': newManager};
  }

  /// ویرایش سهمیه کلاس مدیر توسط ابرمُدیر
  static Future<bool> updateManagerMaxClasses(
      String passcode, int newMax) async {
    final managers = await getAllManagers();
    final idx = managers.indexWhere((m) => m.passcode == passcode.trim());
    if (idx != -1) {
      final old = managers[idx];
      managers[idx] = QuranManagerProfile(
        name: old.name,
        passcode: old.passcode,
        maxClasses: newMax,
        createdAt: old.createdAt,
      );
      await _saveAllManagers(managers);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('quran7_manager_max_${old.passcode}', newMax);
      if (currentManagerPasscode == old.passcode) {
        currentManagerMaxClasses = newMax;
      }
      return true;
    }
    return false;
  }

  /// دریافت تمامی مدیران موجود در سطل زباله
  static Future<List<QuranTrashManagerItem>> getTrashManagers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyTrashManagers);
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list
          .map((e) => QuranTrashManagerItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveTrashManagers(
      List<QuranTrashManagerItem> trash) async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(trash.map((t) => t.toJson()).toList());
    await prefs.setString(_keyTrashManagers, str);
  }

  /// دریافت تعداد مدیران موجود در سطل زباله
  static Future<int> getTrashCount() async {
    final trash = await getTrashManagers();
    return trash.length;
  }

  /// انتقال مدیر به سطل زباله (با حفظ ۱۰۰٪ کلاس‌ها، دانش‌آموزان و نمرات جهت بازیابی کامل)
  static Future<bool> deleteManager(String passcode) async {
    final trimmed = passcode.trim();
    final managers = await getAllManagers();
    final idx = managers.indexWhere((m) => m.passcode == trimmed);
    if (idx != -1) {
      final targetManager = managers[idx];
      final managerClasses = await getClassesOfManager(trimmed);

      // ذخیره کامل در سطل زباله
      final trash = await getTrashManagers();
      trash.removeWhere((t) => t.manager.passcode == trimmed);
      trash.insert(
        0,
        QuranTrashManagerItem(
          manager: targetManager,
          classes: managerClasses,
          deletedAt: DateTime.now().toIso8601String(),
        ),
      );
      await _saveTrashManagers(trash);

      // حذف از لیست مدیران فعال
      managers.removeAt(idx);
      await _saveAllManagers(managers);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('quran7_manager_name_$trimmed');
      await prefs.remove('quran7_manager_max_$trimmed');
      await prefs.remove('quran7_classes_manager_$trimmed');

      // پاکسازی از حافظه زنده کلاس‌ها تا زمان بازیابی
      for (final c in managerClasses) {
        _allKnownClasses.remove(c.classCode);
        _classToManagerMap.remove(c.classCode);
        _globalUsedClassCodes.remove(c.classCode);
      }

      if (currentManagerPasscode == trimmed) {
        await logoutManager();
      }
      return true;
    }
    return false;
  }

  /// بازیابی کامل مدیر از سطل زباله همراه با تمامی کلاس‌ها، دانش‌آموزان و تنظیمات
  static Future<Map<String, dynamic>> restoreManager(String passcode) async {
    final trimmed = passcode.trim();
    final trash = await getTrashManagers();
    final idx = trash.indexWhere((t) => t.manager.passcode == trimmed);
    if (idx == -1) {
      return {'success': false, 'message': 'مدیر در سطل زباله یافت نشد.'};
    }

    final trashItem = trash[idx];
    final activeManagers = await getAllManagers();
    if (activeManagers.any((m) => m.passcode == trimmed)) {
      return {
        'success': false,
        'message':
            'مدیری با این رمز هم‌اکنون در سیستم فعال است. لطفاً ابتدا وضعیت رمز را بررسی کنید.',
      };
    }

    // بازگرداندن مدیر به لیست فعال
    activeManagers.add(trashItem.manager);
    await _saveAllManagers(activeManagers);

    // بازگرداندن کش نام و سهمیه
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'quran7_manager_name_$trimmed', trashItem.manager.name);
    await prefs.setInt(
        'quran7_manager_max_$trimmed', trashItem.manager.maxClasses);

    // بازگرداندن تمامی کلاس‌ها با جزئیات کامل دانش‌آموزان
    final classesJson =
        jsonEncode(trashItem.classes.map((c) => c.toJson()).toList());
    await prefs.setString('quran7_classes_manager_$trimmed', classesJson);

    // ثبت مجدد کلاس‌ها در شاخص‌های زنده سامانه
    for (final c in trashItem.classes) {
      _allKnownClasses[c.classCode] = c;
      _classToManagerMap[c.classCode] = trimmed;
      _globalUsedClassCodes.add(c.classCode);
    }

    // حذف از سطل زباله
    trash.removeAt(idx);
    await _saveTrashManagers(trash);

    return {
      'success': true,
      'manager': trashItem.manager,
      'classesCount': trashItem.classes.length,
    };
  }

  /// حذف قطعی و همیشگی یک مدیر از سطل زباله
  static Future<bool> permanentlyDeleteFromTrash(String passcode) async {
    final trimmed = passcode.trim();
    final trash = await getTrashManagers();
    final initialLen = trash.length;
    trash.removeWhere((t) => t.manager.passcode == trimmed);
    if (trash.length != initialLen) {
      await _saveTrashManagers(trash);
      return true;
    }
    return false;
  }

  /// خالی کردن کامل سطل زباله
  static Future<void> emptyTrash() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTrashManagers);
  }

  /// دریافت لیست کلاس‌های اختصاصی یک مدیر
  static Future<List<QuranClassModel>> getClassesOfManager(
      String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr =
        prefs.getString('quran7_classes_manager_${passcode.trim()}');
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list
          .map((e) => QuranClassModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// دریافت تعداد کلاس‌های ثبت‌شده یک مدیر
  static Future<int> getManagerClassesCount(String passcode) async {
    final list = await getClassesOfManager(passcode);
    return list.length;
  }

  // ===================== اعتبارسنجی ورود مدیر و ابرمُدیر =====================

  /// اعتبارسنجی رمز ورود مدیر یا ابرمُدیر کاملاً محلی، آنی و بدون تأخیر اینترنت
  static Future<Map<String, dynamic>> verifyManagerPasscode(
      String passcode) async {
    final trimmed = passcode.trim();
    if (trimmed.isEmpty || trimmed.length != 10) {
      return {
        'success': false,
        'message': 'رمز ورود مدیر نادرست است',
      };
    }

    // ۱. بررسی ورود ابرمُدیر سیستم با رمز ۸۳۲۷۱۸۳۱۴۱ و تطبیق ۴ شماره تلفن مجاز
    if (trimmed == superAdminPasscode) {
      final currentPhone = AuthManager.phoneNumber.trim();
      if (isSuperAdminPhone(currentPhone)) {
        currentManagerPasscode = superAdminPasscode;
        currentManagerName = 'ابرمُدیر سیستم';
        currentManagerMaxClasses = 999;
        _initialized = true;
        await saveManagerPasscode(trimmed);
        return {
          'success': true,
          'isSuperAdmin': true,
          'phone': currentPhone,
        };
      } else {
        // اگر شماره در لیست ۴ شماره مجاز نباشد، دقیقاً و فقط همین پیام بدون هیچ توضیح اضافه‌ای داده می‌شود
        return {
          'success': false,
          'message': 'رمز ورود مدیر نادرست است',
        };
      }
    }

    // ۲. بررسی مدیران مدارس تعریف‌شده
    final managers = await getAllManagers();
    final matched = managers.where((m) => m.passcode == trimmed).toList();
    if (matched.isNotEmpty) {
      final currentPhone = AuthManager.phoneNumber.trim();
      if (!AuthManager.isLoggedIn || currentPhone.isEmpty) {
        return {
          'success': false,
          'message':
              'برای ورود به پنل مدیر، ابتدا باید با یک شماره تلفن در برنامه ثبت‌نام کنید.',
        };
      }

      final mgr = matched.first;
      currentManagerPasscode = mgr.passcode;
      currentManagerName = mgr.name;
      currentManagerMaxClasses = mgr.maxClasses;

      // بارگذاری کلاس‌های اختصاصی همین مدیر
      final prefs = await SharedPreferences.getInstance();
      final classesJson = prefs.getString('quran7_classes_manager_$trimmed');
      if (classesJson != null && classesJson.isNotEmpty) {
        try {
          final List<dynamic> decoded = jsonDecode(classesJson);
          _classes = decoded
              .map((e) => QuranClassModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (_) {
          _classes = [];
        }
      } else {
        _classes = [];
      }

      _initialized = true;
      await saveManagerPasscode(trimmed);
      return {
        'success': true,
        'isSuperAdmin': false,
        'manager': mgr.toJson(),
      };
    }

    // ۳. بررسی کش محلی اگر قبلاً ثبت شده بوده
    final prefs = await SharedPreferences.getInstance();
    final cachedName = prefs.getString('quran7_manager_name_$trimmed');
    if (cachedName != null && cachedName.isNotEmpty) {
      currentManagerPasscode = trimmed;
      currentManagerName = cachedName;
      currentManagerMaxClasses =
          prefs.getInt('quran7_manager_max_$trimmed') ?? 3;

      final cachedClasses =
          prefs.getString('quran7_classes_manager_$trimmed');
      if (cachedClasses != null && cachedClasses.isNotEmpty) {
        try {
          final List<dynamic> decoded = jsonDecode(cachedClasses);
          _classes = decoded
              .map((e) => QuranClassModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (_) {}
      }

      _initialized = true;
      await saveManagerPasscode(trimmed);
      return {
        'success': true,
        'isSuperAdmin': false,
        'manager': {
          'name': currentManagerName,
          'passcode': trimmed,
          'max_classes': currentManagerMaxClasses,
        },
      };
    }

    // در غیر این صورت، خطای دقیق بدون توضیح اضافه
    return {
      'success': false,
      'message': 'رمز ورود مدیر نادرست است',
    };
  }

  // ===================== مدیریت ماندگاری ورود به تفکیک شماره تلفن (Phone-Scoped Sessions) =====================
  static const String _keySavedManagerPasscode = 'quran7_saved_manager_passcode';
  static const String _keySavedTeacherCode = 'quran7_saved_teacher_code';
  static const String _keySavedStudentClassCode = 'quran7_saved_student_class_code';

  /// تولید کلید تفکیک‌شده بر اساس شماره تلفن کاربر جاری جهت ایزوله‌سازی ۱۰۰٪ اطلاعات هر شماره
  static String _scopedKey(String baseKey) {
    final phone = AuthManager.phoneNumber.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (phone.isNotEmpty) {
      return '${baseKey}_$phone';
    }
    return '${baseKey}_guest';
  }

  /// دریافت رمز مدیر ذخیره‌شده برای ورود خودکار (مختص شماره تلفن کاربر جاری)
  static Future<String?> getSavedManagerPasscode() async {
    final prefs = await SharedPreferences.getInstance();
    final p = prefs.getString(_scopedKey(_keySavedManagerPasscode));
    return (p != null && p.trim().isNotEmpty) ? p.trim() : null;
  }

  /// ذخیره ماندگار رمز ورود مدیر (مختص شماره تلفن کاربر جاری)
  static Future<void> saveManagerPasscode(String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scopedKey(_keySavedManagerPasscode), passcode.trim());
  }

  /// خروج از حساب مدیریت مختص شماره تلفن کاربر جاری
  static Future<void> logoutManager() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scopedKey(_keySavedManagerPasscode));
    await prefs.remove(_keySavedManagerPasscode); // حذف کلید عمومی قدیمی جهت جلوگیری از تداخل
    currentManagerPasscode = null;
    currentManagerName = 'مدیر لیگ قرآن';
    currentManagerMaxClasses = 3;
    _classes = [];
    _initialized = false;
    _lastInitializedPhone = null;
  }

  /// دریافت کد معلم ذخیره‌شده برای ورود خودکار (مختص شماره تلفن کاربر جاری)
  static Future<String?> getSavedTeacherCode() async {
    final prefs = await SharedPreferences.getInstance();
    final c = prefs.getString(_scopedKey(_keySavedTeacherCode));
    return (c != null && c.trim().isNotEmpty) ? c.trim() : null;
  }

  /// ذخیره ماندگار کد معلم (مختص شماره تلفن کاربر جاری)
  static Future<void> saveTeacherCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scopedKey(_keySavedTeacherCode), code.trim());
  }

  /// خروج از حساب معلم مختص شماره تلفن کاربر جاری
  static Future<void> logoutTeacher() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scopedKey(_keySavedTeacherCode));
    await prefs.remove(_keySavedTeacherCode);
  }

  /// دریافت کد ۵ رقمی کلاس دانش‌آموز برای ورود خودکار (مختص شماره تلفن کاربر جاری)
  static Future<String?> getSavedStudentClassCode() async {
    final prefs = await SharedPreferences.getInstance();
    final c = prefs.getString(_scopedKey(_keySavedStudentClassCode)) ??
        prefs.getString(_scopedKey(_lastClassKey));
    return (c != null && c.trim().isNotEmpty) ? c.trim() : null;
  }

  /// ذخیره ماندگار کد کلاس دانش‌آموز (مختص شماره تلفن کاربر جاری)
  static Future<void> saveStudentClassCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scopedKey(_keySavedStudentClassCode), code.trim());
    await prefs.setString(_scopedKey(_lastClassKey), code.trim());
  }

  /// خروج دانش‌آموز از کلاس / تعویض کلاس مختص شماره تلفن کاربر جاری
  static Future<void> logoutStudent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scopedKey(_keySavedStudentClassCode));
    await prefs.remove(_scopedKey(_lastClassKey));
    await prefs.remove(_keySavedStudentClassCode);
    await prefs.remove(_lastClassKey);
  }

  // نگهداری آخرین شماره تلفنی که سیستم برای آن لود شده است
  static String? _lastInitializedPhone;

  static Future<void> init({bool forceReload = false}) async {
    final currentPhone = AuthManager.phoneNumber.trim();
    if (_initialized && !forceReload && _lastInitializedPhone == currentPhone) {
      return;
    }
    _lastInitializedPhone = currentPhone;

    final prefs = await SharedPreferences.getInstance();

    // پاکسازی کلیدهای قدیمی سراسری جهت رفع کامل هرگونه نشت اطلاعات بین شماره‌ها
    if (prefs.containsKey(_keySavedManagerPasscode)) {
      await prefs.remove(_keySavedManagerPasscode);
    }
    if (prefs.containsKey(_keySavedTeacherCode)) {
      await prefs.remove(_keySavedTeacherCode);
    }
    if (prefs.containsKey(_keySavedStudentClassCode)) {
      await prefs.remove(_keySavedStudentClassCode);
    }
    if (prefs.containsKey(_lastClassKey)) {
      await prefs.remove(_lastClassKey);
    }

    // ۱. بررسی رمز مدیر ذخیره‌شده دقیقاً برای شماره تلفن کاربر جاری
    final savedPassForCurrentPhone = await getSavedManagerPasscode();
    if (savedPassForCurrentPhone != null && savedPassForCurrentPhone.isNotEmpty) {
      currentManagerPasscode = savedPassForCurrentPhone;
      currentManagerName =
          prefs.getString('quran7_manager_name_$savedPassForCurrentPhone') ??
              'مدیر لیگ قرآن';
      currentManagerMaxClasses =
          prefs.getInt('quran7_manager_max_$savedPassForCurrentPhone') ?? 3;

      final keyToUse = 'quran7_classes_manager_$currentManagerPasscode';
      final jsonStr = prefs.getString(keyToUse);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        try {
          final List<dynamic> decoded = jsonDecode(jsonStr);
          _classes = decoded
              .map((e) => QuranClassModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (e) {
          debugPrint('Error loading quran7 classes: $e');
          _classes = [];
        }
      } else {
        _classes = [];
      }
    } else {
      // شماره تلفن جدید هنوز رمز مدیریتی ثبت نکرده؛ وضعیت کاملاً خام و تفکیک‌شده است
      currentManagerPasscode = null;
      currentManagerName = 'مدیر لیگ قرآن';
      currentManagerMaxClasses = 3;
      _classes = [];
    }

    // ۲. به‌روزرسانی شاخص سراسری تمامی کلاس‌ها و نگاشت آنها به مدیران
    _allKnownClasses.clear();
    _classToManagerMap.clear();
    _globalUsedClassCodes.clear();

    final managers = await getAllManagers();
    for (final m in managers) {
      final mJson = prefs.getString('quran7_classes_manager_${m.passcode}');
      if (mJson != null && mJson.isNotEmpty) {
        try {
          final List<dynamic> list = jsonDecode(mJson);
          for (final item in list) {
            final cls = QuranClassModel.fromJson(item as Map<String, dynamic>);
            _allKnownClasses[cls.classCode] = cls;
            _classToManagerMap[cls.classCode] = m.passcode;
            _globalUsedClassCodes.add(cls.classCode);
          }
        } catch (_) {}
      }
    }

    for (final c in _classes) {
      _allKnownClasses[c.classCode] = c;
      if (currentManagerPasscode != null) {
        _classToManagerMap[c.classCode] = currentManagerPasscode!;
      }
      _globalUsedClassCodes.add(c.classCode);
    }

    _initialized = true;
  }

  static Future<void> saveClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(_classes.map((c) => c.toJson()).toList());

    if (currentManagerPasscode != null) {
      await prefs.setString(
          'quran7_classes_manager_$currentManagerPasscode', jsonStr);
    }
    await prefs.setString(_prefKey, jsonStr);

    for (final c in _classes) {
      _allKnownClasses[c.classCode] = c;
      if (currentManagerPasscode != null) {
        _classToManagerMap[c.classCode] = currentManagerPasscode!;
      }
    }
  }

  static List<QuranClassModel> getClasses() {
    return List.unmodifiable(_classes);
  }

  static bool classCodeExists(String classCode) {
    final trimmed = classCode.trim();
    if (_classes.any((c) => c.classCode == trimmed)) return true;
    return _allKnownClasses.containsKey(trimmed);
  }

  static QuranClassModel? getClassByCode(String classCode) {
    final trimmed = classCode.trim();
    try {
      return _classes.firstWhere((c) => c.classCode == trimmed);
    } catch (_) {}
    return _allKnownClasses[trimmed];
  }

  static QuranClassModel? getClassByTeacherCode(String teacherCode) {
    final trimmed = teacherCode.trim();
    try {
      return _classes.firstWhere((c) => c.teacherCode == trimmed);
    } catch (_) {}

    for (final c in _allKnownClasses.values) {
      if (c.teacherCode == trimmed) return c;
    }
    return null;
  }

  // تولید کد ۱۰ رقمی معلم به طوری که ۵ رقم اول کد کلاس و ۵ رقم بعدی تصادفی و یکتا باشد
  static String generateUniqueTeacherCode(String classCode) {
    final rand = Random();
    String code;
    do {
      final randomSuffix =
          (10000 + rand.nextInt(90000)).toString(); // ۵ رقم شانسی
      code = '$classCode$randomSuffix';
    } while (_classes.any((c) => c.teacherCode == code) ||
        _allKnownClasses.values.any((c) => c.teacherCode == code));
    return code;
  }

  /// جمع‌آوری تمامی کدهای ۵ رقمی فعال در سراسر سامانه
  static Future<Set<String>> getAllExistingClassCodes() async {
    await init();
    return Set<String>.from(_globalUsedClassCodes);
  }

  /// تولید کد ۵ رقمی کاملاً تصادفی و شانسی که تا کنون در هیچ پنل مدیری ایجاد نشده باشد (کاملاً آفلاین و آنی)
  static Future<String> generateUniqueRandomClassCode() async {
    final existingCodes = await getAllExistingClassCodes();
    final rand = Random();
    String candidate;
    do {
      // تولید ۵ رقم تصادفی (بین 10000 تا 99999)
      candidate = (10000 + rand.nextInt(90000)).toString();
    } while (existingCodes.contains(candidate) || classCodeExists(candidate));

    return candidate;
  }

  // ایجاد کلاس جدید توسط مدیر با کنترل دقیق سقف مجاز (100% محلی، آنی و بدون نیاز به CMS یا اینترنت)
  static Future<Map<String, dynamic>> createClass({
    required String classCode,
    String? title,
  }) async {
    await init();
    final trimmedCode = classCode.trim();

    // بررسی ۵ رقمی بودن
    if (trimmedCode.length != 5 || int.tryParse(trimmedCode) == null) {
      return {
        'success': false,
        'message': 'کد کلاس باید دقیقاً ۵ رقم عددی باشد.',
      };
    }

    // بررسی سقف مجاز برای این مدیر
    if (_classes.length >= currentManagerMaxClasses) {
      return {
        'success': false,
        'message':
            'سقف مجاز ایجاد کلاس برای شما ($currentManagerMaxClasses کلاس) تکمیل شده است!\nشما مجاز به ایجاد کلاس بیشتری نیستید. برای افزایش سقف با ابرمُدیر سیستم هماهنگ فرمایید.',
      };
    }

    // بررسی عدم تکراری بودن کد کلاس در سراسر سامانه
    final existingCodes = await getAllExistingClassCodes();
    if (existingCodes.contains(trimmedCode) || classCodeExists(trimmedCode)) {
      return {
        'success': false,
        'message':
            'این کد کلاس قبلاً در سامانه ایجاد شده است! لطفاً یک کد دیگر انتخاب کنید یا از دکمه تولید کد شانسی (🎲) استفاده نمایید.',
      };
    }

    final teacherCode = generateUniqueTeacherCode(trimmedCode);
    final classTitle = (title != null && title.trim().isNotEmpty)
        ? title.trim()
        : 'کلاس قرآن پایه هفتم (${toPersianDigits(trimmedCode)})';

    final newClass = QuranClassModel(
      classCode: trimmedCode,
      teacherCode: teacherCode,
      title: classTitle,
      createdAt: DateTime.now().toIso8601String(),
      students: [],
    );

    _classes.add(newClass);
    _allKnownClasses[trimmedCode] = newClass;
    if (currentManagerPasscode != null) {
      _classToManagerMap[trimmedCode] = currentManagerPasscode!;
    }
    _globalUsedClassCodes.add(trimmedCode);

    await saveClasses();

    return {
      'success': true,
      'class': newClass,
      'message': 'کلاس با موفقیت ایجاد شد.',
    };
  }

  // ذخیره کمکی یک کلاس تغییر یافته در مخزن مدیر مربوطه‌اش
  static Future<void> _persistClassAcrossManagers(QuranClassModel updatedClass) async {
    _allKnownClasses[updatedClass.classCode] = updatedClass;
    final managerPass = _classToManagerMap[updatedClass.classCode];
    if (managerPass != null && managerPass.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final key = 'quran7_classes_manager_$managerPass';
      final jsonStr = prefs.getString(key);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        try {
          final List<dynamic> list = jsonDecode(jsonStr);
          final classes = list
              .map((e) => QuranClassModel.fromJson(e as Map<String, dynamic>))
              .toList();
          final idx = classes.indexWhere((c) => c.classCode == updatedClass.classCode);
          if (idx != -1) {
            classes[idx] = updatedClass;
          } else {
            classes.add(updatedClass);
          }
          await prefs.setString(key, jsonEncode(classes.map((c) => c.toJson()).toList()));
        } catch (_) {}
      }
    }
  }

  // حذف کلاس
  static Future<bool> deleteClass(String classCode) async {
    await init();
    final index = _classes.indexWhere((c) => c.classCode == classCode);
    if (index != -1) {
      _classes.removeAt(index);
      await saveClasses();
    }
    _allKnownClasses.remove(classCode);
    _globalUsedClassCodes.remove(classCode);

    final managerPass = _classToManagerMap[classCode];
    if (managerPass != null && managerPass.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final key = 'quran7_classes_manager_$managerPass';
      final jsonStr = prefs.getString(key);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        try {
          final List<dynamic> list = jsonDecode(jsonStr);
          final classes = list
              .map((e) => QuranClassModel.fromJson(e as Map<String, dynamic>))
              .where((c) => c.classCode != classCode)
              .toList();
          await prefs.setString(
              key, jsonEncode(classes.map((c) => c.toJson()).toList()));
        } catch (_) {}
      }
    }
    return true;
  }

  // ویرایش نام کلاس (همگام با پنل معلم و پنل مدیر)
  static Future<bool> updateClassTitle(String classCode, String newTitle) async {
    await init();
    final trimmedTitle = newTitle.trim();
    if (trimmedTitle.isEmpty) return false;
    final old = getClassByCode(classCode);
    if (old != null) {
      final updatedClass = QuranClassModel(
        classCode: old.classCode,
        teacherCode: old.teacherCode,
        title: trimmedTitle,
        createdAt: old.createdAt,
        students: old.students,
      );
      final index = _classes.indexWhere((c) => c.classCode == classCode);
      if (index != -1) {
        _classes[index] = updatedClass;
      }
      await saveClasses();
      await _persistClassAcrossManagers(updatedClass);
      return true;
    }
    return false;
  }

  // حذف دانش‌آموز از کلاس توسط معلم یا مدیر
  static Future<QuranClassModel?> removeStudentFromClass(
      String classCode, String studentId) async {
    await init();
    final old = getClassByCode(classCode);
    if (old != null) {
      final updatedStudents =
          old.students.where((s) => s.id != studentId).toList();
      final updatedClass = QuranClassModel(
        classCode: old.classCode,
        teacherCode: old.teacherCode,
        title: old.title,
        createdAt: old.createdAt,
        students: updatedStudents,
      );
      final index = _classes.indexWhere((c) => c.classCode == classCode);
      if (index != -1) {
        _classes[index] = updatedClass;
      }
      await saveClasses();
      await _persistClassAcrossManagers(updatedClass);
      return updatedClass;
    }
    return null;
  }

  // ارتقای ۱ رتبه در جدول لیگ و اهدای سکه به دانش‌آموز برنده چالش
  static Future<bool> promoteStudentRankInClass({
    required String classCode,
    required String studentId,
    required String studentName,
    int bonusCoins = 100,
  }) async {
    await init();
    final old = getClassByCode(classCode);
    if (old == null) return false;

    final students = List<QuranStudentModel>.from(old.students);
    students.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));

    final sIdx = students.indexWhere((s) =>
        s.id == studentId ||
        s.name == studentName ||
        (s.phoneNumber != null && s.phoneNumber == studentId));
    if (sIdx == -1) return false;

    final target = students[sIdx];
    int newJoinedAt = target.joinedAt;
    if (sIdx > 0) {
      final above = students[sIdx - 1];
      newJoinedAt = above.joinedAt - 1000;
    }

    students[sIdx] = target.copyWith(
      coins: target.coins + bonusCoins,
      joinedAt: newJoinedAt,
    );
    students.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));

    final updatedClass = QuranClassModel(
      classCode: old.classCode,
      teacherCode: old.teacherCode,
      title: old.title,
      createdAt: old.createdAt,
      students: students,
    );

    final cIndex = _classes.indexWhere((c) => c.classCode == classCode);
    if (cIndex != -1) {
      _classes[cIndex] = updatedClass;
    }
    await saveClasses();
    await _persistClassAcrossManagers(updatedClass);
    return true;
  }

  // وضعیت تکمیل بازی‌های قرآن هفتم از AuthManager برای کاربر جاری
  static bool getAuthManagerQuran7PartCompleted(int lesson, int part) {
    switch (lesson) {
      case 1:
        return part == 1
            ? AuthManager.quran7Lesson1Part1Completed
            : part == 2
                ? AuthManager.quran7Lesson1Part2Completed
                : AuthManager.quran7Lesson1Part3Completed;
      case 2:
        return part == 1
            ? AuthManager.quran7Lesson2Part1Completed
            : part == 2
                ? AuthManager.quran7Lesson2Part2Completed
                : AuthManager.quran7Lesson2Part3Completed;
      case 3:
        return part == 1
            ? AuthManager.quran7Lesson3Part1Completed
            : part == 2
                ? AuthManager.quran7Lesson3Part2Completed
                : AuthManager.quran7Lesson3Part3Completed;
      case 4:
        return part == 1
            ? AuthManager.quran7Lesson4Part1Completed
            : part == 2
                ? AuthManager.quran7Lesson4Part2Completed
                : AuthManager.quran7Lesson4Part3Completed;
      case 5:
        return part == 1
            ? AuthManager.quran7Lesson5Part1Completed
            : part == 2
                ? AuthManager.quran7Lesson5Part2Completed
                : AuthManager.quran7Lesson5Part3Completed;
      case 6:
        return part == 1
            ? AuthManager.quran7Lesson6Part1Completed
            : part == 2
                ? AuthManager.quran7Lesson6Part2Completed
                : AuthManager.quran7Lesson6Part3Completed;
      case 7:
        return part == 1
            ? AuthManager.quran7Lesson7Part1Completed
            : part == 2
                ? AuthManager.quran7Lesson7Part2Completed
                : AuthManager.quran7Lesson7Part3Completed;
      case 8:
        return part == 1
            ? AuthManager.quran7Lesson8Part1Completed
            : part == 2
                ? AuthManager.quran7Lesson8Part2Completed
                : AuthManager.quran7Lesson8Part3Completed;
      case 9:
        return part == 1
            ? AuthManager.quran7Lesson9Part1Completed
            : part == 2
                ? AuthManager.quran7Lesson9Part2Completed
                : AuthManager.quran7Lesson9Part3Completed;
      case 10:
        return part == 1
            ? AuthManager.quran7Lesson10Part1Completed
            : part == 2
                ? AuthManager.quran7Lesson10Part2Completed
                : AuthManager.quran7Lesson10Part3Completed;
      case 11:
        return part == 1
            ? AuthManager.quran7Lesson11Part1Completed
            : part == 2
                ? AuthManager.quran7Lesson11Part2Completed
                : AuthManager.quran7Lesson11Part3Completed;
      case 12:
        return part == 1
            ? AuthManager.quran7Lesson12Part1Completed
            : part == 2
                ? AuthManager.quran7Lesson12Part2Completed
                : AuthManager.quran7Lesson12Part3Completed;
      default:
        return false;
    }
  }

  // دریافت نقشه بخش‌های تکمیل‌شده برای یک دانش‌آموز
  static Map<String, bool> getStudentCompletedParts(
      String studentId, SharedPreferences prefs) {
    final isCur =
        studentId == AuthManager.phoneNumber.trim() || studentId.isEmpty;
    final Map<String, bool> res = {};
    for (int l = 1; l <= 12; l++) {
      for (int p = 1; p <= 3; p++) {
        bool val = false;
        if (studentId.isNotEmpty) {
          val = prefs.getBool('quran7Lesson${l}Part${p}Completed_$studentId') ??
              false;
        }
        if (!val && isCur) {
          val = prefs.getBool('quran7Lesson${l}Part${p}Completed') ??
              getAuthManagerQuran7PartCompleted(l, p);
        }
        if (val) {
          res['L${l}_P$p'] = true;
        }
      }
    }
    return res;
  }

  // دریافت کلمات اشتباه قسمت سوم برای یک دانش‌آموز
  static Map<String, List<String>> getStudentWrongWords(
      String studentId, SharedPreferences prefs) {
    final isCur =
        studentId == AuthManager.phoneNumber.trim() || studentId.isEmpty;
    final Map<String, List<String>> res = {};
    for (int l = 1; l <= 12; l++) {
      List<String> list = [];
      if (studentId.isNotEmpty) {
        list = prefs.getStringList('quran7_mistakes_L${l}_$studentId') ?? [];
      }
      if (list.isEmpty && isCur) {
        list = prefs.getStringList('quran7_mistakes_L$l') ?? [];
      }
      if (list.isNotEmpty) {
        res['$l'] = list;
      }
    }
    return res;
  }

  // ثبت کلمه اشتباه در قسمت سوم برای کاربر جاری
  static Future<void> recordMistake(
      String lessonKey, String word, String meaning) async {
    final prefs = await SharedPreferences.getInstance();
    final phone = AuthManager.phoneNumber.trim();

    int lessonNum = 1;
    final match = RegExp(r'lesson(\d+)').firstMatch(lessonKey);
    if (match != null) {
      lessonNum = int.tryParse(match.group(1)!) ?? 1;
    }

    final mistakeEntry = meaning.isNotEmpty ? '$word ($meaning)' : word;

    final keyGlobal = 'quran7_mistakes_L$lessonNum';
    final currentList = prefs.getStringList(keyGlobal) ?? [];
    if (!currentList.contains(mistakeEntry)) {
      currentList.add(mistakeEntry);
      await prefs.setStringList(keyGlobal, currentList);
    }

    if (phone.isNotEmpty) {
      final keyPhone = 'quran7_mistakes_L${lessonNum}_$phone';
      final phoneList = prefs.getStringList(keyPhone) ?? [];
      if (!phoneList.contains(mistakeEntry)) {
        phoneList.add(mistakeEntry);
        await prefs.setStringList(keyPhone, phoneList);
      }
    }

    // به‌روزرسانی در کلاس‌های جاری
    await init();
    for (int i = 0; i < _classes.length; i++) {
      final students = List<QuranStudentModel>.from(_classes[i].students);
      final sIdx = students.indexWhere((s) =>
          (phone.isNotEmpty && s.id == phone) ||
          (phone.isEmpty && s.isCurrentUser));
      if (sIdx != -1) {
        final existingWrongs =
            Map<String, List<String>>.from(students[sIdx].wrongWords);
        final lList = List<String>.from(existingWrongs['$lessonNum'] ?? []);
        if (!lList.contains(mistakeEntry)) {
          lList.add(mistakeEntry);
          existingWrongs['$lessonNum'] = lList;
          students[sIdx] = students[sIdx].copyWith(wrongWords: existingWrongs);
          _classes[i] = QuranClassModel(
            classCode: _classes[i].classCode,
            teacherCode: _classes[i].teacherCode,
            title: _classes[i].title,
            createdAt: _classes[i].createdAt,
            students: students,
          );
        }
      }
    }
    await saveClasses();
  }

  // همگام‌سازی سکه‌ها و اطلاعات تمام دانش‌آموزان کلاس با آخرین تغییرات SharedPreferences
  static Future<QuranClassModel?> syncClassStudents(String classCode) async {
    await init();
    final index = _classes.indexWhere((c) => c.classCode == classCode);
    if (index == -1) return null;

    final qClass = _classes[index];
    final prefs = await SharedPreferences.getInstance();
    final currentPhone = AuthManager.phoneNumber.trim();
    final students = List<QuranStudentModel>.from(qClass.students);

    for (int i = 0; i < students.length; i++) {
      final s = students[i];
      int coins = s.coins;
      String name = s.name;
      String? avatar = s.avatar;

      // اگر کاربر جاری است، سکه و نام را با آخرین وضعیت پروفایل بخوان
      if (s.id == currentPhone || (currentPhone.isEmpty && s.isCurrentUser)) {
        coins = await getRealCoins();
        name = await getRealProfileName();
        avatar = await getRealAvatar();
      } else if (s.id.isNotEmpty) {
        final savedCoins = prefs.getInt('coins_${s.id}');
        if (savedCoins != null) coins = savedCoins;
        final savedName = prefs.getString('userName_${s.id}');
        if (savedName != null && savedName.trim().isNotEmpty) {
          name = savedName.trim();
        }
        final savedAvatar = prefs.getString('userAvatar_${s.id}');
        if (savedAvatar != null && savedAvatar.trim().isNotEmpty) {
          avatar = savedAvatar.trim();
        }
      }

      final studentParts = getStudentCompletedParts(s.id, prefs);
      final studentWrongs = getStudentWrongWords(s.id, prefs);

      String? phone = s.phoneNumber;
      if (phone == null || phone.isEmpty) {
        if (s.id.startsWith('09') || RegExp(r'^\d{11}$').hasMatch(s.id)) {
          phone = s.id;
        } else if (s.isCurrentUser || s.id == currentPhone) {
          phone = currentPhone.isNotEmpty ? currentPhone : null;
        }
      }

      students[i] = s.copyWith(
        name: name,
        coins: coins,
        level: max(1, (coins / 50).floor() + 1),
        avatar: avatar,
        phoneNumber: phone,
        completedParts: studentParts.isNotEmpty ? studentParts : s.completedParts,
        wrongWords: studentWrongs.isNotEmpty ? studentWrongs : s.wrongWords,
      );
    }

    final updatedClass = QuranClassModel(
      classCode: qClass.classCode,
      teacherCode: qClass.teacherCode,
      title: qClass.title,
      createdAt: qClass.createdAt,
      students: students,
    );

    _classes[index] = updatedClass;
    await saveClasses();
    await _persistClassAcrossManagers(updatedClass);
    return updatedClass;
  }

  // دریافت نام واقعی ذخیره‌شده در پروفایل
  static Future<String> getRealProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = AuthManager.phoneNumber.trim();
    if (phone.isNotEmpty) {
      final savedPhoneName = prefs.getString('userName_$phone');
      if (savedPhoneName != null && savedPhoneName.trim().isNotEmpty) {
        return savedPhoneName.trim();
      }
    }
    if (AuthManager.userName.trim().isNotEmpty) {
      return AuthManager.userName.trim();
    }
    final defaultSaved = prefs.getString('userName');
    if (defaultSaved != null && defaultSaved.trim().isNotEmpty) {
      return defaultSaved.trim();
    }
    return 'دانش‌آموز نابغه';
  }

  // دریافت سکه‌های واقعی
  static Future<int> getRealCoins() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = AuthManager.phoneNumber.trim();
    if (phone.isNotEmpty) {
      final savedPhoneCoins = prefs.getInt('coins_$phone');
      if (savedPhoneCoins != null) {
        AuthManager.coins = savedPhoneCoins;
        return savedPhoneCoins;
      }
    }
    return AuthManager.coins;
  }

  // دریافت آواتار واقعی
  static Future<String> getRealAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = AuthManager.phoneNumber.trim();
    if (phone.isNotEmpty) {
      final savedAvatar = prefs.getString('userAvatar_$phone');
      if (savedAvatar != null && savedAvatar.trim().isNotEmpty) {
        return savedAvatar.trim();
      }
    }
    if (AuthManager.userAvatar.trim().isNotEmpty) {
      return AuthManager.userAvatar.trim();
    }
    return prefs.getString('userAvatar') ?? '';
  }

  // ورود یا به‌روزرسانی دانش‌آموز واقعی در کلاس (بر اساس پروفایل و سکه‌های واقعی)
  static Future<QuranClassModel?> enrollOrUpdateCurrentUser(String classCode) async {
    await init();
    final qClass = getClassByCode(classCode);
    if (qClass == null) return null;

    final prefs = await SharedPreferences.getInstance();
    final String profileName = await getRealProfileName();
    final int userCoins = await getRealCoins();
    final int userLevel = max(1, (userCoins / 50).floor() + 1);
    final String userAvatar = await getRealAvatar();
    final String userPhone = AuthManager.phoneNumber.trim();
    final String userId = userPhone.isNotEmpty ? userPhone : 'user_${profileName.hashCode}';

    final students = List<QuranStudentModel>.from(qClass.students);

    final userParts = getStudentCompletedParts(userId, prefs);
    final userWrongs = getStudentWrongWords(userId, prefs);

    // جستجوی کاربر در لیست بر اساس شماره تلفن یا آیدی اختصاصی
    final existingIndex = students.indexWhere((s) => s.id == userId);

    if (existingIndex != -1) {
      // کاربر قبلاً عضو بوده: سکه‌ها، نام پروفایل و آواتار بروزرسانی می‌شود ولی زمان ورود (joinedAt) حفظ می‌شود
      students[existingIndex] = students[existingIndex].copyWith(
        name: profileName,
        coins: userCoins,
        level: userLevel,
        avatar: userAvatar,
        phoneNumber: userPhone.isNotEmpty ? userPhone : students[existingIndex].phoneNumber,
        completedParts: userParts.isNotEmpty ? userParts : students[existingIndex].completedParts,
        wrongWords: userWrongs.isNotEmpty ? userWrongs : students[existingIndex].wrongWords,
      );
    } else {
      // کاربر جدید به کلاس ملحق می‌شود
      students.add(
        QuranStudentModel(
          id: userId,
          name: profileName,
          coins: userCoins,
          level: userLevel,
          avatar: userAvatar,
          phoneNumber: userPhone.isNotEmpty ? userPhone : null,
          joinedAt: DateTime.now().millisecondsSinceEpoch,
          completedParts: userParts,
          wrongWords: userWrongs,
        ),
      );
    }

    // به‌روزرسانی سکه‌ها و نام سایر دانش‌آموزان کلاس از حافظه تا در صورت تغییر، رتبه‌بندی اصلاح شود
    for (int i = 0; i < students.length; i++) {
      final s = students[i];
      if (s.id.isNotEmpty && s.id != userId) {
        final phoneCoins = prefs.getInt('coins_${s.id}');
        final phoneName = prefs.getString('userName_${s.id}');
        final phoneAvatar = prefs.getString('userAvatar_${s.id}');
        final otherParts = getStudentCompletedParts(s.id, prefs);
        final otherWrongs = getStudentWrongWords(s.id, prefs);

        students[i] = students[i].copyWith(
          coins: phoneCoins ?? s.coins,
          level: phoneCoins != null ? max(1, (phoneCoins / 50).floor() + 1) : s.level,
          name: (phoneName != null && phoneName.trim().isNotEmpty) ? phoneName.trim() : s.name,
          avatar: (phoneAvatar != null && phoneAvatar.trim().isNotEmpty) ? phoneAvatar.trim() : s.avatar,
          phoneNumber: s.phoneNumber ?? (s.id.startsWith('09') ? s.id : null),
          completedParts: otherParts.isNotEmpty ? otherParts : s.completedParts,
          wrongWords: otherWrongs.isNotEmpty ? otherWrongs : s.wrongWords,
        );
      }
    }

    final updatedClass = QuranClassModel(
      classCode: qClass.classCode,
      teacherCode: qClass.teacherCode,
      title: qClass.title,
      createdAt: qClass.createdAt,
      students: students,
    );

    final idx = _classes.indexWhere((c) => c.classCode == classCode);
    if (idx != -1) {
      _classes[idx] = updatedClass;
      await saveClasses();
    }
    await _persistClassAcrossManagers(updatedClass);

    await setLastEnteredClassCode(classCode);
    return updatedClass;
  }

  // آخرین کد کلاس وارد شده توسط دانش‌آموز (مختص شماره تلفن جاری)
  static Future<String?> getLastEnteredClassCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_scopedKey(_lastClassKey));
  }

  static Future<void> setLastEnteredClassCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scopedKey(_lastClassKey), code.trim());
  }
}
