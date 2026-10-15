import 'package:flutter/material.dart';
import 'motaleat9_game_screen.dart';
import '../managers/auth_manager.dart';

bool _isMotaleat9LessonCompleted(int lessonNum) {
  switch (lessonNum) {
    case 1:
      return AuthManager.motaleat9Lesson1Part1Completed &&
          AuthManager.motaleat9Lesson1Part2Completed &&
          AuthManager.motaleat9Lesson1Part3Completed;
    case 2:
      return AuthManager.motaleat9Lesson2Part1Completed &&
          AuthManager.motaleat9Lesson2Part2Completed &&
          AuthManager.motaleat9Lesson2Part3Completed;
    case 3:
      return AuthManager.motaleat9Lesson3Part1Completed &&
          AuthManager.motaleat9Lesson3Part2Completed &&
          AuthManager.motaleat9Lesson3Part3Completed;
    case 4:
      return AuthManager.motaleat9Lesson4Part1Completed &&
          AuthManager.motaleat9Lesson4Part2Completed &&
          AuthManager.motaleat9Lesson4Part3Completed;
    case 5:
      return AuthManager.motaleat9Lesson5Part1Completed &&
          AuthManager.motaleat9Lesson5Part2Completed &&
          AuthManager.motaleat9Lesson5Part3Completed;
    case 6:
      return AuthManager.motaleat9Lesson6Part1Completed &&
          AuthManager.motaleat9Lesson6Part2Completed &&
          AuthManager.motaleat9Lesson6Part3Completed;
    case 7:
      return AuthManager.motaleat9Lesson7Part1Completed &&
          AuthManager.motaleat9Lesson7Part2Completed &&
          AuthManager.motaleat9Lesson7Part3Completed;
    case 8:
      return AuthManager.motaleat9Lesson8Part1Completed &&
          AuthManager.motaleat9Lesson8Part2Completed &&
          AuthManager.motaleat9Lesson8Part3Completed;
    case 9:
      return AuthManager.motaleat9Lesson9Part1Completed &&
          AuthManager.motaleat9Lesson9Part2Completed &&
          AuthManager.motaleat9Lesson9Part3Completed;
    case 10:
      return AuthManager.motaleat9Lesson10Part1Completed &&
          AuthManager.motaleat9Lesson10Part2Completed &&
          AuthManager.motaleat9Lesson10Part3Completed;
    case 11:
      return AuthManager.motaleat9Lesson11Part1Completed &&
          AuthManager.motaleat9Lesson11Part2Completed &&
          AuthManager.motaleat9Lesson11Part3Completed;
    case 12:
      return AuthManager.motaleat9Lesson12Part1Completed &&
          AuthManager.motaleat9Lesson12Part2Completed &&
          AuthManager.motaleat9Lesson12Part3Completed;
    default:
      return false;
  }
}

Future<void> showMotaleat9LessonsModal(BuildContext context) {
  final List<Map<String, String>> motaleat9Lessons = [
    {'number': '01', 'title': 'فصل اوّل: سیارهٔ ما، زمین', 'subtitle': ''},
    {'number': '02', 'title': 'فصل دوم: سنگ کره، آب کره، هوا کره', 'subtitle': ''},
    {'number': '03', 'title': 'فصل سوم: زیست کره، تنوع شگفت انگیز', 'subtitle': ''},
    {'number': '04', 'title': 'فصل چهارم: ساکنان سیارۀ زمین', 'subtitle': ''},
    {'number': '05', 'title': 'فصل پنجم: عصر یکپارچگی و شکوفایی', 'subtitle': ''},
    {'number': '06', 'title': 'فصل ششم: ایران از عهد نادرشاه تا ناصرالدین شاه', 'subtitle': ''},
    {'number': '07', 'title': 'فصل هفتم: ایران در عصر مشروطه', 'subtitle': ''},
    {'number': '08', 'title': 'فصل هشتم: سقوط حکومت شاهنشاهی و شکل گیری نظام جمهوری اسلامی', 'subtitle': ''},
    {'number': '09', 'title': 'فصل نهم: فرهنگ و هویت', 'subtitle': ''},
    {'number': '10', 'title': 'فصل دهم: خانواده و جامعه', 'subtitle': ''},
    {'number': '11', 'title': 'فصل یازدهم: حکومت و مردم', 'subtitle': ''},
    {'number': '12', 'title': 'فصل دوازدهم: بهره وری', 'subtitle': ''},
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
                          'کتاب مطالعات اجتماعی پایه نهم 🌍',
                          style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'لیست بازی 🎮 های ۱۲ فصل مطالعات نهم',
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
                  itemCount: motaleat9Lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = motaleat9Lessons[index];
                    final bool isPlayable = (index >= 0 && index <= 11);
                    final bool isCompleted = _isMotaleat9LessonCompleted(index + 1);

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
                            _showMotaleat9LessonPartsModal(context, index + 1, lesson['title']!);
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
                                      color: isCompleted ? const Color(0xFF6EE7B7) : const Color(0xFF22D3EE),
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

void _showMotaleat9LessonPartsModal(BuildContext context, int lessonNum, String lessonTitle) {
  final bool p1Completed = lessonNum == 1 ? AuthManager.motaleat9Lesson1Part1Completed :
                           lessonNum == 2 ? AuthManager.motaleat9Lesson2Part1Completed :
                           lessonNum == 3 ? AuthManager.motaleat9Lesson3Part1Completed :
                           lessonNum == 4 ? AuthManager.motaleat9Lesson4Part1Completed :
                           lessonNum == 5 ? AuthManager.motaleat9Lesson5Part1Completed :
                           lessonNum == 6 ? AuthManager.motaleat9Lesson6Part1Completed :
                           lessonNum == 7 ? AuthManager.motaleat9Lesson7Part1Completed :
                           lessonNum == 8 ? AuthManager.motaleat9Lesson8Part1Completed :
                           lessonNum == 9 ? AuthManager.motaleat9Lesson9Part1Completed :
                           lessonNum == 10 ? AuthManager.motaleat9Lesson10Part1Completed :
                           lessonNum == 11 ? AuthManager.motaleat9Lesson11Part1Completed :
                           lessonNum == 12 ? AuthManager.motaleat9Lesson12Part1Completed : false;

  final bool p2Completed = lessonNum == 1 ? AuthManager.motaleat9Lesson1Part2Completed :
                           lessonNum == 2 ? AuthManager.motaleat9Lesson2Part2Completed :
                           lessonNum == 3 ? AuthManager.motaleat9Lesson3Part2Completed :
                           lessonNum == 4 ? AuthManager.motaleat9Lesson4Part2Completed :
                           lessonNum == 5 ? AuthManager.motaleat9Lesson5Part2Completed :
                           lessonNum == 6 ? AuthManager.motaleat9Lesson6Part2Completed :
                           lessonNum == 7 ? AuthManager.motaleat9Lesson7Part2Completed :
                           lessonNum == 8 ? AuthManager.motaleat9Lesson8Part2Completed :
                           lessonNum == 9 ? AuthManager.motaleat9Lesson9Part2Completed :
                           lessonNum == 10 ? AuthManager.motaleat9Lesson10Part2Completed :
                           lessonNum == 11 ? AuthManager.motaleat9Lesson11Part2Completed :
                           lessonNum == 12 ? AuthManager.motaleat9Lesson12Part2Completed : false;

  final bool p3Completed = lessonNum == 1 ? AuthManager.motaleat9Lesson1Part3Completed :
                           lessonNum == 2 ? AuthManager.motaleat9Lesson2Part3Completed :
                           lessonNum == 3 ? AuthManager.motaleat9Lesson3Part3Completed :
                           lessonNum == 4 ? AuthManager.motaleat9Lesson4Part3Completed :
                           lessonNum == 5 ? AuthManager.motaleat9Lesson5Part3Completed :
                           lessonNum == 6 ? AuthManager.motaleat9Lesson6Part3Completed :
                           lessonNum == 7 ? AuthManager.motaleat9Lesson7Part3Completed :
                           lessonNum == 8 ? AuthManager.motaleat9Lesson8Part3Completed :
                           lessonNum == 9 ? AuthManager.motaleat9Lesson9Part3Completed :
                           lessonNum == 10 ? AuthManager.motaleat9Lesson10Part3Completed :
                           lessonNum == 11 ? AuthManager.motaleat9Lesson11Part3Completed :
                           lessonNum == 12 ? AuthManager.motaleat9Lesson12Part3Completed : false;

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
              Text(
                'مطالعات اجتماعی نهم - $lessonTitle 🌍',
                style: const TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              // قسمت اول
              _buildMotaleat9PartButton(
                title: 'قسمت اول: بازی تک‌تیرانداز 🔫',
                icon: '🔫',
                color: const Color(0xFF06B6D4),
                isCompleted: p1Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Motaleat9HtmlGameScreen(
                        gameTitle: 'مطالعات نهم - بازی تک‌تیرانداز 🔫',
                        htmlAssetPath: 'assets/html/Games/Sniper999.html',
                        lessonKey: 'motaleat9_lesson${lessonNum}_p1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت دوم
              _buildMotaleat9PartButton(
                title: 'قسمت دوم: بازی تانک سه‌بعدی 💥',
                icon: '💥',
                color: const Color(0xFFEF4444),
                isCompleted: p2Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Motaleat9HtmlGameScreen(
                        gameTitle: 'مطالعات نهم - بازی تانک سه‌بعدی 💥',
                        htmlAssetPath: 'assets/html/Games/Tank999.html',
                        lessonKey: 'motaleat9_lesson${lessonNum}_p2',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              // قسمت سوم
              _buildMotaleat9PartButton(
                title: 'قسمت سوم: بازی جنگنده آسمان 🛩️',
                icon: '🛩️',
                color: const Color(0xFF8B5CF6),
                isCompleted: p3Completed,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Motaleat9HtmlGameScreen(
                        gameTitle: 'مطالعات نهم - بازی جنگنده آسمان 🛩️',
                        htmlAssetPath: 'assets/html/Games/jangandeh1.html',
                        lessonKey: 'motaleat9_lesson${lessonNum}_p3',
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

Widget _buildMotaleat9PartButton({required String title, String icon = '', required Color color, required VoidCallback onTap, bool isCompleted = false}) {
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
