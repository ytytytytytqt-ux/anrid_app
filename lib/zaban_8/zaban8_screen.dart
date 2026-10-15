import 'package:flutter/material.dart';
import 'zaban8_data.dart';
import '../managers/auth_manager.dart';
import '../screens/home_screen.dart';

bool _isZaban8LessonCompleted(int lessonNum) {
  switch (lessonNum) {
    case 1:
      // Lesson 1 of Zaban 8 has only 2 parts (Part 2 and Part 3)
      return AuthManager.zaban8Lesson1Part2Completed &&
          AuthManager.zaban8Lesson1Part3Completed;
    case 2:
      return AuthManager.zaban8Lesson2Part1Completed &&
          AuthManager.zaban8Lesson2Part2Completed &&
          AuthManager.zaban8Lesson2Part3Completed;
    case 3:
      return AuthManager.zaban8Lesson3Part1Completed &&
          AuthManager.zaban8Lesson3Part2Completed &&
          AuthManager.zaban8Lesson3Part3Completed;
    case 4:
      return AuthManager.zaban8Lesson4Part1Completed &&
          AuthManager.zaban8Lesson4Part2Completed &&
          AuthManager.zaban8Lesson4Part3Completed;
    case 5:
      return AuthManager.zaban8Lesson5Part1Completed &&
          AuthManager.zaban8Lesson5Part2Completed &&
          AuthManager.zaban8Lesson5Part3Completed;
    case 6:
      return AuthManager.zaban8Lesson6Part1Completed &&
          AuthManager.zaban8Lesson6Part2Completed &&
          AuthManager.zaban8Lesson6Part3Completed;
    case 7:
      // Lesson 7 of Zaban 8 has only 2 parts (Part 1 and Part 3)
      return AuthManager.zaban8Lesson7Part1Completed &&
          AuthManager.zaban8Lesson7Part3Completed;
    default:
      return false;
  }
}

Future<void> showZaban8LessonsModal(BuildContext context) {
  final List<Map<String, String>> zaban8Lessons = [
    {'number': '01', 'title': 'Lesson 1', 'subtitle': ''},
    {'number': '02', 'title': 'Lesson 2', 'subtitle': ''},
    {'number': '03', 'title': 'Lesson 3', 'subtitle': ''},
    {'number': '04', 'title': 'Lesson 4', 'subtitle': ''},
    {'number': '05', 'title': 'Lesson 5', 'subtitle': ''},
    {'number': '06', 'title': 'Lesson 6', 'subtitle': ''},
    {'number': '07', 'title': 'Lesson 7', 'subtitle': ''},
  ];

  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.82,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F071E), Color(0xFF1E1B4B), Color(0xFF0F172A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.6), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0284C7), width: 1.5),
                    ),
                    child: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'کتاب زبان انگلیسی پایه هشتم 🇬🇧',
                          style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'لیست بازی 🎮 های ۷ درس زبان هشتم',
                          style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: zaban8Lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = zaban8Lessons[index];
                    final bool isPlayable = (index >= 0 && index <= 6);
                    final bool isCompleted = _isZaban8LessonCompleted(index + 1);

                    final Color itemAccentColor = isCompleted
                        ? const Color(0xFF10B981)
                        : (isPlayable ? const Color(0xFF0284C7) : const Color(0xFF334155));
                    final List<Color> itemGradient = isCompleted
                        ? [const Color(0xFF064E3B).withValues(alpha: 0.75), const Color(0xFF0A2E20)]
                        : [const Color(0xFF231F3D), const Color(0xFF1E1B4B)];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: itemGradient,
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isCompleted
                              ? const Color(0xFF10B981)
                              : (isPlayable ? const Color(0xFF0284C7) : const Color(0xFF0284C7).withOpacity(0.3)),
                          width: (isCompleted || isPlayable) ? 2.0 : 1.5,
                        ),
                        boxShadow: isCompleted
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.pop(context);
                            if (index == 0) {
                              _showZaban8Lesson1PartsModal(context);
                            } else if (index == 1) {
                              _showZaban8Lesson2PartsModal(context);
                            } else if (index == 2) {
                              _showZaban8Lesson3PartsModal(context);
                            } else if (index == 3) {
                              _showZaban8Lesson4PartsModal(context);
                            } else if (index == 4) {
                              _showZaban8Lesson5PartsModal(context);
                            } else if (index == 5) {
                              _showZaban8Lesson6PartsModal(context);
                            } else if (index == 6) {
                              _showZaban8Lesson7PartsModal(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('بازی ${lesson['title']} به زودی فعال می‌شود! 🚀'),
                                  backgroundColor: const Color(0xFF0284C7),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: itemAccentColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: isCompleted
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF10B981).withValues(alpha: 0.4),
                                              blurRadius: 8,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: isCompleted
                                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                                        : Text(
                                            lesson['number']!,
                                            style: const TextStyle(fontFamily: 'Tahoma', fontWeight: FontWeight.w900, color: Colors.white, fontSize: 13),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    lesson['title']!,
                                    style: const TextStyle(fontFamily: 'Tahoma', fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
                                  ),
                                ),
                                if (isPlayable)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: itemAccentColor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: itemAccentColor),
                                    ),
                                    child: Text(
                                      isCompleted ? 'تکمیل شده ✅' : 'شروع بازی 🎮',
                                      style: TextStyle(
                                        fontFamily: 'Tahoma',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isCompleted ? const Color(0xFF6EE7B7) : const Color(0xFF38BDF8),
                                      ),
                                    ),
                                  )
                                else
                                  const Icon(Icons.lock_outline_rounded, color: Color(0xFF94A3B8), size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showZaban8Lesson1PartsModal(BuildContext context) {
  final bool p2Completed = AuthManager.zaban8Lesson1Part2Completed;
  final bool p3Completed = AuthManager.zaban8Lesson1Part3Completed;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: const Color(0xFF0284C7), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'زبان انگلیسی هشتم - Lesson 1 🇬🇧',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت دوم
              _buildZaban8PartButton(
                title: 'قسمت دوم: بازی دیوار آتشین',
                icon: '🔥',
                color: const Color(0xFFF97316),
                isCompleted: p2Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 1',
                        lessonKey: 'zaban8_lesson1_p2',
                        customWords: Zaban8Data.lesson1Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildZaban8PartButton(
                title: 'قسمت سوم: بازی موشک و شهاب‌سنگ',
                icon: '🚀',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part3RocketGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 1',
                        lessonKey: 'zaban8_lesson1_p3',
                        customWords: Zaban8Data.lesson1Part3Vocab,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showZaban8Lesson2PartsModal(BuildContext context) {
  final bool p2Completed = AuthManager.zaban8Lesson2Part2Completed;
  final bool p3Completed = AuthManager.zaban8Lesson2Part3Completed;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: const Color(0xFF0284C7), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'زبان انگلیسی هشتم - Lesson 2 🇬🇧',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت دوم
              _buildZaban8PartButton(
                title: 'قسمت دوم: بازی دیوار آتشین',
                icon: '🔥',
                color: const Color(0xFFF97316),
                isCompleted: p2Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 2',
                        lessonKey: 'zaban8_lesson2_p2',
                        customWords: Zaban8Data.lesson2Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildZaban8PartButton(
                title: 'قسمت سوم: بازی موشک و شهاب‌سنگ',
                icon: '🚀',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part3RocketGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 2',
                        lessonKey: 'zaban8_lesson2_p3',
                        customWords: Zaban8Data.lesson2Part3Vocab,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showZaban8Lesson3PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.zaban8Lesson3Part1Completed;
  final bool p2Completed = AuthManager.zaban8Lesson3Part2Completed;
  final bool p3Completed = AuthManager.zaban8Lesson3Part3Completed;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: const Color(0xFF0284C7), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'زبان انگلیسی هشتم - Lesson 3 🇬🇧',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildZaban8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF0284C7),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 3',
                        lessonKey: 'zaban8_lesson3',
                        customVocabulary: Zaban8Data.lesson3Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildZaban8PartButton(
                title: 'قسمت دوم: بازی دیوار آتشین',
                icon: '🔥',
                color: const Color(0xFFF97316),
                isCompleted: p2Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 3',
                        lessonKey: 'zaban8_lesson3_p2',
                        customWords: Zaban8Data.lesson3Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildZaban8PartButton(
                title: 'قسمت سوم: بازی موشک و شهاب‌سنگ',
                icon: '🚀',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part3RocketGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 3',
                        lessonKey: 'zaban8_lesson3_p3',
                        customWords: Zaban8Data.lesson3Part3Vocab,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showZaban8Lesson4PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.zaban8Lesson4Part1Completed;
  final bool p2Completed = AuthManager.zaban8Lesson4Part2Completed;
  final bool p3Completed = AuthManager.zaban8Lesson4Part3Completed;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: const Color(0xFF0284C7), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'زبان انگلیسی هشتم - Lesson 4 🇬🇧',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildZaban8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF0284C7),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 4',
                        lessonKey: 'zaban8_lesson4',
                        customVocabulary: Zaban8Data.lesson4Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildZaban8PartButton(
                title: 'قسمت دوم: بازی دیوار آتشین',
                icon: '🔥',
                color: const Color(0xFFF97316),
                isCompleted: p2Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 4',
                        lessonKey: 'zaban8_lesson4_p2',
                        customWords: Zaban8Data.lesson4Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildZaban8PartButton(
                title: 'قسمت سوم: بازی موشک و شهاب‌سنگ',
                icon: '🚀',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part3RocketGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 4',
                        lessonKey: 'zaban8_lesson4_p3',
                        customWords: Zaban8Data.lesson4Part3Vocab,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showZaban8Lesson5PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.zaban8Lesson5Part1Completed;
  final bool p2Completed = AuthManager.zaban8Lesson5Part2Completed;
  final bool p3Completed = AuthManager.zaban8Lesson5Part3Completed;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: const Color(0xFF0284C7), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'زبان انگلیسی هشتم - Lesson 5 🇬🇧',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildZaban8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF0284C7),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 5',
                        lessonKey: 'zaban8_lesson5',
                        customVocabulary: Zaban8Data.lesson5Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildZaban8PartButton(
                title: 'قسمت دوم: بازی دیوار آتشین',
                icon: '🔥',
                color: const Color(0xFFF97316),
                isCompleted: p2Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 5',
                        lessonKey: 'zaban8_lesson5_p2',
                        customWords: Zaban8Data.lesson5Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildZaban8PartButton(
                title: 'قسمت سوم: بازی موشک و شهاب‌سنگ',
                icon: '🚀',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part3RocketGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 5',
                        lessonKey: 'zaban8_lesson5_p3',
                        customWords: Zaban8Data.lesson5Part3Vocab,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showZaban8Lesson6PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.zaban8Lesson6Part1Completed;
  final bool p2Completed = AuthManager.zaban8Lesson6Part2Completed;
  final bool p3Completed = AuthManager.zaban8Lesson6Part3Completed;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: const Color(0xFF0284C7), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'زبان انگلیسی هشتم - Lesson 6 🇬🇧',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildZaban8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF0284C7),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 6',
                        lessonKey: 'zaban8_lesson6',
                        customVocabulary: Zaban8Data.lesson6Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildZaban8PartButton(
                title: 'قسمت دوم: بازی دیوار آتشین',
                icon: '🔥',
                color: const Color(0xFFF97316),
                isCompleted: p2Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 6',
                        lessonKey: 'zaban8_lesson6_p2',
                        customWords: Zaban8Data.lesson6Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildZaban8PartButton(
                title: 'قسمت سوم: بازی موشک و شهاب‌سنگ',
                icon: '🚀',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part3RocketGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 6',
                        lessonKey: 'zaban8_lesson6_p3',
                        customWords: Zaban8Data.lesson6Part3Vocab,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showZaban8Lesson7PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.zaban8Lesson7Part1Completed;
  final bool p3Completed = AuthManager.zaban8Lesson7Part3Completed;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: const Color(0xFF0284C7), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'زبان انگلیسی هشتم - Lesson 7 🇬🇧',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildZaban8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF0284C7),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 7',
                        lessonKey: 'zaban8_lesson7',
                        customVocabulary: Zaban8Data.lesson7Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildZaban8PartButton(
                title: 'قسمت سوم: بازی موشک و شهاب‌سنگ',
                icon: '🚀',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part3RocketGameScreen(
                        lessonTitle: 'زبان هشتم - Lesson 7',
                        lessonKey: 'zaban8_lesson7_p3',
                        customWords: Zaban8Data.lesson7Part3Vocab,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildZaban8PartButton({required String title, String icon = '', required Color color, required VoidCallback onTap, bool isCompleted = false}) {
  return Container(
    decoration: BoxDecoration(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color, width: 1.5),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (icon.isNotEmpty) ...[
                Text(icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontFamily: 'Tahoma', fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
              if (isCompleted)
                const Text('✅', style: TextStyle(fontSize: 18))
              else
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
            ],
          ),
        ),
      ),
    ),
  );
}
