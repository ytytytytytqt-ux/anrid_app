import 'package:flutter/material.dart';
import 'farsi7_game_screen.dart';
import '../managers/auth_manager.dart';

bool _isFarsi7LessonCompleted(int lessonNum) {
  switch (lessonNum) {
    case 1:
      return AuthManager.farsi7Lesson1Part1Completed &&
          AuthManager.farsi7Lesson1Part2Completed &&
          AuthManager.farsi7Lesson1Part3Completed;
    case 2:
      return AuthManager.farsi7Lesson2Part1Completed &&
          AuthManager.farsi7Lesson2Part2Completed &&
          AuthManager.farsi7Lesson2Part3Completed;
    case 3:
      return AuthManager.farsi7Lesson3Part1Completed &&
          AuthManager.farsi7Lesson3Part2Completed &&
          AuthManager.farsi7Lesson3Part3Completed;
    case 4:
      return AuthManager.farsi7Lesson4Part1Completed &&
          AuthManager.farsi7Lesson4Part2Completed &&
          AuthManager.farsi7Lesson4Part3Completed;
    case 5:
      return AuthManager.farsi7Lesson5Part1Completed &&
          AuthManager.farsi7Lesson5Part2Completed &&
          AuthManager.farsi7Lesson5Part3Completed;
    case 6:
      return AuthManager.farsi7Lesson6Part1Completed &&
          AuthManager.farsi7Lesson6Part2Completed &&
          AuthManager.farsi7Lesson6Part3Completed;
    default:
      return false;
  }
}

Future<void> showFarsi7LessonsModal(BuildContext context) {
  final List<Map<String, String>> farsi7Lessons = [
    {'number': '01', 'title': 'فصل اول: زیبایی آفرینش', 'subtitle': ''},
    {'number': '02', 'title': 'فصل دوم: شکفتن', 'subtitle': ''},
    {'number': '03', 'title': 'فصل سوم: سبک زندگی', 'subtitle': ''},
    {'number': '04', 'title': 'فصل چهارم: نام‌ها و یادها', 'subtitle': ''},
    {'number': '05', 'title': 'فصل پنجم: اسلام و انقلاب اسلامی', 'subtitle': ''},
    {'number': '06', 'title': 'فصل ششم: ادبیات جهان', 'subtitle': ''},
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
              colors: [Color(0xFF1F140E), Color(0xFF332016), Color(0xFF170E09)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: const Color(0xFFC89657).withOpacity(0.7), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC89657),
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
                      color: const Color(0xFFC89657).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFC89657), width: 1.5),
                    ),
                    child: const Text('✒️', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'کتاب ادبیات فارسی پایه هفتم 📜',
                          style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFFF7E7CE)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'لیست بازی 🎮 های ۶ فصل فارسی هفتم',
                          style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFFD4C3A3)),
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
                  itemCount: farsi7Lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = farsi7Lessons[index];
                    final bool isCompleted = _isFarsi7LessonCompleted(index + 1);

                    final Color itemAccentColor = isCompleted ? const Color(0xFF10B981) : const Color(0xFFC89657);
                    final List<Color> itemGradient = isCompleted
                        ? [const Color(0xFF064E3B).withValues(alpha: 0.75), const Color(0xFF0A2E20)]
                        : [const Color(0xFF3D271C), const Color(0xFF2B1B13)];

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
                            _showFarsi7LessonPartsModal(context, index + 1, lesson['title']!);
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
                                    style: const TextStyle(fontFamily: 'Tahoma', fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFF7E7CE)),
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
                                      color: isCompleted ? const Color(0xFF6EE7B7) : const Color(0xFFF7E7CE),
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

void _showFarsi7LessonPartsModal(BuildContext context, int lessonNum, String lessonTitle) {
  final bool p1Completed = lessonNum == 1 ? AuthManager.farsi7Lesson1Part1Completed :
                           lessonNum == 2 ? AuthManager.farsi7Lesson2Part1Completed :
                           lessonNum == 3 ? AuthManager.farsi7Lesson3Part1Completed :
                           lessonNum == 4 ? AuthManager.farsi7Lesson4Part1Completed :
                           lessonNum == 5 ? AuthManager.farsi7Lesson5Part1Completed :
                           lessonNum == 6 ? AuthManager.farsi7Lesson6Part1Completed : false;

  final bool p2Completed = lessonNum == 1 ? AuthManager.farsi7Lesson1Part2Completed :
                           lessonNum == 2 ? AuthManager.farsi7Lesson2Part2Completed :
                           lessonNum == 3 ? AuthManager.farsi7Lesson3Part2Completed :
                           lessonNum == 4 ? AuthManager.farsi7Lesson4Part2Completed :
                           lessonNum == 5 ? AuthManager.farsi7Lesson5Part2Completed :
                           lessonNum == 6 ? AuthManager.farsi7Lesson6Part2Completed : false;

  final bool p3Completed = lessonNum == 1 ? AuthManager.farsi7Lesson1Part3Completed :
                           lessonNum == 2 ? AuthManager.farsi7Lesson2Part3Completed :
                           lessonNum == 3 ? AuthManager.farsi7Lesson3Part3Completed :
                           lessonNum == 4 ? AuthManager.farsi7Lesson4Part3Completed :
                           lessonNum == 5 ? AuthManager.farsi7Lesson5Part3Completed :
                           lessonNum == 6 ? AuthManager.farsi7Lesson6Part3Completed : false;

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
              colors: [Color(0xFF1F140E), Color(0xFF332016)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: const Color(0xFFC89657), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ادبیات فارسی هفتم - $lessonTitle 📜',
                style: const TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFFF7E7CE)),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFFD4C3A3)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildFarsi7PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFFC89657),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Farsi7HtmlGameScreen(
                        gameTitle: 'فارسی هفتم - تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'farsi7_lesson${lessonNum}_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildFarsi7PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Farsi7HtmlGameScreen(
                        gameTitle: 'فارسی هفتم - تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'farsi7_lesson${lessonNum}_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildFarsi7PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF06B6D4),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Farsi7HtmlGameScreen(
                        gameTitle: 'فارسی هفتم - جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'farsi7_lesson${lessonNum}_p3',
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

Widget _buildFarsi7PartButton({required String title, String icon = '', required Color color, required VoidCallback onTap, bool isCompleted = false}) {
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
