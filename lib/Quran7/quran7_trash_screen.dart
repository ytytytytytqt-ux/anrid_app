import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quran7_league_manager.dart';

class Quran7TrashScreen extends StatefulWidget {
  const Quran7TrashScreen({super.key});

  @override
  State<Quran7TrashScreen> createState() => _Quran7TrashScreenState();
}

class _Quran7TrashScreenState extends State<Quran7TrashScreen> {
  List<QuranTrashManagerItem> _trashList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrashData();
  }

  Future<void> _loadTrashData() async {
    setState(() => _isLoading = true);
    final list = await Quran7LeagueManager.getTrashManagers();
    if (mounted) {
      setState(() {
        _trashList = list;
        _isLoading = false;
      });
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
        duration: const Duration(milliseconds: 3000),
      ),
    );
  }

  Future<void> _handleRestore(QuranTrashManagerItem item) async {
    final res = await Quran7LeagueManager.restoreManager(item.manager.passcode);
    if (!mounted) return;

    if (res['success'] == true) {
      HapticFeedback.mediumImpact();
      _showSnackbar(
        'مدیر «${item.manager.name}» با تمامی ${toPersianDigits(item.classes.length)} کلاس و اطلاعات دانش‌آموزان با موفقیت بازیابی شد.',
        isError: false,
      );
      _loadTrashData();
    } else {
      _showSnackbar(res['message'] ?? 'خطا در بازیابی مدیر', isError: true);
    }
  }

  void _confirmPermanentDelete(QuranTrashManagerItem item) {
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
              Icon(Icons.warning_rounded, color: Color(0xFFEF4444), size: 24),
              SizedBox(width: 8),
              Text(
                'حذف دائمی از سطل زباله',
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
            'آیا از حذف دائمی و غیرقابل‌بازگشت مدیر «${item.manager.name}» اطمینان دارید؟ تمامی ${toPersianDigits(item.classes.length)} کلاس آن نیز برای همیشه پاک خواهند شد.',
            style: const TextStyle(
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
                await Quran7LeagueManager.permanentlyDeleteFromTrash(
                    item.manager.passcode);
                _showSnackbar('مدیر برای همیشه از سطل زباله پاک شد.',
                    isError: false);
                _loadTrashData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'حذف همیشگی',
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

  void _confirmEmptyTrash() {
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
                'خالی کردن کامل سطل زباله',
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
            'آیا از پاکسازی کامل سطل زباله مطمئن هستید؟ تمامی اطلاعات مدیران حذف‌شده برای همیشه پاک شده و دیگر قابل بازیابی نخواهند بود.',
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
                await Quran7LeagueManager.emptyTrash();
                _showSnackbar('سطل زباله کاملاً خالی شد.', isError: false);
                _loadTrashData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'تأیید و پاکسازی',
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
            tooltip: 'بازگشت به پنل ابرمُدیر',
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              const Text('🗑️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text(
                'سطل زباله مدیران',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _trashList.isNotEmpty
                      ? const Color(0xFFEF4444).withValues(alpha: 0.25)
                      : const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _trashList.isNotEmpty
                      ? '${toPersianDigits(_trashList.length)} مورد'
                      : 'خالی',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: _trashList.isNotEmpty
                        ? const Color(0xFFFCA5A5)
                        : const Color(0xFF94A3B8),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            if (_trashList.isNotEmpty)
              TextButton.icon(
                onPressed: _confirmEmptyTrash,
                icon: const Icon(Icons.delete_sweep_rounded,
                    color: Color(0xFFEF4444), size: 18),
                label: const Text(
                  'خالی کردن',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFFEF4444),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFEF4444),
                  strokeWidth: 3,
                ),
              )
            : _trashList.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _loadTrashData,
                    color: const Color(0xFFEF4444),
                    backgroundColor: const Color(0xFF1E293B),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: _trashList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildTrashCard(_trashList[index]);
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: const Text('🗑️', style: TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: 18),
            const Text(
              'سطل زباله خالی است',
              style: TextStyle(
                fontFamily: 'Tahoma',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'هیچ مدیری در سطل زباله قرار ندارد.\nدر صورت حذف هر مدیر، تمامی کلاس‌ها، دانش‌آموزان و اطلاعات او برای بازیابی کامل به این صفحه منتقل خواهند شد.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tahoma',
                color: Color(0xFF94A3B8),
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrashCard(QuranTrashManagerItem item) {
    final totalStudents =
        item.classes.fold<int>(0, (sum, c) => sum + c.students.length);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
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
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.school_rounded,
                    color: Color(0xFF60A5FA), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.manager.name,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'رمز ورود: ${item.manager.passcode}',
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFFFBBF24),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: item.manager.passcode));
                            HapticFeedback.lightImpact();
                            _showSnackbar('رمز ۱۰ رقمی مدیر کپی شد.',
                                isError: false);
                          },
                          child: const Icon(Icons.copy_rounded,
                              color: Color(0xFF60A5FA), size: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // بج کلاس‌ها
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      '${toPersianDigits(item.classes.length)} کلاس محفوظ',
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFF34D399),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${toPersianDigits(totalStudents)} دانش‌آموز',
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFF94A3B8),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFF1E293B), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              // دکمه بازیابی کامل اطلاعات
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: () => _handleRestore(item),
                  icon: const Icon(Icons.settings_backup_restore_rounded,
                      size: 18),
                  label: const Text(
                    'بازیابی کامل اطلاعات',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // دکمه حذف همیشگی
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmPermanentDelete(item),
                  icon: const Icon(Icons.delete_forever_rounded,
                      color: Color(0xFFEF4444), size: 18),
                  label: const Text(
                    'حذف قطعی',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFFEF4444),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
