import 'package:flutter/material.dart';
import '../../managers/auth_manager.dart';
import '../league_config.dart';

/// تنظیمات کامل لیگ کلاسی قرآن هفتم بر پایه الگوی مشترک LeagueCore
LeagueSubjectConfig createQuran7LeagueConfig() {
  return LeagueSubjectConfig(
    subjectId: 'quran7',
    subjectTitle: 'قرآن هفتم',
    leagueTitle: 'لیگ کلاسی قرآن هفتم',
    emoji: '📖',
    primaryColor: const Color(0xFF0284C7),
    darkColor: const Color(0xFF0F172A),
    accentColor: const Color(0xFF38BDF8),
    gradientColors: const [Color(0xFF0F172A), Color(0xFF0284C7)],
    lessons: _generateQuran7Lessons(),
  );
}

bool _getQuran7Part(int lesson, int part) {
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

List<LeagueLessonConfig> _generateQuran7Lessons() {
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
      subtitle: 'درس شماره $num کتاب قرآن پایه هفتم',
      parts: [
        LeaguePartConfig(
          partNumber: 1,
          title: 'تطبیق کلمات و تصویر',
          emoji: '🧩',
          gameLabel: 'بازی پازل تطبیقی لغات',
          isCompletedInAuthManager: () => _getQuran7Part(num, 1),
        ),
        LeaguePartConfig(
          partNumber: 2,
          title: 'دیوار آتشین لغات',
          emoji: '🔥',
          gameLabel: 'چالش سرعت و دقت در معانی',
          isCompletedInAuthManager: () => _getQuran7Part(num, 2),
        ),
        LeaguePartConfig(
          partNumber: 3,
          title: 'پرتاب موشک و شهاب‌سنگ',
          emoji: '🚀',
          gameLabel: 'آزمون تعاملی و ثبت خطاهای لغات',
          isCompletedInAuthManager: () => _getQuran7Part(num, 3),
        ),
      ],
    );
  });
}
