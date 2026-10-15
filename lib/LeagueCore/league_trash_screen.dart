import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'league_models.dart';
import 'league_storage_manager.dart';

/// سطل زباله همگانی برای بازیابی یا حذف قطعی مدیران و کلاس‌ها
class UniversalLeagueTrashScreen extends StatefulWidget {
  const UniversalLeagueTrashScreen({super.key});

  @override
  State<UniversalLeagueTrashScreen> createState() =>
      _UniversalLeagueTrashScreenState();
}

class _UniversalLeagueTrashScreenState
    extends State<UniversalLeagueTrashScreen> {
  List<LeagueTrashItem> _trashList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrashData();
  }

  Future<void> _loadTrashData() async {
    setState(() => _isLoading = true);
    final list = await UniversalLeagueManager.getTrashManagers();
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

  Future<void> _handleRestore(LeagueTrashItem item) async {
    final success =
        await UniversalLeagueManager.restoreManager(item.manager.passcode);
    if (!mounted) return;

    if (success) {
      HapticFeedback.mediumImpact();
      _showSnackbar(
        'مدیر «${item.manager.name}» با تمامی ${toPersianDigits(item.classes.length)} کلاس با موفقیت بازیابی شد.',
        isError: false,
      );
      _loadTrashData();
    } else {
      _showSnackbar('خطا در بازیابی مدیر', isError: true);
    }
  }

  void _confirmPermanentDelete(LeagueTrashItem item) {
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
                'حذف دائمی و غیرقابل بازگشت',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          content: Text(
            'آیا از حذف دائمی مدیر «${item.manager.name}» و تمام کلاس‌ها و دانش‌آموزان آن اطمینان دارید؟\nاین عملیات به هیچ عنوان قابل بازگشت نیست!',
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
                final success =
                    await UniversalLeagueManager.permanentlyDeleteFromTrash(
                        item.manager.passcode);
                if (success) {
                  _showSnackbar('مدیر به طور دائمی حذف گردید.');
                  _loadTrashData();
                } else {
                  _showSnackbar('خطا در حذف دائمی', isError: true);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444)),
              child: const Text('حذف دائمی',
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
              Icon(Icons.delete_sweep_rounded,
                  color: Color(0xFFF87171), size: 22),
              SizedBox(width: 8),
              Text(
                'سطل زباله لیگ کلاسی',
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
            if (_trashList.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_forever_rounded,
                    color: Color(0xFFEF4444), size: 22),
                tooltip: 'تخلیه کامل سطل زباله',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        backgroundColor: const Color(0xFF1E293B),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: const Text('تخلیه سطل زباله',
                            style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        content: const Text(
                          'آیا از پاک‌سازی تمام موارد سطل زباله اطمینان دارید؟',
                          style: TextStyle(
                              fontFamily: 'Tahoma',
                              color: Color(0xFFCBD5E1),
                              fontSize: 13),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('انصراف',
                                style: TextStyle(
                                    fontFamily: 'Tahoma', color: Colors.grey)),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              await UniversalLeagueManager.emptyTrash();
                              _loadTrashData();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF4444)),
                            child: const Text('تخلیه کامل',
                                style: TextStyle(
                                    fontFamily: 'Tahoma', color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF38BDF8)))
            : _trashList.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_outline_rounded,
                            size: 64, color: Color(0xFF475569)),
                        SizedBox(height: 14),
                        Text(
                          'سطل زباله خالی است.',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _trashList.length,
                    itemBuilder: (ctx, i) {
                      final item = _trashList[i];
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
                                  item.manager.name,
                                  style: const TextStyle(
                                    fontFamily: 'Tahoma',
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${toPersianDigits(item.classes.length)} کلاس',
                                    style: const TextStyle(
                                      fontFamily: 'Tahoma',
                                      color: Color(0xFFFCA5A5),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'رمز عبور: ${toPersianDigits(item.manager.passcode)}',
                              style: const TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _confirmPermanentDelete(item),
                                  icon: const Icon(Icons.delete_forever_rounded,
                                      color: Color(0xFFEF4444), size: 16),
                                  label: const Text('حذف دائمی',
                                      style: TextStyle(
                                          fontFamily: 'Tahoma',
                                          color: Color(0xFFEF4444),
                                          fontSize: 12)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () => _handleRestore(item),
                                  icon: const Icon(Icons.restore_rounded,
                                      size: 16),
                                  label: const Text('بازیابی',
                                      style: TextStyle(
                                          fontFamily: 'Tahoma',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10B981),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
