import 'package:flutter/material.dart';
import 'payam8_game_screen.dart';
import '../managers/auth_manager.dart';

bool _isPayam8LessonCompleted(int lessonNum) {
  switch (lessonNum) {
    case 1:
      return AuthManager.payam8Lesson1Part1Completed &&
          AuthManager.payam8Lesson1Part2Completed &&
          AuthManager.payam8Lesson1Part3Completed;
    case 2:
      return AuthManager.payam8Lesson2Part1Completed &&
          AuthManager.payam8Lesson2Part2Completed &&
          AuthManager.payam8Lesson2Part3Completed;
    case 3:
      return AuthManager.payam8Lesson3Part1Completed &&
          AuthManager.payam8Lesson3Part2Completed &&
          AuthManager.payam8Lesson3Part3Completed;
    case 4:
      return AuthManager.payam8Lesson4Part1Completed &&
          AuthManager.payam8Lesson4Part2Completed &&
          AuthManager.payam8Lesson4Part3Completed;
    case 5:
      return AuthManager.payam8Lesson5Part1Completed &&
          AuthManager.payam8Lesson5Part2Completed &&
          AuthManager.payam8Lesson5Part3Completed;
    case 6:
      return AuthManager.payam8Lesson6Part1Completed &&
          AuthManager.payam8Lesson6Part2Completed &&
          AuthManager.payam8Lesson6Part3Completed;
    default:
      return false;
  }
}

Future<void> showPayam8LessonsModal(BuildContext context) {
  final List<Map<String, String>> payam8Lessons = [
    {'number': '01', 'title': 'فصل اول: خداشناسی', 'subtitle': ''},
    {'number': '02', 'title': 'فصل دوم: معاد', 'subtitle': ''},
    {'number': '03', 'title': 'فصل سوم: راهنماشناسی', 'subtitle': ''},
    {'number': '04', 'title': 'فصل چهارم: راه و توشه', 'subtitle': ''},
    {'number': '05', 'title': 'فصل پنجم: اخلاق', 'subtitle': ''},
    {'number': '06', 'title': 'فصل ششم: جامعه اسلامی', 'subtitle': ''},
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
            border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.6), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
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
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF8B5CF6), width: 1.5),
                    ),
                    child: const Text('📖', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'کتاب پیام‌های آسمان پایه هشتم 📖',
                          style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'لیست بازی 🎮 های ۶ فصل پیام‌های هشتم',
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
                  itemCount: payam8Lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = payam8Lessons[index];
                    final bool isCompleted = _isPayam8LessonCompleted(index + 1);

                    final Color itemAccentColor = isCompleted ? const Color(0xFF10B981) : const Color(0xFF8B5CF6);
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
                        border: Border.all(color: itemAccentColor, width: 2.0),
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
                            _showPayam8LessonPartsModal(context, index + 1, lesson['title']!);
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
                                      color: isCompleted ? const Color(0xFF6EE7B7) : const Color(0xFFC4B5FD),
                                    ),
                                  ),
                                ),
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

void _showPayam8LessonPartsModal(BuildContext context, int lessonNum, String lessonTitle) {
  final bool p1Completed = lessonNum == 1 ? AuthManager.payam8Lesson1Part1Completed :
                           lessonNum == 2 ? AuthManager.payam8Lesson2Part1Completed :
                           lessonNum == 3 ? AuthManager.payam8Lesson3Part1Completed :
                           lessonNum == 4 ? AuthManager.payam8Lesson4Part1Completed :
                           lessonNum == 5 ? AuthManager.payam8Lesson5Part1Completed :
                           lessonNum == 6 ? AuthManager.payam8Lesson6Part1Completed : false;

  final bool p2Completed = lessonNum == 1 ? AuthManager.payam8Lesson1Part2Completed :
                           lessonNum == 2 ? AuthManager.payam8Lesson2Part2Completed :
                           lessonNum == 3 ? AuthManager.payam8Lesson3Part2Completed :
                           lessonNum == 4 ? AuthManager.payam8Lesson4Part2Completed :
                           lessonNum == 5 ? AuthManager.payam8Lesson5Part2Completed :
                           lessonNum == 6 ? AuthManager.payam8Lesson6Part2Completed : false;

  final bool p3Completed = lessonNum == 1 ? AuthManager.payam8Lesson1Part3Completed :
                           lessonNum == 2 ? AuthManager.payam8Lesson2Part3Completed :
                           lessonNum == 3 ? AuthManager.payam8Lesson3Part3Completed :
                           lessonNum == 4 ? AuthManager.payam8Lesson4Part3Completed :
                           lessonNum == 5 ? AuthManager.payam8Lesson5Part3Completed :
                           lessonNum == 6 ? AuthManager.payam8Lesson6Part3Completed : false;

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
            border: Border.all(color: const Color(0xFF8B5CF6), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'پیام‌های آسمان هشتم - $lessonTitle 📖',
                style: const TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildPayam8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF8B5CF6),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Payam8HtmlGameScreen(
                        gameTitle: 'پیام‌های هشتم - تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'payam8_lesson${lessonNum}_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildPayam8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Payam8HtmlGameScreen(
                        gameTitle: 'پیام‌های هشتم - تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'payam8_lesson${lessonNum}_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildPayam8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF06B6D4),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Payam8HtmlGameScreen(
                        gameTitle: 'پیام‌های هشتم - جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'payam8_lesson${lessonNum}_p3',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildPayam8PartButton({required String title, String icon = '', required Color color, required VoidCallback onTap, bool isCompleted = false}) {
  return Container(
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.2),
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
