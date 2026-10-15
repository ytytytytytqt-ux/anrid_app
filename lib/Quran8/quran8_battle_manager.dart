import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../managers/auth_manager.dart';
import 'quran8_data.dart';
import 'quran8_league_manager.dart';
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

/// مدل داده رقابت دو نفره لیگ قرآن هشتم
class Quran8BattleModel {
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
  final String lessonTitle; // مثلاً 'قرآن هشتم - درس دوم'
  final String partTitle; // مثلاً 'قسمت دوم: بازی دیوار آتشین'

  // وضعیت و جوایز
  final int createdAt;
  final String status; // 'pending' | 'completed'
  final bool winnerClaimed;
  final bool challengerClaimed;
  final bool opponentClaimed;
  final bool challengerDismissed;
  final bool opponentDismissed;
  final bool loserAcknowledged;

  Quran8BattleModel({
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

  bool isCurrentUserWinner(bool isChallenger) {
    final w = winnerType;
    if (w == BattleWinnerType.tie) return true;
    if (isChallenger && w == BattleWinnerType.challenger) return true;
    if (!isChallenger && w == BattleWinnerType.opponent) return true;
    return false;
  }

  bool isCurrentUserLoser(bool isChallenger) {
    final w = winnerType;
    if (w == BattleWinnerType.tie || w == BattleWinnerType.undecided) {
      return false;
    }
    return !isCurrentUserWinner(isChallenger);
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

  bool isWinnerClaimedBy(String studentId, String studentName) {
    if (challengerId == studentId || challengerName == studentName) {
      return challengerClaimed;
    }
    if (opponentId == studentId || opponentName == studentName) {
      return opponentClaimed;
    }
    return winnerClaimed;
  }

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

  Quran8BattleModel copyWith({
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
    return Quran8BattleModel(
      id: id ?? this.id,
      classCode: classCode ?? this.classCode,
      challengerId: challengerId ?? this.challengerId,
      challengerName: challengerName ?? this.challengerName,
      challengerAvatar: challengerAvatar ?? this.challengerAvatar,
      challengerCoins: challengerCoins ?? this.challengerCoins,
      challengerTimeSeconds:
          challengerTimeSeconds ?? this.challengerTimeSeconds,
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
        'winnerClaimed': winnerClaimed,
        'challengerClaimed': challengerClaimed,
        'opponentClaimed': opponentClaimed,
        'challengerDismissed': challengerDismissed,
        'opponentDismissed': opponentDismissed,
        'loserAcknowledged': loserAcknowledged,
      };

  factory Quran8BattleModel.fromJson(Map<String, dynamic> json) {
    return Quran8BattleModel(
      id: json['id'] as String? ?? '',
      classCode: json['classCode'] as String? ?? '',
      challengerId: json['challengerId'] as String? ?? '',
      challengerName: json['challengerName'] as String? ?? 'دانش‌آموز',
      challengerAvatar: json['challengerAvatar'] as String?,
      challengerCoins: (json['challengerCoins'] as num?)?.toInt() ?? 0,
      challengerTimeSeconds:
          (json['challengerTimeSeconds'] as num?)?.toInt() ?? 60,
      challengerFinished: json['challengerFinished'] as bool? ?? false,
      opponentId: json['opponentId'] as String? ?? '',
      opponentName: json['opponentName'] as String? ?? 'حریف',
      opponentAvatar: json['opponentAvatar'] as String?,
      opponentCoins: (json['opponentCoins'] as num?)?.toInt() ?? 0,
      opponentTimeSeconds:
          (json['opponentTimeSeconds'] as num?)?.toInt() ?? 60,
      opponentFinished: json['opponentFinished'] as bool? ?? false,
      lessonIndex: (json['lessonIndex'] as num?)?.toInt() ?? 0,
      partIndex: (json['partIndex'] as num?)?.toInt() ?? 1,
      lessonTitle: json['lessonTitle'] as String? ?? 'قرآن هشتم',
      partTitle: json['partTitle'] as String? ?? 'قسمت اول',
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'pending',
      winnerClaimed: json['winnerClaimed'] as bool? ?? false,
      challengerClaimed: json['challengerClaimed'] as bool? ?? false,
      opponentClaimed: json['opponentClaimed'] as bool? ?? false,
      challengerDismissed: json['challengerDismissed'] as bool? ?? false,
      opponentDismissed: json['opponentDismissed'] as bool? ?? false,
      loserAcknowledged: json['loserAcknowledged'] as bool? ?? false,
    );
  }
}

/// مدیریت و لاژیک رقابت‌های دو نفره در لیگ قرآن هشتم
class Quran8BattleManager {
  static const String _storageKey = 'quran8_league_battles_v1';

  static Future<List<Quran8BattleModel>> getAllBattles() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final List<dynamic> raw = jsonDecode(jsonStr);
      return raw
          .map((e) => Quran8BattleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveBattles(List<Quran8BattleModel> battles) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(battles.map((b) => b.toJson()).toList());
    await prefs.setString(_storageKey, jsonStr);
  }

  static Future<Quran8BattleModel?> getBattleById(String battleId) async {
    final all = await getAllBattles();
    final idx = all.indexWhere((b) => b.id == battleId);
    if (idx != -1) return all[idx];
    return null;
  }

  static Future<List<Quran8BattleModel>> getBattlesForStudent({
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

      if (matchesChallenger && b.challengerDismissed) return false;
      if (matchesOpponent && b.opponentDismissed) return false;

      return matchesChallenger || matchesOpponent;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static Future<Quran8BattleModel> createBattle({
    required String classCode,
    required Quran8StudentModel challenger,
    required Quran8StudentModel opponent,
    required int lessonIndex,
    required int partIndex,
    required String lessonTitle,
    required String partTitle,
    required int challengerCoins,
    required int challengerTimeSeconds,
  }) async {
    final battles = await getAllBattles();
    final newBattle = Quran8BattleModel(
      id: 'bt8_${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(9999)}',
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

  static Future<Quran8BattleModel?> submitOpponentResult({
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

  static Future<Quran8BattleModel?> dismissBattleForUser({
    required String battleId,
    required bool isChallenger,
  }) async {
    final battles = await getAllBattles();
    final idx = battles.indexWhere((b) => b.id == battleId);
    if (idx == -1) return null;

    final battle = battles[idx];
    final updated = isChallenger
        ? battle.copyWith(challengerDismissed: true)
        : battle.copyWith(opponentDismissed: true);

    if (updated.challengerDismissed && updated.opponentDismissed) {
      battles.removeAt(idx);
    } else {
      battles[idx] = updated;
    }

    await saveBattles(battles);
    return updated;
  }

  static Future<({Quran8BattleModel? battle, int bonusCoins})> claimReward({
    required String battleId,
    required bool isChallenger,
  }) async {
    final battles = await getAllBattles();
    final idx = battles.indexWhere((b) => b.id == battleId);
    if (idx == -1) return (battle: null, bonusCoins: 0);

    final battle = battles[idx];
    if (isChallenger ? battle.challengerClaimed : battle.opponentClaimed) {
      return (battle: battle, bonusCoins: 0);
    }

    final isWinner = battle.isCurrentUserWinner(isChallenger);
    if (!isWinner) {
      return (battle: battle, bonusCoins: 0);
    }

    const int bonusCoins = 100;

    AuthManager.coins += bonusCoins;
    await AuthManager.save();

    final prefs = await SharedPreferences.getInstance();
    final phone = AuthManager.phoneNumber.trim();
    if (phone.isNotEmpty) {
      await prefs.setInt('user_coins_$phone', AuthManager.coins);
    }

    final updated = isChallenger
        ? battle.copyWith(challengerClaimed: true, winnerClaimed: true)
        : battle.copyWith(opponentClaimed: true, winnerClaimed: true);

    battles[idx] = updated;
    await saveBattles(battles);
    return (battle: updated, bonusCoins: bonusCoins);
  }

  static Future<bool> dismissBattleForStudent({
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

  static Future<bool> claimWinnerReward({
    required String battleId,
    required String studentId,
    required String studentName,
  }) async {
    final battles = await getAllBattles();
    final idx = battles.indexWhere((b) => b.id == battleId);
    if (idx == -1) return false;

    final battle = battles[idx];
    if (battle.isWinnerClaimedBy(studentId, studentName)) return false;
    if (!battle.isWinner(studentId, studentName)) return false;

    AuthManager.coins += 100;
    final phone = AuthManager.phoneNumber.trim();
    final prefs = await SharedPreferences.getInstance();
    if (phone.isNotEmpty) {
      await prefs.setInt('coins_$phone', AuthManager.coins);
    }
    await prefs.setInt('coins', AuthManager.coins);
    AuthManager.save();

    await promoteStudentRank(
      classCode: battle.classCode,
      studentId: studentId,
      studentName: studentName,
      bonusCoins: 100,
    );

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

  static Future<bool> promoteStudentRank({
    required String classCode,
    required String studentId,
    required String studentName,
    int bonusCoins = 100,
  }) async {
    return await Quran8LeagueManager.promoteStudentRankInClass(
      classCode: classCode,
      studentId: studentId,
      studentName: studentName,
      bonusCoins: bonusCoins,
    );
  }


  /// ساخت ویجت بازی مربوطه قرآن هشتم به صورت چالش ۱ دقیقه‌ای
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
        lessonKey: 'quran8_lesson${lessonIndex + 1}_battle',
        customVocabulary: vocab,
        isChallengeMode: true,
        challengeTimeLimitSeconds: 60,
        onChallengeComplete: onComplete,
      );
    } else if (partIndex == 2) {
      final words = getPart2Vocab(lessonIndex);
      return ArabicLesson1Part2FirewallGameScreen(
        lessonTitle: lessonTitle,
        lessonKey: 'quran8_lesson${lessonIndex + 1}_p2_battle',
        customWords: words,
        isChallengeMode: true,
        challengeTimeLimitSeconds: 60,
        onChallengeComplete: onComplete,
      );
    } else {
      final words = getPart3Vocab(lessonIndex);
      return ArabicLesson1Part3RocketGameScreen(
        lessonTitle: lessonTitle,
        lessonKey: 'quran8_lesson${lessonIndex + 1}_p3_battle',
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
      return 'قرآن هشتم - ${names[index]}';
    }
    return 'قرآن هشتم - درس ${index + 1}';
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
        return Quran8Data.lesson1Part1Vocab;
      case 1:
        return Quran8Data.lesson2Part1Vocab;
      case 2:
        return Quran8Data.lesson3Part1Vocab;
      case 3:
        return Quran8Data.lesson4Part1Vocab;
      case 4:
        return Quran8Data.lesson5Part1Vocab;
      case 5:
        return Quran8Data.lesson6Part1Vocab;
      case 6:
        return Quran8Data.lesson7Part1Vocab;
      case 7:
        return Quran8Data.lesson8Part1Vocab;
      case 8:
        return Quran8Data.lesson9Part1Vocab;
      case 9:
        return Quran8Data.lesson10Part1Vocab;
      case 10:
        return Quran8Data.lesson11Part1Vocab;
      case 11:
      default:
        return Quran8Data.lesson12Part1Vocab;
    }
  }

  static List<Map<String, String>> getPart2Vocab(int lessonIndex) {
    switch (lessonIndex) {
      case 0:
        return Quran8Data.lesson1Part2Vocab;
      case 1:
        return Quran8Data.lesson2Part2Vocab;
      case 2:
        return Quran8Data.lesson3Part2Vocab;
      case 3:
        return Quran8Data.lesson4Part2Vocab;
      case 4:
        return Quran8Data.lesson5Part2Vocab;
      case 5:
        return Quran8Data.lesson6Part2Vocab;
      case 6:
        return Quran8Data.lesson7Part2Vocab;
      case 7:
        return Quran8Data.lesson8Part2Vocab;
      case 8:
        return Quran8Data.lesson9Part2Vocab;
      case 9:
        return Quran8Data.lesson10Part2Vocab;
      case 10:
        return Quran8Data.lesson11Part2Vocab;
      case 11:
      default:
        return Quran8Data.lesson12Part2Vocab;
    }
  }

  static List<Map<String, String>> getPart3Vocab(int lessonIndex) {
    switch (lessonIndex) {
      case 0:
        return Quran8Data.lesson1Part3Vocab;
      case 1:
        return Quran8Data.lesson2Part3Vocab;
      case 2:
        return Quran8Data.lesson3Part3Vocab;
      case 3:
        return Quran8Data.lesson4Part3Vocab;
      case 4:
        return Quran8Data.lesson5Part3Vocab;
      case 5:
        return Quran8Data.lesson6Part3Vocab;
      case 6:
        return Quran8Data.lesson7Part3Vocab;
      case 7:
        return Quran8Data.lesson8Part3Vocab;
      case 8:
        return Quran8Data.lesson9Part3Vocab;
      case 9:
        return Quran8Data.lesson10Part3Vocab;
      case 10:
        return Quran8Data.lesson11Part3Vocab;
      case 11:
      default:
        return Quran8Data.lesson12Part3Vocab;
    }
  }
}
