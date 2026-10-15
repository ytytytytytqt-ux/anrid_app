import 'package:flutter/material.dart';
import 'olom8_game_screen.dart';
import '../managers/auth_manager.dart';

bool _isOlom8LessonCompleted(int lessonNum) {
  switch (lessonNum) {
    case 1:
      return AuthManager.olom8Lesson1Part1Completed &&
          AuthManager.olom8Lesson1Part2Completed &&
          AuthManager.olom8Lesson1Part3Completed;
    case 2:
      return AuthManager.olom8Lesson2Part1Completed &&
          AuthManager.olom8Lesson2Part2Completed &&
          AuthManager.olom8Lesson2Part3Completed;
    case 3:
      return AuthManager.olom8Lesson3Part1Completed &&
          AuthManager.olom8Lesson3Part2Completed &&
          AuthManager.olom8Lesson3Part3Completed;
    case 4:
      return AuthManager.olom8Lesson4Part1Completed &&
          AuthManager.olom8Lesson4Part2Completed &&
          AuthManager.olom8Lesson4Part3Completed;
    case 5:
      return AuthManager.olom8Lesson5Part1Completed &&
          AuthManager.olom8Lesson5Part2Completed &&
          AuthManager.olom8Lesson5Part3Completed;
    case 6:
      return AuthManager.olom8Lesson6Part1Completed &&
          AuthManager.olom8Lesson6Part2Completed &&
          AuthManager.olom8Lesson6Part3Completed;
    case 7:
      return AuthManager.olom8Lesson7Part1Completed &&
          AuthManager.olom8Lesson7Part2Completed &&
          AuthManager.olom8Lesson7Part3Completed;
    case 8:
      return AuthManager.olom8Lesson8Part1Completed &&
          AuthManager.olom8Lesson8Part2Completed &&
          AuthManager.olom8Lesson8Part3Completed;
    case 9:
      return AuthManager.olom8Lesson9Part1Completed &&
          AuthManager.olom8Lesson9Part2Completed &&
          AuthManager.olom8Lesson9Part3Completed;
    case 10:
      return AuthManager.olom8Lesson10Part1Completed &&
          AuthManager.olom8Lesson10Part2Completed &&
          AuthManager.olom8Lesson10Part3Completed;
    case 11:
      return AuthManager.olom8Lesson11Part1Completed &&
          AuthManager.olom8Lesson11Part2Completed &&
          AuthManager.olom8Lesson11Part3Completed;
    case 12:
      return AuthManager.olom8Lesson12Part1Completed &&
          AuthManager.olom8Lesson12Part2Completed &&
          AuthManager.olom8Lesson12Part3Completed;
    case 13:
      return AuthManager.olom8Lesson13Part1Completed &&
          AuthManager.olom8Lesson13Part2Completed &&
          AuthManager.olom8Lesson13Part3Completed;
    case 14:
      return AuthManager.olom8Lesson14Part1Completed &&
          AuthManager.olom8Lesson14Part2Completed &&
          AuthManager.olom8Lesson14Part3Completed;
    case 15:
      return AuthManager.olom8Lesson15Part1Completed &&
          AuthManager.olom8Lesson15Part2Completed &&
          AuthManager.olom8Lesson15Part3Completed;
    default:
      return false;
  }
}

Future<void> showOlom8LessonsModal(BuildContext context) {
  final List<Map<String, String>> olom8Lessons = [
    {'number': '01', 'title': 'فصل اول: مخلوط و جداسازی مواد'},
    {'number': '02', 'title': 'فصل دوم: تغییرهای شیمیایی در خدمت زندگی'},
    {'number': '03', 'title': 'فصل سوم: از درون اتم چه خبر'},
    {'number': '04', 'title': 'فصل چهارم: تنظیم عصبی'},
    {'number': '05', 'title': 'فصل پنجم: حس و حرکت'},
    {'number': '06', 'title': 'فصل ششم: تنظیم هورمونی'},
    {'number': '07', 'title': 'فصل هفتم: الفبای زیست فناوری'},
    {'number': '08', 'title': 'فصل هشتم: تولید مثل در جانداران'},
    {'number': '09', 'title': 'فصل نهم: الکتریسیته'},
    {'number': '10', 'title': 'فصل دهم: مغناطیس'},
    {'number': '11', 'title': 'فصل یازدهم: کانی ها'},
    {'number': '12', 'title': 'فصل دوازدهم: سنگ ها'},
    {'number': '13', 'title': 'فصل سیزدهم: هوازدگی'},
    {'number': '14', 'title': 'فصل چهاردهم: نور و ویژگی های آن'},
    {'number': '15', 'title': 'فصل پانزدهم: شکست نور'},
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
            border: Border.all(color: const Color(0xFFE2E8F0).withValues(alpha: 0.6), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
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
                      color: const Color(0xFFE2E8F0).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                    ),
                    child: const Text('🔬', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'کتاب علوم تجربی پایه هشتم 🔬',
                          style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'لیست بازی 🎮 های ۱۵ فصل علوم تجربی هشتم',
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
                  itemCount: olom8Lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = olom8Lessons[index];
                    final bool isCompleted = _isOlom8LessonCompleted(index + 1);

                    final Color itemAccentColor = isCompleted ? const Color(0xFF10B981) : const Color(0xFFE2E8F0);
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
                            _showOlom8LessonPartsModal(context, index + 1, lesson['title']!);
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
                                            style: const TextStyle(fontFamily: 'Tahoma', fontWeight: FontWeight.w900, color: Color(0xFF0F172A), fontSize: 13),
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
                                      color: isCompleted ? const Color(0xFF6EE7B7) : const Color(0xFFF8FAFC),
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

void _showOlom8LessonPartsModal(BuildContext context, int lessonNum, String lessonTitle) {
  bool p1Completed = false;
  bool p2Completed = false;
  bool p3Completed = false;

  switch (lessonNum) {
    case 1:
      p1Completed = AuthManager.olom8Lesson1Part1Completed;
      p2Completed = AuthManager.olom8Lesson1Part2Completed;
      p3Completed = AuthManager.olom8Lesson1Part3Completed;
      break;
    case 2:
      p1Completed = AuthManager.olom8Lesson2Part1Completed;
      p2Completed = AuthManager.olom8Lesson2Part2Completed;
      p3Completed = AuthManager.olom8Lesson2Part3Completed;
      break;
    case 3:
      p1Completed = AuthManager.olom8Lesson3Part1Completed;
      p2Completed = AuthManager.olom8Lesson3Part2Completed;
      p3Completed = AuthManager.olom8Lesson3Part3Completed;
      break;
    case 4:
      p1Completed = AuthManager.olom8Lesson4Part1Completed;
      p2Completed = AuthManager.olom8Lesson4Part2Completed;
      p3Completed = AuthManager.olom8Lesson4Part3Completed;
      break;
    case 5:
      p1Completed = AuthManager.olom8Lesson5Part1Completed;
      p2Completed = AuthManager.olom8Lesson5Part2Completed;
      p3Completed = AuthManager.olom8Lesson5Part3Completed;
      break;
    case 6:
      p1Completed = AuthManager.olom8Lesson6Part1Completed;
      p2Completed = AuthManager.olom8Lesson6Part2Completed;
      p3Completed = AuthManager.olom8Lesson6Part3Completed;
      break;
    case 7:
      p1Completed = AuthManager.olom8Lesson7Part1Completed;
      p2Completed = AuthManager.olom8Lesson7Part2Completed;
      p3Completed = AuthManager.olom8Lesson7Part3Completed;
      break;
    case 8:
      p1Completed = AuthManager.olom8Lesson8Part1Completed;
      p2Completed = AuthManager.olom8Lesson8Part2Completed;
      p3Completed = AuthManager.olom8Lesson8Part3Completed;
      break;
    case 9:
      p1Completed = AuthManager.olom8Lesson9Part1Completed;
      p2Completed = AuthManager.olom8Lesson9Part2Completed;
      p3Completed = AuthManager.olom8Lesson9Part3Completed;
      break;
    case 10:
      p1Completed = AuthManager.olom8Lesson10Part1Completed;
      p2Completed = AuthManager.olom8Lesson10Part2Completed;
      p3Completed = AuthManager.olom8Lesson10Part3Completed;
      break;
    case 11:
      p1Completed = AuthManager.olom8Lesson11Part1Completed;
      p2Completed = AuthManager.olom8Lesson11Part2Completed;
      p3Completed = AuthManager.olom8Lesson11Part3Completed;
      break;
    case 12:
      p1Completed = AuthManager.olom8Lesson12Part1Completed;
      p2Completed = AuthManager.olom8Lesson12Part2Completed;
      p3Completed = AuthManager.olom8Lesson12Part3Completed;
      break;
    case 13:
      p1Completed = AuthManager.olom8Lesson13Part1Completed;
      p2Completed = AuthManager.olom8Lesson13Part2Completed;
      p3Completed = AuthManager.olom8Lesson13Part3Completed;
      break;
    case 14:
      p1Completed = AuthManager.olom8Lesson14Part1Completed;
      p2Completed = AuthManager.olom8Lesson14Part2Completed;
      p3Completed = AuthManager.olom8Lesson14Part3Completed;
      break;
    case 15:
      p1Completed = AuthManager.olom8Lesson15Part1Completed;
      p2Completed = AuthManager.olom8Lesson15Part2Completed;
      p3Completed = AuthManager.olom8Lesson15Part3Completed;
      break;
  }

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
            border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'علوم تجربی هشتم - $lessonTitle 🔬',
                style: const TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildOlom8PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFFE2E8F0),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Olom8HtmlGameScreen(
                        gameTitle: 'علوم هشتم - تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'olom8_lesson${lessonNum}_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildOlom8PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Olom8HtmlGameScreen(
                        gameTitle: 'علوم هشتم - تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'olom8_lesson${lessonNum}_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildOlom8PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF06B6D4),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Olom8HtmlGameScreen(
                        gameTitle: 'علوم هشتم - جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'olom8_lesson${lessonNum}_p3',
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

Widget _buildOlom8PartButton({required String title, String icon = '', required Color color, required VoidCallback onTap, bool isCompleted = false}) {
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
