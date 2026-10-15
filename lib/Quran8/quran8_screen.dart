import 'package:flutter/material.dart';
import 'quran8_data.dart';
import '../managers/auth_manager.dart';
import '../screens/home_screen.dart';

bool _isQuran8LessonCompleted(int lessonNum) {
  switch (lessonNum) {
    case 1:
      return AuthManager.quran8Lesson1Part1Completed &&
          AuthManager.quran8Lesson1Part2Completed &&
          AuthManager.quran8Lesson1Part3Completed;
    case 2:
      return AuthManager.quran8Lesson2Part1Completed &&
          AuthManager.quran8Lesson2Part2Completed &&
          AuthManager.quran8Lesson2Part3Completed;
    case 3:
      return AuthManager.quran8Lesson3Part1Completed &&
          AuthManager.quran8Lesson3Part2Completed &&
          AuthManager.quran8Lesson3Part3Completed;
    case 4:
      return AuthManager.quran8Lesson4Part1Completed &&
          AuthManager.quran8Lesson4Part2Completed &&
          AuthManager.quran8Lesson4Part3Completed;
    case 5:
      return AuthManager.quran8Lesson5Part1Completed &&
          AuthManager.quran8Lesson5Part2Completed &&
          AuthManager.quran8Lesson5Part3Completed;
    case 6:
      return AuthManager.quran8Lesson6Part1Completed &&
          AuthManager.quran8Lesson6Part2Completed &&
          AuthManager.quran8Lesson6Part3Completed;
    case 7:
      return AuthManager.quran8Lesson7Part1Completed &&
          AuthManager.quran8Lesson7Part2Completed &&
          AuthManager.quran8Lesson7Part3Completed;
    case 8:
      return AuthManager.quran8Lesson8Part1Completed &&
          AuthManager.quran8Lesson8Part2Completed &&
          AuthManager.quran8Lesson8Part3Completed;
    case 9:
      return AuthManager.quran8Lesson9Part1Completed &&
          AuthManager.quran8Lesson9Part2Completed &&
          AuthManager.quran8Lesson9Part3Completed;
    case 10:
      return AuthManager.quran8Lesson10Part1Completed &&
          AuthManager.quran8Lesson10Part2Completed &&
          AuthManager.quran8Lesson10Part3Completed;
    case 11:
      return AuthManager.quran8Lesson11Part1Completed &&
          AuthManager.quran8Lesson11Part2Completed &&
          AuthManager.quran8Lesson11Part3Completed;
    case 12:
      return AuthManager.quran8Lesson12Part1Completed &&
          AuthManager.quran8Lesson12Part2Completed &&
          AuthManager.quran8Lesson12Part3Completed;
    default:
      return false;
  }
}

Future<dynamic> showQuran8LessonsModal(BuildContext context) {
  final List<Map<String, String>> quran8Lessons = [
    {'number': '01', 'title': 'اَلدَّرْسُ الْأَوَّلُ', 'subtitle': 'سوره مؤمنون / نور'},
    {'number': '02', 'title': 'اَلدَّرْسُ الثّاني', 'subtitle': 'به زودی'},
    {'number': '03', 'title': 'اَلدَّرْسُ الثّالِثُ', 'subtitle': 'به زودی'},
    {'number': '04', 'title': 'اَلدَّرْسُ الرّابِعُ', 'subtitle': 'به زودی'},
    {'number': '05', 'title': 'اَلدَّرْسُ الْخامِسُ', 'subtitle': 'به زودی'},
    {'number': '06', 'title': 'اَلدَّرْسُ السّادِسُ', 'subtitle': 'به زودی'},
    {'number': '07', 'title': 'اَلدَّرْسُ السّابِعُ', 'subtitle': 'به زودی'},
    {'number': '08', 'title': 'اَلدَّرْسُ الثّامِنُ', 'subtitle': 'به زودی'},
    {'number': '09', 'title': 'اَلدَّرْسُ التّاسِعُ', 'subtitle': 'به زودی'},
    {'number': '10', 'title': 'اَلدَّرْسُ الْعاشِِرُ', 'subtitle': 'به زودی'},
    {'number': '11', 'title': 'اَلدَّرْسُ الْحادِی عَشَرَ', 'subtitle': 'به زودی'},
    {'number': '12', 'title': 'اَلدَّرْسُ الثّانی عَشَرَ', 'subtitle': 'به زودی'},
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
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.6), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
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
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                    ),
                    child: const Text('📖', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'کتاب قرآن پایه هشتم 🌟',
                          style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'لیست بازی 🎮 های ۱۲ درس قرآن هشتم',
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
                  itemCount: quran8Lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = quran8Lessons[index];
                    final bool isPlayable = index >= 0 && index <= 11;
                    final bool isCompleted = _isQuran8LessonCompleted(index + 1);

                    final Color itemAccentColor = isCompleted
                        ? const Color(0xFF10B981)
                        : (isPlayable ? const Color(0xFF10B981) : const Color(0xFF334155));
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
                              : (isPlayable ? const Color(0xFF10B981) : const Color(0xFF10B981).withOpacity(0.3)),
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
                              _showQuran8Lesson1PartsModal(context);
                            } else if (index == 1) {
                              _showQuran8Lesson2PartsModal(context);
                            } else if (index == 2) {
                              _showQuran8Lesson3PartsModal(context);
                            } else if (index == 3) {
                              _showQuran8Lesson4PartsModal(context);
                            } else if (index == 4) {
                              _showQuran8Lesson5PartsModal(context);
                            } else if (index == 5) {
                              _showQuran8Lesson6PartsModal(context);
                            } else if (index == 6) {
                              _showQuran8Lesson7PartsModal(context);
                            } else if (index == 7) {
                              _showQuran8Lesson8PartsModal(context);
                            } else if (index == 8) {
                              _showQuran8Lesson9PartsModal(context);
                            } else if (index == 9) {
                              _showQuran8Lesson10PartsModal(context);
                            } else if (index == 10) {
                              _showQuran8Lesson11PartsModal(context);
                            } else if (index == 11) {
                              _showQuran8Lesson12PartsModal(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('بازی ${lesson['title']} قرآن هشتم به زودی فعال می‌شود! 🚀'),
                                  backgroundColor: const Color(0xFF10B981),
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
                                        color: isCompleted ? const Color(0xFF6EE7B7) : const Color(0xFF34D399),
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
              const SizedBox(height: 12),
              // دکمه ورود به لیگ کلاسی قرآن هشتم
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF064E3B), Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.pop(context, 'open_league');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          const Text(
                            'لیگ کلاسی قرآن هشتم',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showQuran8Lesson1PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran8Lesson1Part1Completed;
  final bool p2Completed = AuthManager.quran8Lesson1Part2Completed;
  final bool p3Completed = AuthManager.quran8Lesson1Part3Completed;

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
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'قرآن پایه هشتم - درس اول 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuran8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF10B981),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'قرآن هشتم - درس اول',
                        lessonKey: 'quran8_lesson1',
                        customVocabulary: Quran8Data.lesson1Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس اول',
                        lessonKey: 'quran8_lesson1_p2',
                        customWords: Quran8Data.lesson1Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس اول',
                        lessonKey: 'quran8_lesson1_p3',
                        customWords: Quran8Data.lesson1Part3Vocab,
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

void _showQuran8Lesson2PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran8Lesson2Part1Completed;
  final bool p2Completed = AuthManager.quran8Lesson2Part2Completed;
  final bool p3Completed = AuthManager.quran8Lesson2Part3Completed;

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
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'قرآن پایه هشتم - درس دوم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuran8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF10B981),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'قرآن هشتم - درس دوم',
                        lessonKey: 'quran8_lesson2',
                        customVocabulary: Quran8Data.lesson2Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس دوم',
                        lessonKey: 'quran8_lesson2_p2',
                        customWords: Quran8Data.lesson2Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس دوم',
                        lessonKey: 'quran8_lesson2_p3',
                        customWords: Quran8Data.lesson2Part3Vocab,
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

void _showQuran8Lesson3PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran8Lesson3Part1Completed;
  final bool p2Completed = AuthManager.quran8Lesson3Part2Completed;
  final bool p3Completed = AuthManager.quran8Lesson3Part3Completed;

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
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'قرآن پایه هشتم - درس سوم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuran8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF10B981),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'قرآن هشتم - درس سوم',
                        lessonKey: 'quran8_lesson3',
                        customVocabulary: Quran8Data.lesson3Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس سوم',
                        lessonKey: 'quran8_lesson3_p2',
                        customWords: Quran8Data.lesson3Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس سوم',
                        lessonKey: 'quran8_lesson3_p3',
                        customWords: Quran8Data.lesson3Part3Vocab,
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

void _showQuran8Lesson4PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran8Lesson4Part1Completed;
  final bool p2Completed = AuthManager.quran8Lesson4Part2Completed;
  final bool p3Completed = AuthManager.quran8Lesson4Part3Completed;

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
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'قرآن پایه هشتم - درس چهارم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuran8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF10B981),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'قرآن هشتم - درس چهارم',
                        lessonKey: 'quran8_lesson4',
                        customVocabulary: Quran8Data.lesson4Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس چهارم',
                        lessonKey: 'quran8_lesson4_p2',
                        customWords: Quran8Data.lesson4Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس چهارم',
                        lessonKey: 'quran8_lesson4_p3',
                        customWords: Quran8Data.lesson4Part3Vocab,
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

void _showQuran8Lesson5PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran8Lesson5Part1Completed;
  final bool p2Completed = AuthManager.quran8Lesson5Part2Completed;
  final bool p3Completed = AuthManager.quran8Lesson5Part3Completed;

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
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'قرآن پایه هشتم - درس پنجم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuran8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF10B981),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'قرآن هشتم - درس پنجم',
                        lessonKey: 'quran8_lesson5',
                        customVocabulary: Quran8Data.lesson5Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس پنجم',
                        lessonKey: 'quran8_lesson5_p2',
                        customWords: Quran8Data.lesson5Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس پنجم',
                        lessonKey: 'quran8_lesson5_p3',
                        customWords: Quran8Data.lesson5Part3Vocab,
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

void _showQuran8Lesson6PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran8Lesson6Part1Completed;
  final bool p2Completed = AuthManager.quran8Lesson6Part2Completed;
  final bool p3Completed = AuthManager.quran8Lesson6Part3Completed;

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
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'قرآن پایه هشتم - درس ششم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuran8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF10B981),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'قرآن هشتم - درس ششم',
                        lessonKey: 'quran8_lesson6',
                        customVocabulary: Quran8Data.lesson6Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس ششم',
                        lessonKey: 'quran8_lesson6_p2',
                        customWords: Quran8Data.lesson6Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس ششم',
                        lessonKey: 'quran8_lesson6_p3',
                        customWords: Quran8Data.lesson6Part3Vocab,
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

void _showQuran8Lesson7PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran8Lesson7Part1Completed;
  final bool p2Completed = AuthManager.quran8Lesson7Part2Completed;
  final bool p3Completed = AuthManager.quran8Lesson7Part3Completed;

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
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'قرآن پایه هشتم - درس هفتم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuran8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF10B981),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'قرآن هشتم - درس هفتم',
                        lessonKey: 'quran8_lesson7',
                        customVocabulary: Quran8Data.lesson7Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس هفتم',
                        lessonKey: 'quran8_lesson7_p2',
                        customWords: Quran8Data.lesson7Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس هفتم',
                        lessonKey: 'quran8_lesson7_p3',
                        customWords: Quran8Data.lesson7Part3Vocab,
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

void _showQuran8Lesson8PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran8Lesson8Part1Completed;
  final bool p2Completed = AuthManager.quran8Lesson8Part2Completed;
  final bool p3Completed = AuthManager.quran8Lesson8Part3Completed;

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
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'قرآن پایه هشتم - درس هشتم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuran8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF10B981),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'قرآن هشتم - درس هشتم',
                        lessonKey: 'quran8_lesson8',
                        customVocabulary: Quran8Data.lesson8Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس هشتم',
                        lessonKey: 'quran8_lesson8_p2',
                        customWords: Quran8Data.lesson8Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس هشتم',
                        lessonKey: 'quran8_lesson8_p3',
                        customWords: Quran8Data.lesson8Part3Vocab,
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

void _showQuran8Lesson9PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran8Lesson9Part1Completed;
  final bool p2Completed = AuthManager.quran8Lesson9Part2Completed;
  final bool p3Completed = AuthManager.quran8Lesson9Part3Completed;

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
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'قرآن پایه هشتم - درس نهم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuran8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF10B981),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'قرآن هشتم - درس نهم',
                        lessonKey: 'quran8_lesson9',
                        customVocabulary: Quran8Data.lesson9Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس نهم',
                        lessonKey: 'quran8_lesson9_p2',
                        customWords: Quran8Data.lesson9Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس نهم',
                        lessonKey: 'quran8_lesson9_p3',
                        customWords: Quran8Data.lesson9Part3Vocab,
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

void _showQuran8Lesson10PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran8Lesson10Part1Completed;
  final bool p2Completed = AuthManager.quran8Lesson10Part2Completed;
  final bool p3Completed = AuthManager.quran8Lesson10Part3Completed;

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
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'قرآن پایه هشتم - درس دهم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuran8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF10B981),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'قرآن هشتم - درس دهم',
                        lessonKey: 'quran8_lesson10',
                        customVocabulary: Quran8Data.lesson10Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس دهم',
                        lessonKey: 'quran8_lesson10_p2',
                        customWords: Quran8Data.lesson10Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس دهم',
                        lessonKey: 'quran8_lesson10_p3',
                        customWords: Quran8Data.lesson10Part3Vocab,
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

void _showQuran8Lesson11PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran8Lesson11Part1Completed;
  final bool p2Completed = AuthManager.quran8Lesson11Part2Completed;
  final bool p3Completed = AuthManager.quran8Lesson11Part3Completed;

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
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'قرآن پایه هشتم - درس یازدهم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuran8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF10B981),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'قرآن هشتم - درس یازدهم',
                        lessonKey: 'quran8_lesson11',
                        customVocabulary: Quran8Data.lesson11Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس یازدهم',
                        lessonKey: 'quran8_lesson11_p2',
                        customWords: Quran8Data.lesson11Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس یازدهم',
                        lessonKey: 'quran8_lesson11_p3',
                        customWords: Quran8Data.lesson11Part3Vocab,
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

void _showQuran8Lesson12PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran8Lesson12Part1Completed;
  final bool p2Completed = AuthManager.quran8Lesson12Part2Completed;
  final bool p3Completed = AuthManager.quran8Lesson12Part3Completed;

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
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'قرآن پایه هشتم - درس دوازدهم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuran8PartButton(
                title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                icon: '🧩',
                color: const Color(0xFF10B981),
                isCompleted: p1Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1GameScreen(
                        lessonTitle: 'قرآن هشتم - درس دوازدهم',
                        lessonKey: 'quran8_lesson12',
                        customVocabulary: Quran8Data.lesson12Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuran8PartButton(
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
                        lessonTitle: 'قرآن هشتم - درس دوازدهم',
                        lessonKey: 'quran8_lesson12_p2',
                        customWords: Quran8Data.lesson12Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuran8PartButton(
                title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part3RocketGameScreen(
                        lessonTitle: 'قرآن هشتم - درس دوازدهم',
                        lessonKey: 'quran8_lesson12_p3',
                        customWords: Quran8Data.lesson12Part3Vocab,
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

Widget _buildQuran8PartButton({required String title, String icon = '', required Color color, required VoidCallback onTap, bool isCompleted = false}) {
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
