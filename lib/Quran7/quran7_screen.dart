import 'package:flutter/material.dart';
import 'quran7_data.dart';
import '../managers/auth_manager.dart';
import '../screens/home_screen.dart';

bool _isQuran7LessonCompleted(int lessonNum) {
  switch (lessonNum) {
    case 1:
      return AuthManager.quran7Lesson1Part1Completed &&
          AuthManager.quran7Lesson1Part2Completed &&
          AuthManager.quran7Lesson1Part3Completed;
    case 2:
      return AuthManager.quran7Lesson2Part1Completed &&
          AuthManager.quran7Lesson2Part2Completed &&
          AuthManager.quran7Lesson2Part3Completed;
    case 3:
      return AuthManager.quran7Lesson3Part1Completed &&
          AuthManager.quran7Lesson3Part2Completed &&
          AuthManager.quran7Lesson3Part3Completed;
    case 4:
      return AuthManager.quran7Lesson4Part1Completed &&
          AuthManager.quran7Lesson4Part2Completed &&
          AuthManager.quran7Lesson4Part3Completed;
    case 5:
      return AuthManager.quran7Lesson5Part1Completed &&
          AuthManager.quran7Lesson5Part2Completed &&
          AuthManager.quran7Lesson5Part3Completed;
    case 6:
      return AuthManager.quran7Lesson6Part1Completed &&
          AuthManager.quran7Lesson6Part2Completed &&
          AuthManager.quran7Lesson6Part3Completed;
    case 7:
      return AuthManager.quran7Lesson7Part1Completed &&
          AuthManager.quran7Lesson7Part2Completed &&
          AuthManager.quran7Lesson7Part3Completed;
    case 8:
      return AuthManager.quran7Lesson8Part1Completed &&
          AuthManager.quran7Lesson8Part2Completed &&
          AuthManager.quran7Lesson8Part3Completed;
    case 9:
      return AuthManager.quran7Lesson9Part1Completed &&
          AuthManager.quran7Lesson9Part2Completed &&
          AuthManager.quran7Lesson9Part3Completed;
    case 10:
      return AuthManager.quran7Lesson10Part1Completed &&
          AuthManager.quran7Lesson10Part2Completed &&
          AuthManager.quran7Lesson10Part3Completed;
    case 11:
      return AuthManager.quran7Lesson11Part1Completed &&
          AuthManager.quran7Lesson11Part2Completed &&
          AuthManager.quran7Lesson11Part3Completed;
    case 12:
      return AuthManager.quran7Lesson12Part1Completed &&
          AuthManager.quran7Lesson12Part2Completed &&
          AuthManager.quran7Lesson12Part3Completed;
    default:
      return false;
  }
}

Future<dynamic> showQuran7LessonsModal(BuildContext context) {
  final List<Map<String, String>> quran7Lessons = [
    {'number': '01', 'title': 'اَلدَّرْسُ الْأَوَّلُ', 'subtitle': 'سوره ناس / تبارک / ...'},
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
                          'کتاب قرآن پایه هفتم 🌟',
                          style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'لیست بازی 🎮 های ۱۲ درس قرآن هفتم',
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
                  itemCount: quran7Lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = quran7Lessons[index];
                    final bool isPlayable = index >= 0 && index <= 11;
                    final bool isCompleted = _isQuran7LessonCompleted(index + 1);

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
                              _showQuran7Lesson1PartsModal(context);
                            } else if (index == 1) {
                              _showQuran7Lesson2PartsModal(context);
                            } else if (index == 2) {
                              _showQuran7Lesson3PartsModal(context);
                            } else if (index == 3) {
                              _showQuran7Lesson4PartsModal(context);
                            } else if (index == 4) {
                              _showQuran7Lesson5PartsModal(context);
                            } else if (index == 5) {
                              _showQuran7Lesson6PartsModal(context);
                            } else if (index == 6) {
                              _showQuran7Lesson7PartsModal(context);
                            } else if (index == 7) {
                              _showQuran7Lesson8PartsModal(context);
                            } else if (index == 8) {
                              _showQuran7Lesson9PartsModal(context);
                            } else if (index == 9) {
                              _showQuran7Lesson10PartsModal(context);
                            } else if (index == 10) {
                              _showQuran7Lesson11PartsModal(context);
                            } else if (index == 11) {
                              _showQuran7Lesson12PartsModal(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('بازی ${lesson['title']} قرآن هفتم به زودی فعال می‌شود! 🚀'),
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
              // دکمه ورود به لیگ کلاسی قرآن هفتم
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF047857), Color(0xFF10B981), Color(0xFF059669)],
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
                            'لیگ کلاسی قرآن هفتم',
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

void _showQuran7Lesson1PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran7Lesson1Part1Completed;
  final bool p2Completed = AuthManager.quran7Lesson1Part2Completed;
  final bool p3Completed = AuthManager.quran7Lesson1Part3Completed;

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
                'قرآن پایه هفتم - درس اول 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس اول',
                        lessonKey: 'quran7_lesson1',
                        customVocabulary: Quran7Data.lesson1Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس اول',
                        lessonKey: 'quran7_lesson1_p2',
                        customWords: Quran7Data.lesson1Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس اول',
                        lessonKey: 'quran7_lesson1_p3',
                        customWords: Quran7Data.lesson1Part3Vocab,
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

void _showQuran7Lesson2PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran7Lesson2Part1Completed;
  final bool p2Completed = AuthManager.quran7Lesson2Part2Completed;
  final bool p3Completed = AuthManager.quran7Lesson2Part3Completed;

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
                'قرآن پایه هفتم - درس دوم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس دوم',
                        lessonKey: 'quran7_lesson2',
                        customVocabulary: Quran7Data.lesson2Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس دوم',
                        lessonKey: 'quran7_lesson2_p2',
                        customWords: Quran7Data.lesson2Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس دوم',
                        lessonKey: 'quran7_lesson2_p3',
                        customWords: Quran7Data.lesson2Part3Vocab,
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

void _showQuran7Lesson3PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran7Lesson3Part1Completed;
  final bool p2Completed = AuthManager.quran7Lesson3Part2Completed;
  final bool p3Completed = AuthManager.quran7Lesson3Part3Completed;

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
                'قرآن پایه هفتم - درس سوم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس سوم',
                        lessonKey: 'quran7_lesson3',
                        customVocabulary: Quran7Data.lesson3Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس سوم',
                        lessonKey: 'quran7_lesson3_p2',
                        customWords: Quran7Data.lesson3Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس سوم',
                        lessonKey: 'quran7_lesson3_p3',
                        customWords: Quran7Data.lesson3Part3Vocab,
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

void _showQuran7Lesson4PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran7Lesson4Part1Completed;
  final bool p2Completed = AuthManager.quran7Lesson4Part2Completed;
  final bool p3Completed = AuthManager.quran7Lesson4Part3Completed;

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
                'قرآن پایه هفتم - درس چهارم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس چهارم',
                        lessonKey: 'quran7_lesson4',
                        customVocabulary: Quran7Data.lesson4Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس چهارم',
                        lessonKey: 'quran7_lesson4_p2',
                        customWords: Quran7Data.lesson4Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس چهارم',
                        lessonKey: 'quran7_lesson4_p3',
                        customWords: Quran7Data.lesson4Part3Vocab,
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

void _showQuran7Lesson5PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran7Lesson5Part1Completed;
  final bool p2Completed = AuthManager.quran7Lesson5Part2Completed;
  final bool p3Completed = AuthManager.quran7Lesson5Part3Completed;

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
                'قرآن پایه هفتم - درس پنجم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس پنجم',
                        lessonKey: 'quran7_lesson5',
                        customVocabulary: Quran7Data.lesson5Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس پنجم',
                        lessonKey: 'quran7_lesson5_p2',
                        customWords: Quran7Data.lesson5Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس پنجم',
                        lessonKey: 'quran7_lesson5_p3',
                        customWords: Quran7Data.lesson5Part3Vocab,
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

void _showQuran7Lesson6PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran7Lesson6Part1Completed;
  final bool p2Completed = AuthManager.quran7Lesson6Part2Completed;
  final bool p3Completed = AuthManager.quran7Lesson6Part3Completed;

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
                'قرآن پایه هفتم - درس ششم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس ششم',
                        lessonKey: 'quran7_lesson6',
                        customVocabulary: Quran7Data.lesson6Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس ششم',
                        lessonKey: 'quran7_lesson6_p2',
                        customWords: Quran7Data.lesson6Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس ششم',
                        lessonKey: 'quran7_lesson6_p3',
                        customWords: Quran7Data.lesson6Part3Vocab,
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

void _showQuran7Lesson7PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran7Lesson7Part1Completed;
  final bool p2Completed = AuthManager.quran7Lesson7Part2Completed;
  final bool p3Completed = AuthManager.quran7Lesson7Part3Completed;

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
                'قرآن پایه هفتم - درس هفتم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس هفتم',
                        lessonKey: 'quran7_lesson7',
                        customVocabulary: Quran7Data.lesson7Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس هفتم',
                        lessonKey: 'quran7_lesson7_p2',
                        customWords: Quran7Data.lesson7Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس هفتم',
                        lessonKey: 'quran7_lesson7_p3',
                        customWords: Quran7Data.lesson7Part3Vocab,
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

void _showQuran7Lesson8PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran7Lesson8Part1Completed;
  final bool p2Completed = AuthManager.quran7Lesson8Part2Completed;
  final bool p3Completed = AuthManager.quran7Lesson8Part3Completed;

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
                'قرآن پایه هفتم - درس هشتم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس هشتم',
                        lessonKey: 'quran7_lesson8',
                        customVocabulary: Quran7Data.lesson8Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس هشتم',
                        lessonKey: 'quran7_lesson8_p2',
                        customWords: Quran7Data.lesson8Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس هشتم',
                        lessonKey: 'quran7_lesson8_p3',
                        customWords: Quran7Data.lesson8Part3Vocab,
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

void _showQuran7Lesson9PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran7Lesson9Part1Completed;
  final bool p2Completed = AuthManager.quran7Lesson9Part2Completed;
  final bool p3Completed = AuthManager.quran7Lesson9Part3Completed;

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
                'قرآن پایه هفتم - درس نهم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس نهم',
                        lessonKey: 'quran7_lesson9',
                        customVocabulary: Quran7Data.lesson9Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس نهم',
                        lessonKey: 'quran7_lesson9_p2',
                        customWords: Quran7Data.lesson9Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس نهم',
                        lessonKey: 'quran7_lesson9_p3',
                        customWords: Quran7Data.lesson9Part3Vocab,
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

void _showQuran7Lesson10PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran7Lesson10Part1Completed;
  final bool p2Completed = AuthManager.quran7Lesson10Part2Completed;
  final bool p3Completed = AuthManager.quran7Lesson10Part3Completed;

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
                'قرآن پایه هفتم - درس دهم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس دهم',
                        lessonKey: 'quran7_lesson10',
                        customVocabulary: Quran7Data.lesson10Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس دهم',
                        lessonKey: 'quran7_lesson10_p2',
                        customWords: Quran7Data.lesson10Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس دهم',
                        lessonKey: 'quran7_lesson10_p3',
                        customWords: Quran7Data.lesson10Part3Vocab,
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

void _showQuran7Lesson11PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran7Lesson11Part1Completed;
  final bool p2Completed = AuthManager.quran7Lesson11Part2Completed;
  final bool p3Completed = AuthManager.quran7Lesson11Part3Completed;

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
                'قرآن پایه هفتم - درس یازدهم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس یازدهم',
                        lessonKey: 'quran7_lesson11',
                        customVocabulary: Quran7Data.lesson11Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس یازدهم',
                        lessonKey: 'quran7_lesson11_p2',
                        customWords: Quran7Data.lesson11Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس یازدهم',
                        lessonKey: 'quran7_lesson11_p3',
                        customWords: Quran7Data.lesson11Part3Vocab,
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

void _showQuran7Lesson12PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.quran7Lesson12Part1Completed;
  final bool p2Completed = AuthManager.quran7Lesson12Part2Completed;
  final bool p3Completed = AuthManager.quran7Lesson12Part3Completed;

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
                'قرآن پایه هفتم - درس دوازدهم 📖',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس دوازدهم',
                        lessonKey: 'quran7_lesson12',
                        customVocabulary: Quran7Data.lesson12Part1Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildQuranPartButton(
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
                        lessonTitle: 'قرآن هفتم - درس دوازدهم',
                        lessonKey: 'quran7_lesson12_p2',
                        customWords: Quran7Data.lesson12Part2Vocab,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildQuranPartButton(
                title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArabicLesson1Part3RocketGameScreen(
                        lessonTitle: 'قرآن هفتم - درس دوازدهم',
                        lessonKey: 'quran7_lesson12_p3',
                        customWords: Quran7Data.lesson12Part3Vocab,
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

Widget _buildQuranPartButton({required String title, String icon = '', required Color color, required VoidCallback onTap, bool isCompleted = false}) {
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
