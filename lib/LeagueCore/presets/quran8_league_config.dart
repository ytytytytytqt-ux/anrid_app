import 'package:flutter/material.dart';
import '../../managers/auth_manager.dart';
import '../league_config.dart';

/// تنظیمات کامل و مستقل لیگ کلاسی قرآن هشتم بر پایه الگوی مشترک LeagueCore
LeagueSubjectConfig createQuran8LeagueConfig() {
  return LeagueSubjectConfig(
    subjectId: 'quran8',
    subjectTitle: 'قرآن هشتم',
    leagueTitle: 'لیگ کلاسی قرآن هشتم',
    emoji: '📗',
    primaryColor: const Color(0xFF10B981),
    darkColor: const Color(0xFF064E3B),
    accentColor: const Color(0xFF34D399),
    gradientColors: const [Color(0xFF064E3B), Color(0xFF10B981)],
    lessons: _generateQuran8Lessons(),
  );
}

bool _getQuran8Part(int lesson, int part) {
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

List<LeagueLessonConfig> _generateQuran8Lessons() {
  final lessonTitles = [
    'اَلدَّرْسُ الْأَوَّلُ',
    'اَلدَّرْسُ الثّاني',
    'اَلدَّرْسُ الثّالِثُ',
    'اَلدَّرْسُ الرّابِعُ',
    'اَلدَّرْسُ الْخامِسُ',
    'اَلدَّرْسُ السّادِسُ',
    'اَلدَّرْسُ السّابِعُ',
    'اَلدَّرْسُ الثّامِنُ',
    'اَلدَّرْسُ التّاسِعُ',
    'اَلدَّرْسُ الْعاشِِرُ',
    'اَلدَّرْسُ الْحادِی عَشَرَ',
    'اَلدَّرْسُ الثّانی عَشَرَ',
  ];

  return List.generate(12, (index) {
    final num = index + 1;
    return LeagueLessonConfig(
      lessonNumber: num,
      title: lessonTitles[index],
      subtitle: 'درس شماره $num کتاب قرآن پایه هشتم',
      parts: [
        LeaguePartConfig(
          partNumber: 1,
          title: 'تطبیق کلمات و تصویر',
          emoji: '🧩',
          gameLabel: 'بازی پازل تطبیقی لغات',
          isCompletedInAuthManager: () => _getQuran8Part(num, 1),
        ),
        LeaguePartConfig(
          partNumber: 2,
          title: 'دیوار آتشین لغات',
          emoji: '🔥',
          gameLabel: 'چالش سرعت و دقت در معانی',
          isCompletedInAuthManager: () => _getQuran8Part(num, 2),
        ),
        LeaguePartConfig(
          partNumber: 3,
          title: 'پرتاب موشک و شهاب‌سنگ',
          emoji: '🚀',
          gameLabel: 'آزمون تعاملی و ثبت خطاهای لغات',
          isCompletedInAuthManager: () => _getQuran8Part(num, 3),
        ),
      ],
    );
  });
}
