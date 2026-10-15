import 'package:flutter/material.dart';
import 'motaleat7_game_screen.dart';
import '../managers/auth_manager.dart';

bool _isMotaleat7LessonCompleted(int lessonNum) {
  switch (lessonNum) {
    case 1:
      return AuthManager.motaleat7Lesson1Part1Completed &&
          AuthManager.motaleat7Lesson1Part2Completed &&
          AuthManager.motaleat7Lesson1Part3Completed;
    case 2:
      return AuthManager.motaleat7Lesson2Part1Completed &&
          AuthManager.motaleat7Lesson2Part2Completed &&
          AuthManager.motaleat7Lesson2Part3Completed;
    case 3:
      return AuthManager.motaleat7Lesson3Part1Completed &&
          AuthManager.motaleat7Lesson3Part2Completed &&
          AuthManager.motaleat7Lesson3Part3Completed;
    case 4:
      return AuthManager.motaleat7Lesson4Part1Completed &&
          AuthManager.motaleat7Lesson4Part2Completed &&
          AuthManager.motaleat7Lesson4Part3Completed;
    case 5:
      return AuthManager.motaleat7Lesson5Part1Completed &&
          AuthManager.motaleat7Lesson5Part2Completed &&
          AuthManager.motaleat7Lesson5Part3Completed;
    case 6:
      return AuthManager.motaleat7Lesson6Part1Completed &&
          AuthManager.motaleat7Lesson6Part2Completed &&
          AuthManager.motaleat7Lesson6Part3Completed;
    case 7:
      return AuthManager.motaleat7Lesson7Part1Completed &&
          AuthManager.motaleat7Lesson7Part2Completed &&
          AuthManager.motaleat7Lesson7Part3Completed;
    case 8:
      return AuthManager.motaleat7Lesson8Part1Completed &&
          AuthManager.motaleat7Lesson8Part2Completed &&
          AuthManager.motaleat7Lesson8Part3Completed;
    case 9:
      return AuthManager.motaleat7Lesson9Part1Completed &&
          AuthManager.motaleat7Lesson9Part2Completed &&
          AuthManager.motaleat7Lesson9Part3Completed;
    case 10:
      return AuthManager.motaleat7Lesson10Part1Completed &&
          AuthManager.motaleat7Lesson10Part2Completed &&
          AuthManager.motaleat7Lesson10Part3Completed;
    case 11:
      return AuthManager.motaleat7Lesson11Part1Completed &&
          AuthManager.motaleat7Lesson11Part2Completed &&
          AuthManager.motaleat7Lesson11Part3Completed;
    case 12:
      return AuthManager.motaleat7Lesson12Part1Completed &&
          AuthManager.motaleat7Lesson12Part2Completed &&
          AuthManager.motaleat7Lesson12Part3Completed;
    default:
      return false;
  }
}

Future<void> showMotaleat7LessonsModal(BuildContext context) {
  final List<Map<String, String>> motaleat7Lessons = [
    {'number': '01', 'title': 'فصل اول: حقوق و مسئولیت‌های ما', 'subtitle': ''},
    {'number': '02', 'title': 'فصل دوم: قانون', 'subtitle': ''},
    {'number': '03', 'title': 'فصل سوم: مقابله با حوادث', 'subtitle': ''},
    {'number': '04', 'title': 'فصل چهارم: تولید، توزیع، مصرف', 'subtitle': ''},
    {'number': '05', 'title': 'فصل پنجم: محیط زندگی خود را بشناسیم', 'subtitle': ''},
    {'number': '06', 'title': 'فصل ششم: از زیستگاه‌های ایران حفاظت کنیم', 'subtitle': ''},
    {'number': '07', 'title': 'فصل هفتم: جمعیت و منابع', 'subtitle': ''},
    {'number': '08', 'title': 'فصل هشتم: گردشگری در ایران', 'subtitle': ''},
    {'number': '09', 'title': 'فصل نهم: سرزمین ما، کاوش در گذشته‌های دور', 'subtitle': ''},
    {'number': '10', 'title': 'فصل دهم: شکل‌گیری امپراتوری‌های بزرگ در ایران باستان', 'subtitle': ''},
    {'number': '11', 'title': 'فصل یازدهم: اوضاع اجتماعی و اقتصادی ایران باستان', 'subtitle': ''},
    {'number': '12', 'title': 'فصل دوازدهم: فرهنگ و تمدن ایران باستان', 'subtitle': ''},
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
            border: Border.all(color: const Color(0xFF06B6D4).withOpacity(0.6), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4),
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
                      color: const Color(0xFF06B6D4).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF06B6D4), width: 1.5),
                    ),
                    child: const Text('🌍', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'کتاب مطالعات اجتماعی پایه هفتم 🌍',
                          style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'لیست بازی 🎮 های ۱۲ فصل مطالعات هفتم',
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
                  itemCount: motaleat7Lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = motaleat7Lessons[index];
                    final bool isPlayable = (index >= 0 && index <= 11);
                    final bool isCompleted = _isMotaleat7LessonCompleted(index + 1);

                    final Color itemAccentColor = isCompleted
                        ? const Color(0xFF10B981)
                        : (isPlayable ? const Color(0xFF06B6D4) : const Color(0xFF334155));
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
                              : (isPlayable ? const Color(0xFF06B6D4) : const Color(0xFF06B6D4).withOpacity(0.3)),
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
                              _showMotaleat7Lesson1PartsModal(context);
                            } else if (index == 1) {
                              _showMotaleat7Lesson2PartsModal(context);
                            } else if (index == 2) {
                              _showMotaleat7Lesson3PartsModal(context);
                            } else if (index == 3) {
                              _showMotaleat7Lesson4PartsModal(context);
                            } else if (index == 4) {
                              _showMotaleat7Lesson5PartsModal(context);
                            } else if (index == 5) {
                              _showMotaleat7Lesson6PartsModal(context);
                            } else if (index == 6) {
                              _showMotaleat7Lesson7PartsModal(context);
                            } else if (index == 7) {
                              _showMotaleat7Lesson8PartsModal(context);
                            } else if (index == 8) {
                              _showMotaleat7Lesson9PartsModal(context);
                            } else if (index == 9) {
                              _showMotaleat7Lesson10PartsModal(context);
                            } else if (index == 10) {
                              _showMotaleat7Lesson11PartsModal(context);
                            } else if (index == 11) {
                              _showMotaleat7Lesson12PartsModal(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('بازی ${lesson['title']} به زودی فعال می‌شود! 🚀'),
                                  backgroundColor: const Color(0xFF06B6D4),
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
                                        color: isCompleted ? const Color(0xFF6EE7B7) : const Color(0xFF22D3EE),
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

void _showMotaleat7Lesson1PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat7Lesson1Part1Completed;
  final bool p2Completed = AuthManager.motaleat7Lesson1Part2Completed;
  final bool p3Completed = AuthManager.motaleat7Lesson1Part3Completed;

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
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مطالعات اجتماعی هفتم - فصل ۱ 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat7_lesson1_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat7_lesson1_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat7_lesson1_p3',
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

void _showMotaleat7Lesson2PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat7Lesson2Part1Completed;
  final bool p2Completed = AuthManager.motaleat7Lesson2Part2Completed;
  final bool p3Completed = AuthManager.motaleat7Lesson2Part3Completed;

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
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مطالعات اجتماعی هفتم - فصل ۲ 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat7_lesson2_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat7_lesson2_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat7_lesson2_p3',
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

void _showMotaleat7Lesson3PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat7Lesson3Part1Completed;
  final bool p2Completed = AuthManager.motaleat7Lesson3Part2Completed;
  final bool p3Completed = AuthManager.motaleat7Lesson3Part3Completed;

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
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مطالعات اجتماعی هفتم - فصل ۳ 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat7_lesson3_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat7_lesson3_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat7_lesson3_p3',
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

void _showMotaleat7Lesson4PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat7Lesson4Part1Completed;
  final bool p2Completed = AuthManager.motaleat7Lesson4Part2Completed;
  final bool p3Completed = AuthManager.motaleat7Lesson4Part3Completed;

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
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مطالعات اجتماعی هفتم - فصل ۴ 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat7_lesson4_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat7_lesson4_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat7_lesson4_p3',
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

void _showMotaleat7Lesson5PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat7Lesson5Part1Completed;
  final bool p2Completed = AuthManager.motaleat7Lesson5Part2Completed;
  final bool p3Completed = AuthManager.motaleat7Lesson5Part3Completed;

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
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مطالعات اجتماعی هفتم - فصل ۵ 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat7_lesson5_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat7_lesson5_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat7_lesson5_p3',
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

void _showMotaleat7Lesson6PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat7Lesson6Part1Completed;
  final bool p2Completed = AuthManager.motaleat7Lesson6Part2Completed;
  final bool p3Completed = AuthManager.motaleat7Lesson6Part3Completed;

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
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مطالعات اجتماعی هفتم - فصل ۶ 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat7_lesson6_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat7_lesson6_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat7_lesson6_p3',
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

void _showMotaleat7Lesson7PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat7Lesson7Part1Completed;
  final bool p2Completed = AuthManager.motaleat7Lesson7Part2Completed;
  final bool p3Completed = AuthManager.motaleat7Lesson7Part3Completed;

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
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مطالعات اجتماعی هفتم - فصل ۷ 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat7_lesson7_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat7_lesson7_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat7_lesson7_p3',
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

void _showMotaleat7Lesson8PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat7Lesson8Part1Completed;
  final bool p2Completed = AuthManager.motaleat7Lesson8Part2Completed;
  final bool p3Completed = AuthManager.motaleat7Lesson8Part3Completed;

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
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مطالعات اجتماعی هفتم - فصل ۸ 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat7_lesson8_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat7_lesson8_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat7_lesson8_p3',
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

void _showMotaleat7Lesson9PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat7Lesson9Part1Completed;
  final bool p2Completed = AuthManager.motaleat7Lesson9Part2Completed;
  final bool p3Completed = AuthManager.motaleat7Lesson9Part3Completed;

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
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مطالعات اجتماعی هفتم - فصل ۹ 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat7_lesson9_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat7_lesson9_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat7_lesson9_p3',
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

void _showMotaleat7Lesson10PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat7Lesson10Part1Completed;
  final bool p2Completed = AuthManager.motaleat7Lesson10Part2Completed;
  final bool p3Completed = AuthManager.motaleat7Lesson10Part3Completed;

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
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مطالعات اجتماعی هفتم - فصل ۱۰ 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat7_lesson10_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat7_lesson10_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat7_lesson10_p3',
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

void _showMotaleat7Lesson11PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat7Lesson11Part1Completed;
  final bool p2Completed = AuthManager.motaleat7Lesson11Part2Completed;
  final bool p3Completed = AuthManager.motaleat7Lesson11Part3Completed;

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
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مطالعات اجتماعی هفتم - فصل ۱۱ 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat7_lesson11_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat7_lesson11_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat7_lesson11_p3',
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

void _showMotaleat7Lesson12PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat7Lesson12Part1Completed;
  final bool p2Completed = AuthManager.motaleat7Lesson12Part2Completed;
  final bool p3Completed = AuthManager.motaleat7Lesson12Part3Completed;

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
            border: Border.all(color: const Color(0xFF06B6D4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مطالعات اجتماعی هفتم - فصل ۱۲ 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat7_lesson12_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat7_lesson12_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat7HtmlGameScreen(
                        gameTitle: 'مطالعات هفتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat7_lesson12_p3',
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

Widget _buildMotaleat7PartButton({required String title, String icon = '', required Color color, required VoidCallback onTap, bool isCompleted = false}) {
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
