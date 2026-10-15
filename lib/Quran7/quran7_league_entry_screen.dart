import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../managers/auth_manager.dart';
import '../screens/profile_screen.dart';
import 'quran7_league_manager.dart';
import 'quran7_league_leaderboard_screen.dart';
import 'quran7_league_admin_screen.dart';
import 'quran7_league_teacher_screen.dart';
import 'quran7_super_admin_screen.dart';

class Quran7LeagueEntryScreen extends StatefulWidget {
  const Quran7LeagueEntryScreen({super.key});

  @override
  State<Quran7LeagueEntryScreen> createState() =>
      _Quran7LeagueEntryScreenState();
}

class _Quran7LeagueEntryScreenState extends State<Quran7LeagueEntryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  String? _lastClassCode;

  String? _savedManagerPasscode;
  String? _savedTeacherCode;
  String? _savedStudentCode;

  @override
  void initState() {
    super.initState();
    _loadSavedSessions();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  Future<bool> _isUserRegisteredWithPhone() async {
    final phone = AuthManager.phoneNumber.trim();
    if (AuthManager.isLoggedIn && phone.isNotEmpty) {
      return true;
    }
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    final savedPhone = prefs.getString('phoneNumber') ?? '';
    if (loggedIn && savedPhone.trim().isNotEmpty) {
      AuthManager.isLoggedIn = true;
      AuthManager.phoneNumber = savedPhone.trim();
      return true;
    }
    return false;
  }

  void _navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          isStandalone: true,
          onGoHome: () => Navigator.pop(context),
        ),
      ),
    ).then((_) {
      _loadSavedSessions();
    });
  }

  void _showRegistrationRequiredDialog(String roleTitle) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF131D2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_android_rounded,
                    color: Colors.redAccent, size: 22),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'ثبت‌نام الزامی است',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'برای ورود به پنل $roleTitle، ابتدا باید با یک شماره تلفن در برنامه ثبت‌نام کنید. بدون ثبت‌نام حتی با داشتن کد صحیح، امکان ورود وجود ندارد.',
            style: const TextStyle(
              fontFamily: 'Tahoma',
              color: Color(0xFFCBD5E1),
              fontSize: 13,
              height: 1.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'انصراف',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                _navigateToRegistration();
              },
              icon: const Icon(Icons.app_registration_rounded,
                  size: 18, color: Colors.white),
              label: const Text(
                'ثبت‌نام با شماره تلفن',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSavedSessions() async {
    await Quran7LeagueManager.init(forceReload: true);
    final isRegistered = await _isUserRegisteredWithPhone();
    if (!isRegistered) {
      if (!mounted) return;
      setState(() {
        _savedManagerPasscode = null;
        _savedTeacherCode = null;
        _savedStudentCode = null;
        _lastClassCode = null;
      });
      return;
    }

    final mPass = await Quran7LeagueManager.getSavedManagerPasscode();
    final tCode = await Quran7LeagueManager.getSavedTeacherCode();
    final sCode = await Quran7LeagueManager.getSavedStudentClassCode();
    if (!mounted) return;
    setState(() {
      _savedManagerPasscode = mPass;
      _savedTeacherCode = tCode;
      _savedStudentCode = sCode;
      _lastClassCode = sCode;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // دیالوگ دریافت کد ۵ رقمی دانش‌آموز
  void _showStudentInputDialog() {
    final controller = TextEditingController(text: _lastClassCode ?? '');
    String? errorText;
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF131D2E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Text('🎒', style: TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ورود دانش‌آموز به لیگ قرآن',
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'کد کلاس ۵ رقمی که مدیر ایجاد کرده را وارد کنید',
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // فیلد ورودی کد ۵ رقمی
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF10B981),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 8,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '• • • • •',
                      hintStyle: const TextStyle(
                        color: Color(0xFF475569),
                        letterSpacing: 8,
                        fontSize: 20,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                            color: Color(0xFF10B981), width: 2),
                      ),
                    ),
                  ),

                  if (errorText != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.redAccent.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: Colors.redAccent, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorText!,
                              style: const TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFFFCA5A5),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (errorText!.contains('ثبت‌نام')) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _navigateToRegistration();
                          },
                          icon: const Icon(Icons.app_registration_rounded,
                              size: 16, color: Color(0xFF34D399)),
                          label: const Text(
                            'رفتن به صفحه ثبت‌نام با شماره تلفن',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF34D399),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF34D399)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 20),

                  // دکمه ورود
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              HapticFeedback.lightImpact();
                              final code = controller.text.trim();
                              if (code.length != 5) {
                                setModalState(() {
                                  errorText = 'لطفاً کد کلاس را کامل (۵ رقم) وارد کنید.';
                                });
                                return;
                              }

                              setModalState(() {
                                isSubmitting = true;
                                errorText = null;
                              });
                              FocusScope.of(ctx).unfocus();

                              // بررسی ثبت‌نام اولیه با شماره تلفن
                              final isRegistered =
                                  await _isUserRegisteredWithPhone();
                              if (!isRegistered) {
                                if (ctx.mounted) {
                                  setModalState(() {
                                    isSubmitting = false;
                                    errorText =
                                        'برای ورود به پنل دانش‌آموز، ابتدا باید با یک شماره تلفن در برنامه ثبت‌نام کنید.';
                                  });
                                }
                                return;
                              }

                              // بررسی وجود کلاس
                              await Quran7LeagueManager.init();
                              final qClass =
                                  Quran7LeagueManager.getClassByCode(code);

                              if (qClass == null) {
                                if (ctx.mounted) {
                                  setModalState(() {
                                    isSubmitting = false;
                                    errorText =
                                        'کلاس با کد «$code» یافت نشد! فقط کدهایی که مدیر ایجاد کرده باشد معتبر هستند.';
                                  });
                                }
                                return;
                              }

                              // ثبت دانش‌آموز جاری و ورود
                              final updatedClass =
                                  await Quran7LeagueManager.enrollOrUpdateCurrentUser(
                                      code);
                              await Quran7LeagueManager.saveStudentClassCode(code);
                              if (!mounted) return;
                              Navigator.pop(ctx); // بستن مودال

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Quran7LeagueLeaderboardScreen(
                                    quranClass: updatedClass ?? qClass,
                                  ),
                                ),
                              ).then((_) => _loadSavedSessions());
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        disabledBackgroundColor:
                            const Color(0xFF10B981).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('🏆', style: TextStyle(fontSize: 18)),
                                SizedBox(width: 8),
                                Text(
                                  'ورود به جدول رتبه‌بندی لیگ',
                                  style: TextStyle(
                                    fontFamily: 'Tahoma',
                                    color: Colors.white,
                                    fontSize: 14,
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
        ),
      ),
    );
  }

  // دیالوگ دریافت کد ۱۰ رقمی معلم
  void _showTeacherInputDialog() {
    final controller = TextEditingController();
    String? errorText;
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF131D2E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child:
                            const Text('👨‍🏫', style: TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ورود در نقش معلم',
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'کد اختصاصی ۱۰ رقمی صادره از مدیر را وارد کنید',
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // فیلد ورودی کد ۱۰ رقمی
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF60A5FA),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'کد ۱۰ رقمی دبیر',
                      hintStyle: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFF475569),
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                            color: Color(0xFF3B82F6), width: 2),
                      ),
                    ),
                  ),

                  if (errorText != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.redAccent.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: Colors.redAccent, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorText!,
                              style: const TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFFFCA5A5),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (errorText!.contains('ثبت‌نام')) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _navigateToRegistration();
                          },
                          icon: const Icon(Icons.app_registration_rounded,
                              size: 16, color: Color(0xFF60A5FA)),
                          label: const Text(
                            'رفتن به صفحه ثبت‌نام با شماره تلفن',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF60A5FA),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF60A5FA)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 20),

                  // دکمه ورود
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              HapticFeedback.lightImpact();
                              final code = controller.text.trim();
                              if (code.length != 10) {
                                setModalState(() {
                                  errorText = 'کد معلم باید دقیقاً ۱۰ رقم باشد.';
                                });
                                return;
                              }

                              setModalState(() {
                                isSubmitting = true;
                                errorText = null;
                              });
                              FocusScope.of(ctx).unfocus();

                              // بررسی ثبت‌نام اولیه با شماره تلفن
                              final isRegistered =
                                  await _isUserRegisteredWithPhone();
                              if (!isRegistered) {
                                if (ctx.mounted) {
                                  setModalState(() {
                                    isSubmitting = false;
                                    errorText =
                                        'برای ورود به پنل دبیر، ابتدا باید با یک شماره تلفن در برنامه ثبت‌نام کنید.';
                                  });
                                }
                                return;
                              }

                              await Quran7LeagueManager.init();
                              final qClass =
                                  Quran7LeagueManager.getClassByTeacherCode(code);

                              if (qClass == null) {
                                if (ctx.mounted) {
                                  setModalState(() {
                                    isSubmitting = false;
                                    errorText =
                                        'کد معلم نامعتبر است یا کلاسی با این کد ۱۰ رقمی یافت نشد!';
                                  });
                                }
                                return;
                              }

                              await Quran7LeagueManager.saveTeacherCode(code);
                              if (!mounted) return;
                              Navigator.pop(ctx);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Quran7LeagueTeacherScreen(
                                    quranClass: qClass,
                                  ),
                                ),
                              ).then((_) => _loadSavedSessions());
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        disabledBackgroundColor:
                            const Color(0xFF3B82F6).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login_rounded,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'ورود به پنل دبیر',
                                  style: TextStyle(
                                    fontFamily: 'Tahoma',
                                    color: Colors.white,
                                    fontSize: 14,
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
        ),
      ),
    );
  }

  // دیالوگ ورود مدیر با کد اختصاصی تعریف‌شده در پنل ادمین
  void _showAdminInputDialog() {
    final controller = TextEditingController();
    String? errorText;
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF131D2E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Text('👑', style: TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ورود در نقش مدیر',
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'رمز ورود اختصاصی مدیر را وارد کنید',
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // فیلد ورودی کد مدیر (دقیقاً و حداکثر ۱۰ رقم)
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    obscureText: true,
                    textDirection: TextDirection.ltr,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (val) {
                      if (val.length > 10) {
                        controller.text = val.substring(0, 10);
                        controller.selection = TextSelection.collapsed(
                          offset: controller.text.length,
                        );
                      }
                    },
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFFFBBF24),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '• • • • • • • • • •',
                      hintStyle: const TextStyle(
                        color: Color(0xFF475569),
                        letterSpacing: 6,
                        fontSize: 20,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                            color: Color(0xFFF59E0B), width: 2),
                      ),
                    ),
                  ),

                  if (errorText != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.redAccent.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: Colors.redAccent, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorText!,
                              style: const TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFFFCA5A5),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (errorText!.contains('ثبت‌نام')) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _navigateToRegistration();
                          },
                          icon: const Icon(Icons.app_registration_rounded,
                              size: 16, color: Color(0xFFFBBF24)),
                          label: const Text(
                            'رفتن به صفحه ثبت‌نام با شماره تلفن',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFBBF24),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFBBF24)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 20),

                  // دکمه ورود
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              HapticFeedback.lightImpact();
                              FocusScope.of(ctx).unfocus();
                              final code = controller.text.trim();
                              if (code.isEmpty || code.length != 10) {
                                setModalState(() {
                                  errorText =
                                      'رمز ورود مدیر باید دقیقاً ۱۰ رقم باشد!';
                                });
                                return;
                              }

                              setModalState(() {
                                isSubmitting = true;
                                errorText = null;
                              });

                              // بررسی ثبت‌نام اولیه با شماره تلفن
                              final isRegistered =
                                  await _isUserRegisteredWithPhone();
                              if (!isRegistered) {
                                if (ctx.mounted) {
                                  setModalState(() {
                                    isSubmitting = false;
                                    errorText =
                                        'برای ورود به پنل مدیریت، ابتدا باید با یک شماره تلفن در برنامه ثبت‌نام کنید.';
                                  });
                                }
                                return;
                              }

                              final res =
                                  await Quran7LeagueManager.verifyManagerPasscode(
                                      code);

                              if (!ctx.mounted) return;

                              if (res['success'] != true) {
                                setModalState(() {
                                  isSubmitting = false;
                                  errorText = res['message'] ??
                                      'رمز ورود مدیر نادرست است';
                                });
                                return;
                              }

                              await Quran7LeagueManager.saveManagerPasscode(code);
                              if (!mounted) return;
                              Navigator.pop(ctx);

                              if (res['isSuperAdmin'] == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const Quran7SuperAdminScreen(),
                                  ),
                                ).then((_) => _loadSavedSessions());
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const Quran7LeagueAdminScreen(),
                                  ),
                                ).then((_) => _loadSavedSessions());
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.security_rounded,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'تأیید و ورود به پنل مدیریت',
                                  style: TextStyle(
                                    fontFamily: 'Tahoma',
                                    color: Colors.white,
                                    fontSize: 14,
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
        ),
      ),
    );
  }

  Future<void> _handleStudentTap() async {
    final isRegistered = await _isUserRegisteredWithPhone();
    if (!isRegistered) {
      _showRegistrationRequiredDialog('دانش‌آموز');
      return;
    }

    final savedCode = await Quran7LeagueManager.getSavedStudentClassCode();
    if (savedCode != null && savedCode.isNotEmpty) {
      await Quran7LeagueManager.init();
      final updatedClass =
          await Quran7LeagueManager.enrollOrUpdateCurrentUser(savedCode);
      final qClass =
          updatedClass ?? Quran7LeagueManager.getClassByCode(savedCode);
      if (qClass != null) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Quran7LeagueLeaderboardScreen(
              quranClass: qClass,
            ),
          ),
        ).then((_) => _loadSavedSessions());
        return;
      }
    }
    _showStudentInputDialog();
  }

  Future<void> _handleTeacherTap() async {
    final isRegistered = await _isUserRegisteredWithPhone();
    if (!isRegistered) {
      _showRegistrationRequiredDialog('معلم');
      return;
    }

    final savedCode = await Quran7LeagueManager.getSavedTeacherCode();
    if (savedCode != null && savedCode.isNotEmpty) {
      await Quran7LeagueManager.init();
      final qClass = Quran7LeagueManager.getClassByTeacherCode(savedCode);
      if (qClass != null) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Quran7LeagueTeacherScreen(
              quranClass: qClass,
            ),
          ),
        ).then((_) => _loadSavedSessions());
        return;
      }
    }
    _showTeacherInputDialog();
  }

  Future<void> _handleAdminTap() async {
    final isRegistered = await _isUserRegisteredWithPhone();
    if (!isRegistered) {
      _showRegistrationRequiredDialog('مدیر');
      return;
    }

    final savedPass = await Quran7LeagueManager.getSavedManagerPasscode();
    if (savedPass != null && savedPass.isNotEmpty) {
      final res = await Quran7LeagueManager.verifyManagerPasscode(savedPass);
      if (res['success'] == true) {
        if (!mounted) return;
        if (res['isSuperAdmin'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const Quran7SuperAdminScreen(),
            ),
          ).then((_) => _loadSavedSessions());
          return;
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const Quran7LeagueAdminScreen(),
            ),
          ).then((_) => _loadSavedSessions());
          return;
        }
      } else {
        await Quran7LeagueManager.logoutManager();
        await _loadSavedSessions();
      }
    }
    _showAdminInputDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0F1D),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // دکمه بازگشت
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // هدر اصلی
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'لیگ کلاسی قرآن هفتم',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'نقش خود را برای ورود به لیگ کلاسی انتخاب کنید',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ۳ کارت نقش‌ها
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // کارت دانش‌آموز
                        _buildRoleCard(
                          title: 'دانش‌آموز',
                          subtitle: _savedStudentCode != null
                              ? 'کلاس (${toPersianDigits(_savedStudentCode!)}) ثبت شده است؛ برای ورود لمس کنید'
                              : 'ورود با کد ۵ رقمی کلاس و رقابت بر سر رتبه‌های برتر',
                          badge: _savedStudentCode != null
                              ? 'ورود خودکار فعال است ✅'
                              : 'جدول قهرمانان 🌟',
                          iconEmoji: '🎒',
                          gradient: const [
                            Color(0xFF047857),
                            Color(0xFF10B981),
                          ],
                          accentColor: const Color(0xFF10B981),
                          onTap: _handleStudentTap,
                        ),

                        const SizedBox(height: 16),

                        // کارت معلم
                        _buildRoleCard(
                          title: 'معلم',
                          subtitle: _savedTeacherCode != null
                              ? 'حساب دبیر متصل است؛ برای ورود لمس کنید'
                              : 'ورود با کد ۱۰ رقمی اختصاصی و مشاهده رتبه‌بندی دانش‌آموزان',
                          badge: _savedTeacherCode != null
                              ? 'ورود خودکار فعال است ✅'
                              : 'پنل دبیر 👨‍🏫',
                          iconEmoji: '👨‍🏫',
                          gradient: const [
                            Color(0xFF1D4ED8),
                            Color(0xFF3B82F6),
                          ],
                          accentColor: const Color(0xFF3B82F6),
                          onTap: _handleTeacherTap,
                        ),

                        const SizedBox(height: 16),

                        // کارت مدیر
                        _buildRoleCard(
                          title: (_savedManagerPasscode ==
                                      Quran7LeagueManager.superAdminPasscode &&
                                  Quran7LeagueManager.isSuperAdminPhone(
                                      AuthManager.phoneNumber))
                              ? 'ابرمُدیر سیستم'
                              : 'مدیر',
                          subtitle: _savedManagerPasscode != null
                              ? ((_savedManagerPasscode ==
                                          Quran7LeagueManager
                                              .superAdminPasscode &&
                                      Quran7LeagueManager.isSuperAdminPhone(
                                          AuthManager.phoneNumber))
                                  ? 'حساب ابرمُدیر متصل است؛ برای ورود لمس کنید'
                                  : 'حساب مدیریت متصل است؛ برای ورود لمس کنید')
                              : 'ایجاد کد ۵ رقمی کلاس، صدور کد معلم و نظارت سراسری',
                          badge: _savedManagerPasscode != null
                              ? 'ورود خودکار فعال است ✅'
                              : 'مدیریت و کنترل 👑',
                          iconEmoji: '👑',
                          gradient: const [
                            Color(0xFFB45309),
                            Color(0xFFF59E0B),
                          ],
                          accentColor: const Color(0xFFF59E0B),
                          onTap: _handleAdminTap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required String badge,
    required String iconEmoji,
    required List<Color> gradient,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accentColor.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // آیکون گرد جذاب با گرادیان
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(iconEmoji, style: const TextStyle(fontSize: 26)),
                  ),
                ),

                const SizedBox(width: 16),

                // توضیحات
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: accentColor.withOpacity(0.4)),
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Icon(Icons.arrow_back_ios_new_rounded,
                    color: accentColor, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
