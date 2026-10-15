import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../managers/auth_manager.dart';
import '../screens/home_screen.dart';

class Riyazi9GameScreen extends StatefulWidget {
  final int chapterIndex;
  final String chapterTitle;

  const Riyazi9GameScreen({
    super.key,
    required this.chapterIndex,
    required this.chapterTitle,
  });

  @override
  State<Riyazi9GameScreen> createState() => _Riyazi9GameScreenState();
}

class _Riyazi9GameScreenState extends State<Riyazi9GameScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;
  bool _coinsAwarded = false;

  @override
  void initState() {
    super.initState();

    final bool isCompleted = AuthManager.isRiyazi9ChapterCompleted(widget.chapterIndex);
    if (isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showReplayWarningDialog();
      });
    }

    _initWebViewController();
    _loadGame();
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
              'شما این بازی رو قبلاً تا آخر رفتید و این‌بار سکه‌ای دریافت نمی‌کنید!',
              style: TextStyle(fontFamily: 'Tahoma', color: Color(0xFFCBD5E1), fontSize: 13, height: 1.5),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
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

  void _showReplayCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            backgroundColor: const Color(0xFF131138),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 450, minHeight: 570),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0E26),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: const Color(0xFF06B6D4),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.95),
                    blurRadius: 45,
                    spreadRadius: 20,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF06B6D4), width: 2.5),
                    ),
                    child: const Text('⚠️', style: TextStyle(fontSize: 54)),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'تکرار مأموریت',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'شما این بازی را قبلاً تا آخر رفته‌اید و این بار سکه دریافت نمی‌کنید!',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 14.5,
                      color: Color(0xFFCBD5E1),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF070B19),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF06B6D4).withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🪙', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 10),
                        Text(
                          'سکه جدید: ۰ (قبلاً دریافت شده)',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 44),
                  Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF06B6D4).withValues(alpha: 0.45),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          Navigator.pop(context);
                          _returnToHome();
                        },
                        child: const Center(
                          child: Text(
                            'بازگشت به صفحه خانه 🏠',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 15,
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

  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF070B18))
      ..addJavaScriptChannel(
        'CoinChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final int? coins = int.tryParse(message.message);
          if (coins != null && coins >= 0) {
            final bool isAlreadyCompleted = AuthManager.isRiyazi9ChapterCompleted(widget.chapterIndex);
            if (!isAlreadyCompleted) {
              if (!_coinsAwarded && coins > 0) {
                _coinsAwarded = true;
                setState(() {
                  AuthManager.coins += coins;
                  AuthManager.setRiyazi9ChapterCompleted(widget.chapterIndex, true);
                });
                AuthManager.save();
              }
              // در بار اول دیالوگ اضافه نشان داده نمی‌شود تا کادر زیبای خود بازی نمایش داده شود
            } else {
              // در تکرار بازی کادر هشدار با پوشش کامل صفحه پشت نمایش داده می‌شود
              if (mounted) {
                _showReplayCompletionDialog();
              }
            }
          }
        },
      )
      ..addJavaScriptChannel(
        'HomeChannel',
        onMessageReceived: (JavaScriptMessage message) {
          _returnToHome();
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (String url) async {
            if (mounted) setState(() => _isLoading = false);
            await _controller.runJavaScript('''
              (function() {
                var ids = ['btnRestart', 'btnHome'];
                ids.forEach(function(id) {
                  var btn = document.getElementById(id);
                  if (btn && !btn._flutterBound) {
                    btn._flutterBound = true;
                    btn.addEventListener('click', function() {
                      var coins = 0;
                      if (typeof state !== 'undefined' && state.coins) {
                        coins = state.coins;
                      }
                      if (window.CoinChannel) {
                        window.CoinChannel.postMessage(String(coins));
                      }
                      if (window.HomeChannel) {
                        window.HomeChannel.postMessage('goHome');
                      }
                    });
                  }
                });
              })();
            ''');
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

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController androidController = _controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }
  }

  Future<void> _loadGame() async {
    try {
      final String assetPath = 'assets/html/riazi/nohom/${widget.chapterIndex}.html';
      String htmlContent = await rootBundle.loadString(assetPath);
      await _controller.loadHtmlString(htmlContent);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'بازی این فصل در حال آماده‌سازی است.';
        });
      }
    }
  }

  void _returnToHome() {
    AuthManager.save();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Directionality(
            textDirection: TextDirection.rtl,
            child: ModernHomeScreen(),
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _returnToHome();
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFF070B18),
          appBar: AppBar(
            backgroundColor: const Color(0xFF16265C),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
              onPressed: _returnToHome,
            ),
            title: Text(
              'بازی ریاضی نهم: ${widget.chapterTitle}',
              style: const TextStyle(
                fontFamily: 'Tahoma',
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home_rounded, color: Colors.white, size: 24),
                tooltip: 'صفحه اصلی',
                onPressed: _returnToHome,
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF43F5E).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF43F5E), width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🪙 ', style: TextStyle(fontSize: 12)),
                      Text(
                        '${AuthManager.coins}',
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              if (_errorMessage == null)
                WebViewWidget(controller: _controller)
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF43F5E).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFF43F5E), width: 2),
                          ),
                          child: const Text('📐', style: TextStyle(fontSize: 48)),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.chapterTitle,
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(fontFamily: 'Tahoma', fontSize: 13, color: Color(0xFF94A3B8)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _returnToHome,
                          icon: const Icon(Icons.home_rounded),
                          label: const Text('بازگشت به خانه'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF43F5E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_isLoading && _errorMessage == null)
                Container(
                  color: const Color(0xFF070B18),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Color(0xFFF43F5E)),
                        SizedBox(height: 16),
                        Text(
                          'در حال آماده‌سازی بازی ریاضی نهم... 📐🎮',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
