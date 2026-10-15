import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'league_config.dart';
import 'league_models.dart';
import 'league_storage_manager.dart';
import 'league_teacher_screen.dart';

/// پنل همگانی مدیر مدرسه برای هر درسی که با کانفیگ ارسال می‌شود
class UniversalLeagueAdminScreen extends StatefulWidget {
  final LeagueSubjectConfig config;

  const UniversalLeagueAdminScreen({super.key, required this.config});

  @override
  State<UniversalLeagueAdminScreen> createState() =>
      _UniversalLeagueAdminScreenState();
}

class _UniversalLeagueAdminScreenState
    extends State<UniversalLeagueAdminScreen> {
  final TextEditingController _classCodeController = TextEditingController();
  final TextEditingController _classTitleController = TextEditingController();
  bool _isLoading = false;
  bool _isGeneratingCode = false;
  List<LeagueClassModel> _classes = [];
  LeagueManagerProfile? _managerProfile;
  int _totalUsedAcrossAllSubjects = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await UniversalLeagueManager.init();
    final classes = UniversalLeagueManager.getClasses(widget.config.subjectId);
    final savedPasscode =
        await UniversalLeagueManager.getSavedManagerPasscode();
    LeagueManagerProfile? profile;
    int totalUsed = 0;

    if (savedPasscode != null) {
      profile = await UniversalLeagueManager.getManagerProfileByPasscode(
          savedPasscode);
      totalUsed = await UniversalLeagueManager.getTotalClassesCountForManager(
          savedPasscode);
    }

    if (mounted) {
      setState(() {
        _classes = classes;
        _managerProfile = profile;
        _totalUsedAcrossAllSubjects = totalUsed;
      });
    }
  }

  Future<void> _generateRandomUnusedClassCode() async {
    if (_isGeneratingCode) return;
    HapticFeedback.lightImpact();
    setState(() => _isGeneratingCode = true);
    final randomCode =
        await UniversalLeagueManager.generateUniqueRandomClassCode(
            widget.config.subjectId);
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
            backgroundColor: widget.config.primaryColor,
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

    if (UniversalLeagueManager.classCodeExists(
        widget.config.subjectId, code)) {
      _showWarningDialog(
        title: 'کد کلاس تکراری',
        message:
            'این کد کلاس قبلاً برای این درس ایجاد شده است! لطفاً یک کد دیگر ۵ رقمی بزنید.',
      );
      return;
    }

    // بررسی سهمیه کلی مدیر
    final savedPasscode =
        await UniversalLeagueManager.getSavedManagerPasscode();
    if (savedPasscode != null) {
      final canCreate =
          await UniversalLeagueManager.canCreateClass(savedPasscode);
      if (!canCreate) {
        _showWarningDialog(
          title: 'اتمام سهمیه ایجاد کلاس',
          message:
              'سهمیه ایجاد کلاس شما در تمام درس‌ها به پایان رسیده است. جهت افزایش سهمیه با پشتیبانی یا مدیر ارشد تماس بگیرید.',
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    final res = await UniversalLeagueManager.createClass(
      subjectId: widget.config.subjectId,
      classCode: code,
      title: title.isNotEmpty ? title : null,
      managerPasscode: savedPasscode,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res['success'] == true) {
      final LeagueClassModel newClass = res['class'] as LeagueClassModel;
      _classCodeController.clear();
      _classTitleController.clear();
      await _loadData();
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
                backgroundColor: widget.config.primaryColor,
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

  void _showSuccessCreatedDialog(LeagueClassModel qClass) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: widget.config.accentColor, width: 1.5),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.config.primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_rounded,
                    color: widget.config.accentColor, size: 28),
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
                _buildCodeCopyTile(
                  title: 'کد کلاس (۵ رقمی - مخصوص دانش‌آموزان):',
                  code: qClass.classCode,
                  accentColor: widget.config.accentColor,
                  icon: Icons.school_rounded,
                ),
                const SizedBox(height: 12),
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
                backgroundColor: widget.config.primaryColor,
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

  Future<void> _handleDeleteClass(LeagueClassModel qClass) async {
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
      await UniversalLeagueManager.deleteClass(
          widget.config.subjectId, qClass.classCode);
      await _loadData();
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
      await UniversalLeagueManager.logoutManager();
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quota = _managerProfile?.classQuota ?? 5;
    final remainingQuota = quota - _totalUsedAcrossAllSubjects;

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
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('👑', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'پنل مدیریت ${widget.config.leagueTitle}',
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  fontSize: 15,
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
              tooltip: 'خروج از حساب مدیر',
              onPressed: _confirmLogoutAdmin,
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            // کارت سهمیه کلی مدیر
            if (_managerProfile != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.config.darkColor.withOpacity(0.8),
                      const Color(0xFF0F172A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: widget.config.accentColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.config.primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _managerProfile!.name,
                            style: const TextStyle(
                              fontFamily: 'Tahoma',
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'سهمیه باقیمانده: ${toPersianDigits(remainingQuota > 0 ? remainingQuota : 0)} از ${toPersianDigits(quota)} کلاس (مشترک در تمام درس‌ها)',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              color: remainingQuota > 0
                                  ? widget.config.accentColor
                                  : Colors.redAccent,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // فرم ایجاد کلاس جدید
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF131D2E),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.add_circle_outline_rounded,
                          color: widget.config.accentColor, size: 22),
                      const SizedBox(width: 8),
                      const Text(
                        'ایجاد کلاس جدید',
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _classTitleController,
                    style: const TextStyle(
                        fontFamily: 'Tahoma', color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'نام یا عنوان کلاس (مثال: هفتم الف)',
                      hintStyle: const TextStyle(
                          fontFamily: 'Tahoma',
                          color: Color(0xFF64748B),
                          fontSize: 12),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                      prefixIcon: const Icon(Icons.title_rounded,
                          color: Color(0xFF64748B), size: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _classCodeController,
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: 'کد کلاس (۵ رقم)',
                            hintStyle: const TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF64748B),
                                fontSize: 12,
                                letterSpacing: 0),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: Color(0xFF334155)),
                            ),
                            prefixIcon: const Icon(Icons.numbers_rounded,
                                color: Color(0xFF64748B), size: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _generateRandomUnusedClassCode,
                        icon: const Icon(Icons.casino_outlined, size: 18),
                        label: const Text(
                          'شانسی',
                          style: TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF334155),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleCreateClass,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.config.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'ثبت و دریافت کدهای ورود',
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // سربرگ لیست کلاس‌های ایجاد شده در این درس
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'کلاس‌های ایجاد شده برای ${widget.config.subjectTitle}',
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
                    '${toPersianDigits(_classes.length)} کلاس',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      color: widget.config.accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_classes.isEmpty)
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFF131D2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: const Center(
                  child: Column(
                    children: [
                      Icon(Icons.class_outlined,
                          size: 40, color: Color(0xFF64748B)),
                      SizedBox(height: 10),
                      Text(
                        'هنوز کلاسی برای این درس ایجاد نکرده‌اید.',
                        style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFF94A3B8),
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._classes.map((c) => _buildClassCard(c)),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(LeagueClassModel qClass) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(18),
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.config.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'کد کلاس: ${toPersianDigits(qClass.classCode)}',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: widget.config.accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'کد معلم: ${toPersianDigits(qClass.teacherCode)}',
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFFFBBF24),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تعداد دانش‌آموزان: ${toPersianDigits(qClass.students.length)} نفر',
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UniversalLeagueTeacherScreen(
                        config: widget.config,
                        quranClass: qClass,
                      ),
                    ),
                  ).then((_) => _loadData());
                },
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: const Text(
                  'مشاهده پنل معلم',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: widget.config.accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
