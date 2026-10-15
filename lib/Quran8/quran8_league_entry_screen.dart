import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../managers/auth_manager.dart';
import '../screens/profile_screen.dart';
import 'quran8_league_manager.dart';
import 'quran8_league_leaderboard_screen.dart';
import 'quran8_league_admin_screen.dart';
import 'quran8_league_teacher_screen.dart';
import 'quran8_super_admin_screen.dart';

class Quran8LeagueEntryScreen extends StatefulWidget {
  const Quran8LeagueEntryScreen({super.key});

  @override
  State<Quran8LeagueEntryScreen> createState() =>
      _Quran8LeagueEntryScreenState();
}

class _Quran8LeagueEntryScreenState extends State<Quran8LeagueEntryScreen>
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
    await Quran8LeagueManager.init();
    final savedClassCode = await Quran8LeagueManager.getSavedStudentClassCode();
    final savedTeacher = await Quran8LeagueManager.getSavedTeacherCode();
    final savedManager = await Quran8LeagueManager.getSavedManagerPasscode();

    if (mounted) {
      setState(() {
        _lastClassCode = savedClassCode;
        _savedStudentCode = savedClassCode;
        _savedTeacherCode = savedTeacher;
        _savedManagerPasscode = savedManager;
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // دیالوگ ورود دانش‌آموز (کد ۵ رقمی)
  void _showStudentLoginDialog() async {
    final isRegistered = await _isUserRegisteredWithPhone();
    if (!isRegistered) {
      _showRegistrationRequiredDialog('دانش‌آموز');
      return;
    }

    final controller = TextEditingController(text: _savedStudentCode ?? '');
    String? localError;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF131D2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0xFF1E293B)),
            ),
            title: const Row(
              children: [
                Icon(Icons.person_pin_circle_rounded,
                    color: Color(0xFF10B981), size: 26),
                SizedBox(width: 8),
                Text(
                  'ورود به لیگ دانش‌آموزی',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'کد ۵ رقمی کلاسی که معلم یا مدیر به شما داده است را وارد کنید:',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 6,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '-----',
                      hintStyle: const TextStyle(
                        color: Color(0xFF475569),
                        letterSpacing: 6,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFF10B981), width: 2),
                      ),
                    ),
                  ),
                  if (localError != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      localError!,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Colors.redAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('انصراف',
                    style: TextStyle(fontFamily: 'Tahoma', color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () async {
                  final code = controller.text.trim();
                  if (code.length != 5 || int.tryParse(code) == null) {
                    setDialogState(() {
                      localError = 'کد کلاس باید ۵ رقم عددی باشد.';
                    });
                    return;
                  }

                  final qClass = Quran8LeagueManager.getClassByCode(code);
                  if (qClass == null) {
                    setDialogState(() {
                      localError = 'کلاسی با این کد ۵ رقمی یافت نشد!';
                    });
                    return;
                  }

                  Navigator.pop(ctx);
                  await Quran8LeagueManager.enrollOrUpdateCurrentUser(code);
                  await Quran8LeagueManager.saveStudentClassCode(code);

                  if (mounted) {
                    _loadSavedSessions();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Quran8LeagueLeaderboardScreen(
                          quranClass: qClass,
                          isTeacher: false,
                        ),
                      ),
                    ).then((_) => _loadSavedSessions());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  'ورود به کلاس',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دیالوگ ورود معلم (کد ۱۰ رقمی)
  void _showTeacherLoginDialog() async {
    final isRegistered = await _isUserRegisteredWithPhone();
    if (!isRegistered) {
      _showRegistrationRequiredDialog('دبیر');
      return;
    }

    final controller = TextEditingController(text: _savedTeacherCode ?? '');
    String? localError;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF131D2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0xFF1E293B)),
            ),
            title: const Row(
              children: [
                Icon(Icons.school_rounded, color: Color(0xFF34D399), size: 26),
                SizedBox(width: 8),
                Text(
                  'ورود دبیر محترم',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'کد ۱۰ رقمی اختصاصی معلم را که از مدیر مدرسه تحویل گرفته‌اید وارد کنید:',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '----------',
                      hintStyle: const TextStyle(
                        color: Color(0xFF475569),
                        letterSpacing: 4,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFF10B981), width: 2),
                      ),
                    ),
                  ),
                  if (localError != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      localError!,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Colors.redAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('انصراف',
                    style: TextStyle(fontFamily: 'Tahoma', color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () async {
                  final code = controller.text.trim();
                  if (code.length != 10 || int.tryParse(code) == null) {
                    setDialogState(() {
                      localError = 'کد معلم باید دقیقاً ۱۰ رقم باشد.';
                    });
                    return;
                  }

                  final qClass =
                      await Quran8LeagueManager.loginTeacher(code);
                  if (qClass == null) {
                    setDialogState(() {
                      localError = 'کد ۱۰ رقمی معلم نامعتبر است!';
                    });
                    return;
                  }

                  Navigator.pop(ctx);
                  if (mounted) {
                    _loadSavedSessions();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            Quran8LeagueTeacherScreen(quranClass: qClass),
                      ),
                    ).then((_) => _loadSavedSessions());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  'ورود به پنل دبیر',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دیالوگ ورود مدیر مدرسه (کد ۱۰ رقمی مدیر)
  void _showManagerLoginDialog() async {
    final isRegistered = await _isUserRegisteredWithPhone();
    if (!isRegistered) {
      _showRegistrationRequiredDialog('مدیر');
      return;
    }

    final controller = TextEditingController(text: _savedManagerPasscode ?? '');
    String? localError;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF131D2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0xFF1E293B)),
            ),
            title: const Row(
              children: [
                Icon(Icons.admin_panel_settings_rounded,
                    color: Color(0xFF6EE7B7), size: 26),
                SizedBox(width: 8),
                Text(
                  'ورود مدیر مدرسه',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'رمز ۱۰ رقمی اختصاصی مدیریت مدرسه را وارد کنید:',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '••••••••••',
                      hintStyle: const TextStyle(
                        color: Color(0xFF475569),
                        letterSpacing: 4,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFF10B981), width: 2),
                      ),
                    ),
                  ),
                  if (localError != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      localError!,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Colors.redAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('انصراف',
                    style: TextStyle(fontFamily: 'Tahoma', color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pass = controller.text.trim();
                  if (pass.length != 10 || int.tryParse(pass) == null) {
                    setDialogState(() {
                      localError = 'رمز مدیر باید دقیقاً ۱۰ رقم باشد.';
                    });
                    return;
                  }

                  final ok =
                      await Quran8LeagueManager.loginManager(pass);
                  if (ok == null) {
                    setDialogState(() {
                      localError = 'رمز مدیر مدرسه نامعتبر است!';
                    });
                    return;
                  }

                  Navigator.pop(ctx);
                  if (mounted) {
                    _loadSavedSessions();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Quran8LeagueAdminScreen(),
                      ),
                    ).then((_) => _loadSavedSessions());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF047857),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  'ورود به پنل مدیر',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
            tooltip: 'بازگشت به برنامه',
          ),
          actions: [
            // دسترسی مخفی به ابرمدیر با نگه‌داشتن روی نشان تاج
            GestureDetector(
              onLongPress: () {
                HapticFeedback.heavyImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Quran8SuperAdminScreen(),
                  ),
                ).then((_) => _loadSavedSessions());
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.shield_rounded,
                    color: Color(0xFF334155), size: 20),
              ),
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // آیکون و سربرگ اصلی لیگ قرآن هشتم
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF064E3B), Color(0xFF10B981)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🏆', style: TextStyle(fontSize: 42)),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'لیگ کلاسی قرآن هشتم',
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
                  'سامانه رقابت کلاسی، جدول رتبه‌بندی و پیشرفت درسی',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),

                const SizedBox(height: 30),

                // ۱. کارت دانش‌آموزان
                _buildRoleCard(
                  icon: Icons.emoji_events_rounded,
                  iconGradient: [const Color(0xFF059669), const Color(0xFF10B981)],
                  title: 'پنل دانش‌آموزان',
                  subtitle:
                      'ورود به جدول رتبه‌بندی، چالش‌ها و رقابت دونفره با دوستان',
                  btnLabel: 'ورود با کد ۵ رقمی کلاس',
                  btnColor: const Color(0xFF10B981),
                  badgeText: _savedStudentCode != null ? 'کلاس ذخیره‌شده ✓' : null,
                  onTap: _showStudentLoginDialog,
                ),

                const SizedBox(height: 16),

                // ۲. کارت دبیران
                _buildRoleCard(
                  icon: Icons.school_rounded,
                  iconGradient: [const Color(0xFF047857), const Color(0xFF059669)],
                  title: 'پنل دبیر محترم',
                  subtitle:
                      'مشاهده کارنامه درس‌ها، وضعیت خطاهای بازی و مدیریت دانش‌آموزان',
                  btnLabel: 'ورود با کد ۱۰ رقمی معلم',
                  btnColor: const Color(0xFF059669),
                  badgeText: _savedTeacherCode != null ? 'حساب فعال دبیر ✓' : null,
                  onTap: _showTeacherLoginDialog,
                ),

                const SizedBox(height: 16),

                // ۳. کارت مدیر مدرسه
                _buildRoleCard(
                  icon: Icons.admin_panel_settings_rounded,
                  iconGradient: [const Color(0xFF064E3B), const Color(0xFF047857)],
                  title: 'پنل مدیریت مدرسه',
                  subtitle:
                      'تعریف کلاس‌های جدید ۵ رقمی و صدور کدهای اختصاصی معلمان',
                  btnLabel: 'ورود با رمز مدیریت',
                  btnColor: const Color(0xFF047857),
                  badgeText: _savedManagerPasscode != null ? 'مدیر احراز شده ✓' : null,
                  onTap: _showManagerLoginDialog,
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required IconData icon,
    required List<Color> iconGradient,
    required String title,
    required String subtitle,
    required String btnLabel,
    required Color btnColor,
    String? badgeText,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: iconGradient,
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: iconGradient.last.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badgeText,
                              style: const TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF34D399),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onTap();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    btnLabel,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
