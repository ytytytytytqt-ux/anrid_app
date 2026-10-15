import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quran7_league_manager.dart';
import 'quran7_league_teacher_screen.dart';

class Quran7LeagueAdminScreen extends StatefulWidget {
  const Quran7LeagueAdminScreen({super.key});

  @override
  State<Quran7LeagueAdminScreen> createState() =>
      _Quran7LeagueAdminScreenState();
}

class _Quran7LeagueAdminScreenState extends State<Quran7LeagueAdminScreen> {
  final TextEditingController _classCodeController = TextEditingController();
  final TextEditingController _classTitleController = TextEditingController();
  bool _isLoading = false;
  bool _isGeneratingCode = false;
  List<QuranClassModel> _classes = [];

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    await Quran7LeagueManager.init();
    setState(() {
      _classes = Quran7LeagueManager.getClasses();
    });
  }

  Future<void> _generateRandomUnusedClassCode() async {
    if (_isGeneratingCode) return;
    HapticFeedback.lightImpact();
    setState(() => _isGeneratingCode = true);
    final randomCode = await Quran7LeagueManager.generateUniqueRandomClassCode();
    if (mounted) {
      setState(() {
        _classCodeController.text = randomCode;
        _isGeneratingCode = false;
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'کد شانسی یکتا (${toPersianDigits(randomCode)}) قرار داده شد 🎲',
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Tahoma'),
            ),
            backgroundColor: const Color(0xFF8B5CF6),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  void dispose() {
    _classCodeController.dispose();
    _classTitleController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateClass() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();

    final code = _classCodeController.text.trim();
    final title = _classTitleController.text.trim();

    if (code.length != 5 || int.tryParse(code) == null) {
      _showWarningDialog(
        title: 'خطا در کد کلاس',
        message: 'کد کلاس باید دقیقاً ۵ رقم عددی باشد (مثلاً 54321).',
      );
      return;
    }

    if (Quran7LeagueManager.classCodeExists(code)) {
      _showWarningDialog(
        title: 'کد کلاس تکراری',
        message:
            'این کد کلاس قبلاً ایجاد شده است! لطفاً یک کد دیگر ۵ رقمی بزنید.',
      );
      return;
    }

    setState(() => _isLoading = true);

    final res = await Quran7LeagueManager.createClass(
      classCode: code,
      title: title.isNotEmpty ? title : null,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res['success'] == true) {
      final QuranClassModel newClass = res['class'] as QuranClassModel;
      _classCodeController.clear();
      _classTitleController.clear();
      await _loadClasses();
      if (mounted) {
        _showSuccessCreatedDialog(newClass);
      }
    } else {
      if (mounted) {
        _showWarningDialog(
          title: 'خطا',
          message: res['message'] ?? 'خطا در ایجاد کلاس',
        );
      }
    }
  }

  void _showWarningDialog({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFF59E0B), size: 28),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Tahoma',
              color: Color(0xFFCBD5E1),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('متوجه شدم',
                  style: TextStyle(fontFamily: 'Tahoma', color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessCreatedDialog(QuranClassModel qClass) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFF10B981), width: 1.5),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF10B981), size: 28),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'کلاس با موفقیت ایجاد شد! 🎉',
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
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  qClass.title,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),

                // کد کلاس ۵ رقمی برای دانش‌آموزان
                _buildCodeCopyTile(
                  title: 'کد کلاس (۵ رقمی - مخصوص دانش‌آموزان):',
                  code: qClass.classCode,
                  accentColor: const Color(0xFF06B6D4),
                  icon: Icons.school_rounded,
                ),

                const SizedBox(height: 12),

                // کد معلم ۱۰ رقمی
                _buildCodeCopyTile(
                  title: 'کد اختصاصی معلم (۱۰ رقمی):',
                  code: qClass.teacherCode,
                  subtitle: '(۵ رقم کد کلاس + ۵ رقم تصادفی یکتا)',
                  accentColor: const Color(0xFFF59E0B),
                  icon: Icons.person_pin_rounded,
                ),

                const SizedBox(height: 14),
                const Text(
                  '📌 کد ۵ رقمی را به دانش‌آموزان و کد ۱۰ رقمی را به معلم تحویل دهید.',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFF64748B),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              child: const Text(
                'تأیید و بستن',
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
    );
  }

  Widget _buildCodeCopyTile({
    required String title,
    required String code,
    String? subtitle,
    required Color accentColor,
    required IconData icon,
  }) {
    void copyAction() {
      HapticFeedback.lightImpact();
      Clipboard.setData(ClipboardData(text: code));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('کد $code در کلیپ‌بورد کپی شد'),
            backgroundColor: accentColor,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: copyAction,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentColor.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: accentColor, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFFCBD5E1),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFF64748B),
                    fontSize: 10,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    code,
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      color: accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: accentColor.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.copy_rounded, color: accentColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'کپی',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleDeleteClass(QuranClassModel qClass) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'حذف کلاس',
            style: TextStyle(
                fontFamily: 'Tahoma',
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            'آیا از حذف کلاس «${qClass.title}» با کد ${toPersianDigits(qClass.classCode)} اطمینان دارید؟',
            style: const TextStyle(
                fontFamily: 'Tahoma', color: Color(0xFFCBD5E1), fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('انصراف',
                  style: TextStyle(fontFamily: 'Tahoma', color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('حذف شود',
                  style: TextStyle(fontFamily: 'Tahoma', color: Colors.white)),
            ),
          ],
        ),
      ),
    );

    if (confirm == true) {
      await Quran7LeagueManager.deleteClass(qClass.classCode);
      await _loadClasses();
    }
  }

  Future<void> _confirmLogoutAdmin() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
              SizedBox(width: 8),
              Text(
                'خروج از حساب مدیریت',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: const Text(
            'آیا می‌خواهید از حساب مدیریت خارج شوید؟\nپس از خروج، ورود خودکار غیرفعال شده و برای ورود مجدد باید دوباره رمز ۱۰ رقمی را وارد کنید.',
            style: TextStyle(
              fontFamily: 'Tahoma',
              color: Color(0xFFCBD5E1),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('انصراف',
                  style: TextStyle(fontFamily: 'Tahoma', color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'خروج از حساب',
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
    );

    if (confirm == true) {
      await Quran7LeagueManager.logoutManager();
      if (!mounted) return;
      Navigator.pop(context);
    }
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
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('👑', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'پنل مدیریت لیگ قرآن هفتم',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout_rounded,
                        color: Color(0xFFFCA5A5), size: 16),
                    SizedBox(width: 4),
                    Text(
                      'خروج',
                      style: TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFFFCA5A5),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              tooltip: 'خروج از حساب مدیریت',
              onPressed: _confirmLogoutAdmin,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _loadClasses,
          color: const Color(0xFF8B5CF6),
          backgroundColor: const Color(0xFF131D2E),
          child: ListView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
            // کارت هویت و سهمیه مدیر
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF131D2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFF38BDF8).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user_rounded,
                        color: Color(0xFF38BDF8), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Quran7LeagueManager.currentManagerName,
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'سهمیه ایجاد کلاس: ${toPersianDigits(_classes.length)} از ${toPersianDigits(Quran7LeagueManager.currentManagerMaxClasses)} کلاس',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: _classes.length >=
                                    Quran7LeagueManager.currentManagerMaxClasses
                                ? const Color(0xFFF87171)
                                : const Color(0xFF34D399),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // کارت ایجاد کلاس جدید
            _buildCreateClassCard(),

            const SizedBox(height: 24),

            // عنوان بخش لیست کلاس‌ها
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'کلاس‌های ایجاد شده',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${toPersianDigits(_classes.length)} از ${toPersianDigits(Quran7LeagueManager.currentManagerMaxClasses)} کلاس مجاز',
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF38BDF8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // لیست کلاس‌های تعریف‌شده
            if (_classes.isEmpty)
              _buildEmptyClasses()
            else
              ..._classes.map((c) => _buildClassCard(c)),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildCreateClassCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.15),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.add_business_rounded,
                    color: Color(0xFFA78BFA), size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ایجاد کلاس جدید قرآن هفتم',
                      style: TextStyle(
                        fontFamily: 'Tahoma',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'کد کلاس ۵ رقمی را وارد کنید تا کد معلم خودکار تولید شود',
                      style: TextStyle(
                        fontFamily: 'Tahoma',
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ورودی کد ۵ رقمی کلاس با دکمه کد تصادفی یکتا در سمت چپ
          TextField(
            controller: _classCodeController,
            keyboardType: TextInputType.number,
            maxLength: 5,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              fontFamily: 'Tahoma',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
            decoration: InputDecoration(
              counterText: '',
              prefixIcon: const Icon(Icons.pin_rounded,
                  color: Color(0xFFA78BFA), size: 20),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Tooltip(
                  message: 'تولید کد شانسی که تا کنون ایجاد نشده',
                  child: InkWell(
                    onTap: _generateRandomUnusedClassCode,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _isGeneratingCode
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.casino_rounded,
                                  color: Colors.white, size: 16),
                          const SizedBox(width: 5),
                          const Text(
                            'کد شانسی',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              labelText: 'کد کلاس (۵ رقم)',
              labelStyle: const TextStyle(
                  fontFamily: 'Tahoma', color: Color(0xFF94A3B8), fontSize: 13),
              hintText: 'مثلاً: 54321',
              hintStyle: const TextStyle(
                  fontFamily: 'Tahoma', color: Color(0xFF475569), fontSize: 13),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFA78BFA), width: 2),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ورودی عنوان دلخواه کلاس
          TextField(
            controller: _classTitleController,
            style: const TextStyle(
                fontFamily: 'Tahoma', color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.edit_note_rounded,
                  color: Color(0xFFA78BFA), size: 20),
              labelText: 'عنوان کلاس (اختیاری)',
              labelStyle: const TextStyle(
                  fontFamily: 'Tahoma', color: Color(0xFF94A3B8), fontSize: 13),
              hintText: 'مثلاً: کلاس هفتم ۱ - شهید مطهری',
              hintStyle: const TextStyle(
                  fontFamily: 'Tahoma', color: Color(0xFF475569), fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFA78BFA), width: 2),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // دکمه ایجاد
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleCreateClass,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline_rounded,
                            color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'ایجاد کلاس و صدور کد معلم',
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
    );
  }

  Widget _buildClassCard(QuranClassModel qClass) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  qClass.title,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _handleDeleteClass(qClass),
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent, size: 20),
                tooltip: 'حذف کلاس',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // کدهای کلاس و معلم
          Row(
            children: [
              // کد کلاس
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Clipboard.setData(ClipboardData(text: qClass.classCode));
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text('کد کلاس کپی شد'),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF06B6D4).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'کد کلاس (دانش‌آموز):',
                            style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF94A3B8),
                                fontSize: 10),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                toPersianDigits(qClass.classCode),
                                style: const TextStyle(
                                  fontFamily: 'Tahoma',
                                  color: Color(0xFF22D3EE),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF22D3EE).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.copy_rounded,
                                  color: Color(0xFF22D3EE),
                                  size: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // کد دبیر
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Clipboard.setData(ClipboardData(text: qClass.teacherCode));
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text('کد معلم کپی شد'),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFF59E0B).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'کد دبیر (۱۰ رقمی):',
                            style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF94A3B8),
                                fontSize: 10),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  toPersianDigits(qClass.teacherCode),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Tahoma',
                                    color: Color(0xFFFBBF24),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFFBBF24).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.copy_rounded,
                                  color: Color(0xFFFBBF24),
                                  size: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // دکمه مشاهده رتبه‌بندی
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Quran7LeagueTeacherScreen(
                      quranClass: qClass,
                    ),
                  ),
                ).then((_) => _loadClasses());
              },
              icon: const Icon(Icons.leaderboard_rounded,
                  color: Color(0xFF38BDF8), size: 18),
              label: Text(
                'مشاهده جدول رتبه‌بندی کلاس (${toPersianDigits(qClass.students.length)} دانش‌آموز)',
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  color: Color(0xFF38BDF8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF0284C7)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyClasses() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.class_outlined, color: Color(0xFF64748B), size: 40),
            SizedBox(height: 10),
            Text(
              'هنوز کلاسی ثبت نشده است',
              style: TextStyle(
                fontFamily: 'Tahoma',
                color: Color(0xFF94A3B8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
