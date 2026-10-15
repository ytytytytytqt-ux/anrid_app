import 'package:flutter/material.dart';
import '../league_config.dart';

/// سازنده سریع و منعطف لیگ کلاسی برای هر درس در پایه‌های هفتم، هشتم و نهم
/// مانند عربی، زبان انگلیسی، پیام‌های آسمان، مطالعات اجتماعی، علوم، فارسی، ریاضی و ...
class UniversalSubjectBuilder {
  static LeagueSubjectConfig createSubjectConfig({
    required String subjectId,
    required String subjectTitle,
    required String leagueTitle,
    required String emoji,
    required Color primaryColor,
    required Color darkColor,
    required Color accentColor,
    required int totalLessons,
    int partsPerLesson = 3,
    List<String>? lessonTitles,
    bool Function(int lesson, int part)? customCompletionChecker,
  }) {
    final List<LeagueLessonConfig> lessons = List.generate(totalLessons, (idx) {
      final lessonNum = idx + 1;
      final title = (lessonTitles != null && idx < lessonTitles.length)
          ? lessonTitles[idx]
          : 'درس $lessonNum';

      return LeagueLessonConfig(
        lessonNumber: lessonNum,
        title: title,
        subtitle: '$subjectTitle - درس $lessonNum',
        parts: List.generate(partsPerLesson, (pIdx) {
          final partNum = pIdx + 1;
          final partLabels = [
            'تطبیق و یادگیری اولیه',
            'آزمون سرعت و دقت',
            'چالش مرحله‌ای و رقابت',
          ];
          final partEmojis = ['🧩', '🔥', '🚀'];

          return LeaguePartConfig(
            partNumber: partNum,
            title: pIdx < partLabels.length
                ? partLabels[pIdx]
                : 'قسمت $partNum',
            emoji: pIdx < partEmojis.length ? partEmojis[pIdx] : '⭐',
            gameLabel: 'آزمون مرحله $partNum',
            isCompletedInAuthManager: () {
              if (customCompletionChecker != null) {
                return customCompletionChecker(lessonNum, partNum);
              }
              return false;
            },
          );
        }),
      );
    });

    return LeagueSubjectConfig(
      subjectId: subjectId,
      subjectTitle: subjectTitle,
      leagueTitle: leagueTitle,
      emoji: emoji,
      primaryColor: primaryColor,
      darkColor: darkColor,
      accentColor: accentColor,
      gradientColors: [darkColor, primaryColor],
      lessons: lessons,
    );
  }
}
