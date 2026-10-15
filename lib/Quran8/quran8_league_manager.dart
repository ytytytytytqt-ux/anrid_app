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

// مدل دانش‌آموز در لیگ کلاسی قرآن هشتم
class Quran8StudentModel {
  final String id;
  final String name;
  final int coins;
  final int level;
  final String? avatar;
  final String? phoneNumber;
  final bool isCurrentUser;
  final int joinedAt;
  final Map<String, bool> completedParts;
  final Map<String, List<String>> wrongWords;

  Quran8StudentModel({
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

  factory Quran8StudentModel.fromJson(Map<String, dynamic> json) {
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

    return Quran8StudentModel(
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

  Quran8StudentModel copyWith({
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
    return Quran8StudentModel(
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

// مدل کلاس قرآن هشتم
class Quran8ClassModel {
  final String classCode; // کد ۵ رقمی کلاس
  final String teacherCode; // کد ۱۰ رقمی معلم
  String title;
  final String createdAt;
  final List<Quran8StudentModel> students;

  Quran8ClassModel({
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

  factory Quran8ClassModel.fromJson(Map<String, dynamic> json) =>
      Quran8ClassModel(
        classCode: json['classCode'] as String? ?? '00000',
        teacherCode: json['teacherCode'] as String? ?? '0000000000',
        title: json['title'] as String? ?? 'کلاس قرآن هشتم',
        createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        students: (json['students'] as List<dynamic>?)
                ?.map((e) => Quran8StudentModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

// مدل پروفایل مدیر مدرسه قرآن هشتم
class Quran8ManagerProfile {
  final String name;
  final String passcode; // دقیقاً ۱۰ رقم عددی
  final int maxClasses; // سهمیه تعداد کلاس
  int get classQuota => maxClasses;
  final String createdAt;

  Quran8ManagerProfile({
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

  factory Quran8ManagerProfile.fromJson(Map<String, dynamic> json) =>
      Quran8ManagerProfile(
        name: json['name'] as String? ?? 'مدیر مدرسه',
        passcode: json['passcode'] as String? ?? '',
        maxClasses: (json['maxClasses'] as num?)?.toInt() ?? 3,
        createdAt:
            json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      );
}

// مدل نگهداری مدیر حذف‌شده در سطل زباله
class Quran8TrashManagerItem {
  final Quran8ManagerProfile manager;
  final List<Quran8ClassModel> classes;
  final String deletedAt;

  Quran8TrashManagerItem({
    required this.manager,
    required this.classes,
    required this.deletedAt,
  });

  Map<String, dynamic> toJson() => {
        'manager': manager.toJson(),
        'classes': classes.map((c) => c.toJson()).toList(),
        'deletedAt': deletedAt,
      };

  factory Quran8TrashManagerItem.fromJson(Map<String, dynamic> json) {
    Quran8ManagerProfile mgr;
    try {
      final m = json['manager'];
      if (m is Map) {
        mgr = Quran8ManagerProfile.fromJson(Map<String, dynamic>.from(m));
      } else {
        mgr = Quran8ManagerProfile(
          name: 'مدیر حذف‌شده',
          passcode: '',
          maxClasses: 3,
          createdAt: DateTime.now().toIso8601String(),
        );
      }
    } catch (_) {
      mgr = Quran8ManagerProfile(
        name: 'مدیر حذف‌شده',
        passcode: '',
        maxClasses: 3,
        createdAt: DateTime.now().toIso8601String(),
      );
    }

    final rawClasses = json['classes'] as List<dynamic>? ?? [];
    final List<Quran8ClassModel> classes = [];
    for (final c in rawClasses) {
      try {
        if (c is Map) {
          classes.add(Quran8ClassModel.fromJson(Map<String, dynamic>.from(c)));
        }
      } catch (_) {}
    }

    return Quran8TrashManagerItem(
      manager: mgr,
      classes: classes,
      deletedAt: json['deletedAt'] as String? ??
          DateTime.now().toIso8601String(),
    );
  }
}

// مدیریت سراسری لیگ کلاسی قرآن هشتم
class Quran8LeagueManager {
  static const String _prefKey = 'quran8_classes_data_v1';
  static const String _lastClassKey = 'quran8_last_joined_class';
  static const String _keyLocalManagers = 'quran8_local_managers_v2';
  static const String _keyTrashManagers = 'quran8_trash_managers_v1';

  // رمز عبور اختصاصی ابرمُدیر سیستم
  static const String superAdminPasscode = '8327183141';

  // چهار شماره تلفن مجاز ابرمُدیر
  static const List<String> superAdminPhones = [
    '09154989945',
    '09360492069',
    '09151632069',
    '09388663325',
  ];

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

  static String? currentManagerPasscode;
  static String currentManagerName = 'مدیر لیگ قرآن هشتم';
  static int currentManagerMaxClasses = 3;

  static final Set<String> _globalUsedClassCodes = {};
  static List<Quran8ClassModel> _classes = [];
  static bool _initialized = false;

  static final Map<String, Quran8ClassModel> _allKnownClasses = {};
  static final Map<String, String> _classToManagerMap = {};

  // ===================== مدیریت ابرمُدیر =====================

  static Future<List<Quran8ManagerProfile>> getAllManagers() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonStr = prefs.getString(_keyLocalManagers);
    // اگر در قرآن هشتم هنوز مدیری ثبت نشده بود، از مخزن قرآن هفتم لود کن تا مشترک باشد
    if (jsonStr == null || jsonStr.trim().isEmpty) {
      jsonStr = prefs.getString('quran7_local_managers_v2');
    }
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list
          .map((e) => Quran8ManagerProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveAllManagers(List<Quran8ManagerProfile> managers) async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(managers.map((m) => m.toJson()).toList());
    await prefs.setString(_keyLocalManagers, str);
  }

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
        'message': 'رمز عبور مدیر باید دقیقاً ۱۰ رقم عددی باشد.',
      };
    }
    if (trimmedPass == superAdminPasscode) {
      return {
        'success': false,
        'message': 'این رمز مخصوص ابرمُدیر سیستم است و قابل تعریف نیست.',
      };
    }

    final managers = await getAllManagers();
    if (managers.any((m) => m.passcode == trimmedPass)) {
      return {
        'success': false,
        'message': 'این رمز عبور ۱۰ رقمی قبلاً برای مدیر دیگری ثبت شده است.',
      };
    }

    final newMgr = Quran8ManagerProfile(
      name: trimmedName,
      passcode: trimmedPass,
      maxClasses: maxClasses > 0 ? maxClasses : 3,
      createdAt: DateTime.now().toIso8601String(),
    );
    managers.insert(0, newMgr);
    await _saveAllManagers(managers);

    return {'success': true, 'manager': newMgr};
  }

  static Future<bool> updateManagerQuota(String passcode, int newQuota) async {
    final managers = await getAllManagers();
    final idx = managers.indexWhere((m) => m.passcode == passcode);
    if (idx == -1) return false;

    managers[idx] = Quran8ManagerProfile(
      name: managers[idx].name,
      passcode: managers[idx].passcode,
      maxClasses: newQuota > 0 ? newQuota : 1,
      createdAt: managers[idx].createdAt,
    );
    await _saveAllManagers(managers);
    if (currentManagerPasscode == passcode) {
      currentManagerMaxClasses = managers[idx].maxClasses;
    }
    return true;
  }

  static Future<bool> updateManagerName(String passcode, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return false;
    final managers = await getAllManagers();
    final idx = managers.indexWhere((m) => m.passcode == passcode);
    if (idx == -1) return false;

    managers[idx] = Quran8ManagerProfile(
      name: trimmed,
      passcode: managers[idx].passcode,
      maxClasses: managers[idx].maxClasses,
      createdAt: managers[idx].createdAt,
    );
    await _saveAllManagers(managers);
    if (currentManagerPasscode == passcode) {
      currentManagerName = trimmed;
    }
    return true;
  }

  static Future<List<Quran8TrashManagerItem>> getTrashManagers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyTrashManagers);
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list
          .map((e) => Quran8TrashManagerItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveTrashManagers(List<Quran8TrashManagerItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(items.map((i) => i.toJson()).toList());
    await prefs.setString(_keyTrashManagers, str);
  }

  static Future<bool> deleteManager(String passcode) async {
    final managers = await getAllManagers();
    final idx = managers.indexWhere((m) => m.passcode == passcode);
    if (idx == -1) return false;

    final targetManager = managers[idx];
    final managerClasses = await getClassesForManager(passcode);

    final trash = await getTrashManagers();
    trash.insert(
      0,
      Quran8TrashManagerItem(
        manager: targetManager,
        classes: managerClasses,
        deletedAt: DateTime.now().toIso8601String(),
      ),
    );
    await _saveTrashManagers(trash);

    managers.removeAt(idx);
    await _saveAllManagers(managers);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quran8_manager_classes_$passcode');

    for (final c in managerClasses) {
      _allKnownClasses.remove(c.classCode);
      _classToManagerMap.remove(c.classCode);
      _globalUsedClassCodes.remove(c.classCode);
    }

    if (currentManagerPasscode == passcode) {
      currentManagerPasscode = null;
      _classes = [];
    }
    return true;
  }

  static Future<bool> restoreManagerFromTrash(String passcode) async {
    final trash = await getTrashManagers();
    final idx = trash.indexWhere((item) => item.manager.passcode == passcode);
    if (idx == -1) return false;

    final item = trash[idx];
    final managers = await getAllManagers();
    if (managers.any((m) => m.passcode == item.manager.passcode)) {
      return false;
    }

    managers.insert(0, item.manager);
    await _saveAllManagers(managers);

    await saveClassesForManager(item.manager.passcode, item.classes);

    for (final c in item.classes) {
      _allKnownClasses[c.classCode] = c;
      _classToManagerMap[c.classCode] = item.manager.passcode;
      _globalUsedClassCodes.add(c.classCode);
    }

    trash.removeAt(idx);
    await _saveTrashManagers(trash);
    return true;
  }

  static Future<bool> permanentlyDeleteFromTrash(String passcode) async {
    final trash = await getTrashManagers();
    final before = trash.length;
    trash.removeWhere((item) => item.manager.passcode == passcode);
    if (trash.length == before) return false;
    await _saveTrashManagers(trash);
    return true;
  }

  static Future<bool> clearAllTrash() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTrashManagers);
    return true;
  }

  static Future<void> emptyTrash() async => clearAllTrash();

  static Future<int> getTrashCount() async {
    final trash = await getTrashManagers();
    return trash.length;
  }

  static Future<int> getManagerClassesCount(String passcode) async {
    final list = await getClassesForManager(passcode);
    return list.length;
  }

  static Future<Map<String, dynamic>> createManager({
    required String name,
    required String passcode,
    required int classQuota,
  }) async {
    return addManager(name: name, passcode: passcode, maxClasses: classQuota);
  }

  static Future<Map<String, dynamic>> softDeleteManager(String passcode) async {
    final ok = await deleteManager(passcode);
    return {'success': ok, 'message': ok ? null : 'خطا در حذف مدیر'};
  }

  static Future<Map<String, dynamic>> restoreManager(String passcode) async {
    final ok = await restoreManagerFromTrash(passcode);
    return {'success': ok, 'message': ok ? null : 'خطا در بازیابی مدیر'};
  }

  // ===================== مدیریت مدیر =====================

  static Future<Quran8ManagerProfile?> loginManager(String passcode) async {
    final trimmed = passcode.trim();
    if (trimmed == superAdminPasscode) {
      currentManagerPasscode = superAdminPasscode;
      currentManagerName = 'ابرمُدیر سیستم';
      currentManagerMaxClasses = 9999;
      return Quran8ManagerProfile(
        name: 'ابرمُدیر سیستم',
        passcode: superAdminPasscode,
        maxClasses: 9999,
        createdAt: DateTime.now().toIso8601String(),
      );
    }

    final managers = await getAllManagers();
    try {
      final mgr = managers.firstWhere((m) => m.passcode == trimmed);
      currentManagerPasscode = mgr.passcode;
      currentManagerName = mgr.name;
      currentManagerMaxClasses = mgr.maxClasses;
      await init();
      return mgr;
    } catch (_) {
      return null;
    }
  }

  static Future<List<Quran8ClassModel>> getClassesForManager(String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('quran8_manager_classes_$passcode');
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list
          .map((e) => Quran8ClassModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveClassesForManager(
      String passcode, List<Quran8ClassModel> classes) async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(classes.map((c) => c.toJson()).toList());
    await prefs.setString('quran8_manager_classes_$passcode', str);
  }

  static Future<void> init({bool forceReload = false}) async {
    if (_initialized && currentManagerPasscode != null && !forceReload) return;
    final prefs = await SharedPreferences.getInstance();

    final allMgrs = await getAllManagers();
    for (final mgr in allMgrs) {
      final mgrClasses = await getClassesForManager(mgr.passcode);
      for (final c in mgrClasses) {
        _allKnownClasses[c.classCode] = c;
        _classToManagerMap[c.classCode] = mgr.passcode;
        _globalUsedClassCodes.add(c.classCode);
      }
    }

    final legacyStr = prefs.getString(_prefKey);
    if (legacyStr != null && legacyStr.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(legacyStr);
        for (final item in list) {
          final c = Quran8ClassModel.fromJson(item as Map<String, dynamic>);
          _allKnownClasses[c.classCode] = c;
          _globalUsedClassCodes.add(c.classCode);
        }
      } catch (_) {}
    }

    if (currentManagerPasscode != null) {
      _classes = await getClassesForManager(currentManagerPasscode!);
    } else {
      _classes = [];
    }
    _initialized = true;
  }

  static Future<void> _save() async {
    if (currentManagerPasscode != null) {
      await saveClassesForManager(currentManagerPasscode!, _classes);
    }
    for (final c in _classes) {
      _allKnownClasses[c.classCode] = c;
      if (currentManagerPasscode != null) {
        _classToManagerMap[c.classCode] = currentManagerPasscode!;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(_allKnownClasses.values.map((c) => c.toJson()).toList());
    await prefs.setString(_prefKey, str);
  }

  static List<Quran8ClassModel> get classes => List.unmodifiable(_classes);

  static int get maxClasses => currentManagerMaxClasses;
  static int get remainingClassSlots => max(0, maxClasses - _classes.length);

  static String _generateUniqueClassCode() {
    final rand = Random();
    String code;
    do {
      code = (10000 + rand.nextInt(90000)).toString();
    } while (_globalUsedClassCodes.contains(code) ||
        _allKnownClasses.containsKey(code));
    _globalUsedClassCodes.add(code);
    return code;
  }

  static String _generateTeacherCode(String classCode) {
    final rand = Random();
    final randPart = (10000 + rand.nextInt(90000)).toString();
    return '$classCode$randPart';
  }

  static List<Quran8ClassModel> getClasses() => List.unmodifiable(_classes);

  static bool classCodeExists(String classCode) {
    final trimmed = classCode.trim();
    if (_classes.any((c) => c.classCode == trimmed)) return true;
    return _allKnownClasses.containsKey(trimmed);
  }

  static Quran8ClassModel? getClassByCode(String classCode) {
    final trimmed = classCode.trim();
    try {
      return _classes.firstWhere((c) => c.classCode == trimmed);
    } catch (_) {}
    return _allKnownClasses[trimmed];
  }

  static Quran8ClassModel? getClassByTeacherCode(String teacherCode) {
    final trimmed = teacherCode.trim();
    try {
      return _classes.firstWhere((c) => c.teacherCode == trimmed);
    } catch (_) {}
    for (final c in _allKnownClasses.values) {
      if (c.teacherCode == trimmed) return c;
    }
    return null;
  }

  static Future<String> generateUniqueRandomClassCode() async {
    final rand = Random();
    String candidate;
    do {
      candidate = (10000 + rand.nextInt(90000)).toString();
    } while (classCodeExists(candidate));
    return candidate;
  }

  static Quran8ManagerProfile? getActiveManagerProfile() {
    if (currentManagerPasscode == null) return null;
    return Quran8ManagerProfile(
      name: currentManagerName,
      passcode: currentManagerPasscode!,
      maxClasses: currentManagerMaxClasses,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  static Future<Map<String, dynamic>> createClass({
    required String classCode,
    String? title,
  }) async {
    await init();
    final trimmedCode = classCode.trim();
    if (trimmedCode.length != 5 || int.tryParse(trimmedCode) == null) {
      return {'success': false, 'message': 'کد کلاس باید دقیقاً ۵ رقم عددی باشد.'};
    }
    if (_classes.length >= maxClasses) {
      return {'success': false, 'message': 'سقف مجاز ایجاد کلاس تکمیل شده است.'};
    }
    if (classCodeExists(trimmedCode)) {
      return {'success': false, 'message': 'این کد کلاس قبلاً ایجاد شده است.'};
    }

    final rand = Random();
    final randomSuffix = (10000 + rand.nextInt(90000)).toString();
    final teacherCode = '$trimmedCode$randomSuffix';
    final classTitle = (title != null && title.trim().isNotEmpty)
        ? title.trim()
        : 'کلاس قرآن هشتم (${toPersianDigits(trimmedCode)})';

    final newClass = Quran8ClassModel(
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
    await _save();

    return {
      'success': true,
      'class': newClass,
      'message': 'کلاس با موفقیت ایجاد شد.',
    };
  }

  static Future<bool> deleteClass(String classCode) async {
    await init();
    final before = _classes.length;
    _classes.removeWhere((c) => c.classCode == classCode);
    _allKnownClasses.remove(classCode);
    _classToManagerMap.remove(classCode);
    _globalUsedClassCodes.remove(classCode);
    if (_classes.length != before) {
      await _save();
      return true;
    }
    return false;
  }

  static Future<bool> updateClassTitle(String classCode, String newTitle) async {
    await init();
    final trimmed = newTitle.trim();
    if (trimmed.isEmpty) return false;

    bool found = false;
    for (int i = 0; i < _classes.length; i++) {
      if (_classes[i].classCode == classCode) {
        _classes[i] = Quran8ClassModel(
          classCode: _classes[i].classCode,
          teacherCode: _classes[i].teacherCode,
          title: trimmed,
          createdAt: _classes[i].createdAt,
          students: _classes[i].students,
        );
        found = true;
        break;
      }
    }

    if (_allKnownClasses.containsKey(classCode)) {
      final old = _allKnownClasses[classCode]!;
      _allKnownClasses[classCode] = Quran8ClassModel(
        classCode: old.classCode,
        teacherCode: old.teacherCode,
        title: trimmed,
        createdAt: old.createdAt,
        students: old.students,
      );
      final mgrPass = _classToManagerMap[classCode];
      if (mgrPass != null && mgrPass != currentManagerPasscode) {
        final otherClasses = await getClassesForManager(mgrPass);
        for (int j = 0; j < otherClasses.length; j++) {
          if (otherClasses[j].classCode == classCode) {
            otherClasses[j] = Quran8ClassModel(
              classCode: otherClasses[j].classCode,
              teacherCode: otherClasses[j].teacherCode,
              title: trimmed,
              createdAt: otherClasses[j].createdAt,
              students: otherClasses[j].students,
            );
            await saveClassesForManager(mgrPass, otherClasses);
            break;
          }
        }
      }
      found = true;
    }

    if (found) {
      await _save();
      return true;
    }
    return false;
  }

  // ===================== بخش نشست‌ها، احراز هویت و دسترسی‌ها =====================

  static const String _keySavedManagerPasscode = 'quran8_saved_manager_passcode';
  static const String _keySavedTeacherCode = 'quran8_saved_teacher_code';
  static const String _keySavedStudentClassCode = 'quran8_saved_student_class_code';

  static String _scopedKey(String key) {
    final phone = AuthManager.phoneNumber.trim();
    if (phone.isNotEmpty) {
      return '${key}_$phone';
    }
    return key;
  }

  static Future<String?> getSavedManagerPasscode() async {
    final prefs = await SharedPreferences.getInstance();
    final p = prefs.getString(_scopedKey(_keySavedManagerPasscode));
    return (p != null && p.trim().isNotEmpty) ? p.trim() : null;
  }

  static Future<void> saveManagerPasscode(String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scopedKey(_keySavedManagerPasscode), passcode.trim());
  }

  static Future<void> logoutManager() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scopedKey(_keySavedManagerPasscode));
    await prefs.remove(_keySavedManagerPasscode);
    currentManagerPasscode = null;
    currentManagerName = 'مدیر لیگ قرآن هشتم';
    currentManagerMaxClasses = 3;
    _classes = [];
    _initialized = false;
  }

  static Future<String?> getSavedTeacherCode() async {
    final prefs = await SharedPreferences.getInstance();
    final c = prefs.getString(_scopedKey(_keySavedTeacherCode));
    return (c != null && c.trim().isNotEmpty) ? c.trim() : null;
  }

  static Future<void> saveTeacherCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scopedKey(_keySavedTeacherCode), code.trim());
  }

  static Future<void> logoutTeacher() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scopedKey(_keySavedTeacherCode));
    await prefs.remove(_keySavedTeacherCode);
  }

  static Future<Quran8ClassModel?> loginTeacher(String teacherCode) async {
    await init();
    final clean = teacherCode.trim();
    final qClass = getClassByTeacherCode(clean);
    if (qClass != null) {
      await saveTeacherCode(clean);
      return qClass;
    }
    return null;
  }

  static Future<String?> getSavedStudentClassCode() async {
    final prefs = await SharedPreferences.getInstance();
    final c = prefs.getString(_scopedKey(_keySavedStudentClassCode)) ??
        prefs.getString(_scopedKey(_lastClassKey));
    return (c != null && c.trim().isNotEmpty) ? c.trim() : null;
  }

  static Future<void> saveStudentClassCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scopedKey(_keySavedStudentClassCode), code.trim());
    await prefs.setString(_scopedKey(_lastClassKey), code.trim());
  }

  static Future<void> logoutStudent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scopedKey(_keySavedStudentClassCode));
    await prefs.remove(_scopedKey(_lastClassKey));
  }

  static Future<bool> removeStudentFromClass(String classCode, String studentId) async {
    return await removeStudent(classCode: classCode, studentId: studentId);
  }

  static Future<Quran8ClassModel?> getLastJoinedClass() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_lastClassKey);
    if (code != null && code.isNotEmpty) {
      return getClassByCode(code);
    }
    return null;
  }

  static Future<bool> joinClass({
    required String classCode,
    required Quran8StudentModel student,
  }) async {
    await init();
    final qClass = await getClassByCode(classCode);
    if (qClass == null) return false;

    final updatedStudents = List<Quran8StudentModel>.from(qClass.students);
    final cleanPhone = (student.phoneNumber != null &&
            student.phoneNumber!.trim().isNotEmpty)
        ? student.phoneNumber!.trim()
        : student.id.startsWith('09')
            ? student.id.trim()
            : '';

    final existingIdx = updatedStudents.indexWhere((s) {
      if (cleanPhone.isNotEmpty && s.phoneNumber != null && s.phoneNumber!.trim() == cleanPhone) {
        return true;
      }
      if (s.id == student.id) return true;
      if (student.isCurrentUser && s.isCurrentUser) return true;
      return false;
    });

    if (existingIdx != -1) {
      updatedStudents[existingIdx] = student.copyWith(
        joinedAt: updatedStudents[existingIdx].joinedAt,
      );
    } else {
      updatedStudents.add(student);
    }

    final updatedClass = Quran8ClassModel(
      classCode: qClass.classCode,
      teacherCode: qClass.teacherCode,
      title: qClass.title,
      createdAt: qClass.createdAt,
      students: updatedStudents,
    );

    _allKnownClasses[classCode] = updatedClass;
    for (int i = 0; i < _classes.length; i++) {
      if (_classes[i].classCode == classCode) {
        _classes[i] = updatedClass;
        break;
      }
    }

    final mgrPass = _classToManagerMap[classCode];
    if (mgrPass != null) {
      final mgrClasses = await getClassesForManager(mgrPass);
      final idx = mgrClasses.indexWhere((c) => c.classCode == classCode);
      if (idx != -1) {
        mgrClasses[idx] = updatedClass;
        await saveClassesForManager(mgrPass, mgrClasses);
      }
    }

    await _save();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastClassKey, classCode);
    return true;
  }

  static Future<bool> removeStudent({
    required String classCode,
    required String studentId,
  }) async {
    await init();
    final qClass = await getClassByCode(classCode);
    if (qClass == null) return false;

    final updatedStudents = List<Quran8StudentModel>.from(qClass.students)
      ..removeWhere((s) => s.id == studentId);

    final updatedClass = Quran8ClassModel(
      classCode: qClass.classCode,
      teacherCode: qClass.teacherCode,
      title: qClass.title,
      createdAt: qClass.createdAt,
      students: updatedStudents,
    );

    _allKnownClasses[classCode] = updatedClass;
    for (int i = 0; i < _classes.length; i++) {
      if (_classes[i].classCode == classCode) {
        _classes[i] = updatedClass;
        break;
      }
    }

    final mgrPass = _classToManagerMap[classCode];
    if (mgrPass != null) {
      final mgrClasses = await getClassesForManager(mgrPass);
      final idx = mgrClasses.indexWhere((c) => c.classCode == classCode);
      if (idx != -1) {
        mgrClasses[idx] = updatedClass;
        await saveClassesForManager(mgrPass, mgrClasses);
      }
    }

    await _save();
    return true;
  }

  // وضعیت تکمیل بازی‌های قرآن هشتم از AuthManager برای کاربر جاری
  static bool getAuthManagerQuran8PartCompleted(int lesson, int part) {
    switch (lesson) {
      case 1:
        return part == 1
            ? AuthManager.quran8Lesson1Part1Completed
            : part == 2
                ? AuthManager.quran8Lesson1Part2Completed
                : AuthManager.quran8Lesson1Part3Completed;
      case 2:
        return part == 1
            ? AuthManager.quran8Lesson2Part1Completed
            : part == 2
                ? AuthManager.quran8Lesson2Part2Completed
                : AuthManager.quran8Lesson2Part3Completed;
      case 3:
        return part == 1
            ? AuthManager.quran8Lesson3Part1Completed
            : part == 2
                ? AuthManager.quran8Lesson3Part2Completed
                : AuthManager.quran8Lesson3Part3Completed;
      case 4:
        return part == 1
            ? AuthManager.quran8Lesson4Part1Completed
            : part == 2
                ? AuthManager.quran8Lesson4Part2Completed
                : AuthManager.quran8Lesson4Part3Completed;
      case 5:
        return part == 1
            ? AuthManager.quran8Lesson5Part1Completed
            : part == 2
                ? AuthManager.quran8Lesson5Part2Completed
                : AuthManager.quran8Lesson5Part3Completed;
      case 6:
        return part == 1
            ? AuthManager.quran8Lesson6Part1Completed
            : part == 2
                ? AuthManager.quran8Lesson6Part2Completed
                : AuthManager.quran8Lesson6Part3Completed;
      case 7:
        return part == 1
            ? AuthManager.quran8Lesson7Part1Completed
            : part == 2
                ? AuthManager.quran8Lesson7Part2Completed
                : AuthManager.quran8Lesson7Part3Completed;
      case 8:
        return part == 1
            ? AuthManager.quran8Lesson8Part1Completed
            : part == 2
                ? AuthManager.quran8Lesson8Part2Completed
                : AuthManager.quran8Lesson8Part3Completed;
      case 9:
        return part == 1
            ? AuthManager.quran8Lesson9Part1Completed
            : part == 2
                ? AuthManager.quran8Lesson9Part2Completed
                : AuthManager.quran8Lesson9Part3Completed;
      case 10:
        return part == 1
            ? AuthManager.quran8Lesson10Part1Completed
            : part == 2
                ? AuthManager.quran8Lesson10Part2Completed
                : AuthManager.quran8Lesson10Part3Completed;
      case 11:
        return part == 1
            ? AuthManager.quran8Lesson11Part1Completed
            : part == 2
                ? AuthManager.quran8Lesson11Part2Completed
                : AuthManager.quran8Lesson11Part3Completed;
      case 12:
        return part == 1
            ? AuthManager.quran8Lesson12Part1Completed
            : part == 2
                ? AuthManager.quran8Lesson12Part2Completed
                : AuthManager.quran8Lesson12Part3Completed;
      default:
        return false;
    }
  }

  static Map<String, bool> getStudentCompletedParts(
      String studentId, SharedPreferences prefs) {
    final isCur =
        studentId == AuthManager.phoneNumber.trim() || studentId.isEmpty;
    final Map<String, bool> res = {};
    for (int l = 1; l <= 12; l++) {
      for (int p = 1; p <= 3; p++) {
        bool val = false;
        if (studentId.isNotEmpty) {
          val = prefs.getBool('quran8Lesson${l}Part${p}Completed_$studentId') ??
              false;
        }
        if (!val && isCur) {
          val = prefs.getBool('quran8Lesson${l}Part${p}Completed') ??
              getAuthManagerQuran8PartCompleted(l, p);
        }
        if (val) {
          res['L${l}_P$p'] = true;
        }
      }
    }
    return res;
  }

  static Map<String, List<String>> getStudentWrongWords(
      String studentId, SharedPreferences prefs) {
    final isCur =
        studentId == AuthManager.phoneNumber.trim() || studentId.isEmpty;
    final Map<String, List<String>> res = {};
    for (int l = 1; l <= 12; l++) {
      List<String> list = [];
      if (studentId.isNotEmpty) {
        list = prefs.getStringList('quran8_mistakes_L${l}_$studentId') ?? [];
      }
      if (list.isEmpty && isCur) {
        list = prefs.getStringList('quran8_mistakes_L$l') ?? [];
      }
      if (list.isNotEmpty) {
        res['$l'] = list;
      }
    }
    return res;
  }

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

    final keyGlobal = 'quran8_mistakes_L$lessonNum';
    final currentList = prefs.getStringList(keyGlobal) ?? [];
    if (!currentList.contains(mistakeEntry)) {
      currentList.add(mistakeEntry);
      await prefs.setStringList(keyGlobal, currentList);
    }

    if (phone.isNotEmpty) {
      final keyPhone = 'quran8_mistakes_L${lessonNum}_$phone';
      final phoneList = prefs.getStringList(keyPhone) ?? [];
      if (!phoneList.contains(mistakeEntry)) {
        phoneList.add(mistakeEntry);
        await prefs.setStringList(keyPhone, phoneList);
      }
    }

    await init();
    for (int i = 0; i < _classes.length; i++) {
      final students = List<Quran8StudentModel>.from(_classes[i].students);
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
          _classes[i] = Quran8ClassModel(
            classCode: _classes[i].classCode,
            teacherCode: _classes[i].teacherCode,
            title: _classes[i].title,
            createdAt: _classes[i].createdAt,
            students: students,
          );
          _allKnownClasses[_classes[i].classCode] = _classes[i];
        }
      }
    }
    await _save();
  }

  static Future<bool> promoteStudentRankInClass({
    required String classCode,
    required String studentId,
    required String studentName,
    int bonusCoins = 100,
  }) async {
    await init();
    final old = await getClassByCode(classCode);
    if (old == null) return false;

    final students = List<Quran8StudentModel>.from(old.students);
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

    final updatedClass = Quran8ClassModel(
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
    _allKnownClasses[classCode] = updatedClass;
    final mgrPass = _classToManagerMap[classCode];
    if (mgrPass != null) {
      final mgrClasses = await getClassesForManager(mgrPass);
      final idx = mgrClasses.indexWhere((c) => c.classCode == classCode);
      if (idx != -1) {
        mgrClasses[idx] = updatedClass;
        await saveClassesForManager(mgrPass, mgrClasses);
      }
    }
    await _save();
    return true;
  }

  static Future<Quran8ClassModel?> syncClassStudents(String classCode) async {
    await init();
    final qClass = await getClassByCode(classCode);
    if (qClass == null) return null;

    final prefs = await SharedPreferences.getInstance();
    final curPhone = AuthManager.phoneNumber.trim();
    final updatedStudents = <Quran8StudentModel>[];

    for (final s in qClass.students) {
      final isCur = s.isCurrentUser ||
          (curPhone.isNotEmpty && s.id == curPhone) ||
          (curPhone.isNotEmpty && s.phoneNumber == curPhone);

      int currentCoins = s.coins;
      int currentLevel = s.level;
      String? currentAvatar = s.avatar;
      String currentName = s.name;

      if (isCur) {
        currentCoins = AuthManager.coins;
        currentLevel = 1 + (AuthManager.coins ~/ 100);
        currentAvatar = AuthManager.userAvatar;
        if (AuthManager.userName.trim().isNotEmpty) {
          currentName = AuthManager.userName.trim();
        }
      } else {
        if (s.id.isNotEmpty) {
          final savedCoins = prefs.getInt('user_coins_${s.id}');
          if (savedCoins != null && savedCoins > currentCoins) {
            currentCoins = savedCoins;
            currentLevel = 1 + (currentCoins ~/ 100);
          }
        }
      }

      final completedParts = getStudentCompletedParts(s.id, prefs);
      final wrongWords = getStudentWrongWords(s.id, prefs);

      updatedStudents.add(
        s.copyWith(
          name: currentName,
          coins: currentCoins,
          level: currentLevel,
          avatar: currentAvatar,
          completedParts: completedParts,
          wrongWords: wrongWords,
        ),
      );
    }

    final updatedClass = Quran8ClassModel(
      classCode: qClass.classCode,
      teacherCode: qClass.teacherCode,
      title: qClass.title,
      createdAt: qClass.createdAt,
      students: updatedStudents,
    );

    _allKnownClasses[classCode] = updatedClass;
    for (int i = 0; i < _classes.length; i++) {
      if (_classes[i].classCode == classCode) {
        _classes[i] = updatedClass;
        break;
      }
    }

    final mgrPass = _classToManagerMap[classCode];
    if (mgrPass != null) {
      final mgrClasses = await getClassesForManager(mgrPass);
      final idx = mgrClasses.indexWhere((c) => c.classCode == classCode);
      if (idx != -1) {
        mgrClasses[idx] = updatedClass;
        await saveClassesForManager(mgrPass, mgrClasses);
      }
    }

    await _save();
    return updatedClass;
  }

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

  static Future<Quran8ClassModel?> enrollOrUpdateCurrentUser(String classCode) async {
    await init();
    final qClass = await getClassByCode(classCode);
    if (qClass == null) return null;

    final prefs = await SharedPreferences.getInstance();
    final String profileName = await getRealProfileName();
    final int userCoins = await getRealCoins();
    final int userLevel = max(1, (userCoins / 50).floor() + 1);
    final String userAvatar = await getRealAvatar();
    final String userPhone = AuthManager.phoneNumber.trim();
    final String userId = userPhone.isNotEmpty ? userPhone : 'user_${profileName.hashCode}';

    final students = List<Quran8StudentModel>.from(qClass.students);
    final userParts = getStudentCompletedParts(userId, prefs);
    final userWrongs = getStudentWrongWords(userId, prefs);

    final existingIndex = students.indexWhere((s) => s.id == userId);

    if (existingIndex != -1) {
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
      students.add(
        Quran8StudentModel(
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

    final updatedClass = Quran8ClassModel(
      classCode: qClass.classCode,
      teacherCode: qClass.teacherCode,
      title: qClass.title,
      createdAt: qClass.createdAt,
      students: students,
    );

    _allKnownClasses[classCode] = updatedClass;
    for (int i = 0; i < _classes.length; i++) {
      if (_classes[i].classCode == classCode) {
        _classes[i] = updatedClass;
        break;
      }
    }
    final mgrPass = _classToManagerMap[classCode];
    if (mgrPass != null) {
      final mgrClasses = await getClassesForManager(mgrPass);
      final idx = mgrClasses.indexWhere((c) => c.classCode == classCode);
      if (idx != -1) {
        mgrClasses[idx] = updatedClass;
        await saveClassesForManager(mgrPass, mgrClasses);
      }
    }

    await _save();
    await saveStudentClassCode(classCode);
    return updatedClass;
  }
}

