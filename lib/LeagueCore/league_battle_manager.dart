import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../managers/auth_manager.dart';
import 'league_models.dart';
import 'league_storage_manager.dart';

class UniversalBattleManager {
  static String _key(String subjectId) => 'universal_league_battles_${subjectId}_v1';

  static Future<List<LeagueBattleModel>> getAllBattles(String subjectId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key(subjectId));
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list
          .map((e) => LeagueBattleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveBattles(String subjectId, List<LeagueBattleModel> battles) async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(battles.map((b) => b.toJson()).toList());
    await prefs.setString(_key(subjectId), str);
  }

  static Future<List<LeagueBattleModel>> getPendingBattlesForStudent({
    required String subjectId,
    required String classCode,
    required String studentId,
    required String studentName,
    String? phoneNumber,
  }) async {
    final battles = await getAllBattles(subjectId);
    final cleanId = studentId.trim();
    final cleanName = studentName.trim();
    final cleanPhone = phoneNumber?.trim() ?? '';

    return battles.where((b) {
      if (b.classCode != classCode) return false;
      if (b.status != LeagueBattleStatus.pendingOpponent) return false;
      if (b.opponentDismissed) return false;

      final bool idMatch =
          cleanId.isNotEmpty && b.opponentId.trim().isNotEmpty && b.opponentId.trim() == cleanId;
      final bool phoneMatch =
          cleanPhone.isNotEmpty && b.opponentPhone != null && b.opponentPhone!.trim() == cleanPhone;
      final bool nameMatch = b.opponentName.trim() == cleanName;

      return idMatch || phoneMatch || nameMatch;
    }).toList();
  }

  static Future<List<LeagueBattleModel>> getCompletedBattlesForStudent({
    required String subjectId,
    required String classCode,
    required String studentId,
    required String studentName,
    String? phoneNumber,
  }) async {
    final battles = await getAllBattles(subjectId);
    final cleanId = studentId.trim();
    final cleanName = studentName.trim();
    final cleanPhone = phoneNumber?.trim() ?? '';

    return battles.where((b) {
      if (b.classCode != classCode) return false;
      if (b.status != LeagueBattleStatus.completed) return false;

      bool isChallenger = false;
      if (cleanId.isNotEmpty && b.challengerId.trim().isNotEmpty) {
        isChallenger = b.challengerId.trim() == cleanId;
      }
      if (!isChallenger && cleanPhone.isNotEmpty) {
        isChallenger = b.challengerPhone != null && b.challengerPhone!.trim() == cleanPhone;
      }
      if (!isChallenger) {
        isChallenger = b.challengerName.trim() == cleanName;
      }

      bool isOpponent = false;
      if (cleanId.isNotEmpty && b.opponentId.trim().isNotEmpty) {
        isOpponent = b.opponentId.trim() == cleanId;
      }
      if (!isOpponent && cleanPhone.isNotEmpty) {
        isOpponent = b.opponentPhone != null && b.opponentPhone!.trim() == cleanPhone;
      }
      if (!isOpponent) {
        isOpponent = b.opponentName.trim() == cleanName;
      }

      if (!isChallenger && !isOpponent) return false;
      if (isChallenger && b.challengerDismissed) return false;
      if (isOpponent && b.opponentDismissed) return false;

      return true;
    }).toList();
  }

  static Future<List<LeagueBattleModel>> getPendingSentBattlesByStudent({
    required String subjectId,
    required String classCode,
    required String studentId,
    required String studentName,
    String? phoneNumber,
  }) async {
    final battles = await getAllBattles(subjectId);
    final cleanId = studentId.trim();
    final cleanName = studentName.trim();
    final cleanPhone = phoneNumber?.trim() ?? '';

    return battles.where((b) {
      if (b.classCode != classCode) return false;
      if (b.status != LeagueBattleStatus.pendingOpponent) return false;
      if (b.challengerDismissed) return false;

      final bool idMatch =
          cleanId.isNotEmpty && b.challengerId.trim().isNotEmpty && b.challengerId.trim() == cleanId;
      final bool phoneMatch =
          cleanPhone.isNotEmpty && b.challengerPhone != null && b.challengerPhone!.trim() == cleanPhone;
      final bool nameMatch = b.challengerName.trim() == cleanName;

      return idMatch || phoneMatch || nameMatch;
    }).toList();
  }

  static Future<LeagueBattleModel> createBattle({
    required String subjectId,
    required String classCode,
    required int lessonIndex,
    required int partIndex,
    required String challengerId,
    required String challengerName,
    String? challengerAvatar,
    String? challengerPhone,
    required int challengerScore,
    required int challengerRemainingSeconds,
    required String opponentId,
    required String opponentName,
    String? opponentAvatar,
    String? opponentPhone,
  }) async {
    final battles = await getAllBattles(subjectId);
    final battle = LeagueBattleModel(
      id: 'bt_${DateTime.now().millisecondsSinceEpoch}_${challengerId.hashCode.abs()}',
      subjectId: subjectId,
      classCode: classCode,
      lessonIndex: lessonIndex,
      partIndex: partIndex,
      challengerId: challengerId,
      challengerName: challengerName,
      challengerAvatar: challengerAvatar,
      challengerPhone: challengerPhone,
      challengerScore: challengerScore,
      challengerRemainingSeconds: challengerRemainingSeconds,
      opponentId: opponentId,
      opponentName: opponentName,
      opponentAvatar: opponentAvatar,
      opponentPhone: opponentPhone,
    );

    battles.insert(0, battle);
    await saveBattles(subjectId, battles);
    return battle;
  }

  static Future<LeagueBattleModel?> submitOpponentResult({
    required String subjectId,
    required String battleId,
    required int opponentScore,
    required int opponentRemainingSeconds,
  }) async {
    final battles = await getAllBattles(subjectId);
    final idx = battles.indexWhere((b) => b.id == battleId);
    if (idx == -1) return null;

    final updated = battles[idx].copyWith(
      opponentScore: opponentScore,
      opponentRemainingSeconds: opponentRemainingSeconds,
      status: LeagueBattleStatus.completed,
      completedAt: DateTime.now().millisecondsSinceEpoch,
    );

    battles[idx] = updated;
    await saveBattles(subjectId, battles);
    return updated;
  }

  static Future<bool> claimWinnerReward({
    required String subjectId,
    required String battleId,
    required bool isChallenger,
  }) async {
    final battles = await getAllBattles(subjectId);
    final idx = battles.indexWhere((b) => b.id == battleId);
    if (idx == -1) return false;

    final battle = battles[idx];
    if (isChallenger ? battle.challengerClaimed : battle.opponentClaimed) {
      return false;
    }

    final isWinner = battle.isCurrentUserWinner(isChallenger);
    if (!isWinner && !battle.isDraw()) return false;

    const int rewardCoins = 100;
    AuthManager.coins += rewardCoins;
    await AuthManager.save();

    final winnerId = isChallenger ? battle.challengerId : battle.opponentId;
    final winnerName = isChallenger ? battle.challengerName : battle.opponentName;

    await UniversalLeagueManager.promoteStudentRankInClass(
      subjectId: subjectId,
      classCode: battle.classCode,
      studentId: winnerId,
      studentName: winnerName,
      bonusCoins: rewardCoins,
    );

    final updated = isChallenger
        ? battle.copyWith(challengerClaimed: true, winnerClaimed: true)
        : battle.copyWith(opponentClaimed: true, winnerClaimed: true);

    battles[idx] = updated;
    await saveBattles(subjectId, battles);
    return true;
  }

  static Future<bool> dismissBattleForStudent({
    required String subjectId,
    required String battleId,
    required String studentId,
    required String studentName,
    String? phoneNumber,
  }) async {
    final battles = await getAllBattles(subjectId);
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
      isChallenger = battle.challengerPhone != null && battle.challengerPhone!.trim() == cleanPhone;
    }
    if (!isChallenger) {
      isChallenger = battle.challengerName.trim() == cleanName;
    }

    final updated = isChallenger
        ? battle.copyWith(challengerDismissed: true)
        : battle.copyWith(opponentDismissed: true);

    if (updated.challengerDismissed && updated.opponentDismissed) {
      battles.removeAt(idx);
    } else {
      battles[idx] = updated;
    }

    await saveBattles(subjectId, battles);
    return true;
  }

  static Future<bool> acknowledgeLoserDefeat({
    required String subjectId,
    required String battleId,
  }) async {
    final battles = await getAllBattles(subjectId);
    final idx = battles.indexWhere((b) => b.id == battleId);
    if (idx == -1) return false;

    final updated = battles[idx].copyWith(loserAcknowledged: true);
    battles[idx] = updated;
    await saveBattles(subjectId, battles);
    return true;
  }

  static Future<void> deleteBattle(String subjectId, String battleId) async {
    final battles = await getAllBattles(subjectId);
    battles.removeWhere((b) => b.id == battleId);
    await saveBattles(subjectId, battles);
  }
}
