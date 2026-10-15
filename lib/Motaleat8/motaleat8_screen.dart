import 'package:flutter/material.dart';
import 'motaleat8_game_screen.dart';
import '../managers/auth_manager.dart';

bool _isMotaleat8LessonCompleted(int lessonNum) {
  switch (lessonNum) {
    case 1:
      return AuthManager.motaleat8Lesson1Part1Completed &&
          AuthManager.motaleat8Lesson1Part2Completed &&
          AuthManager.motaleat8Lesson1Part3Completed;
    case 2:
      return AuthManager.motaleat8Lesson2Part1Completed &&
          AuthManager.motaleat8Lesson2Part2Completed &&
          AuthManager.motaleat8Lesson2Part3Completed;
    case 3:
      return AuthManager.motaleat8Lesson3Part1Completed &&
          AuthManager.motaleat8Lesson3Part2Completed &&
          AuthManager.motaleat8Lesson3Part3Completed;
    case 4:
      return AuthManager.motaleat8Lesson4Part1Completed &&
          AuthManager.motaleat8Lesson4Part2Completed &&
          AuthManager.motaleat8Lesson4Part3Completed;
    case 5:
      return AuthManager.motaleat8Lesson5Part1Completed &&
          AuthManager.motaleat8Lesson5Part2Completed &&
          AuthManager.motaleat8Lesson5Part3Completed;
    case 6:
      return AuthManager.motaleat8Lesson6Part1Completed &&
          AuthManager.motaleat8Lesson6Part2Completed &&
          AuthManager.motaleat8Lesson6Part3Completed;
    case 7:
      return AuthManager.motaleat8Lesson7Part1Completed &&
          AuthManager.motaleat8Lesson7Part2Completed &&
          AuthManager.motaleat8Lesson7Part3Completed;
    case 8:
      return AuthManager.motaleat8Lesson8Part1Completed &&
          AuthManager.motaleat8Lesson8Part2Completed &&
          AuthManager.motaleat8Lesson8Part3Completed;
    case 9:
      return AuthManager.motaleat8Lesson9Part1Completed &&
          AuthManager.motaleat8Lesson9Part2Completed &&
          AuthManager.motaleat8Lesson9Part3Completed;
    case 10:
      return AuthManager.motaleat8Lesson10Part1Completed &&
          AuthManager.motaleat8Lesson10Part2Completed &&
          AuthManager.motaleat8Lesson10Part3Completed;
    case 11:
      return AuthManager.motaleat8Lesson11Part1Completed &&
          AuthManager.motaleat8Lesson11Part2Completed &&
          AuthManager.motaleat8Lesson11Part3Completed;
    case 12:
      return AuthManager.motaleat8Lesson12Part1Completed &&
          AuthManager.motaleat8Lesson12Part2Completed &&
          AuthManager.motaleat8Lesson12Part3Completed;
    default:
      return false;
  }
}

Future<void> showMotaleat8LessonsModal(BuildContext context) {
  final List<Map<String, String>> motaleat8Lessons = [
    {'number': '01', 'title': 'فصل اول: تعاون', 'subtitle': ''},
    {'number': '02', 'title': 'فصل دوم: نقش دولت در ادارهٔ کشور', 'subtitle': ''},
    {'number': '03', 'title': 'فصل سوم: نوجوانان و قانون', 'subtitle': ''},
    {'number': '04', 'title': 'فصل چهارم: عصر ارتباطات', 'subtitle': ''},
    {'number': '05', 'title': 'فصل پنجم: از حرا تا نینوا', 'subtitle': ''},
    {'number': '06', 'title': 'فصل ششم: عصری تازه در تاریخ ایران', 'subtitle': ''},
    {'number': '07', 'title': 'فصل هفتم: از غزنویان تا هجوم چنگیزخان', 'subtitle': ''},
    {'number': '08', 'title': 'فصل هشتم: عصر مغول و تیموری', 'subtitle': ''},
    {'number': '09', 'title': 'فصل نهم: آسیا، پهناورترین قارّه', 'subtitle': ''},
    {'number': '10', 'title': 'فصل دهم: منطقۀ جنوب غربی آسیا و جایگاه ایران در آن', 'subtitle': ''},
    {'number': '11', 'title': 'فصل یازدهم: اروپا و افریقا', 'subtitle': ''},
    {'number': '12', 'title': 'فصل دوازدهم: قاره آمریکا و قاره اقیانوسیه', 'subtitle': ''},
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
                          'کتاب مطالعات اجتماعی پایه هشتم 🌍',
                          style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'لیست بازی 🎮 های ۱۲ فصل مطالعات هشتم',
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
                  itemCount: motaleat8Lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = motaleat8Lessons[index];
                    final bool isPlayable = (index >= 0 && index <= 11);
                    final bool isCompleted = _isMotaleat8LessonCompleted(index + 1);

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
                              _showMotaleat8Lesson1PartsModal(context);
                            } else if (index == 1) {
                              _showMotaleat8Lesson2PartsModal(context);
                            } else if (index == 2) {
                              _showMotaleat8Lesson3PartsModal(context);
                            } else if (index == 3) {
                              _showMotaleat8Lesson4PartsModal(context);
                            } else if (index == 4) {
                              _showMotaleat8Lesson5PartsModal(context);
                            } else if (index == 5) {
                              _showMotaleat8Lesson6PartsModal(context);
                            } else if (index == 6) {
                              _showMotaleat8Lesson7PartsModal(context);
                            } else if (index == 7) {
                              _showMotaleat8Lesson8PartsModal(context);
                            } else if (index == 8) {
                              _showMotaleat8Lesson9PartsModal(context);
                            } else if (index == 9) {
                              _showMotaleat8Lesson10PartsModal(context);
                            } else if (index == 10) {
                              _showMotaleat8Lesson11PartsModal(context);
                            } else if (index == 11) {
                              _showMotaleat8Lesson12PartsModal(context);
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

void _showMotaleat8Lesson1PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat8Lesson1Part1Completed;
  final bool p2Completed = AuthManager.motaleat8Lesson1Part2Completed;
  final bool p3Completed = AuthManager.motaleat8Lesson1Part3Completed;

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
                'مطالعات اجتماعی هشتم - فصل ۱ (تعاون) 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat8_lesson1_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat8_lesson1_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat8_lesson1_p3',
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

void _showMotaleat8Lesson2PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat8Lesson2Part1Completed;
  final bool p2Completed = AuthManager.motaleat8Lesson2Part2Completed;
  final bool p3Completed = AuthManager.motaleat8Lesson2Part3Completed;

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
                'مطالعات اجتماعی هشتم - فصل ۲ (نقش دولت) 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat8_lesson2_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat8_lesson2_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat8_lesson2_p3',
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

void _showMotaleat8Lesson3PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat8Lesson3Part1Completed;
  final bool p2Completed = AuthManager.motaleat8Lesson3Part2Completed;
  final bool p3Completed = AuthManager.motaleat8Lesson3Part3Completed;

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
                'مطالعات اجتماعی هشتم - فصل ۳ (نوجوانان و قانون) 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat8_lesson3_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat8_lesson3_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat8_lesson3_p3',
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

void _showMotaleat8Lesson4PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat8Lesson4Part1Completed;
  final bool p2Completed = AuthManager.motaleat8Lesson4Part2Completed;
  final bool p3Completed = AuthManager.motaleat8Lesson4Part3Completed;

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
                'مطالعات اجتماعی هشتم - فصل ۴ (عصر ارتباطات) 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat8_lesson4_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat8_lesson4_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat8_lesson4_p3',
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

void _showMotaleat8Lesson5PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat8Lesson5Part1Completed;
  final bool p2Completed = AuthManager.motaleat8Lesson5Part2Completed;
  final bool p3Completed = AuthManager.motaleat8Lesson5Part3Completed;

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
                'مطالعات اجتماعی هشتم - فصل ۵ (از حرا تا نینوا) 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat8_lesson5_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat8_lesson5_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat8_lesson5_p3',
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

void _showMotaleat8Lesson6PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat8Lesson6Part1Completed;
  final bool p2Completed = AuthManager.motaleat8Lesson6Part2Completed;
  final bool p3Completed = AuthManager.motaleat8Lesson6Part3Completed;

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
                'مطالعات اجتماعی هشتم - فصل ۶ (عصری تازه در تاریخ ایران) 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat8_lesson6_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat8_lesson6_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat8_lesson6_p3',
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

void _showMotaleat8Lesson7PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat8Lesson7Part1Completed;
  final bool p2Completed = AuthManager.motaleat8Lesson7Part2Completed;
  final bool p3Completed = AuthManager.motaleat8Lesson7Part3Completed;

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
                'مطالعات اجتماعی هشتم - فصل ۷ (از غزنویان تا هجوم چنگیزخان) 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat8_lesson7_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat8_lesson7_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat8_lesson7_p3',
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

void _showMotaleat8Lesson8PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat8Lesson8Part1Completed;
  final bool p2Completed = AuthManager.motaleat8Lesson8Part2Completed;
  final bool p3Completed = AuthManager.motaleat8Lesson8Part3Completed;

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
                'مطالعات اجتماعی هشتم - فصل ۸ (عصر مغول و تیموری) 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat8_lesson8_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat8_lesson8_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat8_lesson8_p3',
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

void _showMotaleat8Lesson9PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat8Lesson9Part1Completed;
  final bool p2Completed = AuthManager.motaleat8Lesson9Part2Completed;
  final bool p3Completed = AuthManager.motaleat8Lesson9Part3Completed;

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
                'مطالعات اجتماعی هشتم - فصل ۹ (آسیا، پهناورترین قارّه) 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat8_lesson9_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat8_lesson9_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat8_lesson9_p3',
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

void _showMotaleat8Lesson10PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat8Lesson10Part1Completed;
  final bool p2Completed = AuthManager.motaleat8Lesson10Part2Completed;
  final bool p3Completed = AuthManager.motaleat8Lesson10Part3Completed;

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
                'مطالعات اجتماعی هشتم - فصل ۱۰ (جنوب غربی آسیا) 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat8_lesson10_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat8_lesson10_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat8_lesson10_p3',
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

void _showMotaleat8Lesson11PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat8Lesson11Part1Completed;
  final bool p2Completed = AuthManager.motaleat8Lesson11Part2Completed;
  final bool p3Completed = AuthManager.motaleat8Lesson11Part3Completed;

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
                'مطالعات اجتماعی هشتم - فصل ۱۱ (اروپا و افریقا) 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat8_lesson11_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat8_lesson11_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat8_lesson11_p3',
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

void _showMotaleat8Lesson12PartsModal(BuildContext context) {
  final bool p1Completed = AuthManager.motaleat8Lesson12Part1Completed;
  final bool p2Completed = AuthManager.motaleat8Lesson12Part2Completed;
  final bool p3Completed = AuthManager.motaleat8Lesson12Part3Completed;

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
                'مطالعات اجتماعی هشتم - فصل ۱۲ (آمریکا و اقیانوسیه) 🌍',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat8_lesson12_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat8_lesson12_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Motaleat8HtmlGameScreen(
                        gameTitle: 'مطالعات هشتم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat8_lesson12_p3',
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

Widget _buildMotaleat8PartButton({required String title, String icon = '', required Color color, required VoidCallback onTap, bool isCompleted = false}) {
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
