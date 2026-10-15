import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../managers/auth_manager.dart';
import '../screens/home_screen.dart';
import 'olom9_data.dart';

class Olom9HtmlGameScreen extends StatefulWidget {
  final String gameTitle;
  final String htmlAssetPath;
  final String lessonKey;

  const Olom9HtmlGameScreen({
    super.key,
    required this.gameTitle,
    required this.htmlAssetPath,
    required this.lessonKey,
  });

  @override
  State<Olom9HtmlGameScreen> createState() => _Olom9HtmlGameScreenState();
}

class _Olom9HtmlGameScreenState extends State<Olom9HtmlGameScreen> {
  late final WebViewController controller;
  bool _isLoading = true;
  String? _errorMessage;

  bool _isLessonCompleted(String lessonKey) {
    switch (lessonKey) {
      case 'olom9_lesson1_p1': return AuthManager.olom9Lesson1Part1Completed;
      case 'olom9_lesson1_p2': return AuthManager.olom9Lesson1Part2Completed;
      case 'olom9_lesson1_p3': return AuthManager.olom9Lesson1Part3Completed;
      case 'olom9_lesson2_p1': return AuthManager.olom9Lesson2Part1Completed;
      case 'olom9_lesson2_p2': return AuthManager.olom9Lesson2Part2Completed;
      case 'olom9_lesson2_p3': return AuthManager.olom9Lesson2Part3Completed;
      case 'olom9_lesson3_p1': return AuthManager.olom9Lesson3Part1Completed;
      case 'olom9_lesson3_p2': return AuthManager.olom9Lesson3Part2Completed;
      case 'olom9_lesson3_p3': return AuthManager.olom9Lesson3Part3Completed;
      case 'olom9_lesson4_p1': return AuthManager.olom9Lesson4Part1Completed;
      case 'olom9_lesson4_p2': return AuthManager.olom9Lesson4Part2Completed;
      case 'olom9_lesson4_p3': return AuthManager.olom9Lesson4Part3Completed;
      case 'olom9_lesson5_p1': return AuthManager.olom9Lesson5Part1Completed;
      case 'olom9_lesson5_p2': return AuthManager.olom9Lesson5Part2Completed;
      case 'olom9_lesson5_p3': return AuthManager.olom9Lesson5Part3Completed;
      case 'olom9_lesson6_p1': return AuthManager.olom9Lesson6Part1Completed;
      case 'olom9_lesson6_p2': return AuthManager.olom9Lesson6Part2Completed;
      case 'olom9_lesson6_p3': return AuthManager.olom9Lesson6Part3Completed;
      case 'olom9_lesson7_p1': return AuthManager.olom9Lesson7Part1Completed;
      case 'olom9_lesson7_p2': return AuthManager.olom9Lesson7Part2Completed;
      case 'olom9_lesson7_p3': return AuthManager.olom9Lesson7Part3Completed;
      case 'olom9_lesson8_p1': return AuthManager.olom9Lesson8Part1Completed;
      case 'olom9_lesson8_p2': return AuthManager.olom9Lesson8Part2Completed;
      case 'olom9_lesson8_p3': return AuthManager.olom9Lesson8Part3Completed;
      case 'olom9_lesson9_p1': return AuthManager.olom9Lesson9Part1Completed;
      case 'olom9_lesson9_p2': return AuthManager.olom9Lesson9Part2Completed;
      case 'olom9_lesson9_p3': return AuthManager.olom9Lesson9Part3Completed;
      case 'olom9_lesson10_p1': return AuthManager.olom9Lesson10Part1Completed;
      case 'olom9_lesson10_p2': return AuthManager.olom9Lesson10Part2Completed;
      case 'olom9_lesson10_p3': return AuthManager.olom9Lesson10Part3Completed;
      case 'olom9_lesson11_p1': return AuthManager.olom9Lesson11Part1Completed;
      case 'olom9_lesson11_p2': return AuthManager.olom9Lesson11Part2Completed;
      case 'olom9_lesson11_p3': return AuthManager.olom9Lesson11Part3Completed;
      case 'olom9_lesson12_p1': return AuthManager.olom9Lesson12Part1Completed;
      case 'olom9_lesson12_p2': return AuthManager.olom9Lesson12Part2Completed;
      case 'olom9_lesson12_p3': return AuthManager.olom9Lesson12Part3Completed;
      case 'olom9_lesson13_p1': return AuthManager.olom9Lesson13Part1Completed;
      case 'olom9_lesson13_p2': return AuthManager.olom9Lesson13Part2Completed;
      case 'olom9_lesson13_p3': return AuthManager.olom9Lesson13Part3Completed;
      case 'olom9_lesson14_p1': return AuthManager.olom9Lesson14Part1Completed;
      case 'olom9_lesson14_p2': return AuthManager.olom9Lesson14Part2Completed;
      case 'olom9_lesson14_p3': return AuthManager.olom9Lesson14Part3Completed;
      case 'olom9_lesson15_p1': return AuthManager.olom9Lesson15Part1Completed;
      case 'olom9_lesson15_p2': return AuthManager.olom9Lesson15Part2Completed;
      case 'olom9_lesson15_p3': return AuthManager.olom9Lesson15Part3Completed;
      default: return false;
    }
  }

  void _markLessonCompleted(String lessonKey) {
    switch (lessonKey) {
      case 'olom9_lesson1_p1': AuthManager.olom9Lesson1Part1Completed = true; break;
      case 'olom9_lesson1_p2': AuthManager.olom9Lesson1Part2Completed = true; break;
      case 'olom9_lesson1_p3': AuthManager.olom9Lesson1Part3Completed = true; break;
      case 'olom9_lesson2_p1': AuthManager.olom9Lesson2Part1Completed = true; break;
      case 'olom9_lesson2_p2': AuthManager.olom9Lesson2Part2Completed = true; break;
      case 'olom9_lesson2_p3': AuthManager.olom9Lesson2Part3Completed = true; break;
      case 'olom9_lesson3_p1': AuthManager.olom9Lesson3Part1Completed = true; break;
      case 'olom9_lesson3_p2': AuthManager.olom9Lesson3Part2Completed = true; break;
      case 'olom9_lesson3_p3': AuthManager.olom9Lesson3Part3Completed = true; break;
      case 'olom9_lesson4_p1': AuthManager.olom9Lesson4Part1Completed = true; break;
      case 'olom9_lesson4_p2': AuthManager.olom9Lesson4Part2Completed = true; break;
      case 'olom9_lesson4_p3': AuthManager.olom9Lesson4Part3Completed = true; break;
      case 'olom9_lesson5_p1': AuthManager.olom9Lesson5Part1Completed = true; break;
      case 'olom9_lesson5_p2': AuthManager.olom9Lesson5Part2Completed = true; break;
      case 'olom9_lesson5_p3': AuthManager.olom9Lesson5Part3Completed = true; break;
      case 'olom9_lesson6_p1': AuthManager.olom9Lesson6Part1Completed = true; break;
      case 'olom9_lesson6_p2': AuthManager.olom9Lesson6Part2Completed = true; break;
      case 'olom9_lesson6_p3': AuthManager.olom9Lesson6Part3Completed = true; break;
      case 'olom9_lesson7_p1': AuthManager.olom9Lesson7Part1Completed = true; break;
      case 'olom9_lesson7_p2': AuthManager.olom9Lesson7Part2Completed = true; break;
      case 'olom9_lesson7_p3': AuthManager.olom9Lesson7Part3Completed = true; break;
      case 'olom9_lesson8_p1': AuthManager.olom9Lesson8Part1Completed = true; break;
      case 'olom9_lesson8_p2': AuthManager.olom9Lesson8Part2Completed = true; break;
      case 'olom9_lesson8_p3': AuthManager.olom9Lesson8Part3Completed = true; break;
      case 'olom9_lesson9_p1': AuthManager.olom9Lesson9Part1Completed = true; break;
      case 'olom9_lesson9_p2': AuthManager.olom9Lesson9Part2Completed = true; break;
      case 'olom9_lesson9_p3': AuthManager.olom9Lesson9Part3Completed = true; break;
      case 'olom9_lesson10_p1': AuthManager.olom9Lesson10Part1Completed = true; break;
      case 'olom9_lesson10_p2': AuthManager.olom9Lesson10Part2Completed = true; break;
      case 'olom9_lesson10_p3': AuthManager.olom9Lesson10Part3Completed = true; break;
      case 'olom9_lesson11_p1': AuthManager.olom9Lesson11Part1Completed = true; break;
      case 'olom9_lesson11_p2': AuthManager.olom9Lesson11Part2Completed = true; break;
      case 'olom9_lesson11_p3': AuthManager.olom9Lesson11Part3Completed = true; break;
      case 'olom9_lesson12_p1': AuthManager.olom9Lesson12Part1Completed = true; break;
      case 'olom9_lesson12_p2': AuthManager.olom9Lesson12Part2Completed = true; break;
      case 'olom9_lesson12_p3': AuthManager.olom9Lesson12Part3Completed = true; break;
      case 'olom9_lesson13_p1': AuthManager.olom9Lesson13Part1Completed = true; break;
      case 'olom9_lesson13_p2': AuthManager.olom9Lesson13Part2Completed = true; break;
      case 'olom9_lesson13_p3': AuthManager.olom9Lesson13Part3Completed = true; break;
      case 'olom9_lesson14_p1': AuthManager.olom9Lesson14Part1Completed = true; break;
      case 'olom9_lesson14_p2': AuthManager.olom9Lesson14Part2Completed = true; break;
      case 'olom9_lesson14_p3': AuthManager.olom9Lesson14Part3Completed = true; break;
      case 'olom9_lesson15_p1': AuthManager.olom9Lesson15Part1Completed = true; break;
      case 'olom9_lesson15_p2': AuthManager.olom9Lesson15Part2Completed = true; break;
      case 'olom9_lesson15_p3': AuthManager.olom9Lesson15Part3Completed = true; break;
    }
  }

  List<Map<String, dynamic>> _getQuestionsForLessonKey(String lessonKey) {
    switch (lessonKey) {
      case 'olom9_lesson1_p1': return Olom9Data.chapter1Part1Questions;
      case 'olom9_lesson1_p2': return Olom9Data.chapter1Part2Questions;
      case 'olom9_lesson1_p3': return Olom9Data.chapter1Part3Questions;
      case 'olom9_lesson2_p1': return Olom9Data.chapter2Part1Questions;
      case 'olom9_lesson2_p2': return Olom9Data.chapter2Part2Questions;
      case 'olom9_lesson2_p3': return Olom9Data.chapter2Part3Questions;
      case 'olom9_lesson3_p1': return Olom9Data.chapter3Part1Questions;
      case 'olom9_lesson3_p2': return Olom9Data.chapter3Part2Questions;
      case 'olom9_lesson3_p3': return Olom9Data.chapter3Part3Questions;
      case 'olom9_lesson4_p1': return Olom9Data.chapter4Part1Questions;
      case 'olom9_lesson4_p2': return Olom9Data.chapter4Part2Questions;
      case 'olom9_lesson4_p3': return Olom9Data.chapter4Part3Questions;
      case 'olom9_lesson5_p1': return Olom9Data.chapter5Part1Questions;
      case 'olom9_lesson5_p2': return Olom9Data.chapter5Part2Questions;
      case 'olom9_lesson5_p3': return Olom9Data.chapter5Part3Questions;
      case 'olom9_lesson6_p1': return Olom9Data.chapter6Part1Questions;
      case 'olom9_lesson6_p2': return Olom9Data.chapter6Part2Questions;
      case 'olom9_lesson6_p3': return Olom9Data.chapter6Part3Questions;
      case 'olom9_lesson7_p1': return Olom9Data.chapter7Part1Questions;
      case 'olom9_lesson7_p2': return Olom9Data.chapter7Part2Questions;
      case 'olom9_lesson7_p3': return Olom9Data.chapter7Part3Questions;
      case 'olom9_lesson8_p1': return Olom9Data.chapter8Part1Questions;
      case 'olom9_lesson8_p2': return Olom9Data.chapter8Part2Questions;
      case 'olom9_lesson8_p3': return Olom9Data.chapter8Part3Questions;
      case 'olom9_lesson9_p1': return Olom9Data.chapter9Part1Questions;
      case 'olom9_lesson9_p2': return Olom9Data.chapter9Part2Questions;
      case 'olom9_lesson9_p3': return Olom9Data.chapter9Part3Questions;
      case 'olom9_lesson10_p1': return Olom9Data.chapter10Part1Questions;
      case 'olom9_lesson10_p2': return Olom9Data.chapter10Part2Questions;
      case 'olom9_lesson10_p3': return Olom9Data.chapter10Part3Questions;
      case 'olom9_lesson11_p1': return Olom9Data.chapter11Part1Questions;
      case 'olom9_lesson11_p2': return Olom9Data.chapter11Part2Questions;
      case 'olom9_lesson11_p3': return Olom9Data.chapter11Part3Questions;
      case 'olom9_lesson12_p1': return Olom9Data.chapter12Part1Questions;
      case 'olom9_lesson12_p2': return Olom9Data.chapter12Part2Questions;
      case 'olom9_lesson12_p3': return Olom9Data.chapter12Part3Questions;
      case 'olom9_lesson13_p1': return Olom9Data.chapter13Part1Questions;
      case 'olom9_lesson13_p2': return Olom9Data.chapter13Part2Questions;
      case 'olom9_lesson13_p3': return Olom9Data.chapter13Part3Questions;
      case 'olom9_lesson14_p1': return Olom9Data.chapter14Part1Questions;
      case 'olom9_lesson14_p2': return Olom9Data.chapter14Part2Questions;
      case 'olom9_lesson14_p3': return Olom9Data.chapter14Part3Questions;
      case 'olom9_lesson15_p1': return Olom9Data.chapter15Part1Questions;
      case 'olom9_lesson15_p2': return Olom9Data.chapter15Part2Questions;
      case 'olom9_lesson15_p3': return Olom9Data.chapter15Part3Questions;
      default: return Olom9Data.chapter1Part1Questions;
    }
  }

  @override
  void initState() {
    super.initState();

    bool isCompleted = _isLessonCompleted(widget.lessonKey);
    if (isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showReplayWarningDialog();
      });
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'CoinChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final int? earnedCoins = int.tryParse(message.message);
          if (earnedCoins != null && earnedCoins >= 0) {
            bool alreadyCompleted = _isLessonCompleted(widget.lessonKey);
            if (!alreadyCompleted) {
              setState(() {
                AuthManager.coins += earnedCoins;
                _markLessonCompleted(widget.lessonKey);
              });
              AuthManager.save();
              if (mounted) {
                _showVictoryRewardDialog(earnedCoins, false);
              }
            } else {
              if (mounted) {
                _showVictoryRewardDialog(0, true);
              }
            }
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _errorMessage = error.description;
              });
            }
          },
        ),
      );

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController androidController = controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    _loadGame();
  }

  Future<void> _loadGame() async {
    try {
      String htmlContent = await rootBundle.loadString(widget.htmlAssetPath);
      if (htmlContent.contains('three.min.js')) {
        String threeJsContent = await Olom9Data.getThreeJs();
        htmlContent = htmlContent.replaceFirst(
          '<script src="./three.min.js"></script>',
          '<script>$threeJsContent</script>',
        );
      }

      if (widget.htmlAssetPath.contains('Sniper999.html')) {
        try {
          ByteData audioBytes = await rootBundle.load('assets/html/Games/h.mp3');
          String audioBase64 = base64Encode(audioBytes.buffer.asUint8List());
          htmlContent = htmlContent.replaceFirst(
            '<script>',
            '<script>\nwindow.HEADSHOT_AUDIO_B64 = "data:audio/mp3;base64,$audioBase64";\n',
          );
        } catch (_) {}
      }

      List<Map<String, dynamic>> questionsList = _getQuestionsForLessonKey(widget.lessonKey);

      final String qJson = jsonEncode(questionsList);
      if (widget.htmlAssetPath.contains('Sniper999.html')) {
        htmlContent = htmlContent.replaceFirst(
          'let studyQuestions = [];',
          'let studyQuestions = $qJson;',
        );
      } else {
        htmlContent = htmlContent.replaceFirst(
          'let QUESTIONS = [];',
          'let QUESTIONS = $qJson;',
        );
      }

      await controller.loadHtmlString(htmlContent);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _showReplayWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: const Color(0xFF1E1B4B),
            title: const Row(
              children: [
                Text('⚠️', style: TextStyle(fontSize: 28)),
                SizedBox(width: 10),
                Text('توجه', style: TextStyle(fontFamily: 'Tahoma', color: Colors.white, fontWeight: FontWeight.w900)),
              ],
            ),
            content: const Text(
              'شما این بازی رو تا آخر رفتید و اینبار سکه نمی‌گیرید!',
              style: TextStyle(fontFamily: 'Tahoma', color: Color(0xFFCBD5E1), fontSize: 13, height: 1.5),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF0891B2)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text('متوجه شدم', style: TextStyle(fontFamily: 'Tahoma', color: Colors.white, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVictoryRewardDialog(int finalCoins, bool isAlreadyCompleted) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            backgroundColor: const Color(0xFF1E1B4B),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E1065), Color(0xFF1E1B4B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: isAlreadyCompleted ? const Color(0xFF06B6D4) : const Color(0xFFFFB703), width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: (isAlreadyCompleted ? const Color(0xFF06B6D4) : const Color(0xFFFFB703)).withValues(alpha: 0.4),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: (isAlreadyCompleted ? const Color(0xFF06B6D4) : const Color(0xFFFFB703)).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: isAlreadyCompleted ? const Color(0xFF06B6D4) : const Color(0xFFFFB703), width: 2),
                    ),
                    child: Text(isAlreadyCompleted ? '⚠️' : '🏆', style: const TextStyle(fontSize: 44)),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    isAlreadyCompleted ? 'تکرار مأموریت' : 'پایان درخشان مأموریت! 🌟',
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isAlreadyCompleted
                        ? 'شما این بازی را قبلاً تا آخر رفته‌اید و این بار سکه دریافت نمی‌کنید!'
                        : 'شما با موفقیت بازی را به اتمام رساندید و جوایز ارزنده‌ای کسب کردید',
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!isAlreadyCompleted) ...[
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFFFB703), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFB703).withValues(alpha: 0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🪙', style: TextStyle(fontSize: 26)),
                          const SizedBox(width: 10),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              '+$finalCoins',
                              style: const TextStyle(
                                fontFamily: 'Tahoma',
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFFB703),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.5),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          AuthManager.save();
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Directionality(textDirection: TextDirection.rtl, child: ModernHomeScreen())),
                              (route) => false,
                            );
                          }
                        },
                        child: const Center(
                          child: Text(
                            'بازگشت به لیست دروس 🚀',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F071E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.gameTitle,
          style: const TextStyle(fontFamily: 'Tahoma', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF8B5CF6)),
              ),
              child: Row(
                children: [
                  const Text('🪙 ', style: TextStyle(fontSize: 12)),
                  Text(
                    '${AuthManager.coins}',
                    style: const TextStyle(fontFamily: 'Tahoma', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading)
            Container(
              color: const Color(0xFF0F071E),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF8B5CF6)),
                    SizedBox(height: 16),
                    Text(
                      'در حال بارگذاری بازی... 🎮',
                      style: TextStyle(fontFamily: 'Tahoma', fontSize: 13, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ),
            ),
          if (_errorMessage != null)
            Container(
              color: const Color(0xFF0F071E),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(fontFamily: 'Tahoma', fontSize: 13, color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
