import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../managers/auth_manager.dart';
import '../screens/profile_screen.dart';
import 'league_config.dart';
import 'league_models.dart';
import 'league_storage_manager.dart';
import 'league_leaderboard_screen.dart';
import 'league_teacher_screen.dart';
import 'league_admin_screen.dart';
import 'league_super_admin_screen.dart';

/// درگاه همگانی ورود به لیگ کلاسی (دانش‌آموز، دبیر، مدیر مدرسه و مدیر ارشد)
class UniversalLeagueEntryScreen extends StatefulWidget {
  final LeagueSubjectConfig config;

  const UniversalLeagueEntryScreen({super.key, required this.config});

  @override
  State<UniversalLeagueEntryScreen> createState() =>
      _UniversalLeagueEntryScreenState();
}

class _UniversalLeagueEntryScreenState extends State<UniversalLeagueEntryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

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

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedSessions() async {
    await UniversalLeagueManager.init();
    final mgrPass = await UniversalLeagueManager.getSavedManagerPasscode();
    final teachCode = await UniversalLeagueManager.getSavedTeacherCode(
        widget.config.subjectId);
    final studCode = await UniversalLeagueManager.getSavedStudentClassCode(
        widget.config.subjectId);

    if (mounted) {
      setState(() {
        _savedManagerPasscode = mgrPass;
        _savedTeacherCode = teachCode;
        _savedStudentCode = studCode;
      });
    }
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
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ورودی دانش‌آموز
  Future<void> _handleStudentEntry() async {
    final isRegistered = await _isUserRegisteredWithPhone();
    if (!isRegistered) {
      if (mounted) _showRegistrationRequiredDialog('دانش‌آموز');
      return;
    }

    if (_savedStudentCode != null && _savedStudentCode!.isNotEmpty) {
      final qClass = UniversalLeagueManager.getClassByCode(
          widget.config.subjectId, _savedStudentCode!);
      if (qClass != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UniversalLeagueLeaderboardScreen(
              config: widget.config,
              quranClass: qClass,
              isTeacher: false,
            ),
          ),
        ).then((_) => _loadSavedSessions());
        return;
      }
    }

    _showStudentCodeDialog();
  }

  void _showStudentCodeDialog() {
    final controller = TextEditingController();
    String? localError;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF131D2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: const BorderSide(color: Color(0xFF1E293B)),
            ),
            title: Row(
              children: [
                Icon(Icons.school_rounded,
                    color: widget.config.accentColor, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'ورود دانش‌آموز',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'کد ۵ رقمی کلاس خود را که از معلم دریافت کرده‌اید وارد کنید:',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  autofocus: true,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'کد ۵ رقمی',
                    hintStyle: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF475569),
                      fontSize: 13,
                      letterSpacing: 0,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF334155)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: widget.config.accentColor, width: 1.8),
                    ),
                  ),
                ),
                if (localError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    localError!,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Colors.redAccent,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('انصراف',
                    style: TextStyle(
                        fontFamily: 'Tahoma', color: Color(0xFF94A3B8))),
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

                  final qClass = UniversalLeagueManager.getClassByCode(
                      widget.config.subjectId, code);
                  if (qClass == null) {
                    setDialogState(() {
                      localError = 'کلاسی با این کد در این درس یافت نشد.';
                    });
                    return;
                  }

                  Navigator.pop(ctx);
                  await UniversalLeagueManager.saveStudentClassCode(
                      widget.config.subjectId, code);
                  await UniversalLeagueManager.enrollStudent(
                      widget.config.subjectId, code);

                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UniversalLeagueLeaderboardScreen(
                          config: widget.config,
                          quranClass: qClass,
                          isTeacher: false,
                        ),
                      ),
                    ).then((_) => _loadSavedSessions());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.config.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'ورود به لیگ',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ورودی دبیر
  Future<void> _handleTeacherEntry() async {
    final isRegistered = await _isUserRegisteredWithPhone();
    if (!isRegistered) {
      if (mounted) _showRegistrationRequiredDialog('دبیر');
      return;
    }

    if (_savedTeacherCode != null && _savedTeacherCode!.isNotEmpty) {
      final qClass = UniversalLeagueManager.getClassByTeacherCode(
          widget.config.subjectId, _savedTeacherCode!);
      if (qClass != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UniversalLeagueTeacherScreen(
              config: widget.config,
              quranClass: qClass,
            ),
          ),
        ).then((_) => _loadSavedSessions());
        return;
      }
    }

    _showTeacherCodeDialog();
  }

  void _showTeacherCodeDialog() {
    final controller = TextEditingController();
    String? localError;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF131D2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: const BorderSide(color: Color(0xFF1E293B)),
            ),
            title: const Row(
              children: [
                Icon(Icons.person_pin_rounded,
                    color: Color(0xFFF59E0B), size: 24),
                SizedBox(width: 8),
                Text(
                  'ورود دبیر محترم',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'کد اختصاصی ۱۰ رقمی معلم را که مدیر مدرسه به شما تحویل داده وارد کنید:',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  autofocus: true,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'کد ۱۰ رقمی دبیر',
                    hintStyle: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF475569),
                      fontSize: 12,
                      letterSpacing: 0,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF334155)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                          color: Color(0xFFF59E0B), width: 1.8),
                    ),
                  ),
                ),
                if (localError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    localError!,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Colors.redAccent,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('انصراف',
                    style: TextStyle(
                        fontFamily: 'Tahoma', color: Color(0xFF94A3B8))),
              ),
              ElevatedButton(
                onPressed: () async {
                  final code = controller.text.trim();
                  if (code.length != 10 || int.tryParse(code) == null) {
                    setDialogState(() {
                      localError = 'کد دبیر باید ۱۰ رقم عددی باشد.';
                    });
                    return;
                  }

                  final qClass = UniversalLeagueManager.getClassByTeacherCode(
                      widget.config.subjectId, code);
                  if (qClass == null) {
                    setDialogState(() {
                      localError =
                          'کلاسی با این کد معلم در این درس یافت نشد.';
                    });
                    return;
                  }

                  Navigator.pop(ctx);
                  await UniversalLeagueManager.saveTeacherCode(
                      widget.config.subjectId, code);

                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UniversalLeagueTeacherScreen(
                          config: widget.config,
                          quranClass: qClass,
                        ),
                      ),
                    ).then((_) => _loadSavedSessions());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'ورود به پنل دبیر',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ورودی مدیر مدرسه
  Future<void> _handleManagerEntry() async {
    final isRegistered = await _isUserRegisteredWithPhone();
    if (!isRegistered) {
      if (mounted) _showRegistrationRequiredDialog('مدیر مدرسه');
      return;
    }

    if (_savedManagerPasscode != null && _savedManagerPasscode!.isNotEmpty) {
      final profile = await UniversalLeagueManager.getManagerProfileByPasscode(
          _savedManagerPasscode!);
      if (profile != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UniversalLeagueAdminScreen(config: widget.config),
          ),
        ).then((_) => _loadSavedSessions());
        return;
      }
    }

    _showManagerPasscodeDialog();
  }

  void _showManagerPasscodeDialog() {
    final controller = TextEditingController();
    String? localError;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF131D2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: const BorderSide(color: Color(0xFF1E293B)),
            ),
            title: const Row(
              children: [
                Icon(Icons.admin_panel_settings_rounded,
                    color: Color(0xFF8B5CF6), size: 24),
                SizedBox(width: 8),
                Text(
                  'ورود مدیر مدرسه',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'رمز عبور ۱۰ رقمی مدیریت مدرسه را وارد کنید:',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  autofocus: true,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'رمز ۱۰ رقمی مدیر',
                    hintStyle: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF475569),
                      fontSize: 12,
                      letterSpacing: 0,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF334155)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                          color: Color(0xFF8B5CF6), width: 1.8),
                    ),
                  ),
                ),
                if (localError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    localError!,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Colors.redAccent,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('انصراف',
                    style: TextStyle(
                        fontFamily: 'Tahoma', color: Color(0xFF94A3B8))),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pass = controller.text.trim();
                  if (pass.length != 10 || int.tryParse(pass) == null) {
                    setDialogState(() {
                      localError = 'رمز عبور باید ۱۰ رقم عددی باشد.';
                    });
                    return;
                  }

                  final profile =
                      await UniversalLeagueManager.loginManager(pass);
                  if (profile == null) {
                    setDialogState(() {
                      localError =
                          'رمز عبور نامعتبر است یا مدیر تعریف نشده است.';
                    });
                    return;
                  }

                  Navigator.pop(ctx);
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            UniversalLeagueAdminScreen(config: widget.config),
                      ),
                    ).then((_) => _loadSavedSessions());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'ورود به پنل مدیریت',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ورود مخفیانه مدیر ارشد
  void _openSuperAdminPanel() {
    HapticFeedback.heavyImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UniversalLeagueSuperAdminScreen(),
      ),
    ).then((_) => _loadSavedSessions());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0F1D),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111827),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: GestureDetector(
            onLongPress: _openSuperAdminPanel,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.config.emoji,
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  widget.config.leagueTitle,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              // کارت هدر خوش‌آمدگویی و معرفی
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.config.darkColor.withOpacity(0.85),
                      const Color(0xFF0F172A),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: widget.config.accentColor.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: widget.config.primaryColor.withOpacity(0.15),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'سامانه لیگ کلاسی ${widget.config.subjectTitle}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'لطفاً نقش خود را برای ورود به سامانه رقابت کلاسی انتخاب کنید:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ۳ کارت اصلی: دانش‌آموز، دبیر، مدیر
              _buildRoleCard(
                title: 'پنل دانش‌آموزان',
                subtitle: 'ورود به جدول رتبه‌بندی و شرکت در رقابت‌های دونفره',
                emoji: '🎒',
                accentColor: widget.config.accentColor,
                onTap: _handleStudentEntry,
                hasActiveSession: _savedStudentCode != null,
                sessionInfo: _savedStudentCode != null
                    ? 'کلاس: ${toPersianDigits(_savedStudentCode!)}'
                    : null,
              ),

              const SizedBox(height: 14),

              _buildRoleCard(
                title: 'پنل دبیر محترم',
                subtitle: 'مشاهده کارنامه درس‌ها، خطاهای لغات و مدیریت کلاس',
                emoji: '👨‍🏫',
                accentColor: const Color(0xFFF59E0B),
                onTap: _handleTeacherEntry,
                hasActiveSession: _savedTeacherCode != null,
                sessionInfo:
                    _savedTeacherCode != null ? 'ورود سریع فعال است' : null,
              ),

              const SizedBox(height: 14),

              _buildRoleCard(
                title: 'پنل مدیریت مدرسه',
                subtitle: 'ایجاد کلاس‌های جدید، دریافت کدها و نظارت بر لیگ',
                emoji: '👑',
                accentColor: const Color(0xFF8B5CF6),
                onTap: _handleManagerEntry,
                hasActiveSession: _savedManagerPasscode != null,
                sessionInfo:
                    _savedManagerPasscode != null ? 'ورود سریع فعال است' : null,
              ),

              const SizedBox(height: 36),

              // پانویس راهنما
              const Center(
                child: Text(
                  '💡 برای دسترسی به پنل مدیر ارشد، روی عنوان بالا نگه دارید.',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required String emoji,
    required Color accentColor,
    required VoidCallback onTap,
    required bool hasActiveSession,
    String? sessionInfo,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: hasActiveSession
              ? accentColor.withOpacity(0.5)
              : const Color(0xFF1E293B),
          width: hasActiveSession ? 1.5 : 1.0,
        ),
        boxShadow: hasActiveSession
            ? [
                BoxShadow(
                  color: accentColor.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 26)),
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
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (hasActiveSession) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                sessionInfo ?? 'فعال',
                                style: TextStyle(
                                  fontFamily: 'Tahoma',
                                  color: accentColor,
                                  fontSize: 10,
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
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
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
