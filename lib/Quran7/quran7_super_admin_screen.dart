import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../managers/auth_manager.dart';
import 'quran7_league_manager.dart';
import 'quran7_league_teacher_screen.dart';
import 'quran7_trash_screen.dart';

class Quran7SuperAdminScreen extends StatefulWidget {
  const Quran7SuperAdminScreen({super.key});

  @override
  State<Quran7SuperAdminScreen> createState() => _Quran7SuperAdminScreenState();
}

class _Quran7SuperAdminScreenState extends State<Quran7SuperAdminScreen> {
  List<QuranManagerProfile> _managers = [];
  Map<String, int> _managerClassesCount = {};
  int _trashCount = 0;
  bool _isLoading = true;

  // فیلدهای فرم ایجاد مدیر جدید
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passcodeController = TextEditingController();
  final TextEditingController _quotaController = TextEditingController();
  bool _isCreating = false;

  // وضعیت نمایش رمز عبور برای هر مدیر (مخفی یا آشکار)
  final Map<String, bool> _revealedPasscodes = {};

  @override
  void initState() {
    super.initState();
    _loadManagersData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passcodeController.dispose();
    _quotaController.dispose();
    super.dispose();
  }

  Future<void> _loadManagersData() async {
    setState(() => _isLoading = true);
    await Quran7LeagueManager.init(forceReload: true);
    final managers = await Quran7LeagueManager.getAllManagers();
    final trashCount = await Quran7LeagueManager.getTrashCount();
    final Map<String, int> counts = {};

    for (final m in managers) {
      final count = await Quran7LeagueManager.getManagerClassesCount(m.passcode);
      counts[m.passcode] = count;
    }

    if (mounted) {
      setState(() {
        _managers = managers;
        _managerClassesCount = counts;
        _trashCount = trashCount;
        _isLoading = false;
      });
    }
  }

  // تولید رمز ۱۰ رقمی کاملاً تصادفی
  void _generateRandom10DigitPasscode() {
    HapticFeedback.lightImpact();
    final rand = Random();
    String code = '';
    for (int i = 0; i < 10; i++) {
      code += rand.nextInt(10).toString();
    }
    // اطمینان از عدم شروع با صفر اگر مایل باشیم، یا هر ۱۰ رقم تصادفی
    if (code.startsWith('0')) {
      code = '${rand.nextInt(9) + 1}${code.substring(1)}';
    }
    _passcodeController.text = code;
  }

  // ثبت مدیر جدید
  Future<void> _handleCreateManager() async {
    final name = _nameController.text.trim();
    final pass = _passcodeController.text.trim();
    final quotaText = _quotaController.text.trim();
    final quota = int.tryParse(quotaText);

    if (name.isEmpty) {
      _showSnackbar('لطفاً نام مدیر یا مدرسه را وارد کنید.', isError: true);
      return;
    }

    if (pass.length != 10 || int.tryParse(pass) == null) {
      _showSnackbar('رمز عبور باید دقیقاً ۱۰ رقم عددی باشد.', isError: true);
      return;
    }

    if (quota == null || quota <= 0) {
      _showSnackbar(
          'لطفاً سهمیه تعداد کلاس را به عدد (حداقل ۱ کلاس) وارد کنید.',
          isError: true);
      return;
    }

    setState(() => _isCreating = true);
    FocusScope.of(context).unfocus();

    final res = await Quran7LeagueManager.addManager(
      name: name,
      passcode: pass,
      maxClasses: quota,
    );

    if (!mounted) return;
    setState(() => _isCreating = false);

    if (res['success'] == true) {
      HapticFeedback.mediumImpact();
      _nameController.clear();
      _passcodeController.clear();
      _quotaController.clear();
      _showSnackbar('مدیر جدید با موفقیت تعریف شد.', isError: false);
      _loadManagersData();
    } else {
      _showSnackbar(res['message'] ?? 'خطا در ثبت مدیر', isError: true);
    }
  }

  // ویرایش سهمیه کلاس
  void _showEditQuotaDialog(QuranManagerProfile manager) {
    int currentQuota = manager.maxClasses;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.edit_note_rounded,
                    color: Color(0xFFF59E0B), size: 24),
                const SizedBox(width: 8),
                Text(
                  'ویرایش سهمیه: ${manager.name}',
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'سقف مجاز ایجاد کلاس برای این مدیر را تعیین کنید:',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: currentQuota > 1
                          ? () {
                              setDialogState(() => currentQuota--);
                            }
                          : null,
                      icon: const Icon(Icons.remove_circle_outline_rounded,
                          color: Color(0xFFEF4444), size: 28),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Text(
                        toPersianDigits(currentQuota),
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          color: Color(0xFFFBBF24),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: currentQuota < 50
                          ? () {
                              setDialogState(() => currentQuota++);
                            }
                          : null,
                      icon: const Icon(Icons.add_circle_outline_rounded,
                          color: Color(0xFF10B981), size: 28),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('انصراف',
                    style: TextStyle(fontFamily: 'Tahoma', color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await Quran7LeagueManager.updateManagerMaxClasses(
                      manager.passcode, currentQuota);
                  _showSnackbar('سهمیه مدیر به‌روزرسانی شد.', isError: false);
                  _loadManagersData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'ذخیره تغییرات',
                  style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // انتقال مدیر به سطل زباله
  void _confirmDeleteManager(QuranManagerProfile manager) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.delete_sweep_rounded,
                  color: Colors.redAccent, size: 24),
              SizedBox(width: 8),
              Text(
                'انتقال به سطل زباله',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'آیا از انتقال «${manager.name}» به سطل زباله اطمینان دارید؟\nتمامی کلاس‌ها، دانش‌آموزان و نمرات این مدیر محفوظ مانده و هر زمان بخواهید از بخش «سطل زباله» در انتهای صفحه قابل بازیابی کامل خواهند بود.',
            style: const TextStyle(
              fontFamily: 'Tahoma',
              color: Color(0xFFCBD5E1),
              fontSize: 12,
              height: 1.6,
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
                Navigator.pop(ctx);
                await Quran7LeagueManager.deleteManager(manager.passcode);
                _showSnackbar(
                    'مدیر به سطل زباله منتقل شد. امکان بازیابی کامل کلاس‌ها و اطلاعات محفوظ است.',
                    isError: false);
                _loadManagersData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'انتقال به سطل زباله',
                style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // مشاهده کلاس‌های اختصاصی یک مدیر در شیت
  Future<void> _showManagerClassesSheet(QuranManagerProfile manager) async {
    final classes =
        await Quran7LeagueManager.getClassesOfManager(manager.passcode);

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.75,
          ),
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(top: BorderSide(color: Color(0xFF334155), width: 2)),
          ),
          child: Column(
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'کلاس‌های ${manager.name}',
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'تعداد کلاس‌ها: ${toPersianDigits(classes.length)} از ${toPersianDigits(manager.maxClasses)} کلاس مجاز',
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
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.touch_app_rounded, color: Color(0xFF60A5FA), size: 14),
                        SizedBox(width: 4),
                        Text(
                          'لمس هر کلاس = ورود به پنل دبیر آن کلاس',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFF93C5FD),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: Color(0xFF1E293B), height: 20),
              Expanded(
                child: classes.isEmpty
                    ? const Center(
                        child: Text(
                          'این مدیر هنوز هیچ کلاسی ایجاد نکرده است.',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: classes.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (ctx, idx) {
                          final c = classes[idx];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(ctx); // بستن شیت
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Quran7LeagueTeacherScreen(
                                      quranClass: c,
                                    ),
                                  ),
                                ).then((_) => _loadManagersData());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: const Color(0xFF3B82F6).withOpacity(0.4)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            c.title,
                                            style: const TextStyle(
                                              fontFamily: 'Tahoma',
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF10B981)
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '${toPersianDigits(c.students.length)} دانش‌آموز',
                                            style: const TextStyle(
                                              fontFamily: 'Tahoma',
                                              color: Color(0xFF34D399),
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        _buildSmallTag('کد کلاس:', c.classCode,
                                            const Color(0xFF10B981)),
                                        const SizedBox(width: 10),
                                        _buildSmallTag('کد معلم:', c.teacherCode,
                                            const Color(0xFF60A5FA)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0F172A),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: const Color(0xFF3B82F6)
                                                .withOpacity(0.3)),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.login_rounded,
                                              color: Color(0xFF60A5FA),
                                              size: 14),
                                          SizedBox(width: 6),
                                          Text(
                                            'ورود به پنل دبیر این کلاس (مدیریت به عنوان معلم)',
                                            style: TextStyle(
                                              fontFamily: 'Tahoma',
                                              color: Color(0xFF93C5FD),
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Color(0xFF60A5FA),
                                              size: 11),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallTag(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Tahoma',
              color: Color(0xFF94A3B8),
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            toPersianDigits(value),
            style: TextStyle(
              fontFamily: 'Tahoma',
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // خروج از حساب ابرمُدیر
  void _confirmLogoutSuperAdmin() {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.orangeAccent, size: 24),
              SizedBox(width: 8),
              Text(
                'خروج از پنل ابرمُدیر',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'آیا مایل به خروج از پنل مدیریت کل هستید؟ برای ورود مجدد باید دوباره رمز ۱۰ رقمی را وارد نمایید.',
            style: TextStyle(
              fontFamily: 'Tahoma',
              color: Color(0xFFCBD5E1),
              fontSize: 12,
              height: 1.5,
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
                Navigator.pop(ctx);
                await Quran7LeagueManager.logoutManager();
                if (mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'تأیید و خروج',
                style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Tahoma', fontSize: 13),
          textAlign: TextAlign.right,
        ),
        backgroundColor:
            isError ? const Color(0xFFDC2626) : const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPhone = AuthManager.phoneNumber.trim();
    final totalCreatedClasses =
        _managerClassesCount.values.fold<int>(0, (a, b) => a + b);
    final totalCapacity =
        _managers.fold<int>(0, (a, b) => a + b.maxClasses);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0F1D),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F172A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Row(
            children: [
              Text('👑', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'مدیریت کل سیستم (ابرمُدیر)',
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
                  color: Color(0xFFFCA5A5), size: 22),
              tooltip: 'خروج از حساب ابرمُدیر',
              onPressed: _confirmLogoutSuperAdmin,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFF59E0B),
                  strokeWidth: 3,
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadManagersData,
                color: const Color(0xFFF59E0B),
                backgroundColor: const Color(0xFF1E293B),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // کارت اطلاعات کاربر ابرمُدیر
                      _buildSuperAdminHeaderCard(currentPhone),
                      const SizedBox(height: 16),

                      // کارت آمار کلی
                      _buildStatsRow(
                        managersCount: _managers.length,
                        classesCount: totalCreatedClasses,
                        capacity: totalCapacity,
                      ),
                      const SizedBox(height: 20),

                      // فرم تعریف مدیر جدید
                      _buildCreateManagerCard(),
                      const SizedBox(height: 24),

                      // لیست مدیران
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'مدیران مدارس تعریف‌شده',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${toPersianDigits(_managers.length)} مدیر',
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

                      if (_managers.isEmpty)
                        _buildEmptyManagersState()
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _managers.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (ctx, index) {
                            return _buildManagerCard(_managers[index]);
                          },
                        ),

                      const SizedBox(height: 28),
                      // دکمه سطل زباله در پایین‌ترین بخش
                      _buildTrashBinButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // کارت مشخصات ابرمُدیر
  Widget _buildSuperAdminHeaderCard(String phone) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Text('🛡️', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ابرمُدیر سیستم',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'شماره مجاز: ${toPersianDigits(phone)}',
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFFA5B4FC),
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4)),
            ),
            child: const Text(
              'فعال و متصل',
              style: TextStyle(
                fontFamily: 'Tahoma',
                color: Color(0xFF34D399),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // کارت آمار سه گانه
  Widget _buildStatsRow({
    required int managersCount,
    required int classesCount,
    required int capacity,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            title: 'مدیران',
            value: toPersianDigits(managersCount),
            icon: Icons.people_alt_rounded,
            color: const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatItem(
            title: 'کلاس‌های فعال',
            value: toPersianDigits(classesCount),
            icon: Icons.class_rounded,
            color: const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatItem(
            title: 'مجموع ظرفیت',
            value: toPersianDigits(capacity),
            icon: Icons.pie_chart_rounded,
            color: const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Tahoma',
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Tahoma',
              color: Color(0xFF94A3B8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // فرم ثبت مدیر جدید
  Widget _buildCreateManagerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF111827)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person_add_alt_1_rounded,
                  color: Color(0xFFF59E0B), size: 22),
              SizedBox(width: 8),
              Text(
                'تعریف مدیر مدرسه جدید',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'مشخصات مدرسه، رمز عبور ۱۰ رقمی و سقف تعداد کلاس مجاز را تعیین کنید:',
            style: TextStyle(
              fontFamily: 'Tahoma',
              color: Color(0xFF94A3B8),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),

          // نام مدیر / مدرسه
          TextField(
            controller: _nameController,
            style: const TextStyle(
              fontFamily: 'Tahoma',
              color: Colors.white,
              fontSize: 13,
            ),
            decoration: InputDecoration(
              labelText: 'نام مدیر یا مدرسه (مثلاً دبیرستان شهید مطهری)',
              labelStyle: const TextStyle(
                fontFamily: 'Tahoma',
                color: Color(0xFF94A3B8),
                fontSize: 12,
              ),
              prefixIcon: const Icon(Icons.school_rounded,
                  color: Color(0xFFF59E0B), size: 18),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xFFF59E0B), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // فیلد رمز ۱۰ رقمی + دکمه تولید رندوم
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _passcodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFFFBBF24),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                  decoration: InputDecoration(
                    labelText: 'رمز ورود (دقیقاً ۱۰ رقم)',
                    labelStyle: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      letterSpacing: 0,
                    ),
                    counterText: '',
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF334155)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF334155)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                          color: Color(0xFFF59E0B), width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _generateRandom10DigitPasscode,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFFF59E0B).withOpacity(0.6)),
                  ),
                  child: const Row(
                    children: [
                      Text('🎲', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 6),
                      Text(
                        'رمز شانسی',
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          color: Color(0xFFFBBF24),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // فیلد سهمیه تعداد کلاس (تایپ دستی عدد)
          TextField(
            controller: _quotaController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            style: const TextStyle(
              fontFamily: 'Tahoma',
              color: Color(0xFFFBBF24),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
            decoration: InputDecoration(
              labelText: 'سهمیه تعداد کلاس',
              hintText: 'تعداد کلاس مجاز را وارد کنید',
              hintStyle: const TextStyle(
                fontFamily: 'Tahoma',
                color: Color(0xFF475569),
                fontSize: 12,
              ),
              labelStyle: const TextStyle(
                fontFamily: 'Tahoma',
                color: Color(0xFF94A3B8),
                fontSize: 12,
              ),
              prefixIcon: const Icon(Icons.class_rounded,
                  color: Color(0xFFF59E0B), size: 18),
              suffixText: 'کلاس',
              suffixStyle: const TextStyle(
                fontFamily: 'Tahoma',
                color: Color(0xFF94A3B8),
                fontSize: 12,
              ),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xFFF59E0B), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // دکمه ثبت
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: _isCreating ? null : _handleCreateManager,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
              ),
              child: _isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded,
                            color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'ثبت و صدور رمز اختصاصی مدیر',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Colors.white,
                            fontSize: 13,
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

  // کارت یک مدیر در لیست
  Widget _buildManagerCard(QuranManagerProfile manager) {
    final classesCount = _managerClassesCount[manager.passcode] ?? 0;
    final isRevealed = _revealedPasscodes[manager.passcode] ?? false;
    final progress = (classesCount / max(1, manager.maxClasses)).clamp(0.0, 1.0);

    return Container(
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Text('🏢', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      manager.name,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'سهمیه: ${toPersianDigits(classesCount)} از ${toPersianDigits(manager.maxClasses)} کلاس',
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // دکمه مشاهده کلاس‌ها
              InkWell(
                onTap: () => _showManagerClassesSheet(manager),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFF10B981).withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.remove_red_eye_rounded,
                          color: Color(0xFF34D399), size: 14),
                      SizedBox(width: 4),
                      Text(
                        'کلاس‌ها',
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          color: Color(0xFF34D399),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // نوار پیشرفت سهمیه
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF1E293B),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0
                    ? Colors.redAccent
                    : const Color(0xFFF59E0B),
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 14),

          // باکس رمز عبور ۱۰ رقمی + دکمه کپی
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                const Icon(Icons.key_rounded,
                    color: Color(0xFFF59E0B), size: 16),
                const SizedBox(width: 8),
                const Text(
                  'رمز ورود مدیر:',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isRevealed ? manager.passcode : '••••••••••',
                    style: TextStyle(
                      fontFamily: isRevealed ? 'Courier' : 'Tahoma',
                      color: const Color(0xFFFBBF24),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: isRevealed ? 2 : 1,
                    ),
                  ),
                ),
                // نمایش/مخفی کردن
                IconButton(
                  onPressed: () {
                    setState(() {
                      _revealedPasscodes[manager.passcode] = !isRevealed;
                    });
                  },
                  icon: Icon(
                    isRevealed
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: const Color(0xFF94A3B8),
                    size: 18,
                  ),
                  tooltip: 'نمایش/مخفی',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 10),
                // دکمه کپی
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: manager.passcode));
                    HapticFeedback.lightImpact();
                    _showSnackbar('رمز ۱۰ رقمی مدیر در حافظه کپی شد.',
                        isError: false);
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.copy_rounded,
                        color: Color(0xFF60A5FA), size: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // اکشن‌های ویرایش سهمیه و حذف
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _showEditQuotaDialog(manager),
                icon: const Icon(Icons.tune_rounded,
                    color: Color(0xFFF59E0B), size: 16),
                label: const Text(
                  'ویرایش سهمیه',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFFF59E0B),
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _confirmDeleteManager(manager),
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent, size: 16),
                label: const Text(
                  'حذف',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.redAccent,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyManagersState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: const Column(
        children: [
          Text('🏫', style: TextStyle(fontSize: 36)),
          SizedBox(height: 12),
          Text(
            'هنوز هیچ مدیری تعریف نشده است',
            style: TextStyle(
              fontFamily: 'Tahoma',
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'از فرم بالا می‌توانید نام مدرسه، رمز اختصاصی ۱۰ رقمی و سهمیه کلاس را مشخص و ثبت نمایید.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tahoma',
              color: Color(0xFF94A3B8),
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ===================== بخش سطل زباله (مدیران حذف‌شده و بازیابی کامل) =====================

  Widget _buildTrashBinButton() {
    final hasTrash = _trashCount > 0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _openTrashScreen,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: hasTrash
                ? [const Color(0xFF2D1517), const Color(0xFF191114)]
                : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: hasTrash
                ? const Color(0xFFEF4444).withValues(alpha: 0.6)
                : const Color(0xFF334155),
            width: 1.5,
          ),
          boxShadow: hasTrash
              ? [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _openTrashScreen,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: hasTrash
                          ? const Color(0xFFEF4444).withValues(alpha: 0.2)
                          : const Color(0xFF334155).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      '🗑️',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'سطل زباله',
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: hasTrash
                                    ? const Color(0xFFEF4444)
                                        .withValues(alpha: 0.25)
                                    : const Color(0xFF334155),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                hasTrash
                                    ? '${toPersianDigits(_trashCount)} مدیر حذف‌شده'
                                    : 'خالی',
                                style: TextStyle(
                                  fontFamily: 'Tahoma',
                                  color: hasTrash
                                      ? const Color(0xFFFCA5A5)
                                      : const Color(0xFF94A3B8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'مدیران حذف‌شده و بازیابی کامل تمامی کلاس‌ها و اطلاعات آن‌ها',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF94A3B8),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openTrashScreen() {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const Quran7TrashScreen(),
      ),
    ).then((_) => _loadManagersData());
  }
}
