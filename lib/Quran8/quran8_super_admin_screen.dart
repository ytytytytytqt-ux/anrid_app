import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quran8_league_manager.dart';
import 'quran8_trash_screen.dart';

class Quran8SuperAdminScreen extends StatefulWidget {
  const Quran8SuperAdminScreen({super.key});

  @override
  State<Quran8SuperAdminScreen> createState() => _Quran8SuperAdminScreenState();
}

class _Quran8SuperAdminScreenState extends State<Quran8SuperAdminScreen> {
  List<Quran8ManagerProfile> _managers = [];
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
    await Quran8LeagueManager.init(forceReload: true);
    final managers = await Quran8LeagueManager.getAllManagers();
    final trashCount = await Quran8LeagueManager.getTrashCount();
    final Map<String, int> counts = {};

    for (final m in managers) {
      final count = await Quran8LeagueManager.getManagerClassesCount(m.passcode);
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

  // تولید رمز عبور ۱۰ رقمی تصادفی
  void _generateRandomPasscode() {
    final rand = Random();
    final buffer = StringBuffer();
    buffer.write(rand.nextInt(9) + 1);
    for (int i = 0; i < 9; i++) {
      buffer.write(rand.nextInt(10));
    }
    _passcodeController.text = buffer.toString();
    HapticFeedback.lightImpact();
  }

  void _showSnackbar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              Icon(
                isError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  msg,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor:
            isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 2500),
      ),
    );
  }

  // ثبت و ایجاد مدیر جدید
  Future<void> _handleCreateManager() async {
    FocusScope.of(context).unfocus();
    final name = _nameController.text.trim();
    final passcode = _passcodeController.text.trim();
    final quotaText = _quotaController.text.trim();

    if (name.isEmpty) {
      _showSnackbar('لطفاً نام یا عنوان مدرسه مدیر را وارد کنید.', isError: true);
      return;
    }

    if (passcode.length != 10 || !RegExp(r'^\d{10}$').hasMatch(passcode)) {
      _showSnackbar('رمز ورود مدیر باید دقیقاً یک کد ۱۰ رقمی عددی باشد.',
          isError: true);
      return;
    }

    final quota = int.tryParse(quotaText) ?? 5;
    if (quota <= 0) {
      _showSnackbar('ظرفیت کلاس‌ها باید حداقل ۱ کلاس باشد.', isError: true);
      return;
    }

    setState(() => _isCreating = true);
    final res = await Quran8LeagueManager.createManager(
      name: name,
      passcode: passcode,
      classQuota: quota,
    );
    setState(() => _isCreating = false);

    if (res['success'] == true) {
      _nameController.clear();
      _passcodeController.clear();
      _quotaController.clear();
      _showSnackbar('مدیر با موفقیت ثبت شد.');
      _loadManagersData();
    } else {
      _showSnackbar(res['message'] ?? 'خطا در ثبت مدیر', isError: true);
    }
  }

  // حذف نرم مدیر و انتقال به سطل زباله
  void _confirmDeleteManager(Quran8ManagerProfile manager) {
    final classCount = _managerClassesCount[manager.passcode] ?? 0;
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
                  color: Color(0xFFEF4444), size: 24),
              SizedBox(width: 8),
              Text(
                'انتقال به سطل زباله',
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
            'آیا می‌خواهید مدیر «${manager.name}» را به سطل زباله منتقل کنید؟\n\n'
            'تمامی $classCount کلاس و اطلاعات دانش‌آموزان این مدیر به سطل زباله منتقل شده و در هر زمان قابل بازیابی خواهد بود.',
            style: const TextStyle(
              fontFamily: 'Tahoma',
              color: Color(0xFFCBD5E1),
              fontSize: 13,
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
                final res = await Quran8LeagueManager.softDeleteManager(
                    manager.passcode);
                if (res['success'] == true) {
                  _showSnackbar('مدیر به سطل زباله منتقل شد.');
                  _loadManagersData();
                } else {
                  _showSnackbar(res['message'] ?? 'خطا در انتقال', isError: true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('انتقال به سطل زباله',
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

  // ویرایش ظرفیت کلاس مدیر
  void _showEditQuotaDialog(Quran8ManagerProfile manager) {
    final ctl =
        TextEditingController(text: manager.classQuota.toString());
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'تغییر سهمیه «${manager.name}»',
            style: const TextStyle(
              fontFamily: 'Tahoma',
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'حداکثر تعداد کلاسی که این مدیر می‌تواند در لیگ قرآن هشتم بسازد را وارد کنید:',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctl,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    fontFamily: 'Tahoma', color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
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
                final q = int.tryParse(ctl.text.trim());
                if (q != null && q > 0) {
                  Navigator.pop(ctx);
                  await Quran8LeagueManager.updateManagerQuota(
                      manager.passcode, q);
                  _showSnackbar('سهمیه مدیر به‌روزرسانی شد.');
                  _loadManagersData();
                } else {
                  _showSnackbar('سهمیه نامعتبر است.', isError: true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('ذخیره',
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

  @override
  Widget build(BuildContext context) {
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
              Text('👑', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'پنل اَبَرمُدیر • قرآن هشتم',
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
            // دکمه سطل زباله
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: Color(0xFFEF4444), size: 24),
                  tooltip: 'سطل زباله مدیران',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const Quran8TrashScreen()),
                    ).then((_) => _loadManagersData());
                  },
                ),
                if (_trashCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        toPersianDigits(_trashCount),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded,
                  color: Color(0xFF10B981), size: 22),
              tooltip: 'تازه‌سازی',
              onPressed: _loadManagersData,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF10B981)),
              )
            : RefreshIndicator(
                onRefresh: _loadManagersData,
                color: const Color(0xFF10B981),
                backgroundColor: const Color(0xFF1E293B),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    // کارت آمار کل
                    _buildStatsBanner(),

                    const SizedBox(height: 18),

                    // فرم تعریف مدیر جدید
                    _buildCreateManagerForm(),

                    const SizedBox(height: 24),

                    // لیست مدیران
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'مدیران فعال مدارس',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${toPersianDigits(_managers.length)} مدیر',
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

                    if (_managers.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131D2E),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: const Center(
                          child: Text(
                            'هیچ مدیری هنوز تعریف نشده است.\nاز کادر بالا اولین مدیر مدرسه را اضافه کنید.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              color: Color(0xFF94A3B8),
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                        ),
                      )
                    else
                      ..._managers.map((m) => _buildManagerCard(m)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStatsBanner() {
    final totalClasses =
        _managerClassesCount.values.fold<int>(0, (sum, c) => sum + c);

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('👥 کل مدیران', toPersianDigits(_managers.length)),
          Container(width: 1, height: 36, color: Colors.white12),
          _buildStatItem('🏫 کل کلاس‌ها', toPersianDigits(totalClasses)),
          Container(width: 1, height: 36, color: Colors.white12),
          _buildStatItem('🗑️ سطل زباله', toPersianDigits(_trashCount)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Tahoma',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Tahoma',
            color: Color(0xFF94A3B8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateManagerForm() {
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
              Icon(Icons.person_add_alt_1_rounded,
                  color: Color(0xFF10B981), size: 20),
              SizedBox(width: 8),
              Text(
                'تعریف مدیر مدرسه جدید (پایه هشتم)',
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
          // فیلد نام مدرسه / مدیر
          TextField(
            controller: _nameController,
            style: const TextStyle(
                fontFamily: 'Tahoma', color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'نام مدیر یا مدرسه (مثلاً دبیرستان شهید رجایی)',
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
          // فیلد رمز ورود ۱۰ رقمی با تولید تصادفی
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _passcodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'رمز ورود ۱۰ رقمی مدیر',
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
                onPressed: _generateRandomPasscode,
                icon: const Icon(Icons.casino_rounded, size: 16),
                label: const Text('رمز تصادفی',
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
          const SizedBox(height: 10),
          // فیلد سهمیه کلاس
          TextField(
            controller: _quotaController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
                fontFamily: 'Tahoma', color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'سقف مجاز تعداد کلاس‌ها (پیش‌فرض: ۵)',
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
          const SizedBox(height: 14),
          // دکمه تایید ایجاد مدیر
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isCreating ? null : _handleCreateManager,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'ثبت و صدور مجوز مدیر',
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

  Widget _buildManagerCard(Quran8ManagerProfile manager) {
    final classCount = _managerClassesCount[manager.passcode] ?? 0;
    final isPassRevealed = _revealedPasscodes[manager.passcode] ?? false;

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
                      manager.name,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ظرفیت: ${toPersianDigits(classCount)} از ${toPersianDigits(manager.classQuota)} کلاس',
                      style: TextStyle(
                        fontFamily: 'Tahoma',
                        color: classCount >= manager.classQuota
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_note_rounded,
                    color: Color(0xFF34D399), size: 22),
                tooltip: 'تغییر سهمیه',
                onPressed: () => _showEditQuotaDialog(manager),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent, size: 22),
                tooltip: 'انتقال به سطل زباله',
                onPressed: () => _confirmDeleteManager(manager),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF1E293B), height: 1),
          const SizedBox(height: 10),
          // ردیف نمایش رمز و کپی
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'رمز ورود: ',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    isPassRevealed ? manager.passcode : '••••••••••',
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFFFBBF24),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isPassRevealed
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: const Color(0xFF94A3B8),
                      size: 16,
                    ),
                    onPressed: () {
                      setState(() {
                        _revealedPasscodes[manager.passcode] = !isPassRevealed;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: manager.passcode));
                  HapticFeedback.lightImpact();
                  _showSnackbar('رمز ۱۰ رقمی مدیر کپی شد.');
                },
                icon: const Icon(Icons.copy_rounded, size: 14),
                label: const Text('کپی رمز',
                    style: TextStyle(fontFamily: 'Tahoma', fontSize: 11)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF065F46),
                  foregroundColor: const Color(0xFF6EE7B7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
