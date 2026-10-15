import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../managers/auth_manager.dart';
import 'quran7_data.dart';
import 'quran7_league_manager.dart';
import '../screens/home_screen.dart';

/// وضعیت رقابت
enum BattleStatus {
  pending, // چلنجر رفته، منتظر بازی حریف است
  completed, // هر دو بازی کردند، برنده مشخص است
}

/// برنده رقابت
enum BattleWinnerType {
  challenger,
  opponent,
  tie,
  undecided,
}

/// مدل داده رقابت دو نفره لیگ قرآن هفتم
class Quran7BattleModel {
  final String id;
  final String classCode;

  // اطلاعات درخواست‌دهنده (Challenger)
  final String challengerId;
  final String challengerName;
  final String? challengerAvatar;
  final int challengerCoins;
  final int challengerTimeSeconds;
  final bool challengerFinished;

  // اطلاعات حریف (Opponent)
  final String opponentId;
  final String opponentName;
  final String? opponentAvatar;
  final int opponentCoins;
  final int opponentTimeSeconds;
  final bool opponentFinished;

  // اطلاعات درس و بخش
  final int lessonIndex; // 0 تا 11 (درس 1 تا 12)
  final int partIndex; // 1, 2, یا 3
  final String lessonTitle; // مثلاً 'قرآن هفتم - درس دوم'
  final String partTitle; // مثلاً 'قسمت دوم: بازی دیوار آتشین'

  // وضعیت و جوایز
  final int createdAt;
  final String status; // 'pending' | 'completed'
  final bool winnerClaimed; // آیا برنده جایزه ۱۰۰ سکه و ارتقای رتبه را دریافت کرده
  final bool challengerClaimed; // آیا چلنجر جایزه خود را دریافت کرده
  final bool opponentClaimed; // آیا حریف جایزه خود را دریافت کرده
  final bool challengerDismissed; // آیا چلنجر صفحه رقابت را برای خودش حذف کرده
  final bool opponentDismissed; // آیا حریف صفحه رقابت را برای خودش حذف کرده
  final bool loserAcknowledged; // آیا بازنده دکمه اعلام شکست را زده

  Quran7BattleModel({
    required this.id,
    required this.classCode,
    required this.challengerId,
    required this.challengerName,
    this.challengerAvatar,
    this.challengerCoins = 0,
    this.challengerTimeSeconds = 60,
    this.challengerFinished = false,
    required this.opponentId,
    required this.opponentName,
    this.opponentAvatar,
    this.opponentCoins = 0,
    this.opponentTimeSeconds = 60,
    this.opponentFinished = false,
    required this.lessonIndex,
    required this.partIndex,
    required this.lessonTitle,
    required this.partTitle,
    required this.createdAt,
    this.status = 'pending',
    this.winnerClaimed = false,
    this.challengerClaimed = false,
    this.opponentClaimed = false,
    this.challengerDismissed = false,
    this.opponentDismissed = false,
    this.loserAcknowledged = false,
  });

  /// تشخیص برنده بر اساس قوانین:
  /// ۱) سکه بیشتر
  /// ۲) اگر مساوی بود، زمان کمتر
  /// ۳) اگر هر دو مساوی بود، مساوی (هر دو برنده)
  BattleWinnerType get winnerType {
    if (!challengerFinished || !opponentFinished) {
      return BattleWinnerType.undecided;
    }
    if (challengerCoins > opponentCoins) {
      return BattleWinnerType.challenger;
    }
    if (opponentCoins > challengerCoins) {
      return BattleWinnerType.opponent;
    }
    if (challengerTimeSeconds < opponentTimeSeconds) {
      return BattleWinnerType.challenger;
    }
    if (opponentTimeSeconds < challengerTimeSeconds) {
      return BattleWinnerType.opponent;
    }
    return BattleWinnerType.tie;
  }

  bool isWinner(String studentId, String studentName) {
    final type = winnerType;
    if (type == BattleWinnerType.tie) return true;
    if (type == BattleWinnerType.challenger) {
      return challengerId == studentId || challengerName == studentName;
    }
    if (type == BattleWinnerType.opponent) {
      return opponentId == studentId || opponentName == studentName;
    }
    return false;
  }

  /// بررسی اینکه آیا یک بازیکن خاص جایزه خود را دریافت کرده یا نه (به‌ویژه در حالت مساوی)
  bool isWinnerClaimedBy(String studentId, String studentName) {
    if (challengerId == studentId || challengerName == studentName) {
      return challengerClaimed;
    }
    if (opponentId == studentId || opponentName == studentName) {
      return opponentClaimed;
    }
    return winnerClaimed;
  }

  /// بررسی اینکه آیا صفحه رقابت برای این بازیکن حذف شده است یا نه
  bool isDismissedBy(String studentId, String studentName, [String? phoneNumber]) {
    final cleanId = studentId.trim();
    final cleanName = studentName.trim();
    final cleanPhone = phoneNumber?.trim() ?? '';

    if ((cleanId.isNotEmpty && challengerId.trim() == cleanId) ||
        (cleanPhone.isNotEmpty && challengerId.trim() == cleanPhone) ||
        (cleanName.isNotEmpty && challengerName.trim() == cleanName)) {
      return challengerDismissed;
    }
    if ((cleanId.isNotEmpty && opponentId.trim() == cleanId) ||
        (cleanPhone.isNotEmpty && opponentId.trim() == cleanPhone) ||
        (cleanName.isNotEmpty && opponentName.trim() == cleanName)) {
      return opponentDismissed;
    }
    return false;
  }

  bool isLoser(String studentId, String studentName) {
    final type = winnerType;
    if (type == BattleWinnerType.undecided || type == BattleWinnerType.tie) {
      return false;
    }
    return !isWinner(studentId, studentName);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'classCode': classCode,
        'challengerId': challengerId,
        'challengerName': challengerName,
        'challengerAvatar': challengerAvatar,
        'challengerCoins': challengerCoins,
        'challengerTimeSeconds': challengerTimeSeconds,
        'challengerFinished': challengerFinished,
        'opponentId': opponentId,
        'opponentName': opponentName,
        'opponentAvatar': opponentAvatar,
        'opponentCoins': opponentCoins,
        'opponentTimeSeconds': opponentTimeSeconds,
        'opponentFinished': opponentFinished,
        'lessonIndex': lessonIndex,
        'partIndex': partIndex,
        'lessonTitle': lessonTitle,
        'partTitle': partTitle,
        'createdAt': createdAt,
        'status': status,
        'winnerClaimed': winnerClaimed || (challengerClaimed && opponentClaimed),
        'challengerClaimed': challengerClaimed,
        'opponentClaimed': opponentClaimed,
        'challengerDismissed': challengerDismissed,
        'opponentDismissed': opponentDismissed,
        'loserAcknowledged': loserAcknowledged,
      };

  factory Quran7BattleModel.fromJson(Map<String, dynamic> json) {
    final legacyClaimed = json['winnerClaimed'] as bool? ?? false;
    return Quran7BattleModel(
      id: json['id'] as String? ?? 'b_${DateTime.now().millisecondsSinceEpoch}',
      classCode: json['classCode'] as String? ?? '',
      challengerId: json['challengerId'] as String? ?? '',
      challengerName: json['challengerName'] as String? ?? '',
      challengerAvatar: json['challengerAvatar'] as String?,
      challengerCoins: (json['challengerCoins'] as num?)?.toInt() ?? 0,
      challengerTimeSeconds:
          (json['challengerTimeSeconds'] as num?)?.toInt() ?? 60,
      challengerFinished: json['challengerFinished'] as bool? ?? false,
      opponentId: json['opponentId'] as String? ?? '',
      opponentName: json['opponentName'] as String? ?? '',
      opponentAvatar: json['opponentAvatar'] as String?,
      opponentCoins: (json['opponentCoins'] as num?)?.toInt() ?? 0,
      opponentTimeSeconds:
          (json['opponentTimeSeconds'] as num?)?.toInt() ?? 60,
      opponentFinished: json['opponentFinished'] as bool? ?? false,
      lessonIndex: (json['lessonIndex'] as num?)?.toInt() ?? 0,
      partIndex: (json['partIndex'] as num?)?.toInt() ?? 1,
      lessonTitle: json['lessonTitle'] as String? ?? 'قرآن هفتم',
      partTitle: json['partTitle'] as String? ?? 'بخش بازی',
      createdAt: (json['createdAt'] as num?)?.toInt() ??
          DateTime.now().millisecondsSinceEpoch,
      status: json['status'] as String? ?? 'pending',
      winnerClaimed: legacyClaimed,
      challengerClaimed: json['challengerClaimed'] as bool? ?? legacyClaimed,
      opponentClaimed: json['opponentClaimed'] as bool? ?? legacyClaimed,
      challengerDismissed: json['challengerDismissed'] as bool? ?? false,
      opponentDismissed: json['opponentDismissed'] as bool? ?? false,
      loserAcknowledged: json['loserAcknowledged'] as bool? ?? false,
    );
  }

  Quran7BattleModel copyWith({
    String? id,
    String? classCode,
    String? challengerId,
    String? challengerName,
    String? challengerAvatar,
    int? challengerCoins,
    int? challengerTimeSeconds,
    bool? challengerFinished,
    String? opponentId,
    String? opponentName,
    String? opponentAvatar,
    int? opponentCoins,
    int? opponentTimeSeconds,
    bool? opponentFinished,
    int? lessonIndex,
    int? partIndex,
    String? lessonTitle,
    String? partTitle,
    int? createdAt,
    String? status,
    bool? winnerClaimed,
    bool? challengerClaimed,
    bool? opponentClaimed,
    bool? challengerDismissed,
    bool? opponentDismissed,
    bool? loserAcknowledged,
  }) {
    return Quran7BattleModel(
      id: id ?? this.id,
      classCode: classCode ?? this.classCode,
      challengerId: challengerId ?? this.challengerId,
      challengerName: challengerName ?? this.challengerName,
      challengerAvatar: challengerAvatar ?? this.challengerAvatar,
      challengerCoins: challengerCoins ?? this.challengerCoins,
      challengerTimeSeconds: challengerTimeSeconds ?? this.challengerTimeSeconds,
      challengerFinished: challengerFinished ?? this.challengerFinished,
      opponentId: opponentId ?? this.opponentId,
      opponentName: opponentName ?? this.opponentName,
      opponentAvatar: opponentAvatar ?? this.opponentAvatar,
      opponentCoins: opponentCoins ?? this.opponentCoins,
      opponentTimeSeconds: opponentTimeSeconds ?? this.opponentTimeSeconds,
      opponentFinished: opponentFinished ?? this.opponentFinished,
      lessonIndex: lessonIndex ?? this.lessonIndex,
      partIndex: partIndex ?? this.partIndex,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      partTitle: partTitle ?? this.partTitle,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      winnerClaimed: winnerClaimed ?? this.winnerClaimed,
      challengerClaimed: challengerClaimed ?? this.challengerClaimed,
      opponentClaimed: opponentClaimed ?? this.opponentClaimed,
      challengerDismissed: challengerDismissed ?? this.challengerDismissed,
      opponentDismissed: opponentDismissed ?? this.opponentDismissed,
      loserAcknowledged: loserAcknowledged ?? this.loserAcknowledged,
    );
  }
}

/// مدیریت و ذخیره‌سازی رقابت‌ها
class Quran7BattleManager {
  static const String _storageKey = 'quran7_battles_list_v1';

  /// خواندن همه رقابت‌ها
  static Future<List<Quran7BattleModel>> getAllBattles() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) => Quran7BattleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// ذخیره لیست رقابت‌ها
  static Future<void> saveBattles(List<Quran7BattleModel> battles) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(battles.map((b) => b.toJson()).toList());
    await prefs.setString(_storageKey, jsonStr);
  }

  /// یافتن رقابت بر اساس شناسه
  static Future<Quran7BattleModel?> getBattleById(String battleId) async {
    final all = await getAllBattles();
    final idx = all.indexWhere((b) => b.id == battleId);
    if (idx != -1) return all[idx];
    return null;
  }

  /// لیست رقابت‌های مربوط به یک کلاس و دانش‌آموز جاری
  static Future<List<Quran7BattleModel>> getBattlesForStudent({
    required String classCode,
    required String studentId,
    required String studentName,
    String? phoneNumber,
  }) async {
    final all = await getAllBattles();
    final cleanId = studentId.trim();
    final cleanName = studentName.trim();
    final cleanPhone = phoneNumber?.trim() ?? '';

    return all.where((b) {
      if (b.classCode.isNotEmpty && b.classCode != classCode) return false;

      bool matchesChallenger = false;
      if (cleanId.isNotEmpty && b.challengerId.trim().isNotEmpty) {
        matchesChallenger = b.challengerId.trim() == cleanId;
      }
      if (!matchesChallenger && cleanPhone.isNotEmpty) {
        matchesChallenger = b.challengerId.trim() == cleanPhone;
      }
      if (!matchesChallenger && cleanId.isEmpty && cleanName.isNotEmpty) {
        matchesChallenger = b.challengerName.trim() == cleanName;
      }

      bool matchesOpponent = false;
      if (cleanId.isNotEmpty && b.opponentId.trim().isNotEmpty) {
        matchesOpponent = b.opponentId.trim() == cleanId;
      }
      if (!matchesOpponent && cleanPhone.isNotEmpty) {
        matchesOpponent = b.opponentId.trim() == cleanPhone;
      }
      if (!matchesOpponent && cleanId.isEmpty && cleanName.isNotEmpty) {
        matchesOpponent = b.opponentName.trim() == cleanName;
      }

      // اگر کاربر این رقابت را فقط برای خودش حذف کرده باشد، به او نشان داده نمی‌شود
      if (matchesChallenger && b.challengerDismissed) return false;
      if (matchesOpponent && b.opponentDismissed) return false;

      return matchesChallenger || matchesOpponent;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// پیدا کردن چالش معلق بین دو دانش‌آموز (اگر وجود داشته باشد)
  static Future<Quran7BattleModel?> getPendingBattleBetween({
    required String classCode,
    required String user1Id,
    required String user2Id,
  }) async {
    final all = await getAllBattles();
    for (final b in all) {
      if (b.classCode == classCode && b.status == 'pending') {
        final matches = (b.challengerId == user1Id && b.opponentId == user2Id) ||
            (b.challengerId == user2Id && b.opponentId == user1Id);
        if (matches) return b;
      }
    }
    return null;
  }

  /// ایجاد رقابت جدید توسط چلنجر
  static Future<Quran7BattleModel> createBattle({
    required String classCode,
    required QuranStudentModel challenger,
    required QuranStudentModel opponent,
    required int lessonIndex,
    required int partIndex,
    required String lessonTitle,
    required String partTitle,
    required int challengerCoins,
    required int challengerTimeSeconds,
  }) async {
    final battles = await getAllBattles();
    final newBattle = Quran7BattleModel(
      id: 'bt_${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(9999)}',
      classCode: classCode,
      challengerId: challenger.id,
      challengerName: challenger.name,
      challengerAvatar: challenger.avatar,
      challengerCoins: challengerCoins,
      challengerTimeSeconds: challengerTimeSeconds,
      challengerFinished: true,
      opponentId: opponent.id,
      opponentName: opponent.name,
      opponentAvatar: opponent.avatar,
      opponentCoins: 0,
      opponentTimeSeconds: 60,
      opponentFinished: false,
      lessonIndex: lessonIndex,
      partIndex: partIndex,
      lessonTitle: lessonTitle,
      partTitle: partTitle,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: 'pending',
    );

    battles.insert(0, newBattle);
    await saveBattles(battles);
    return newBattle;
  }

  /// ثبت نتیجه حریف (Opponent) در رقابت
  static Future<Quran7BattleModel?> submitOpponentResult({
    required String battleId,
    required int opponentCoins,
    required int opponentTimeSeconds,
  }) async {
    final battles = await getAllBattles();
    final idx = battles.indexWhere((b) => b.id == battleId);
    if (idx == -1) return null;

    final updated = battles[idx].copyWith(
      opponentCoins: opponentCoins,
      opponentTimeSeconds: opponentTimeSeconds,
      opponentFinished: true,
      status: 'completed',
    );

    battles[idx] = updated;
    await saveBattles(battles);
    return updated;
  }

  /// حذف یک رقابت و بازگشت کامل به حالت عادی (برای هر دو طرف)
  static Future<bool> deleteBattle(String battleId) async {
    final battles = await getAllBattles();
    final beforeCount = battles.length;
    battles.removeWhere((b) => b.id == battleId);
    if (battles.length != beforeCount) {
      await saveBattles(battles);
      return true;
    }
    return false;
  }

  /// حذف صفحه رقابت و بازگشت به حالت عادی فقط برای شخص درخواست‌دهنده
  static Future<bool> dismissBattleForUser({
    required String battleId,
    required String studentId,
    required String studentName,
    String? phoneNumber,
  }) async {
    final battles = await getAllBattles();
    final idx = battles.indexWhere((b) => b.id == battleId);
    if (idx == -1) return false;

    final battle = battles[idx];
    final cleanId = studentId.trim();
    final cleanName = studentName.trim();
    final cleanPhone = phoneNumber?.trim() ?? '';

    bool isChallenger = false;
    if (cleanId.isNotEmpty && battle.challengerId.trim().isNotEmpty) {
      isChallenger = battle.challengerId.trim() == cleanId;
    }
    if (!isChallenger && cleanPhone.isNotEmpty) {
      isChallenger = battle.challengerId.trim() == cleanPhone;
    }
    if (!isChallenger && cleanName.isNotEmpty) {
      isChallenger = battle.challengerName.trim() == cleanName;
    }

    final newChallengerDismissed =
        isChallenger ? true : battle.challengerDismissed;
    final newOpponentDismissed =
        !isChallenger ? true : battle.opponentDismissed;

    // اگر هر دو نفر صفحه رقابت را برای خودشان حذف کردند، رقابت به کلی پاک می‌شود
    if (newChallengerDismissed && newOpponentDismissed) {
      battles.removeAt(idx);
    } else {
      battles[idx] = battle.copyWith(
        challengerDismissed: newChallengerDismissed,
        opponentDismissed: newOpponentDismissed,
      );
    }

    await saveBattles(battles);
    return true;
  }

  /// دریافت جایزه ۱۰۰ سکه و ارتقای ۱ رتبه برای برنده (مستقل برای هر برنده در صورت مساوی)
  static Future<bool> claimWinnerReward({
    required String battleId,
    required String studentId,
    required String studentName,
  }) async {
    final battles = await getAllBattles();
    final idx = battles.indexWhere((b) => b.id == battleId);
    if (idx == -1) return false;

    final battle = battles[idx];
    // بررسی دریافت جایزه برای همین بازیکن خاص (تا در حالت مساوی مانع طرف مقابل نشود)
    if (battle.isWinnerClaimedBy(studentId, studentName)) return false;
    if (!battle.isWinner(studentId, studentName)) return false;

    // ۱) اعطای در لحظه و فوری ۱۰۰ سکه به کاربر جاری و ذخیره مستقیم در SharedPreferences
    AuthManager.coins += 100;
    final phone = AuthManager.phoneNumber.trim();
    final prefs = await SharedPreferences.getInstance();
    if (phone.isNotEmpty) {
      await prefs.setInt('coins_$phone', AuthManager.coins);
    }
    await prefs.setInt('coins', AuthManager.coins);

    // همگام‌سازی کامل با پنل در پس‌زمینه بدون ایجاد معطلی
    AuthManager.save();

    // ۲) بالا بردن ۱ رتبه در لیست لیگ کلاس
    await promoteStudentRank(
      classCode: battle.classCode,
      studentId: studentId,
      studentName: studentName,
      bonusCoins: 100,
    );

    // ۳) بروزرسانی وضعیت چالش: هر طرف پرچم دریافت جایزه مستقل خود را پر می‌کند
    final bool isChallenger =
        battle.challengerId == studentId || battle.challengerName == studentName;
    battles[idx] = battle.copyWith(
      challengerClaimed: isChallenger ? true : battle.challengerClaimed,
      opponentClaimed: !isChallenger ? true : battle.opponentClaimed,
      winnerClaimed: true,
    );
    await saveBattles(battles);
    return true;
  }

  /// ثبت اعلام شکست توسط بازنده
  static Future<bool> acknowledgeLoserDefeat({
    required String battleId,
    required String studentId,
    required String studentName,
  }) async {
    final battles = await getAllBattles();
    final idx = battles.indexWhere((b) => b.id == battleId);
    if (idx == -1) return false;

    final battle = battles[idx];
    if (battle.loserAcknowledged) return true;

    battles[idx] = battle.copyWith(loserAcknowledged: true);
    await saveBattles(battles);
    return true;
  }

  /// ارتقای ۱ رتبه در لیست کلاس و اضافه کردن سکه
  static Future<bool> promoteStudentRank({
    required String classCode,
    required String studentId,
    required String studentName,
    int bonusCoins = 100,
  }) async {
    return await Quran7LeagueManager.promoteStudentRankInClass(
      classCode: classCode,
      studentId: studentId,
      studentName: studentName,
      bonusCoins: bonusCoins,
    );
  }

  /// ساخت ویجت بازی مربوطه به صورت چالش ۱ دقیقه‌ای
  static Widget buildGameScreenForBattle({
    required int lessonIndex,
    required int partIndex,
    required void Function(int coins, int timeTaken) onComplete,
  }) {
    final lessonTitle = getLessonTitle(lessonIndex);

    if (partIndex == 1) {
      final vocab = getPart1Vocab(lessonIndex);
      return ArabicLesson1GameScreen(
        lessonTitle: lessonTitle,
        lessonKey: 'quran7_lesson${lessonIndex + 1}_battle',
        customVocabulary: vocab,
        isChallengeMode: true,
        challengeTimeLimitSeconds: 60,
        onChallengeComplete: onComplete,
      );
    } else if (partIndex == 2) {
      final words = getPart2Vocab(lessonIndex);
      return ArabicLesson1Part2FirewallGameScreen(
        lessonTitle: lessonTitle,
        lessonKey: 'quran7_lesson${lessonIndex + 1}_p2_battle',
        customWords: words,
        isChallengeMode: true,
        challengeTimeLimitSeconds: 60,
        onChallengeComplete: onComplete,
      );
    } else {
      final words = getPart3Vocab(lessonIndex);
      return ArabicLesson1Part3RocketGameScreen(
        lessonTitle: lessonTitle,
        lessonKey: 'quran7_lesson${lessonIndex + 1}_p3_battle',
        customWords: words,
        isChallengeMode: true,
        challengeTimeLimitSeconds: 60,
        onChallengeComplete: onComplete,
      );
    }
  }

  static String getLessonTitle(int index) {
    const names = [
      'درس اول',
      'درس دوم',
      'درس سوم',
      'درس چهارم',
      'درس پنجم',
      'درس ششم',
      'درس هفتم',
      'درس هشتم',
      'درس نهم',
      'درس دهم',
      'درس یازدهم',
      'درس دوازدهم',
    ];
    if (index >= 0 && index < names.length) {
      return 'قرآن هفتم - ${names[index]}';
    }
    return 'قرآن هفتم - درس ${index + 1}';
  }

  static String getPartName(int part) {
    switch (part) {
      case 1:
        return 'قسمت اول: تطبیق کلمات و ایموجی 🧩';
      case 2:
        return 'قسمت دوم: بازی دیوار آتشین 🔥';
      case 3:
      default:
        return 'قسمت سوم: موشک و شهاب‌سنگ 🚀';
    }
  }

  static List<Map<String, String>> getPart1Vocab(int lessonIndex) {
    switch (lessonIndex) {
      case 0:
        return Quran7Data.lesson1Part1Vocab;
      case 1:
        return Quran7Data.lesson2Part1Vocab;
      case 2:
        return Quran7Data.lesson3Part1Vocab;
      case 3:
        return Quran7Data.lesson4Part1Vocab;
      case 4:
        return Quran7Data.lesson5Part1Vocab;
      case 5:
        return Quran7Data.lesson6Part1Vocab;
      case 6:
        return Quran7Data.lesson7Part1Vocab;
      case 7:
        return Quran7Data.lesson8Part1Vocab;
      case 8:
        return Quran7Data.lesson9Part1Vocab;
      case 9:
        return Quran7Data.lesson10Part1Vocab;
      case 10:
        return Quran7Data.lesson11Part1Vocab;
      case 11:
      default:
        return Quran7Data.lesson12Part1Vocab;
    }
  }

  static List<Map<String, String>> getPart2Vocab(int lessonIndex) {
    switch (lessonIndex) {
      case 0:
        return Quran7Data.lesson1Part2Vocab;
      case 1:
        return Quran7Data.lesson2Part2Vocab;
      case 2:
        return Quran7Data.lesson3Part2Vocab;
      case 3:
        return Quran7Data.lesson4Part2Vocab;
      case 4:
        return Quran7Data.lesson5Part2Vocab;
      case 5:
        return Quran7Data.lesson6Part2Vocab;
      case 6:
        return Quran7Data.lesson7Part2Vocab;
      case 7:
        return Quran7Data.lesson8Part2Vocab;
      case 8:
        return Quran7Data.lesson9Part2Vocab;
      case 9:
        return Quran7Data.lesson10Part2Vocab;
      case 10:
        return Quran7Data.lesson11Part2Vocab;
      case 11:
      default:
        return Quran7Data.lesson12Part2Vocab;
    }
  }

  static List<Map<String, String>> getPart3Vocab(int lessonIndex) {
    switch (lessonIndex) {
      case 0:
        return Quran7Data.lesson1Part3Vocab;
      case 1:
        return Quran7Data.lesson2Part3Vocab;
      case 2:
        return Quran7Data.lesson3Part3Vocab;
      case 3:
        return Quran7Data.lesson4Part3Vocab;
      case 4:
        return Quran7Data.lesson5Part3Vocab;
      case 5:
        return Quran7Data.lesson6Part3Vocab;
      case 6:
        return Quran7Data.lesson7Part3Vocab;
      case 7:
        return Quran7Data.lesson8Part3Vocab;
      case 8:
        return Quran7Data.lesson9Part3Vocab;
      case 9:
        return Quran7Data.lesson10Part3Vocab;
      case 10:
        return Quran7Data.lesson11Part3Vocab;
      case 11:
      default:
        return Quran7Data.lesson12Part3Vocab;
    }
  }
}
