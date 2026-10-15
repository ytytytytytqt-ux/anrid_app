import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:anroid_app/managers/auth_manager.dart';

class CarGameScreen extends StatefulWidget {
  final String title;

  const CarGameScreen({
    super.key,
    required this.title,
  });

  @override
  State<CarGameScreen> createState() => _CarGameScreenState();
}

class _CarGameScreenState extends State<CarGameScreen> {
  late final WebViewController controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'CoinChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final int? earnedCoins = int.tryParse(message.message);
          if (earnedCoins != null && earnedCoins > 0) {
            if (mounted) {
              setState(() {
                AuthManager.coins += earnedCoins;
              });
            } else {
              AuthManager.coins += earnedCoins;
            }
            AuthManager.save();
          }
        },
      )
      ..setOnConsoleMessage((JavaScriptConsoleMessage msg) {
        debugPrint('GameConsole: ${msg.message} [${msg.level}]');
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            if (mounted) setState(() => _isLoading = false);
            debugPrint('CarGame loaded: $url');
            for (int delay in [50, 150, 300, 600, 1000]) {
              Future.delayed(Duration(milliseconds: delay), () {
                if (mounted) {
                  controller.runJavaScript('''
                    if (typeof window.resize === "function") { window.resize(); }
                    window.dispatchEvent(new Event("resize"));
                  ''');
                }
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('GameError: ${error.description} (url: ${error.url}, isMain: ${error.isForMainFrame})');
            if (mounted && (error.isForMainFrame ?? false)) {
              setState(() {
                _isLoading = false;
                _errorMessage = error.description;
              });
            }
          },
        ),
      );

    if (controller.platform is AndroidWebViewController) {
      final androidController = controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    _loadGame();
  }

  Future<String> _loadAssetString(String filename) async {
    try {
      return await rootBundle.loadString('assets/html/Games/Car/$filename');
    } catch (_) {
      return await rootBundle.loadString('assets/html/Games/$filename');
    }
  }

  Future<ByteData> _loadAssetBytes(String filename) async {
    try {
      return await rootBundle.load('assets/html/Games/Car/$filename');
    } catch (_) {
      return await rootBundle.load('assets/html/Games/$filename');
    }
  }

  Future<void> _loadGame() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      }

      // 1. بارگذاری فایل اصلی Car.html
      String htmlContent = await _loadAssetString('Car.html');

      // 2. تزریق مستقیم three.min.js برای اجرای 100% آفلاین و بدون مشکل CORS
      try {
        final String threeJsContent = await _loadAssetString('three.min.js');
        if (threeJsContent.isNotEmpty) {
          if (htmlContent.contains('<script src="three.min.js"></script>')) {
            htmlContent = htmlContent.replaceFirst(
              '<script src="three.min.js"></script>',
              '<script>\n/* INLINED_THREE */\n$threeJsContent\n</script>',
            );
          } else if (htmlContent.contains('<script src="./three.min.js"></script>')) {
            htmlContent = htmlContent.replaceFirst(
              '<script src="./three.min.js"></script>',
              '<script>\n/* INLINED_THREE */\n$threeJsContent\n</script>',
            );
          } else {
            htmlContent = htmlContent.replaceFirst(
              RegExp(r'<script\s+src=[\x22\x27]\.?\/?three\.min\.js[\x22\x27]\s*><\/script>'),
              '<script>\n/* INLINED_THREE */\n$threeJsContent\n</script>',
            );
          }
          if (!htmlContent.contains('/* INLINED_THREE */')) {
            htmlContent = '<script>\n/* INLINED_THREE */\n$threeJsContent\n</script>\n$htmlContent';
          }
        } else {
          debugPrint('WARNING: threeJsContent is empty!');
        }
      } catch (e) {
        debugPrint('Three.js inlining warning: $e');
      }

      // 3. تبدیل و درج فونت‌های وزیرمتن به Base64 برای نمایش قطعی و بدون CORS
      try {
        final ByteData boldBytes = await _loadAssetBytes('Vazirmatn-Bold.ttf');
        final String boldB64 = base64Encode(boldBytes.buffer.asUint8List());
        htmlContent = htmlContent.replaceAll(
          RegExp(r'''url\(['"]?\.?\/?Vazirmatn-Bold\.ttf['"]?\)'''),
          "url('data:font/truetype;charset=utf-8;base64,$boldB64')",
        );
      } catch (e) {
        debugPrint('Vazirmatn Bold font embedding warning: $e');
      }

      try {
        final ByteData blackBytes = await _loadAssetBytes('Vazirmatn-Black.ttf');
        final String blackB64 = base64Encode(blackBytes.buffer.asUint8List());
        htmlContent = htmlContent.replaceAll(
          RegExp(r'''url\(['"]?\.?\/?Vazirmatn-Black\.ttf['"]?\)'''),
          "url('data:font/truetype;charset=utf-8;base64,$blackB64')",
        );
      } catch (e) {
        debugPrint('Vazirmatn Black font embedding warning: $e');
      }

      // 4. بارگذاری مستقیم در وب‌ویو بدون دامنه اینترنتی خارجی (حل قطعی ERR_NAME_NOT_RESOLVED)
      await controller.loadHtmlString(htmlContent);
    } catch (e) {
      debugPrint('Fatal error loading car game: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _stopAudio() {
    try {
      controller.runJavaScript('''
        if (typeof window.stopAllGameAudio === "function") {
          window.stopAllGameAudio();
        }
        if (typeof audioCtx !== "undefined" && audioCtx) {
          try {
            if (typeof engineGain !== "undefined" && engineGain) engineGain.gain.value = 0;
            if (typeof masterGain !== "undefined" && masterGain) masterGain.gain.value = 0;
            if (typeof engineOsc !== "undefined" && engineOsc) { engineOsc.stop(); engineOsc.disconnect(); }
            if (typeof engineSub !== "undefined" && engineSub) { engineSub.stop(); engineSub.disconnect(); }
            audioCtx.close();
          } catch(e){}
        }
        document.querySelectorAll("audio, video").forEach(el => {
          try { el.pause(); el.src = ""; el.remove(); } catch(e){}
        });
      ''');
      controller.loadRequest(Uri.parse('about:blank'));
    } catch (_) {}
  }

  @override
  void dispose() {
    _stopAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        _stopAudio();
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFF05070D),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0C1422),
            elevation: 0,
            centerTitle: true,
            title: Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'Tahoma',
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
              onPressed: () {
                _stopAudio();
                Navigator.pop(context);
              },
            ),
          actions: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 14),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Text('🪙 ', style: TextStyle(fontSize: 12)),
                    Text(
                      '${AuthManager.coins}',
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
            WebViewWidget(controller: controller),
            if (_isLoading)
              Container(
                color: const Color(0xFF05070D),
                child: const Center(
                  child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       CircularProgressIndicator(
                         color: Color(0xFF4FF0FF),
                       ),
                       SizedBox(height: 16),
                       Text(
                         'در حال آماده‌سازی مسابقه... 🏎️⚡',
                         style: TextStyle(
                           fontFamily: 'Tahoma',
                           fontSize: 14,
                           fontWeight: FontWeight.bold,
                           color: Color(0xFF8FB6D8),
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
            if (_errorMessage != null)
              Container(
                color: const Color(0xFF05070D),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'خطا در بارگذاری بازی:\n$_errorMessage',
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadGame,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('تلاش مجدد'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E1065),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
