import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'league_models.dart';
import 'league_storage_manager.dart';
import 'league_trash_screen.dart';

/// پنل مدیر ارشد همگانی برای مدیریت تمام مدیران مدارس و سهمیه‌های سراسری
class UniversalLeagueSuperAdminScreen extends StatefulWidget {
  const UniversalLeagueSuperAdminScreen({super.key});

  @override
  State<UniversalLeagueSuperAdminScreen> createState() =>
      _UniversalLeagueSuperAdminScreenState();
}

class _UniversalLeagueSuperAdminScreenState
    extends State<UniversalLeagueSuperAdminScreen> {
  List<LeagueManagerProfile> _managers = [];
  Map<String, int> _managerClassesCount = {};
  int _trashCount = 0;
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passcodeController = TextEditingController();
  final TextEditingController _quotaController = TextEditingController();
  bool _isCreating = false;
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
    await UniversalLeagueManager.init(null, true);
    final managers = await UniversalLeagueManager.getAllManagers();
    final trashCount = await UniversalLeagueManager.getTrashCount();
    final Map<String, int> counts = {};

    for (final m in managers) {
      final count =
          await UniversalLeagueManager.getTotalClassesCountForManager(
              m.passcode);
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

  void _generateRandom10DigitPasscode() {
    HapticFeedback.lightImpact();
    final rand = Random();
    String code = '';
    for (int i = 0; i < 10; i++) {
      code += rand.nextInt(10).toString();
    }
    if (code.startsWith('0')) {
      code = '${rand.nextInt(9) + 1}${code.substring(1)}';
    }
    _passcodeController.text = code;
  }

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
      _showSnackbar('سهمیه کلاس باید یک عدد معتبر بزرگتر از صفر باشد.',
          isError: true);
      return;
    }

    setState(() => _isCreating = true);

    final res = await UniversalLeagueManager.createManagerProfile(
      name: name,
      passcode: pass,
      classQuota: quota,
    );

    if (!mounted) return;
    setState(() => _isCreating = false);

    if (res['success'] == true) {
      HapticFeedback.mediumImpact();
      _nameController.clear();
      _passcodeController.clear();
      _quotaController.clear();
      _showSnackbar('مدیر جدید با موفقیت ثبت شد.');
      _loadManagersData();
    } else {
      _showSnackbar(res['message'] ?? 'خطا در ثبت مدیر', isError: true);
    }
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
                isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_rounded,
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
        duration: const Duration(milliseconds: 3000),
      ),
    );
  }

  void _confirmDeleteManager(LeagueManagerProfile manager) {
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
              Icon(Icons.warning_amber_rounded,
                  color: Colors.redAccent, size: 24),
              SizedBox(width: 8),
              Text(
                'انتقال به سطل زباله',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Text(
            'آیا از انتقال مدیر «${manager.name}» به سطل زباله اطمینان دارید؟ تمام کلاس‌های این مدیر به سطل زباله منتقل خواهند شد و از سطل زباله قابل بازیابی هستند.',
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
                final res = await UniversalLeagueManager.deleteManagerToTrash(
                    manager.passcode);
                if (res['success'] == true) {
                  _showSnackbar('مدیر به سطل زباله منتقل گردید.');
                  _loadManagersData();
                } else {
                  _showSnackbar(res['message'] ?? 'خطا در حذف مدیر',
                      isError: true);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent),
              child: const Text('انتقال به زباله‌دان',
                  style: TextStyle(fontFamily: 'Tahoma', color: Colors.white)),
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
              Text('⚡', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'مدیریت ارشد لیگ کلاسی (سراسری)',
                style: TextStyle(
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
              icon: Stack(
                children: [
                  const Icon(Icons.delete_outline_rounded,
                      color: Color(0xFF38BDF8), size: 24),
                  if (_trashCount > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        constraints:
                            const BoxConstraints(minWidth: 14, minHeight: 14),
                        child: Text(
                          toPersianDigits(_trashCount),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              tooltip: 'سطل زباله',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UniversalLeagueTrashScreen(),
                  ),
                ).then((_) => _loadManagersData());
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF38BDF8)))
            : ListView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                children: [
                  // کارت فرم ایجاد مدیر جدید
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
                        const Row(
                          children: [
                            Icon(Icons.person_add_alt_1_rounded,
                                color: Color(0xFF38BDF8), size: 22),
                            SizedBox(width: 8),
                            Text(
                              'تعریف مدیر مدرسه جدید',
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
                          controller: _nameController,
                          style: const TextStyle(
                              fontFamily: 'Tahoma',
                              color: Colors.white,
                              fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'نام مدیر یا مدرسه (مثال: دبستان رازی)',
                            hintStyle: const TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF64748B),
                                fontSize: 12),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: Color(0xFF334155)),
                            ),
                            prefixIcon: const Icon(Icons.badge_rounded,
                                color: Color(0xFF64748B), size: 18),
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                  hintText: 'رمز ۱۰ رقمی مدیر',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'Tahoma',
                                      color: Color(0xFF64748B),
                                      fontSize: 12,
                                      letterSpacing: 0),
                                  filled: true,
                                  fillColor: const Color(0xFF0F172A),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF334155)),
                                  ),
                                  prefixIcon: const Icon(Icons.key_rounded,
                                      color: Color(0xFF64748B), size: 18),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: _generateRandom10DigitPasscode,
                              icon: const Icon(Icons.casino_outlined, size: 18),
                              label: const Text(
                                'تولید رمز',
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
                        const SizedBox(height: 10),
                        TextField(
                          controller: _quotaController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontFamily: 'Tahoma',
                              color: Colors.white,
                              fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'سهمیه کلاس (مشترک در تمام درس‌ها - مثال: 5)',
                            hintStyle: const TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF64748B),
                                fontSize: 12),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: Color(0xFF334155)),
                            ),
                            prefixIcon: const Icon(Icons.pie_chart_outline_rounded,
                                color: Color(0xFF64748B), size: 18),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isCreating ? null : _handleCreateManager,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: _isCreating
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text(
                                    'ثبت مدیر جدید',
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'لیست مدیران تعریف شده',
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${toPersianDigits(_managers.length)} مدیر',
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          color: Color(0xFF38BDF8),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (_managers.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'هنوز هیچ مدیری تعریف نشده است.',
                          style: TextStyle(
                              fontFamily: 'Tahoma',
                              color: Color(0xFF94A3B8),
                              fontSize: 13),
                        ),
                      ),
                    )
                  else
                    ..._managers.map((m) {
                      final isRevealed =
                          _revealedPasscodes[m.passcode] ?? false;
                      final used = _managerClassesCount[m.passcode] ?? 0;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
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
                                Text(
                                  m.name,
                                  style: const TextStyle(
                                    fontFamily: 'Tahoma',
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _confirmDeleteManager(m),
                                  icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.redAccent,
                                      size: 20),
                                  tooltip: 'انتقال به سطل زباله',
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  'رمز عبور: ${isRevealed ? toPersianDigits(m.passcode) : '••••••••••'}',
                                  style: const TextStyle(
                                    fontFamily: 'Tahoma',
                                    color: Color(0xFF38BDF8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _revealedPasscodes[m.passcode] =
                                          !isRevealed;
                                    });
                                  },
                                  child: Icon(
                                    isRevealed
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: const Color(0xFF64748B),
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: m.passcode));
                                    _showSnackbar(
                                        'رمز عبور در کلیپ‌بورد کپی شد.');
                                  },
                                  child: const Icon(
                                    Icons.copy_rounded,
                                    color: Color(0xFF64748B),
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'سهمیه کلاس: ${toPersianDigits(used)} از ${toPersianDigits(m.classQuota)} کلاس استفاده شده',
                              style: const TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
      ),
    );
  }
}
