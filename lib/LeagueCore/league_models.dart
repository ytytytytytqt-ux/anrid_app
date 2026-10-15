import 'dart:math';

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

/// مدل دانش‌آموز در لیگ
class LeagueStudentModel {
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

  LeagueStudentModel({
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

  factory LeagueStudentModel.fromJson(Map<String, dynamic> json) {
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

    return LeagueStudentModel(
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

  LeagueStudentModel copyWith({
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
    return LeagueStudentModel(
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

/// مدل کلاس
class LeagueClassModel {
  final String classCode; // کد ۵ رقمی کلاس
  final String teacherCode; // کد ۱۰ رقمی معلم
  String title;
  final String createdAt;
  final List<LeagueStudentModel> students;
  final String subjectId; // شناسه درسی که این کلاس برای آن است

  LeagueClassModel({
    required this.classCode,
    required this.teacherCode,
    required this.title,
    required this.createdAt,
    required this.students,
    this.subjectId = '',
  });

  Map<String, dynamic> toJson() => {
        'classCode': classCode,
        'teacherCode': teacherCode,
        'title': title,
        'createdAt': createdAt,
        'students': students.map((s) => s.toJson()).toList(),
        'subjectId': subjectId,
      };

  factory LeagueClassModel.fromJson(Map<String, dynamic> json) =>
      LeagueClassModel(
        classCode: json['classCode'] as String? ?? '00000',
        teacherCode: json['teacherCode'] as String? ?? '0000000000',
        title: json['title'] as String? ?? 'کلاس درس',
        createdAt:
            json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        students: (json['students'] as List<dynamic>?)
                ?.map((e) => LeagueStudentModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        subjectId: json['subjectId'] as String? ?? '',
      );
}

/// مدل مدیر مدرسه (مشترک در تمام لیگ‌ها)
class LeagueManagerProfile {
  final String name;
  final String passcode; // دقیقاً ۱۰ رقم عددی
  final int maxClasses; // سهمیه تعداد کلاس
  int get classQuota => maxClasses;
  final String createdAt;

  LeagueManagerProfile({
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

  factory LeagueManagerProfile.fromJson(Map<String, dynamic> json) =>
      LeagueManagerProfile(
        name: json['name'] as String? ?? 'مدیر مدرسه',
        passcode: json['passcode'] as String? ?? '',
        maxClasses: (json['maxClasses'] as num?)?.toInt() ?? 5,
        createdAt:
            json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      );
}

/// مدل نگهداری مدیر حذف‌شده در سطل زباله
class LeagueTrashItem {
  final LeagueManagerProfile manager;
  final List<LeagueClassModel> classes;
  final String deletedAt;

  LeagueTrashItem({
    required this.manager,
    required this.classes,
    required this.deletedAt,
  });

  Map<String, dynamic> toJson() => {
        'manager': manager.toJson(),
        'classes': classes.map((c) => c.toJson()).toList(),
        'deletedAt': deletedAt,
      };

  factory LeagueTrashItem.fromJson(Map<String, dynamic> json) {
    LeagueManagerProfile mgr;
    try {
      final m = json['manager'];
      if (m is Map) {
        mgr = LeagueManagerProfile.fromJson(Map<String, dynamic>.from(m));
      } else {
        mgr = LeagueManagerProfile(
          name: 'مدیر حذف‌شده',
          passcode: '',
          maxClasses: 5,
          createdAt: DateTime.now().toIso8601String(),
        );
      }
    } catch (_) {
      mgr = LeagueManagerProfile(
        name: 'مدیر حذف‌شده',
        passcode: '',
        maxClasses: 5,
        createdAt: DateTime.now().toIso8601String(),
      );
    }

    final rawClasses = json['classes'] as List<dynamic>? ?? [];
    final List<LeagueClassModel> classes = [];
    for (final c in rawClasses) {
      try {
        if (c is Map) {
          classes.add(LeagueClassModel.fromJson(Map<String, dynamic>.from(c)));
        }
      } catch (_) {}
    }

    return LeagueTrashItem(
      manager: mgr,
      classes: classes,
      deletedAt: json['deletedAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}

/// وضعیت نبرد دونفره
enum LeagueBattleStatus {
  pendingOpponent, // در انتظار پاسخ حریف
  completed, // هر دو بازی کردند و نتیجه نهایی شده
  canceled, // لغو شده
}

/// مدل چالش نبرد دونفره در لیگ
class LeagueBattleModel {
  final String id;
  final String subjectId;
  final String classCode;
  final int lessonIndex;
  final int partIndex;

  // اطلاعات درخواست‌دهنده
  final String challengerId;
  final String challengerName;
  final String? challengerAvatar;
  final String? challengerPhone;
  final int challengerScore;
  final int challengerRemainingSeconds;

  // اطلاعات حریف دعوت‌شده
  final String opponentId;
  final String opponentName;
  final String? opponentAvatar;
  final String? opponentPhone;
  final int? opponentScore;
  final int? opponentRemainingSeconds;

  final LeagueBattleStatus status;
  final int createdAt;
  final int? completedAt;

  final bool winnerClaimed;
  final bool challengerClaimed;
  final bool opponentClaimed;
  final bool loserAcknowledged;

  final bool challengerDismissed;
  final bool opponentDismissed;

  LeagueBattleModel({
    required this.id,
    this.subjectId = '',
    required this.classCode,
    required this.lessonIndex,
    required this.partIndex,
    required this.challengerId,
    required this.challengerName,
    this.challengerAvatar,
    this.challengerPhone,
    required this.challengerScore,
    required this.challengerRemainingSeconds,
    required this.opponentId,
    required this.opponentName,
    this.opponentAvatar,
    this.opponentPhone,
    this.opponentScore,
    this.opponentRemainingSeconds,
    this.status = LeagueBattleStatus.pendingOpponent,
    int? createdAt,
    this.completedAt,
    this.winnerClaimed = false,
    this.challengerClaimed = false,
    this.opponentClaimed = false,
    this.loserAcknowledged = false,
    this.challengerDismissed = false,
    this.opponentDismissed = false,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  bool isCurrentUserWinner(bool isChallenger) {
    if (opponentScore == null) return false;
    final myScore = isChallenger ? challengerScore : opponentScore!;
    final theirScore = isChallenger ? opponentScore! : challengerScore;
    if (myScore > theirScore) return true;
    if (myScore < theirScore) return false;
    final myTime =
        isChallenger ? challengerRemainingSeconds : (opponentRemainingSeconds ?? 0);
    final theirTime =
        isChallenger ? (opponentRemainingSeconds ?? 0) : challengerRemainingSeconds;
    return myTime >= theirTime;
  }

  bool isDraw() {
    if (opponentScore == null) return false;
    return challengerScore == opponentScore &&
        challengerRemainingSeconds == (opponentRemainingSeconds ?? 0);
  }

  LeagueBattleModel copyWith({
    int? opponentScore,
    int? opponentRemainingSeconds,
    LeagueBattleStatus? status,
    int? completedAt,
    bool? winnerClaimed,
    bool? challengerClaimed,
    bool? opponentClaimed,
    bool? loserAcknowledged,
    bool? challengerDismissed,
    bool? opponentDismissed,
  }) {
    return LeagueBattleModel(
      id: id,
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
      opponentScore: opponentScore ?? this.opponentScore,
      opponentRemainingSeconds:
          opponentRemainingSeconds ?? this.opponentRemainingSeconds,
      status: status ?? this.status,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
      winnerClaimed: winnerClaimed ?? this.winnerClaimed,
      challengerClaimed: challengerClaimed ?? this.challengerClaimed,
      opponentClaimed: opponentClaimed ?? this.opponentClaimed,
      loserAcknowledged: loserAcknowledged ?? this.loserAcknowledged,
      challengerDismissed: challengerDismissed ?? this.challengerDismissed,
      opponentDismissed: opponentDismissed ?? this.opponentDismissed,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subjectId': subjectId,
        'classCode': classCode,
        'lessonIndex': lessonIndex,
        'partIndex': partIndex,
        'challengerId': challengerId,
        'challengerName': challengerName,
        'challengerAvatar': challengerAvatar,
        'challengerPhone': challengerPhone,
        'challengerScore': challengerScore,
        'challengerRemainingSeconds': challengerRemainingSeconds,
        'opponentId': opponentId,
        'opponentName': opponentName,
        'opponentAvatar': opponentAvatar,
        'opponentPhone': opponentPhone,
        'opponentScore': opponentScore,
        'opponentRemainingSeconds': opponentRemainingSeconds,
        'status': status.name,
        'createdAt': createdAt,
        'completedAt': completedAt,
        'winnerClaimed': winnerClaimed,
        'challengerClaimed': challengerClaimed,
        'opponentClaimed': opponentClaimed,
        'loserAcknowledged': loserAcknowledged,
        'challengerDismissed': challengerDismissed,
        'opponentDismissed': opponentDismissed,
      };

  factory LeagueBattleModel.fromJson(Map<String, dynamic> json) {
    LeagueBattleStatus parseStatus(String? val) {
      if (val == null) return LeagueBattleStatus.pendingOpponent;
      for (final s in LeagueBattleStatus.values) {
        if (s.name == val) return s;
      }
      return LeagueBattleStatus.pendingOpponent;
    }

    final rawWinnerClaimed = json['winnerClaimed'] as bool? ?? false;

    return LeagueBattleModel(
      id: json['id'] as String? ?? 'b_${Random().nextInt(999999)}',
      subjectId: json['subjectId'] as String? ?? '',
      classCode: json['classCode'] as String? ?? '00000',
      lessonIndex: (json['lessonIndex'] as num?)?.toInt() ?? 0,
      partIndex: (json['partIndex'] as num?)?.toInt() ?? 0,
      challengerId: json['challengerId'] as String? ?? '',
      challengerName: json['challengerName'] as String? ?? 'دانش‌آموز',
      challengerAvatar: json['challengerAvatar'] as String?,
      challengerPhone: json['challengerPhone'] as String?,
      challengerScore: (json['challengerScore'] as num?)?.toInt() ?? 0,
      challengerRemainingSeconds:
          (json['challengerRemainingSeconds'] as num?)?.toInt() ?? 0,
      opponentId: json['opponentId'] as String? ?? '',
      opponentName: json['opponentName'] as String? ?? 'حریف',
      opponentAvatar: json['opponentAvatar'] as String?,
      opponentPhone: json['opponentPhone'] as String?,
      opponentScore: (json['opponentScore'] as num?)?.toInt(),
      opponentRemainingSeconds:
          (json['opponentRemainingSeconds'] as num?)?.toInt(),
      status: parseStatus(json['status'] as String?),
      createdAt: (json['createdAt'] as num?)?.toInt() ??
          DateTime.now().millisecondsSinceEpoch,
      completedAt: (json['completedAt'] as num?)?.toInt(),
      winnerClaimed: rawWinnerClaimed,
      challengerClaimed:
          json['challengerClaimed'] as bool? ?? rawWinnerClaimed,
      opponentClaimed: json['opponentClaimed'] as bool? ?? false,
      loserAcknowledged: json['loserAcknowledged'] as bool? ?? false,
      challengerDismissed: json['challengerDismissed'] as bool? ?? false,
      opponentDismissed: json['opponentDismissed'] as bool? ?? false,
    );
  }
}
