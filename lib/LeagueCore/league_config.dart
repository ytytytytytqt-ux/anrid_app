import 'package:flutter/material.dart';

/// اطلاعات یک قسمت از درس (مثلاً قسمت ۱: تطبیق، قسمت ۲: دیوار آتشین، قسمت ۳: موشک)
class LeaguePartConfig {
  final int partNumber;
  final String title;
  final String emoji;
  final String gameLabel;

  /// تابعی که مشخص می‌کند آیا این پارت توسط کاربر جاری تکمیل شده است یا خیر (از AuthManager)
  final bool Function() isCompletedInAuthManager;

  const LeaguePartConfig({
    required this.partNumber,
    required this.title,
    this.emoji = '🎮',
    required this.gameLabel,
    required this.isCompletedInAuthManager,
  });
}

/// اطلاعات یک درس یا فصل از کتاب (مثلاً درس ۱، درس ۲ یا فصل ۱ تا ...)
class LeagueLessonConfig {
  final int lessonNumber;
  final String title;
  final String subtitle;
  final List<LeaguePartConfig> parts;

  const LeagueLessonConfig({
    required this.lessonNumber,
    required this.title,
    this.subtitle = '',
    required this.parts,
  });
}

/// مشخصات کامل یک درس/موضوع برای راه‌اندازی لیگ کلاسی اختصاصی
class LeagueSubjectConfig {
  /// شناسه یکتای درس (مثلاً 'quran7', 'quran8', 'zaban7', 'arabi8', ...)
  final String subjectId;

  /// عنوان کتاب و پایه (مثلاً 'قرآن پایه هفتم', 'زبان پایه هشتم', ...)
  final String subjectTitle;

  /// عنوان کامل لیگ برای دکمه و سربرگ‌ها (مثلاً 'لیگ کلاسی قرآن هفتم')
  final String leagueTitle;

  /// آیکون درس (مثلاً '📖', '🔤', '🔬', '🌍', ...)
  final String emoji;

  // رنگ‌بندی و تم ظاهری
  final Color primaryColor;
  final Color darkColor;
  final Color accentColor;
  final Color cardBackgroundColor;
  final List<Color> gradientColors;
  final List<Color>? buttonGradient;

  /// فهرست تمام درس‌ها/فصل‌های این درس همراه با پارت‌های آنها
  final List<LeagueLessonConfig> lessons;

  /// تابعی برای ساخت صفحه بازی نبرد برای یک درس و پارت مشخص (اختیاری)
  final Widget Function({
    required BuildContext context,
    required int lessonIndex,
    required int partIndex,
    required String battleKey,
    required String challengerName,
    required String? challengerAvatar,
    required String opponentName,
    required String? opponentAvatar,
    required int challengerScore,
    required Function(int score, int remainingSeconds) onGameFinished,
  })? buildBattleGameScreen;

  const LeagueSubjectConfig({
    required this.subjectId,
    required this.subjectTitle,
    required this.leagueTitle,
    this.emoji = '🏆',
    required this.primaryColor,
    required this.darkColor,
    required this.accentColor,
    this.cardBackgroundColor = const Color(0xFF131D2E),
    required this.gradientColors,
    this.buttonGradient,
    required this.lessons,
    this.buildBattleGameScreen,
  });
}
