import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../managers/auth_manager.dart';
import '../services/api_service.dart';

// پینتر حرفه‌ای برای رسم صاعقه‌ها و طوفان الکتریکی دندانه‌دار و پرنور (دقیقاً مشابه تصاویر ارسالی شما)
class LightningStormPainter extends CustomPainter {
  final double animationValue;
  final bool isNight;

  LightningStormPainter({required this.animationValue, required this.isNight});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Rect cardRect = rect.deflate(6);
    const double r = 24.0; // شعاع گوشه‌های کارت

    // رنگ‌های دقیقاً مطابق نمونه‌های ارسالی (شب: صورتی/بنفش نئونی - روز: فیروزه‌ای/آبی الکتریک درخشان)
    final List<Color> colors = isNight
        ? [
            const Color(0xFFFF007F),
            const Color(0xFFE00065),
            const Color(0xFFFF66C4),
            const Color(0xFFFF007F),
          ]
        : [
            const Color(0xFF00E5FF),
            const Color(0xFF00B4DB),
            const Color(0xFF70F3FF),
            const Color(0xFF00E5FF),
          ];

    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    final Paint corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // ترسیم دو لایه صاعقه دندانه‌دار و پویا برای ایجاد افکت طوفان الکتریکی زنده و واقعی
    for (int layer = 0; layer < 2; layer++) {
      final Path path = Path();
      const int steps = 120; // دقت بالا برای جزئیات دندانه‌دار صاعقه

      for (int i = 0; i <= steps; i++) {
        double progress = i / steps;
        Offset pt = _getRoundedRectPoint(cardRect, r, progress);

        // ایجاد نویز دندانه‌دار و ارگانیک صاعقه دقیقاً مثل نمونه ارسالی
        double freq = 36.0 + (layer * 14);
        double amp = 5.5 + (layer * 2.0);
        double phase = animationValue * math.pi * 6 * (layer == 0 ? 1 : -1.2);

        // ترکیب امواج سینوسی و فرکانس بالا برای ساخت ظاهر واقعی صاعقه
        double jagged = math.sin(progress * freq * math.pi + phase) * amp +
                        math.cos(progress * (freq * 2) - phase) * (amp * 0.4) +
                        math.sin(progress * 120.0 + phase * 2) * 1.5;

        Offset normal = _getRoundedRectNormal(cardRect, r, progress);
        Offset displacedPt = pt + (normal * jagged);

        if (i == 0) {
          path.moveTo(displacedPt.dx, displacedPt.dy);
        } else {
          path.lineTo(displacedPt.dx, displacedPt.dy);
        }
      }
      path.close();

      // رسم هاله نورانی پشت صاعقه
      glowPaint.color = colors[layer % colors.length].withOpacity(0.7);
      canvas.drawPath(path, glowPaint);

      // رسم هسته اصلی صاعقه
      corePaint.color = colors[(layer + 1) % colors.length];
      canvas.drawPath(path, corePaint);
    }
  }

  Offset _getRoundedRectPoint(Rect rect, double r, double t) {
    double w = rect.width;
    double h = rect.height;
    double l = rect.left;
    double top = rect.top;

    double straightTop = math.max(0.0, w - 2 * r);
    double straightRight = math.max(0.0, h - 2 * r);
    double straightBottom = math.max(0.0, w - 2 * r);
    double straightLeft = math.max(0.0, h - 2 * r);
    double cornerArc = 0.5 * math.pi * r;
    double totalPerimeter = straightTop + straightRight + straightBottom + straightLeft + (4 * cornerArc);

    double currentDist = t * totalPerimeter;

    if (currentDist <= straightTop) {
      return Offset(l + r + currentDist, top);
    }
    currentDist -= straightTop;

    if (currentDist <= cornerArc) {
      double ang = -math.pi / 2 + (currentDist / cornerArc) * (math.pi / 2);
      return Offset(l + w - r + r * math.cos(ang), top + r + r * math.sin(ang));
    }
    currentDist -= cornerArc;

    if (currentDist <= straightRight) {
      return Offset(l + w, top + r + currentDist);
    }
    currentDist -= straightRight;

    if (currentDist <= cornerArc) {
      double ang = 0 + (currentDist / cornerArc) * (math.pi / 2);
      return Offset(l + w - r + r * math.cos(ang), top + h - r + r * math.sin(ang));
    }
    currentDist -= cornerArc;

    if (currentDist <= straightBottom) {
      return Offset(l + w - r - currentDist, top + h);
    }
    currentDist -= straightBottom;

    if (currentDist <= cornerArc) {
      double ang = math.pi / 2 + (currentDist / cornerArc) * (math.pi / 2);
      return Offset(l + r + r * math.cos(ang), top + h - r + r * math.sin(ang));
    }
    currentDist -= cornerArc;

    if (currentDist <= straightLeft) {
      return Offset(l, top + h - r - currentDist);
    }
    currentDist -= straightLeft;

    double ang = math.pi + (currentDist / cornerArc) * (math.pi / 2);
    return Offset(l + r + r * math.cos(ang), top + r + r * math.sin(ang));
  }

  Offset _getRoundedRectNormal(Rect rect, double r, double t) {
    Offset pt = _getRoundedRectPoint(rect, r, t);
    double cx = rect.center.dx;
    double cy = rect.center.dy;
    Offset dir = Offset(pt.dx - cx, pt.dy - cy);
    double len = math.sqrt(dir.dx * dir.dx + dir.dy * dir.dy);
    if (len == 0) return const Offset(0, -1);
    return Offset(dir.dx / len, dir.dy / len);
  }

  @override
  bool shouldRepaint(covariant LightningStormPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.isNight != isNight;
  }
}

class AnimatedLightningCard extends StatefulWidget {
  final Widget child;
  final bool isNight;

  const AnimatedLightningCard({super.key, required this.child, required this.isNight});

  @override
  State<AnimatedLightningCard> createState() => _AnimatedLightningCardState();
}

class _AnimatedLightningCardState extends State<AnimatedLightningCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // سرعت رقص صاعقه‌ها
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color auraColor = widget.isNight ? const Color(0xFFFF007F) : const Color(0xFF00E5FF);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: LightningStormPainter(
            animationValue: _controller.value,
            isNight: widget.isNight,
          ),
          child: Container(
            margin: const EdgeInsets.all(12), // فضای لازم برای صاعقه‌ها
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: auraColor.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: auraColor.withOpacity(0.2),
                  blurRadius: 45,
                  spreadRadius: 8,
                ),
              ],
              color: widget.isNight
                  ? const Color(0xFF0F172A).withOpacity(0.96)
                  : Colors.white.withOpacity(0.96),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

// ====================================================================
// صفحه پروفایل / ورود و ثبت‌نام
// ====================================================================
class ProfileScreen extends StatefulWidget {
  final bool isStandalone;
  final VoidCallback? onGoHome;
  final Function(int)? onGradeChanged;
  final VoidCallback? onProfileUpdated;

  const ProfileScreen({
    super.key,
    this.isStandalone = false,
    this.onGoHome,
    this.onGradeChanged,
    this.onProfileUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isOtpScreen = false;
  bool _isNightMode = true; // پیش‌فرض حالت شب
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(text: AuthManager.userName);
  
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  Timer? _otpTimer;
  int _otpRemainingSeconds = 120; // مدت اعتبار کد: دقیقاً ۲ دقیقه (۱۲۰ ثانیه)
  String _expectedOtpCode = '2048'; // کد ارسال‌شده برای اعتبارسنجی دقیق

  void _startOtpTimer() {
    _otpTimer?.cancel();
    // تولید کد ۴ رقمی تصادفی واقعی (قابل اتصال مستقیم به درگاه پیامک)
    _expectedOtpCode = (1000 + math.Random().nextInt(9000)).toString();
    setState(() {
      _otpRemainingSeconds = 120;
    });
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_otpRemainingSeconds > 0) {
        setState(() {
          _otpRemainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });

    // نمایش کد پیامکی به کاربر
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                const Icon(Icons.sms_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '📩 کد تایید پیامکی شما: $_expectedOtpCode (معتبر تا ۲ دقیقه)',
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: const Color(0xFF6D28D9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          duration: const Duration(seconds: 6),
        ),
      );
    });
  }

  String _formatOtpTimer(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    String sStr = s < 10 ? '0$s' : '$s';
    return '$m:$sStr';
  }

  final List<String> _avatarOptions = [
    'image/avatar/1.webp',
    'image/avatar/2.webp',
    'image/avatar/3.webp',
    'image/avatar/4.webp',
    'image/avatar/5.webp',
    'image/avatar/7.webp',
    'image/avatar/8.webp',
    'image/avatar/9.webp',
  ];

  List<Color> _getThemeAccentGradient() {
    switch (AuthManager.currentTheme) {
      case 'persian_pink':
      case 'pastel_pink':
        return [const Color(0xFFFF3FA4), const Color(0xFFC71585)];
      case 'electric_blue':
        return [const Color(0xFF38BDF8), const Color(0xFF0284C7)];
      case 'persepolis_red':
        return [const Color(0xFFF87171), const Color(0xFFDC2626)];
      case 'radiant_purple':
        return [const Color(0xFFC084FC), const Color(0xFF9333EA)];
      default:
        return [const Color(0xFF7C3AED), const Color(0xFF4F46E5)]; // بنفش دقیقاً مشابه صفحه خانه
    }
  }

  @override
  void dispose() {
    _otpTimer?.cancel();
    _phoneController.dispose();
    _nameController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _showCustomError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontFamily: 'Tahoma', fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // نمایش مدال پشتیبانی و مشاوره با عکس ۴ برای پیامک و کپی خودکار بی‌صدا
  void _showSupportOptionsModal(BuildContext context) {
    final List<Map<String, String>> supportPlatforms = [
      {
        'name': 'ارسال کلمه "مشاوره" در ایتا',
        'source': 'image/eitaa_bale/1.webp',
        'url': 'https://eitaa.com/App_game_Lesson',
      },
      {
        'name': 'ارسال کلمه "مشاوره" در بله',
        'source': 'image/eitaa_bale/2.webp',
        'url': 'https://ble.ir/App_game_Lesson',
      },
      {
        'name': 'ارسال پیامک کلمه مشاوره',
        'source': 'image/eitaa_bale/4.webp',
        'url': 'sms:09050341218?body=مشاوره',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'پشتیبانی و مشاوره تحصیلی 🎯',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً روش ارتباطی خود را انتخاب کنید:',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 20),
                ...supportPlatforms.map((platform) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF334155)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          Navigator.pop(context);

                          if (!platform['url']!.toString().startsWith('sms:')) {
                            await Clipboard.setData(const ClipboardData(text: 'مشاوره'));
                          }

                          final Uri url = Uri.parse(platform['url']!);
                          try {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('امکان باز کردن لینک وجود ندارد.')),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.asset(
                                  platform['source']!,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  platform['name']!,
                                  style: const TextStyle(
                                    fontFamily: 'Tahoma',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF94A3B8), size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'انتخاب آواتار دلخواه 🌟',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 6),
              const Text(
                'از میان تصاویر زیر، آواتار خود را انتخاب کنید:',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _avatarOptions.length,
                  itemBuilder: (context, index) {
                    final avatarPath = _avatarOptions[index];
                    final isSelected = AuthManager.userAvatar == avatarPath;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          AuthManager.userAvatar = avatarPath;
                          AuthManager.save();
                        });
                        if (widget.onProfileUpdated != null) {
                          widget.onProfileUpdated!();
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? _getThemeAccentGradient().first : Colors.transparent,
                            width: 3,
                          ),
                          image: DecorationImage(
                            image: AssetImage(avatarPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ImageProvider _getAvatarProvider(String path) {
    if (path.isEmpty) {
      return const AssetImage('image/avatar/1.webp');
    }
    return AssetImage(path);
  }

  @override
  Widget build(BuildContext context) {
    // تضمین چینش راست به چپ (RTL) برای تمامی المان‌های صفحه ورود، ثبت‌نام و پروفایل
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PopScope(
        canPop: widget.isStandalone,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            if (widget.onGoHome != null) {
              widget.onGoHome!();
            } else {
              Navigator.pop(context);
            }
          }
        },
        child: Scaffold(
          body: AuthManager.isLoggedIn
              ? _buildDashboardView()
              : (_isOtpScreen ? _buildOtpView() : _buildPhoneInputView()),
        ),
      ),
    );
  }

  // مرحله ۱: صفحه ورود
  Widget _buildPhoneInputView() {
    return Material(
      color: _isNightMode ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ۱. تصویر پس‌زمینه
          Positioned.fill(
            child: Image.asset(
              _isNightMode ? 'image/login/1.webp' : 'image/login/2.webp',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          // ۲. دکمه تغییر تم روز و شب در بالا سمت راست
          Positioned(
            top: 45,
            left: 20,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isNightMode = !_isNightMode;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isNightMode ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: _isNightMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isNightMode ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                        color: _isNightMode ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isNightMode ? 'طرح شب' : 'طرح روز',
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _isNightMode ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.sync_rounded,
                        color: _isNightMode ? Colors.white70 : Colors.black54,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ۳. بدنه اصلی
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: AnimatedLightningCard(
                isNight: _isNightMode,
                child: Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'خوش آمدی قهرمان 🚀',
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: _isNightMode ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'شماره‌ات رو وارد کن و هدیه‌ی ورود رو همین الان دریافت کن 🎁',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 11,
                          color: _isNightMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // برچسب شماره موبایل
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'شماره موبایل',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _isNightMode ? const Color(0xFFE879F9) : const Color(0xFF0284C7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // کادر ورود شماره موبایل
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: _isNightMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isNightMode ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 11,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'Tahoma',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: _isNightMode ? Colors.white : const Color(0xFF0F172A),
                                    letterSpacing: 1.5,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    hintText: '09xxxxxxxxxx',
                                    hintStyle: TextStyle(
                                      color: _isNightMode ? Colors.grey.shade600 : Colors.grey.shade400,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.phone_android_rounded,
                              color: _isNightMode ? const Color(0xFFA855F7) : const Color(0xFF0284C7),
                              size: 20,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // دکمه ارسال کد تایید با گرادینت زیبا
                      Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: _isNightMode
                                ? [const Color(0xFF7C3AED), const Color(0xFFDB2777)]
                                : [const Color(0xFF0284C7), const Color(0xFF2563EB)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_isNightMode ? const Color(0xFFDB2777) : const Color(0xFF0284C7))
                                  .withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              String phone = _phoneController.text.trim();
                              if (phone.length == 11 && phone.startsWith('09')) {
                                for (var c in _otpControllers) {
                                  c.clear();
                                }
                                setState(() {
                                  AuthManager.phoneNumber = phone;
                                  _isOtpScreen = true;
                                  _startOtpTimer();
                                });
                              } else {
                                _showCustomError('لطفاً شماره موبایل معتبر وارد کنید.\nمثال: ۰۹۱۲۳۴۵۶۷۸۹');
                              }
                            },
                            child: const Center(
                              child: Text(
                                'ارسال کد تایید',
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
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // مرحله ۲: صفحه کد تایید
  Widget _buildOtpView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF1E293B)),
                    onPressed: () {
                      _otpTimer?.cancel();
                      setState(() {
                        _isOtpScreen = false;
                      });
                    },
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'تایید شماره موبایل',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 8),
              Text(
                'کد ۴ رقمی ارسال‌شده به شماره ${AuthManager.phoneNumber} را وارد کنید',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 40),

              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 55,
                      height: 55,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 3)),
                        ],
                      ),
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF4C1D95)),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) async {
                          if (value.isNotEmpty && index < 3) {
                            _otpFocusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            _otpFocusNodes[index - 1].requestFocus();
                          }

                          if (index == 3 && value.isNotEmpty) {
                            String fullCode = _otpControllers.map((c) => c.text).join();
                            if (fullCode.length == 4) {
                              if (_otpRemainingSeconds <= 0) {
                                _showCustomError('مهلت ۲ دقیقه‌ای کد منقضی شده است! ⏳\nلطفاً روی «ارسال مجدد کد» بزنید.');
                                return;
                              }

                              // اعتبارسنجی دقیق کد پیامکی؛ فقط و فقط در صورت ورود کد ارسال‌شده پیامک ورود انجام می‌شود
                              if (fullCode != _expectedOtpCode) {
                                _showCustomError('کد وارد شده نادرست است! ❌\nلطفاً کد تایید پیامکی ارسال‌شده ($_expectedOtpCode) را وارد کنید.');
                                for (var c in _otpControllers) {
                                  c.clear();
                                }
                                _otpFocusNodes[0].requestFocus();
                                return;
                              }

                              _otpTimer?.cancel();
                              String phone = AuthManager.phoneNumber;
                              await AuthManager.loadUserData(phone);

                              bool alreadyRewarded = await AuthManager.hasReceivedGiftFor(phone);

                              setState(() {
                                AuthManager.isLoggedIn = true;
                                if (!alreadyRewarded) {
                                  AuthManager.coins += 500;
                                  AuthManager.markGiftReceivedFor(phone);
                                  AuthManager.pendingWelcomeGift = true;
                                  AuthManager.save();
                                } else {
                                  AuthManager.pendingWelcomeGift = false;
                                  AuthManager.save();
                                }
                              });
                              if (widget.onProfileUpdated != null) {
                                widget.onProfileUpdated!();
                              }

                              // همگام‌سازی و ثبت در پنل ادمین در پس‌زمینه بدون ایجاد تاخیر
                              ApiService.syncStudentToAdmin(
                                phoneNumber: phone,
                                coins: AuthManager.coins,
                                selectedGrade: AuthManager.selectedGrade,
                              );
                            }
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 30),
              if (_otpRemainingSeconds > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer_outlined, size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 6),
                    Text(
                      'ارسال مجدد کد (${_formatOtpTimer(_otpRemainingSeconds)})',
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              else
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    for (var c in _otpControllers) {
                      c.clear();
                    }
                    _otpFocusNodes[0].requestFocus();
                    _startOtpTimer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 18,
                          color: _isNightMode ? const Color(0xFFDB2777) : const Color(0xFF0284C7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'ارسال مجدد کد تأیید',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            fontSize: 13,
                            color: _isNightMode ? const Color(0xFFDB2777) : const Color(0xFF0284C7),
                            fontWeight: FontWeight.w900,
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

  // مرحله ۳: پنل کاربری پس از ورود موفق
  Widget _buildDashboardView() {
    final List<String> gradeNames = ['پایه هفتم', 'پایه هشتم', 'پایه نهم'];
    String currentName = AuthManager.userName.isEmpty ? 'دانش‌آموز نابغه' : AuthManager.userName;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  onPressed: () {
                    if (widget.isStandalone) {
                      Navigator.pop(context);
                    } else if (widget.onGoHome != null) {
                      widget.onGoHome!();
                    }
                  },
                ),
                const Text('پروفایل من', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  // آواتار صفحه پروفایل
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: _showAvatarPicker,
                        child: SizedBox(
                          width: 96,
                          height: 96,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipOval(
                                child: Image(
                                  image: _getAvatarProvider(AuthManager.userAvatar),
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: _getThemeAccentGradient().first, width: 3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: GestureDetector(
                          onTap: _showAvatarPicker,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _getThemeAccentGradient().first,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'برای تغییر آواتار کلیک کنید',
                    style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  // نام کاربری قابل ویرایش
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit_rounded, size: 18, color: Color(0xFF4C1D95)),
                        onPressed: () {
                          _nameController.text = AuthManager.userName.isEmpty ? 'دانش‌آموز نابغه' : AuthManager.userName;
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('ویرایش نام کاربری', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                content: TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(hintText: 'نام خود را وارد کنید'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('لغو'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        AuthManager.userName = _nameController.text.trim();
                                        AuthManager.save();
                                      });
                                      if (widget.onProfileUpdated != null) {
                                        widget.onProfileUpdated!();
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text('ذخیره'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      AuthManager.phoneNumber,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFF1F5F9), thickness: 2),
                  const SizedBox(height: 16),

                  // انتخابگر پایه تحصیلی
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'پایه تحصیلی پیش‌فرض',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.all(4),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final double tabWidth = constraints.maxWidth / 3;
                            return Stack(
                              children: [
                                AnimatedPositionedDirectional(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  start: AuthManager.selectedGrade * tabWidth,
                                  top: 0,
                                  bottom: 0,
                                  width: tabWidth,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: _getThemeAccentGradient(),
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _getThemeAccentGradient()
                                              .first
                                              .withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: List.generate(3, (index) {
                                    final isSelected =
                                        AuthManager.selectedGrade == index;
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            AuthManager.selectedGrade = index;
                                            AuthManager.save();
                                          });
                                          if (widget.onGradeChanged != null) {
                                            widget.onGradeChanged!(index);
                                          }
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Center(
                                          child: AnimatedDefaultTextStyle(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            style: TextStyle(
                                              fontFamily: 'Tahoma',
                                              fontSize: isSelected ? 13 : 12,
                                              fontWeight: isSelected
                                                  ? FontWeight.w900
                                                  : FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.white
                                                  : const Color(0xFF64748B),
                                            ),
                                            child: Text(gradeNames[index]),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  // کارت تبلیغاتی هدیه پشتیبانی و مشاوره رایگان تحصیلی
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF059669), Color(0xFF10B981)],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          _showSupportOptionsModal(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Text('🎁',
                                    style: TextStyle(fontSize: 20)),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Text(
                                  'دریافت هدیه یک هفته پشتیبانی\nو مشاوره رایگان تحصیلی 🎉',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'Tahoma',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white70,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // دکمه خروج از حساب کاربری حرفه‌ای و مدرن پررنگ قبلی
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEF4444).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          // تغییر فوری رابط کاربری در همان لحظه تاچ دکمه (بدون معطلی)
                          setState(() {
                            AuthManager.isLoggedIn = false;
                            AuthManager.phoneNumber = '';
                            AuthManager.pendingWelcomeGift = false;
                            _isOtpScreen = false;
                            _phoneController.clear();
                            for (var c in _otpControllers) {
                              c.clear();
                            }
                          });
                          if (widget.onProfileUpdated != null) {
                            widget.onProfileUpdated!();
                          }
                          // ذخیره و پاکسازی امن داده‌های کاربر
                          await AuthManager.logoutClean();
                        },
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'خروج از حساب کاربری',
                                style: TextStyle(
                                  fontFamily: 'Tahoma',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

