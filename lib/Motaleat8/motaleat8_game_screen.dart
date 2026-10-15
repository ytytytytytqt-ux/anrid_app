import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../managers/auth_manager.dart';
import '../screens/home_screen.dart';
import 'motaleat8_data.dart';

class Motaleat8HtmlGameScreen extends StatefulWidget {
  final String gameTitle;
  final String htmlAssetPath;
  final String lessonKey;

  const Motaleat8HtmlGameScreen({
    super.key,
    required this.gameTitle,
    required this.htmlAssetPath,
    required this.lessonKey,
  });

  @override
  State<Motaleat8HtmlGameScreen> createState() => _Motaleat8HtmlGameScreenState();
}

class _Motaleat8HtmlGameScreenState extends State<Motaleat8HtmlGameScreen> {
  late final WebViewController controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    bool isCompleted = widget.lessonKey.startsWith('motaleat8_lesson12') ? (
                         widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson12Part1Completed :
                         widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson12Part2Completed :
                         AuthManager.motaleat8Lesson12Part3Completed
                       ) : widget.lessonKey.startsWith('motaleat8_lesson11') ? (
                         widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson11Part1Completed :
                         widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson11Part2Completed :
                         AuthManager.motaleat8Lesson11Part3Completed
                       ) : widget.lessonKey.startsWith('motaleat8_lesson10') ? (
                         widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson10Part1Completed :
                         widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson10Part2Completed :
                         AuthManager.motaleat8Lesson10Part3Completed
                       ) : widget.lessonKey.startsWith('motaleat8_lesson9') ? (
                         widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson9Part1Completed :
                         widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson9Part2Completed :
                         AuthManager.motaleat8Lesson9Part3Completed
                       ) : widget.lessonKey.startsWith('motaleat8_lesson8') ? (
                         widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson8Part1Completed :
                         widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson8Part2Completed :
                         AuthManager.motaleat8Lesson8Part3Completed
                       ) : widget.lessonKey.startsWith('motaleat8_lesson7') ? (
                         widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson7Part1Completed :
                         widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson7Part2Completed :
                         AuthManager.motaleat8Lesson7Part3Completed
                       ) : widget.lessonKey.startsWith('motaleat8_lesson6') ? (
                         widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson6Part1Completed :
                         widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson6Part2Completed :
                         AuthManager.motaleat8Lesson6Part3Completed
                       ) : widget.lessonKey.startsWith('motaleat8_lesson5') ? (
                         widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson5Part1Completed :
                         widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson5Part2Completed :
                         AuthManager.motaleat8Lesson5Part3Completed
                       ) : widget.lessonKey.startsWith('motaleat8_lesson4') ? (
                         widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson4Part1Completed :
                         widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson4Part2Completed :
                         AuthManager.motaleat8Lesson4Part3Completed
                       ) : widget.lessonKey.startsWith('motaleat8_lesson3') ? (
                         widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson3Part1Completed :
                         widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson3Part2Completed :
                         AuthManager.motaleat8Lesson3Part3Completed
                       ) : widget.lessonKey.startsWith('motaleat8_lesson2') ? (
                         widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson2Part1Completed :
                         widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson2Part2Completed :
                         AuthManager.motaleat8Lesson2Part3Completed
                       ) : widget.lessonKey.startsWith('motaleat8_lesson1') ? (
                         widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson1Part1Completed :
                         widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson1Part2Completed :
                         AuthManager.motaleat8Lesson1Part3Completed
                       ) : false;

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
            bool alreadyCompleted = widget.lessonKey.startsWith('motaleat8_lesson12') ? (
                                     widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson12Part1Completed :
                                     widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson12Part2Completed :
                                     AuthManager.motaleat8Lesson12Part3Completed
                                   ) : widget.lessonKey.startsWith('motaleat8_lesson11') ? (
                                     widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson11Part1Completed :
                                     widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson11Part2Completed :
                                     AuthManager.motaleat8Lesson11Part3Completed
                                   ) : widget.lessonKey.startsWith('motaleat8_lesson10') ? (
                                     widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson10Part1Completed :
                                     widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson10Part2Completed :
                                     AuthManager.motaleat8Lesson10Part3Completed
                                   ) : widget.lessonKey.startsWith('motaleat8_lesson9') ? (
                                     widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson9Part1Completed :
                                     widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson9Part2Completed :
                                     AuthManager.motaleat8Lesson9Part3Completed
                                   ) : widget.lessonKey.startsWith('motaleat8_lesson8') ? (
                                     widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson8Part1Completed :
                                     widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson8Part2Completed :
                                     AuthManager.motaleat8Lesson8Part3Completed
                                   ) : widget.lessonKey.startsWith('motaleat8_lesson7') ? (
                                     widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson7Part1Completed :
                                     widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson7Part2Completed :
                                     AuthManager.motaleat8Lesson7Part3Completed
                                   ) : widget.lessonKey.startsWith('motaleat8_lesson6') ? (
                                     widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson6Part1Completed :
                                     widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson6Part2Completed :
                                     AuthManager.motaleat8Lesson6Part3Completed
                                   ) : widget.lessonKey.startsWith('motaleat8_lesson5') ? (
                                     widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson5Part1Completed :
                                     widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson5Part2Completed :
                                     AuthManager.motaleat8Lesson5Part3Completed
                                   ) : widget.lessonKey.startsWith('motaleat8_lesson4') ? (
                                     widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson4Part1Completed :
                                     widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson4Part2Completed :
                                     AuthManager.motaleat8Lesson4Part3Completed
                                   ) : widget.lessonKey.startsWith('motaleat8_lesson3') ? (
                                     widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson3Part1Completed :
                                     widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson3Part2Completed :
                                     AuthManager.motaleat8Lesson3Part3Completed
                                   ) : widget.lessonKey.startsWith('motaleat8_lesson2') ? (
                                     widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson2Part1Completed :
                                     widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson2Part2Completed :
                                     AuthManager.motaleat8Lesson2Part3Completed
                                   ) : widget.lessonKey.startsWith('motaleat8_lesson1') ? (
                                     widget.lessonKey.contains('p1') ? AuthManager.motaleat8Lesson1Part1Completed :
                                     widget.lessonKey.contains('p2') ? AuthManager.motaleat8Lesson1Part2Completed :
                                     AuthManager.motaleat8Lesson1Part3Completed
                                   ) : false;
            if (!alreadyCompleted) {
              setState(() {
                AuthManager.coins += earnedCoins;
                if (widget.lessonKey.startsWith('motaleat8_lesson12')) {
                  if (widget.lessonKey.contains('p1')) AuthManager.motaleat8Lesson12Part1Completed = true;
                  else if (widget.lessonKey.contains('p2')) AuthManager.motaleat8Lesson12Part2Completed = true;
                  else if (widget.lessonKey.contains('p3')) AuthManager.motaleat8Lesson12Part3Completed = true;
                } else if (widget.lessonKey.startsWith('motaleat8_lesson11')) {
                  if (widget.lessonKey.contains('p1')) AuthManager.motaleat8Lesson11Part1Completed = true;
                  else if (widget.lessonKey.contains('p2')) AuthManager.motaleat8Lesson11Part2Completed = true;
                  else if (widget.lessonKey.contains('p3')) AuthManager.motaleat8Lesson11Part3Completed = true;
                } else if (widget.lessonKey.startsWith('motaleat8_lesson10')) {
                  if (widget.lessonKey.contains('p1')) AuthManager.motaleat8Lesson10Part1Completed = true;
                  else if (widget.lessonKey.contains('p2')) AuthManager.motaleat8Lesson10Part2Completed = true;
                  else if (widget.lessonKey.contains('p3')) AuthManager.motaleat8Lesson10Part3Completed = true;
                } else if (widget.lessonKey.startsWith('motaleat8_lesson9')) {
                  if (widget.lessonKey.contains('p1')) AuthManager.motaleat8Lesson9Part1Completed = true;
                  else if (widget.lessonKey.contains('p2')) AuthManager.motaleat8Lesson9Part2Completed = true;
                  else if (widget.lessonKey.contains('p3')) AuthManager.motaleat8Lesson9Part3Completed = true;
                } else if (widget.lessonKey.startsWith('motaleat8_lesson8')) {
                  if (widget.lessonKey.contains('p1')) AuthManager.motaleat8Lesson8Part1Completed = true;
                  else if (widget.lessonKey.contains('p2')) AuthManager.motaleat8Lesson8Part2Completed = true;
                  else if (widget.lessonKey.contains('p3')) AuthManager.motaleat8Lesson8Part3Completed = true;
                } else if (widget.lessonKey.startsWith('motaleat8_lesson7')) {
                  if (widget.lessonKey.contains('p1')) AuthManager.motaleat8Lesson7Part1Completed = true;
                  else if (widget.lessonKey.contains('p2')) AuthManager.motaleat8Lesson7Part2Completed = true;
                  else if (widget.lessonKey.contains('p3')) AuthManager.motaleat8Lesson7Part3Completed = true;
                } else if (widget.lessonKey.startsWith('motaleat8_lesson6')) {
                  if (widget.lessonKey.contains('p1')) AuthManager.motaleat8Lesson6Part1Completed = true;
                  else if (widget.lessonKey.contains('p2')) AuthManager.motaleat8Lesson6Part2Completed = true;
                  else if (widget.lessonKey.contains('p3')) AuthManager.motaleat8Lesson6Part3Completed = true;
                } else if (widget.lessonKey.startsWith('motaleat8_lesson5')) {
                  if (widget.lessonKey.contains('p1')) AuthManager.motaleat8Lesson5Part1Completed = true;
                  else if (widget.lessonKey.contains('p2')) AuthManager.motaleat8Lesson5Part2Completed = true;
                  else if (widget.lessonKey.contains('p3')) AuthManager.motaleat8Lesson5Part3Completed = true;
                } else if (widget.lessonKey.startsWith('motaleat8_lesson4')) {
                  if (widget.lessonKey.contains('p1')) AuthManager.motaleat8Lesson4Part1Completed = true;
                  else if (widget.lessonKey.contains('p2')) AuthManager.motaleat8Lesson4Part2Completed = true;
                  else if (widget.lessonKey.contains('p3')) AuthManager.motaleat8Lesson4Part3Completed = true;
                } else if (widget.lessonKey.startsWith('motaleat8_lesson3')) {
                  if (widget.lessonKey.contains('p1')) AuthManager.motaleat8Lesson3Part1Completed = true;
                  else if (widget.lessonKey.contains('p2')) AuthManager.motaleat8Lesson3Part2Completed = true;
                  else if (widget.lessonKey.contains('p3')) AuthManager.motaleat8Lesson3Part3Completed = true;
                } else if (widget.lessonKey.startsWith('motaleat8_lesson2')) {
                  if (widget.lessonKey.contains('p1')) AuthManager.motaleat8Lesson2Part1Completed = true;
                  else if (widget.lessonKey.contains('p2')) AuthManager.motaleat8Lesson2Part2Completed = true;
                  else if (widget.lessonKey.contains('p3')) AuthManager.motaleat8Lesson2Part3Completed = true;
                } else if (widget.lessonKey.startsWith('motaleat8_lesson1')) {
                  if (widget.lessonKey.contains('p1')) AuthManager.motaleat8Lesson1Part1Completed = true;
                  else if (widget.lessonKey.contains('p2')) AuthManager.motaleat8Lesson1Part2Completed = true;
                  else if (widget.lessonKey.contains('p3')) AuthManager.motaleat8Lesson1Part3Completed = true;
                }
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
        String threeJsContent = await Motaleat8Data.getThreeJs();
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

      List<Map<String, dynamic>> questionsList = [];
      if (widget.lessonKey.startsWith('motaleat8_lesson12')) {
        if (widget.lessonKey.contains('p1')) questionsList = Motaleat8Data.lesson12Part1Questions;
        else if (widget.lessonKey.contains('p2')) questionsList = Motaleat8Data.lesson12Part2Questions;
        else if (widget.lessonKey.contains('p3')) questionsList = Motaleat8Data.lesson12Part3Questions;
      } else if (widget.lessonKey.startsWith('motaleat8_lesson11')) {
        if (widget.lessonKey.contains('p1')) questionsList = Motaleat8Data.lesson11Part1Questions;
        else if (widget.lessonKey.contains('p2')) questionsList = Motaleat8Data.lesson11Part2Questions;
        else if (widget.lessonKey.contains('p3')) questionsList = Motaleat8Data.lesson11Part3Questions;
      } else if (widget.lessonKey.startsWith('motaleat8_lesson10')) {
        if (widget.lessonKey.contains('p1')) questionsList = Motaleat8Data.lesson10Part1Questions;
        else if (widget.lessonKey.contains('p2')) questionsList = Motaleat8Data.lesson10Part2Questions;
        else if (widget.lessonKey.contains('p3')) questionsList = Motaleat8Data.lesson10Part3Questions;
      } else if (widget.lessonKey.startsWith('motaleat8_lesson9')) {
        if (widget.lessonKey.contains('p1')) questionsList = Motaleat8Data.lesson9Part1Questions;
        else if (widget.lessonKey.contains('p2')) questionsList = Motaleat8Data.lesson9Part2Questions;
        else if (widget.lessonKey.contains('p3')) questionsList = Motaleat8Data.lesson9Part3Questions;
      } else if (widget.lessonKey.startsWith('motaleat8_lesson8')) {
        if (widget.lessonKey.contains('p1')) questionsList = Motaleat8Data.lesson8Part1Questions;
        else if (widget.lessonKey.contains('p2')) questionsList = Motaleat8Data.lesson8Part2Questions;
        else if (widget.lessonKey.contains('p3')) questionsList = Motaleat8Data.lesson8Part3Questions;
      } else if (widget.lessonKey.startsWith('motaleat8_lesson7')) {
        if (widget.lessonKey.contains('p1')) questionsList = Motaleat8Data.lesson7Part1Questions;
        else if (widget.lessonKey.contains('p2')) questionsList = Motaleat8Data.lesson7Part2Questions;
        else if (widget.lessonKey.contains('p3')) questionsList = Motaleat8Data.lesson7Part3Questions;
      } else if (widget.lessonKey.startsWith('motaleat8_lesson6')) {
        if (widget.lessonKey.contains('p1')) questionsList = Motaleat8Data.lesson6Part1Questions;
        else if (widget.lessonKey.contains('p2')) questionsList = Motaleat8Data.lesson6Part2Questions;
        else if (widget.lessonKey.contains('p3')) questionsList = Motaleat8Data.lesson6Part3Questions;
      } else if (widget.lessonKey.startsWith('motaleat8_lesson5')) {
        if (widget.lessonKey.contains('p1')) questionsList = Motaleat8Data.lesson5Part1Questions;
        else if (widget.lessonKey.contains('p2')) questionsList = Motaleat8Data.lesson5Part2Questions;
        else if (widget.lessonKey.contains('p3')) questionsList = Motaleat8Data.lesson5Part3Questions;
      } else if (widget.lessonKey.startsWith('motaleat8_lesson4')) {
        if (widget.lessonKey.contains('p1')) questionsList = Motaleat8Data.lesson4Part1Questions;
        else if (widget.lessonKey.contains('p2')) questionsList = Motaleat8Data.lesson4Part2Questions;
        else if (widget.lessonKey.contains('p3')) questionsList = Motaleat8Data.lesson4Part3Questions;
      } else if (widget.lessonKey.startsWith('motaleat8_lesson3')) {
        if (widget.lessonKey.contains('p1')) questionsList = Motaleat8Data.lesson3Part1Questions;
        else if (widget.lessonKey.contains('p2')) questionsList = Motaleat8Data.lesson3Part2Questions;
        else if (widget.lessonKey.contains('p3')) questionsList = Motaleat8Data.lesson3Part3Questions;
      } else if (widget.lessonKey.startsWith('motaleat8_lesson2')) {
        if (widget.lessonKey.contains('p1')) questionsList = Motaleat8Data.lesson2Part1Questions;
        else if (widget.lessonKey.contains('p2')) questionsList = Motaleat8Data.lesson2Part2Questions;
        else if (widget.lessonKey.contains('p3')) questionsList = Motaleat8Data.lesson2Part3Questions;
      } else if (widget.lessonKey.startsWith('motaleat8_lesson1')) {
        if (widget.lessonKey.contains('p1')) questionsList = Motaleat8Data.lesson1Part1Questions;
        else if (widget.lessonKey.contains('p2')) questionsList = Motaleat8Data.lesson1Part2Questions;
        else if (widget.lessonKey.contains('p3')) questionsList = Motaleat8Data.lesson1Part3Questions;
      }

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
                    color: (isAlreadyCompleted ? const Color(0xFF06B6D4) : const Color(0xFFFFB703)).withOpacity(0.4),
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
                      color: (isAlreadyCompleted ? const Color(0xFF06B6D4) : const Color(0xFFFFB703)).withOpacity(0.2),
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
                            color: const Color(0xFFFFB703).withOpacity(0.3),
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
                          color: const Color(0xFF7C3AED).withOpacity(0.5),
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
          style: const TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
            ),
          if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'خطا در بارگذاری بازی: $_errorMessage',
                  style: const TextStyle(color: Colors.redAccent, fontFamily: 'Tahoma'),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
