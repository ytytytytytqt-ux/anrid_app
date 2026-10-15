import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quran8_league_manager.dart';
import 'quran8_league_teacher_screen.dart';

class Quran8LeagueAdminScreen extends StatefulWidget {
  const Quran8LeagueAdminScreen({super.key});

  @override
  State<Quran8LeagueAdminScreen> createState() =>
      _Quran8LeagueAdminScreenState();
}

class _Quran8LeagueAdminScreenState extends State<Quran8LeagueAdminScreen> {
  final TextEditingController _classCodeController = TextEditingController();
  final TextEditingController _classTitleController = TextEditingController();
  bool _isLoading = false;
  bool _isGeneratingCode = false;
  List<Quran8ClassModel> _classes = [];

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    await Quran8LeagueManager.init();
    setState(() {
      _classes = Quran8LeagueManager.getClasses();
    });
  }

  Future<void> _generateRandomUnusedClassCode() async {
    if (_isGeneratingCode) return;
    HapticFeedback.lightImpact();
    setState(() => _isGeneratingCode = true);
    final randomCode = await Quran8LeagueManager.generateUniqueRandomClassCode();
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
            backgroundColor: const Color(0xFF10B981),
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

    if (Quran8LeagueManager.classCodeExists(code)) {
      _showWarningDialog(
        title: 'کد کلاس تکراری',
        message:
            'این کد کلاس قبلاً ایجاد شده است! لطفاً یک کد دیگر ۵ رقمی بزنید.',
      );
      return;
    }

    setState(() => _isLoading = true);

    final res = await Quran8LeagueManager.createClass(
      classCode: code,
      title: title.isNotEmpty ? title : null,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res['success'] == true) {
      final Quran8ClassModel newClass = res['class'] as Quran8ClassModel;
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
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('متوجه شدم',
                  style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessCreatedDialog(Quran8ClassModel newClass) {
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
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded,
                  color: Color(0xFF10B981), size: 30),
              SizedBox(width: 10),
              Text(
                'کلاس با موفقیت ساخته شد 🎉',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'کلاس «${newClass.title}» با کدهای اختصاصی زیر آماده است:',
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  color: Color(0xFFCBD5E1),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              // باکس کد ۵ رقمی دانش‌آموز
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'کد ورود دانش‌آموزان (۵ رقم):',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          toPersianDigits(newClass.classCode),
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFF34D399),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded,
                          color: Color(0xFF34D399), size: 20),
                      tooltip: 'کپی کد کلاس',
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: newClass.classCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('کد کلاس کپی شد'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // باکس کد ۱۰ رقمی معلم
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFFF59E0B).withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'کد اختصاصی معلم (۱۰ رقم):',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          toPersianDigits(newClass.teacherCode),
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFFFBBF24),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded,
                          color: Color(0xFFFBBF24), size: 20),
                      tooltip: 'کپی کد معلم',
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: newClass.teacherCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('کد معلم کپی شد'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('متوجه شدم',
                  style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteClass(Quran8ClassModel qClass) async {
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
              Icon(Icons.delete_forever_rounded,
                  color: Colors.redAccent, size: 26),
              SizedBox(width: 8),
              Text(
                'حذف کلاس',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'آیا از حذف کلاس «${qClass.title}» مطمئن هستید؟ تمامی اطلاعات ${toPersianDigits(qClass.students.length)} دانش‌آموز عضو این کلاس نیز پاک خواهد شد.',
            style: const TextStyle(
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
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('حذف کلاس',
                  style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );

    if (confirm == true) {
      await Quran8LeagueManager.deleteClass(qClass.classCode);
      await _loadClasses();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('کلاس با موفقیت حذف شد.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final manager = Quran8LeagueManager.getActiveManagerProfile();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E293B),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
            tooltip: 'بازگشت',
          ),
          title: const Row(
            children: [
              Text('🏛️', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'پنل مدیریت • لیگ قرآن هشتم',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded,
                  color: Colors.redAccent, size: 20),
              tooltip: 'خروج از حساب مدیر',
              onPressed: () async {
                await Quran8LeagueManager.logoutManager();
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // کارت خوش‌آمدگویی مدیر و ظرفیت کلاس‌ها
            _buildManagerHeaderCard(manager),

            const SizedBox(height: 18),

            // فرم ساخت کلاس جدید ۵ رقمی
            _buildCreateClassCard(),

            const SizedBox(height: 24),

            // عنوان لیست کلاس‌های فعال
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'کلاس‌های فعال ساخته‌شده',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 15,
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
                    '${toPersianDigits(_classes.length)} کلاس',
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF10B981),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // لیست کلاس‌ها
            if (_classes.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF131D2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: const Center(
                  child: Column(
                    children: [
                      Icon(Icons.class_outlined,
                          color: Color(0xFF64748B), size: 44),
                      SizedBox(height: 12),
                      Text(
                        'هنوز کلاسی ساخته نشده است.\nبا استفاده از کادر بالا، اولین کلاس ۵ رقمی خود را بسازید.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          color: Color(0xFF94A3B8),
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._classes.map((c) => _buildClassTile(c)),
          ],
        ),
      ),
    );
  }

  Widget _buildManagerHeaderCard(Quran8ManagerProfile? manager) {
    final name = manager?.name ?? 'مدیر محترم';
    final quota = manager?.classQuota ?? 5;
    final createdCount = _classes.length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF0F172A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.15),
            blurRadius: 14,
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
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.manage_accounts_rounded,
                    color: Color(0xFF34D399), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'مدیریت کلاس‌های پایه هشتم و تولید کدها',
                      style: TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFF6EE7B7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white12),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ظرفیت ایجاد: ${toPersianDigits(createdCount)} از ${toPersianDigits(quota)} کلاس مجاز',
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  color: Color(0xFFCBD5E1),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                createdCount >= quota ? 'ظرفیت تکمیل ⚠️' : 'دارای سهمیه ✓',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: createdCount >= quota
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF34D399),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateClassCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.add_circle_outline_rounded,
                  color: Color(0xFF10B981), size: 20),
              SizedBox(width: 8),
              Text(
                'ایجاد کلاس جدید (۵ رقمی)',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // فیلد نام کلاس
          TextField(
            controller: _classTitleController,
            style: const TextStyle(
                fontFamily: 'Tahoma', color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'نام کلاس (اختیاری، مثلاً کلاس هشتم الف)',
              hintStyle: const TextStyle(
                  fontFamily: 'Tahoma', color: Color(0xFF64748B), fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xFF10B981), width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          // فیلد کد کلاس ۵ رقمی + دکمه کد شانسی
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
                    hintText: 'کد ۵ رقمی (مثلاً 54321)',
                    hintStyle: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF64748B),
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
                          color: Color(0xFF10B981), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _generateRandomUnusedClassCode,
                icon: const Icon(Icons.casino_rounded, size: 16),
                label: const Text('کد شانسی',
                    style: TextStyle(fontFamily: 'Tahoma', fontSize: 11)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF065F46),
                  foregroundColor: const Color(0xFF6EE7B7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // دکمه تایید ساخت کلاس
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleCreateClass,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'ثبت و ایجاد کلاس',
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
    );
  }

  Widget _buildClassTile(Quran8ClassModel qClass) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school_rounded,
                    color: Color(0xFF34D399), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      qClass.title,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${toPersianDigits(qClass.students.length)} دانش‌آموز عضو',
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent, size: 20),
                tooltip: 'حذف کلاس',
                onPressed: () => _confirmDeleteClass(qClass),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF1E293B), height: 1),
          const SizedBox(height: 10),
          // نمایش کدها
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('کد کلاس: ',
                      style: TextStyle(
                          fontFamily: 'Tahoma',
                          color: Color(0xFF94A3B8),
                          fontSize: 11)),
                  Text(
                    toPersianDigits(qClass.classCode),
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF34D399),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('کد معلم: ',
                      style: TextStyle(
                          fontFamily: 'Tahoma',
                          color: Color(0xFF94A3B8),
                          fontSize: 11)),
                  Text(
                    toPersianDigits(qClass.teacherCode),
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFFFBBF24),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // دکمه ورود به پنل دبیر این کلاس
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        Quran8LeagueTeacherScreen(quranClass: qClass),
                  ),
                ).then((_) => _loadClasses());
              },
              icon: const Icon(Icons.co_present_rounded, size: 16),
              label: const Text(
                'مشاهده پنل معلم و وضعیت درس‌ها',
                style: TextStyle(fontFamily: 'Tahoma', fontSize: 11),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF065F46),
                foregroundColor: const Color(0xFF6EE7B7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
