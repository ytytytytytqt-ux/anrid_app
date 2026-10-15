import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../managers/auth_manager.dart';
import 'league_models.dart';
import 'league_config.dart';

class UniversalLeagueManager {
  static const String _keyGlobalManagers = 'universal_league_managers_v1';
  static const String _keyGlobalTrash = 'universal_league_trash_managers_v1';
  static const String superAdminPasscode = '8327183141';

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
  static String currentManagerName = 'مدیر مدرسه';
  static int currentManagerMaxClasses = 5;

  static final Map<String, LeagueClassModel> _allKnownClasses = {};
  static final Map<String, String> _classToManagerMap = {};
  static final Set<String> _globalUsedClassCodes = {};
  static List<LeagueClassModel> _classes = [];
  static bool _initialized = false;
  static String _currentSubjectId = '';

  // ===================== مدیریت حساب مدیران مشترک سراسری =====================

  static Future<List<LeagueManagerProfile>> getAllManagers() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonStr = prefs.getString(_keyGlobalManagers);
    // اگر خالی بود از قرآن ۷ و ۸ لود کن تا سازگار باشد
    if (jsonStr == null || jsonStr.trim().isEmpty) {
      jsonStr = prefs.getString('quran7_local_managers_v2') ??
          prefs.getString('quran8_local_managers_v1');
    }
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list
          .map((e) => LeagueManagerProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveAllManagers(List<LeagueManagerProfile> managers) async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(managers.map((m) => m.toJson()).toList());
    await prefs.setString(_keyGlobalManagers, str);
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

    final newMgr = LeagueManagerProfile(
      name: trimmedName,
      passcode: trimmedPass,
      maxClasses: maxClasses > 0 ? maxClasses : 5,
      createdAt: DateTime.now().toIso8601String(),
    );
    managers.insert(0, newMgr);
    await _saveAllManagers(managers);

    return {'success': true, 'manager': newMgr};
  }

  static Future<Map<String, dynamic>> createManagerProfile({
    required String name,
    required String passcode,
    required int classQuota,
  }) =>
      addManager(name: name, passcode: passcode, maxClasses: classQuota);

  static Future<Map<String, dynamic>> deleteManagerToTrash(String passcode) async {
    final ok = await deleteManager(passcode);
    return {'success': ok};
  }

  static Future<bool> updateManagerQuota(String passcode, int newQuota) async {
    final managers = await getAllManagers();
    final idx = managers.indexWhere((m) => m.passcode == passcode);
    if (idx == -1) return false;

    managers[idx] = LeagueManagerProfile(
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

  static Future<List<LeagueTrashItem>> getTrashManagers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyGlobalTrash);
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list
          .map((e) => LeagueTrashItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveTrashManagers(List<LeagueTrashItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(items.map((i) => i.toJson()).toList());
    await prefs.setString(_keyGlobalTrash, str);
  }

  static Future<int> getTrashCount() async {
    final trash = await getTrashManagers();
    return trash.length;
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
      LeagueTrashItem(
        manager: targetManager,
        classes: managerClasses,
        deletedAt: DateTime.now().toIso8601String(),
      ),
    );
    await _saveTrashManagers(trash);

    managers.removeAt(idx);
    await _saveAllManagers(managers);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('universal_manager_classes_$passcode');

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

  static Future<bool> restoreManager(String passcode) async {
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

  static Future<bool> emptyTrash() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyGlobalTrash);
    return true;
  }

  static Future<int> getManagerClassesCount(String passcode) async {
    final list = await getClassesForManager(passcode);
    return list.length;
  }

  static Future<int> getTotalClassesCountForManager(String passcode) =>
      getManagerClassesCount(passcode);

  // ===================== ورود و ذخیره‌سازی مدیر =====================

  static Future<LeagueManagerProfile?> loginManager(String passcode) async {
    final trimmed = passcode.trim();
    if (trimmed == superAdminPasscode) {
      currentManagerPasscode = superAdminPasscode;
      currentManagerName = 'ابرمُدیر سیستم';
      currentManagerMaxClasses = 9999;
      return LeagueManagerProfile(
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
      await saveManagerPasscode(trimmed);
      await init(_currentSubjectId);
      return mgr;
    } catch (_) {
      return null;
    }
  }

  static Future<List<LeagueClassModel>> getClassesForManager(String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('universal_manager_classes_$passcode');
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list
          .map((e) => LeagueClassModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveClassesForManager(
      String passcode, List<LeagueClassModel> classes) async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(classes.map((c) => c.toJson()).toList());
    await prefs.setString('universal_manager_classes_$passcode', str);
  }

  // ===================== راه‌اندازی و کلاس‌های درس موردنظر =====================

  static String _scopedKey(String key, [String? subjectId]) {
    final phone = AuthManager.phoneNumber.trim();
    final sId = subjectId ?? _currentSubjectId;
    if (phone.isNotEmpty) {
      return '${sId}_${key}_$phone';
    }
    return '${sId}_$key';
  }

  static Future<void> init([String? subjectId, bool forceReload = false]) async {
    final sId = subjectId ?? _currentSubjectId;
    if (_initialized &&
        (sId.isEmpty || _currentSubjectId == sId) &&
        !forceReload) {
      return;
    }
    if (sId.isNotEmpty) {
      _currentSubjectId = sId;
    }
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

    final legacyKey = 'league_classes_$subjectId';
    final legacyStr = prefs.getString(legacyKey);
    if (legacyStr != null && legacyStr.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(legacyStr);
        for (final item in list) {
          final c = LeagueClassModel.fromJson(item as Map<String, dynamic>);
          _allKnownClasses[c.classCode] = c;
          _globalUsedClassCodes.add(c.classCode);
        }
      } catch (_) {}
    }

    if (currentManagerPasscode != null) {
      final allMyClasses = await getClassesForManager(currentManagerPasscode!);
      _classes = allMyClasses
          .where((c) => c.subjectId.isEmpty || c.subjectId == subjectId)
          .toList();
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
    final str =
        jsonEncode(_allKnownClasses.values.map((c) => c.toJson()).toList());
    await prefs.setString('league_classes_$_currentSubjectId', str);
  }

  static List<LeagueClassModel> getClasses() => List.unmodifiable(_classes);

  static bool classCodeExists(String classCode) {
    final trimmed = classCode.trim();
    if (_classes.any((c) => c.classCode == trimmed)) return true;
    return _allKnownClasses.containsKey(trimmed);
  }

  static LeagueClassModel? getClassByCode(String classCode) {
    final trimmed = classCode.trim();
    try {
      return _classes.firstWhere((c) => c.classCode == trimmed);
    } catch (_) {}
    return _allKnownClasses[trimmed];
  }

  static LeagueClassModel? getClassByTeacherCode(String teacherCode) {
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

  static LeagueManagerProfile? getActiveManagerProfile() {
    if (currentManagerPasscode == null) return null;
    return LeagueManagerProfile(
      name: currentManagerName,
      passcode: currentManagerPasscode!,
      maxClasses: currentManagerMaxClasses,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  static Future<Map<String, dynamic>> createClass({
    required String subjectId,
    required String subjectTitle,
    required String classCode,
    String? title,
  }) async {
    await init(subjectId);
    final trimmedCode = classCode.trim();
    if (trimmedCode.length != 5 || int.tryParse(trimmedCode) == null) {
      return {'success': false, 'message': 'کد کلاس باید دقیقاً ۵ رقم عددی باشد.'};
    }

    final totalClassesOfManager = currentManagerPasscode != null
        ? await getManagerClassesCount(currentManagerPasscode!)
        : _classes.length;

    if (totalClassesOfManager >= currentManagerMaxClasses) {
      return {
        'success': false,
        'message': 'سقف مجاز کل کلاس‌های شما ($currentManagerMaxClasses کلاس) تکمیل شده است.',
      };
    }

    if (classCodeExists(trimmedCode)) {
      return {'success': false, 'message': 'این کد کلاس قبلاً ایجاد شده است.'};
    }

    final rand = Random();
    final randomSuffix = (10000 + rand.nextInt(90000)).toString();
    final teacherCode = '$trimmedCode$randomSuffix';
    final classTitle = (title != null && title.trim().isNotEmpty)
        ? title.trim()
        : 'کلاس $subjectTitle (${toPersianDigits(trimmedCode)})';

    final newClass = LeagueClassModel(
      classCode: trimmedCode,
      teacherCode: teacherCode,
      title: classTitle,
      createdAt: DateTime.now().toIso8601String(),
      students: [],
      subjectId: subjectId,
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
    await init(_currentSubjectId);
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
    await init(_currentSubjectId);
    final trimmed = newTitle.trim();
    if (trimmed.isEmpty) return false;

    bool found = false;
    for (int i = 0; i < _classes.length; i++) {
      if (_classes[i].classCode == classCode) {
        _classes[i].title = trimmed;
        found = true;
        break;
      }
    }
    final old = _allKnownClasses[classCode];
    if (old != null) {
      old.title = trimmed;
      found = true;
    }

    if (found) {
      await _save();
      return true;
    }
    return false;
  }

  // ===================== مدیریت نشست‌ها =====================

  static Future<String?> getSavedManagerPasscode() async {
    final prefs = await SharedPreferences.getInstance();
    final p = prefs.getString(_scopedKey('saved_manager_passcode'));
    return (p != null && p.trim().isNotEmpty) ? p.trim() : null;
  }

  static Future<void> saveManagerPasscode(String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scopedKey('saved_manager_passcode'), passcode.trim());
  }

  static Future<void> logoutManager() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scopedKey('saved_manager_passcode'));
    currentManagerPasscode = null;
    currentManagerName = 'مدیر مدرسه';
    currentManagerMaxClasses = 5;
    _classes = [];
    _initialized = false;
  }

  static Future<String?> getSavedTeacherCode(String subjectId) async {
    final prefs = await SharedPreferences.getInstance();
    final c = prefs.getString(_scopedKey('saved_teacher_code', subjectId));
    return (c != null && c.trim().isNotEmpty) ? c.trim() : null;
  }

  static Future<void> saveTeacherCode(String subjectId, String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scopedKey('saved_teacher_code', subjectId), code.trim());
  }

  static Future<void> logoutTeacher(String subjectId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scopedKey('saved_teacher_code', subjectId));
  }

  static Future<LeagueClassModel?> loginTeacher(
      String subjectId, String teacherCode) async {
    await init(subjectId);
    final clean = teacherCode.trim();
    final qClass = getClassByTeacherCode(clean);
    if (qClass != null) {
      await saveTeacherCode(subjectId, clean);
      return qClass;
    }
    return null;
  }

  static Future<String?> getSavedStudentClassCode(String subjectId) async {
    final prefs = await SharedPreferences.getInstance();
    final c = prefs.getString(_scopedKey('saved_student_class_code', subjectId));
    return (c != null && c.trim().isNotEmpty) ? c.trim() : null;
  }

  static Future<void> saveStudentClassCode(String subjectId, String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scopedKey('saved_student_class_code', subjectId), code.trim());
  }

  static Future<void> logoutStudent(String subjectId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scopedKey('saved_student_class_code', subjectId));
  }

  static Future<bool> removeStudentFromClass(
      String classCode, String studentId) async {
    await init(_currentSubjectId);
    final qClass = getClassByCode(classCode);
    if (qClass == null) return false;

    final updatedStudents = List<LeagueStudentModel>.from(qClass.students)
      ..removeWhere((s) => s.id == studentId);

    final updatedClass = LeagueClassModel(
      classCode: qClass.classCode,
      teacherCode: qClass.teacherCode,
      title: qClass.title,
      createdAt: qClass.createdAt,
      students: updatedStudents,
      subjectId: qClass.subjectId,
    );

    _allKnownClasses[classCode] = updatedClass;
    for (int i = 0; i < _classes.length; i++) {
      if (_classes[i].classCode == classCode) {
        _classes[i] = updatedClass;
        break;
      }
    }
    await _save();
    return true;
  }

  // ===================== محاسبه و همگام‌سازی پیشرفت و کارنامه =====================

  static Map<String, bool> getStudentCompletedParts(
    LeagueSubjectConfig config,
    String studentId,
    SharedPreferences prefs,
  ) {
    final isCur =
        studentId == AuthManager.phoneNumber.trim() || studentId.isEmpty;
    final Map<String, bool> res = {};

    for (final lesson in config.lessons) {
      final lNum = lesson.lessonNumber;
      for (final part in lesson.parts) {
        final pNum = part.partNumber;
        bool val = false;
        if (studentId.isNotEmpty) {
          val = prefs.getBool('${config.subjectId}Lesson${lNum}Part${pNum}Completed_$studentId') ??
              false;
        }
        if (!val && isCur) {
          val = prefs.getBool('${config.subjectId}Lesson${lNum}Part${pNum}Completed') ??
              part.isCompletedInAuthManager();
        }
        if (val) {
          res['L${lNum}_P$pNum'] = true;
        }
      }
    }
    return res;
  }

  static Map<String, List<String>> getStudentWrongWords(
    String subjectId,
    String studentId,
    SharedPreferences prefs,
  ) {
    final isCur =
        studentId == AuthManager.phoneNumber.trim() || studentId.isEmpty;
    final Map<String, List<String>> res = {};
    for (int l = 1; l <= 30; l++) {
      List<String> list = [];
      if (studentId.isNotEmpty) {
        list = prefs.getStringList('${subjectId}_mistakes_L${l}_$studentId') ?? [];
      }
      if (list.isEmpty && isCur) {
        list = prefs.getStringList('${subjectId}_mistakes_L$l') ?? [];
      }
      if (list.isNotEmpty) {
        res['$l'] = list;
      }
    }
    return res;
  }

  static Future<void> recordMistake({
    required String subjectId,
    required String lessonKey,
    required String word,
    required String meaning,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final phone = AuthManager.phoneNumber.trim();

    int lessonNum = 1;
    final match = RegExp(r'lesson(\d+)').firstMatch(lessonKey);
    if (match != null) {
      lessonNum = int.tryParse(match.group(1)!) ?? 1;
    }

    final mistakeEntry = meaning.isNotEmpty ? '$word ($meaning)' : word;

    final keyGlobal = '${subjectId}_mistakes_L$lessonNum';
    final currentList = prefs.getStringList(keyGlobal) ?? [];
    if (!currentList.contains(mistakeEntry)) {
      currentList.add(mistakeEntry);
      await prefs.setStringList(keyGlobal, currentList);
    }

    if (phone.isNotEmpty) {
      final keyPhone = '${subjectId}_mistakes_L${lessonNum}_$phone';
      final phoneList = prefs.getStringList(keyPhone) ?? [];
      if (!phoneList.contains(mistakeEntry)) {
        phoneList.add(mistakeEntry);
        await prefs.setStringList(keyPhone, phoneList);
      }
    }
  }

  static Future<LeagueClassModel?> enrollOrUpdateCurrentUser({
    required LeagueSubjectConfig config,
    required String classCode,
  }) async {
    await init(config.subjectId);
    final qClass = getClassByCode(classCode);
    if (qClass == null) return null;

    final prefs = await SharedPreferences.getInstance();
    final phone = AuthManager.phoneNumber.trim();
    final profileName = AuthManager.userName.trim().isNotEmpty
        ? AuthManager.userName.trim()
        : 'دانش‌آموز';
    final userCoins = AuthManager.coins;
    final userLevel = max(1, (userCoins / 50).floor() + 1);
    final userAvatar = AuthManager.userAvatar.trim().isNotEmpty
        ? AuthManager.userAvatar.trim()
        : null;
    final userId = phone.isNotEmpty ? phone : 'user_${profileName.hashCode}';

    final students = List<LeagueStudentModel>.from(qClass.students);
    final userParts = getStudentCompletedParts(config, userId, prefs);
    final userWrongs = getStudentWrongWords(config.subjectId, userId, prefs);

    final existingIndex = students.indexWhere((s) => s.id == userId);
    if (existingIndex != -1) {
      students[existingIndex] = students[existingIndex].copyWith(
        name: profileName,
        coins: userCoins,
        level: userLevel,
        avatar: userAvatar,
        phoneNumber: phone.isNotEmpty ? phone : students[existingIndex].phoneNumber,
        completedParts: userParts.isNotEmpty ? userParts : students[existingIndex].completedParts,
        wrongWords: userWrongs.isNotEmpty ? userWrongs : students[existingIndex].wrongWords,
      );
    } else {
      students.add(
        LeagueStudentModel(
          id: userId,
          name: profileName,
          coins: userCoins,
          level: userLevel,
          avatar: userAvatar,
          phoneNumber: phone.isNotEmpty ? phone : null,
          joinedAt: DateTime.now().millisecondsSinceEpoch,
          completedParts: userParts,
          wrongWords: userWrongs,
        ),
      );
    }

    final updatedClass = LeagueClassModel(
      classCode: qClass.classCode,
      teacherCode: qClass.teacherCode,
      title: qClass.title,
      createdAt: qClass.createdAt,
      students: students,
      subjectId: config.subjectId,
    );

    _allKnownClasses[classCode] = updatedClass;
    for (int i = 0; i < _classes.length; i++) {
      if (_classes[i].classCode == classCode) {
        _classes[i] = updatedClass;
        break;
      }
    }
    await _save();
    await saveStudentClassCode(config.subjectId, classCode);
    return updatedClass;
  }

  static Future<LeagueClassModel?> syncClassStudents({
    required LeagueSubjectConfig config,
    required String classCode,
  }) async {
    await init(config.subjectId);
    final qClass = getClassByCode(classCode);
    if (qClass == null) return null;

    final prefs = await SharedPreferences.getInstance();
    final currentPhone = AuthManager.phoneNumber.trim();
    final students = List<LeagueStudentModel>.from(qClass.students);

    for (int i = 0; i < students.length; i++) {
      final s = students[i];
      int coins = s.coins;
      String name = s.name;
      String? avatar = s.avatar;

      if (s.id == currentPhone || (currentPhone.isEmpty && s.isCurrentUser)) {
        coins = AuthManager.coins;
        name = AuthManager.userName.trim().isNotEmpty
            ? AuthManager.userName.trim()
            : s.name;
        avatar = AuthManager.userAvatar.trim().isNotEmpty
            ? AuthManager.userAvatar.trim()
            : s.avatar;
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

      final studentParts = getStudentCompletedParts(config, s.id, prefs);
      final studentWrongs = getStudentWrongWords(config.subjectId, s.id, prefs);

      students[i] = s.copyWith(
        coins: coins,
        name: name,
        avatar: avatar,
        level: max(1, (coins / 50).floor() + 1),
        completedParts: studentParts,
        wrongWords: studentWrongs,
      );
    }

    final updatedClass = LeagueClassModel(
      classCode: qClass.classCode,
      teacherCode: qClass.teacherCode,
      title: qClass.title,
      createdAt: qClass.createdAt,
      students: students,
      subjectId: config.subjectId,
    );

    _allKnownClasses[classCode] = updatedClass;
    for (int i = 0; i < _classes.length; i++) {
      if (_classes[i].classCode == classCode) {
        _classes[i] = updatedClass;
        break;
      }
    }
    await _save();
    return updatedClass;
  }

  static Future<bool> promoteStudentRankInClass({
    required String subjectId,
    required String classCode,
    required String studentId,
    required String studentName,
    int bonusCoins = 100,
  }) async {
    await init(subjectId);
    final old = getClassByCode(classCode);
    if (old == null) return false;

    final students = List<LeagueStudentModel>.from(old.students);
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

    final updatedClass = LeagueClassModel(
      classCode: old.classCode,
      teacherCode: old.teacherCode,
      title: old.title,
      createdAt: old.createdAt,
      students: students,
      subjectId: old.subjectId,
    );

    _allKnownClasses[classCode] = updatedClass;
    for (int i = 0; i < _classes.length; i++) {
      if (_classes[i].classCode == classCode) {
        _classes[i] = updatedClass;
        break;
      }
    }
    await _save();
    return true;
  }
}
