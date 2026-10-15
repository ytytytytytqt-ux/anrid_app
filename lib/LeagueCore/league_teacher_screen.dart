import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'league_config.dart';
import 'league_models.dart';
import 'league_storage_manager.dart';
import 'league_leaderboard_screen.dart';

/// صفحه همگانی پنل دبیر برای تمامی دروس
class UniversalLeagueTeacherScreen extends StatefulWidget {
  final LeagueSubjectConfig config;
  final LeagueClassModel quranClass;

  const UniversalLeagueTeacherScreen({
    super.key,
    required this.config,
    required this.quranClass,
  });

  @override
  State<UniversalLeagueTeacherScreen> createState() =>
      _UniversalLeagueTeacherScreenState();
}

class _UniversalLeagueTeacherScreenState
    extends State<UniversalLeagueTeacherScreen> {
  late LeagueClassModel _currentClass;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _currentClass = widget.quranClass;
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() => _isSyncing = true);
    final updated = await UniversalLeagueManager.syncClassStudents(
      config: widget.config,
      classCode: _currentClass.classCode,
    );
    if (!mounted) return;
    setState(() {
      _isSyncing = false;
      if (updated != null) {
        _currentClass = updated;
      }
    });
  }

  Future<void> _confirmLogoutTeacher() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF131D2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFF1E293B)),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
              SizedBox(width: 8),
              Text(
                'خروج از حساب دبیر',
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
            'آیا می‌خواهید از حساب دبیر این کلاس خارج شوید؟\nپس از خروج، ورود خودکار غیرفعال شده و برای ورود مجدد باید دوباره کد ۱۰ رقمی معلم را وارد کنید.',
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
      await UniversalLeagueManager.logoutTeacher(widget.config.subjectId);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void _showEditClassTitleDialog() {
    final controller = TextEditingController(text: _currentClass.title);
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
                Icon(Icons.edit_note_rounded,
                    color: widget.config.accentColor, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'ویرایش نام کلاس',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                    'نام جدید کلاس را وارد کنید. این تغییر در پنل مدیر و برای دانش‌آموزان نیز اعمال خواهد شد:',
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
                    autofocus: true,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'عنوان کلاس',
                      hintStyle: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFF475569),
                        fontSize: 12,
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
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'انصراف',
                  style:
                      TextStyle(fontFamily: 'Tahoma', color: Color(0xFF94A3B8)),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newTitle = controller.text.trim();
                  if (newTitle.isEmpty) {
                    setDialogState(() {
                      localError = 'عنوان کلاس نمی‌تواند خالی باشد.';
                    });
                    return;
                  }

                  Navigator.pop(ctx);
                  final success = await UniversalLeagueManager.updateClassTitle(
                    _currentClass.classCode,
                    newTitle,
                  );

                  if (success && mounted) {
                    setState(() {
                      _currentClass.title = newTitle;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.config.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'ذخیره تغییرات',
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

  void _confirmRemoveStudent(LeagueStudentModel student) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF131D2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFF1E293B)),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.redAccent, size: 24),
              SizedBox(width: 8),
              Text(
                'حذف دانش‌آموز',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: Text(
            'آیا از حذف دانش‌آموز «${student.name}» از این کلاس اطمینان دارید؟',
            style: const TextStyle(
              fontFamily: 'Tahoma',
              fontSize: 13,
              color: Color(0xFFCBD5E1),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'انصراف',
                style:
                    TextStyle(fontFamily: 'Tahoma', color: Color(0xFF94A3B8)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final success =
                    await UniversalLeagueManager.removeStudentFromClass(
                  _currentClass.classCode,
                  student.id,
                );

                if (success && mounted) {
                  setState(() {
                    _currentClass.students.removeWhere((s) => s.id == student.id);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'دانش‌آموز «${student.name}» از کلاس حذف شد.',
                        style: const TextStyle(fontFamily: 'Tahoma'),
                      ),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'حذف قطعی',
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

  @override
  Widget build(BuildContext context) {
    final List<LeagueStudentModel> sortedStudents =
        List.from(_currentClass.students)
          ..sort((a, b) => a.joinedAt.compareTo(b.joinedAt));

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
              const Text('👨‍🏫', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'پنل دبیر ${widget.config.leagueTitle}',
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
              tooltip: 'خروج از حساب دبیر',
              onPressed: _confirmLogoutTeacher,
            ),
            IconButton(
              onPressed: _isSyncing ? null : _refreshData,
              icon: _isSyncing
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: widget.config.accentColor,
                      ),
                    )
                  : Icon(Icons.sync_rounded,
                      color: widget.config.accentColor, size: 22),
              tooltip: 'به‌روزرسانی رتبه‌ها و سکه‌ها',
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          color: widget.config.accentColor,
          backgroundColor: const Color(0xFF131D2E),
          child: ListView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
              _buildClassHeaderCard(),
              const SizedBox(height: 18),
              _buildOpenLeaderboardButton(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'رتبه‌بندی دانش‌آموزان کلاس',
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
                      '${toPersianDigits(sortedStudents.length)} نفر',
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
              if (sortedStudents.isEmpty)
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
                        Icon(Icons.group_off_rounded,
                            size: 44, color: Color(0xFF64748B)),
                        SizedBox(height: 12),
                        Text(
                          'هنوز هیچ دانش‌آموزی با کد کلاس وارد نشده است.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...List.generate(sortedStudents.length, (index) {
                  return _buildStudentTile(sortedStudents[index], index + 1);
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.config.darkColor.withOpacity(0.85),
            const Color(0xFF0F172A),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: widget.config.accentColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: widget.config.primaryColor.withOpacity(0.12),
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
                  color: widget.config.primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  widget.config.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentClass.title,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.config.leagueTitle,
                      style: TextStyle(
                        fontFamily: 'Tahoma',
                        color: widget.config.accentColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _showEditClassTitleDialog,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.config.primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.config.accentColor.withOpacity(0.4),
                    ),
                  ),
                  child: Icon(Icons.edit_rounded,
                      color: widget.config.accentColor, size: 16),
                ),
                tooltip: 'ویرایش نام کلاس',
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
          Row(
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
                    toPersianDigits(_currentClass.classCode),
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      color: widget.config.accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Clipboard.setData(
                      ClipboardData(text: _currentClass.classCode));
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('کد کلاس در کلیپ‌بورد کپی شد'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                },
                icon: const Icon(Icons.copy_rounded, size: 14),
                label: const Text('کپی کد',
                    style: TextStyle(fontFamily: 'Tahoma', fontSize: 11)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.config.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOpenLeaderboardButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.config.darkColor, widget.config.primaryColor],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.config.primaryColor.withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UniversalLeagueLeaderboardScreen(
                  config: widget.config,
                  quranClass: _currentClass,
                  isTeacher: true,
                ),
              ),
            ).then((_) => _refreshData());
          },
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🏆', style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text(
                  'ورود به باشگاه قهرمانان (جدول رتبه‌بندی)',
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
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    if (rank == 1) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF59E0B).withOpacity(0.2),
          border: Border.all(color: const Color(0xFFFACC15), width: 1.5),
        ),
        child: const Center(
          child: Icon(Icons.emoji_events_rounded,
              color: Color(0xFFFACC15), size: 17),
        ),
      );
    } else if (rank == 2) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF94A3B8).withOpacity(0.2),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
        ),
        child: const Center(
          child: Icon(Icons.emoji_events_rounded,
              color: Color(0xFFCBD5E1), size: 17),
        ),
      );
    } else if (rank == 3) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFB45309).withOpacity(0.2),
          border: Border.all(color: const Color(0xFFFB923C), width: 1.5),
        ),
        child: const Center(
          child: Icon(Icons.emoji_events_rounded,
              color: Color(0xFFFB923C), size: 17),
        ),
      );
    }
    return SizedBox(
      width: 30,
      child: Center(
        child: Text(
          toPersianDigits(rank),
          style: const TextStyle(
            fontFamily: 'Tahoma',
            color: Color(0xFF94A3B8),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentTile(LeagueStudentModel student, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showStudentProgressDetails(student),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _buildRankBadge(rank),
                const SizedBox(width: 8),
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: (student.avatar != null && student.avatar!.isNotEmpty)
                        ? ClipOval(
                            child: Image.asset(
                              student.avatar!,
                              width: 38,
                              height: 38,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person_rounded,
                                      color: Color(0xFF94A3B8), size: 20),
                            ),
                          )
                        : const Icon(Icons.person_rounded,
                            color: Color(0xFF94A3B8), size: 20),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'سطح ${toPersianDigits(student.level)}',
                            style: const TextStyle(
                              fontFamily: 'Tahoma',
                              color: Color(0xFF64748B),
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: widget.config.accentColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'کارنامه درس‌ها',
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: widget.config.accentColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '${toPersianDigits(student.coins)} XP',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: widget.config.accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => _confirmRemoveStudent(student),
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: Color(0xFFEF4444), size: 20),
                  tooltip: 'حذف دانش‌آموز از کلاس',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStudentProgressDetails(LeagueStudentModel student) {
    final String rawPhone = (student.phoneNumber != null &&
            student.phoneNumber!.trim().isNotEmpty)
        ? student.phoneNumber!.trim()
        : (student.id.startsWith('09') ||
                RegExp(r'^\d{11}$').hasMatch(student.id))
            ? student.id.trim()
            : '';

    final lessons = widget.config.lessons;

    int completedLessonsCount = 0;
    for (final l in lessons) {
      bool allPartsDone = true;
      for (final p in l.parts) {
        final isPartDone = (student.completedParts[
                    'L${l.lessonNumber}_P${p.partNumber}'] ==
                true) ||
            (student.isCurrentUser && p.isCompletedInAuthManager());
        if (!isPartDone) {
          allPartsDone = false;
          break;
        }
      }
      if (allPartsDone && l.parts.isNotEmpty) {
        completedLessonsCount++;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.90,
            decoration: const BoxDecoration(
              color: Color(0xFF0B1120),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(
                top: BorderSide(color: Color(0xFF1E293B), width: 1.5),
                left: BorderSide(color: Color(0xFF1E293B), width: 1.5),
                right: BorderSide(color: Color(0xFF1E293B), width: 1.5),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.config.accentColor.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0B1120),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: (student.avatar != null &&
                                        student.avatar!.isNotEmpty)
                                    ? ClipOval(
                                        child: Image.asset(
                                          student.avatar!,
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                      Icons.person_rounded,
                                                      color: Color(0xFF94A3B8),
                                                      size: 26),
                                        ),
                                      )
                                    : const Icon(Icons.person_rounded,
                                        color: Color(0xFF94A3B8), size: 26),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student.name,
                                    style: const TextStyle(
                                      fontFamily: 'Tahoma',
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'سطح ${toPersianDigits(student.level)}  •  ${toPersianDigits(student.coins)} امتیاز XP',
                                    style: TextStyle(
                                      fontFamily: 'Tahoma',
                                      color: widget.config.accentColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (rawPhone.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.phone_android_rounded,
                                          color: Color(0xFF94A3B8),
                                          size: 13,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'شماره تماس: ${toPersianDigits(rawPhone)}',
                                          style: const TextStyle(
                                            fontFamily: 'Tahoma',
                                            color: Color(0xFFCBD5E1),
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: completedLessonsCount == lessons.length
                                    ? const Color(0xFF10B981).withOpacity(0.2)
                                    : widget.config.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: completedLessonsCount == lessons.length
                                      ? const Color(0xFF10B981)
                                      : widget.config.accentColor,
                                ),
                              ),
                              child: Text(
                                '${toPersianDigits(completedLessonsCount)} از ${toPersianDigits(lessons.length)} درس',
                                style: TextStyle(
                                  fontFamily: 'Tahoma',
                                  color: completedLessonsCount == lessons.length
                                      ? const Color(0xFF34D399)
                                      : widget.config.accentColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: lessons.isEmpty
                                ? 0.0
                                : completedLessonsCount / lessons.length.toDouble(),
                            minHeight: 6,
                            backgroundColor: const Color(0xFF1E293B),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              completedLessonsCount == lessons.length
                                  ? const Color(0xFF10B981)
                                  : widget.config.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book_rounded,
                          color: Color(0xFF94A3B8), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'وضعیت بازی‌ها و پیشرفت درس‌های ${widget.config.leagueTitle}:',
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 6),
                    physics: const BouncingScrollPhysics(),
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final l = lessons[index];
                      final int lNum = l.lessonNumber;
                      final String lTitle = l.title;
                      final partsCount = l.parts.length;

                      final List<bool> partsStatus = [];
                      int doneCount = 0;
                      for (final p in l.parts) {
                        final isDone = (student.completedParts[
                                    'L${lNum}_P${p.partNumber}'] ==
                                true) ||
                            (student.isCurrentUser &&
                                p.isCompletedInAuthManager());
                        partsStatus.add(isDone);
                        if (isDone) doneCount++;
                      }

                      final bool isFullyDone = doneCount == partsCount;
                      final bool isPartiallyDone =
                          doneCount > 0 && doneCount < partsCount;

                      final List<String> mistakes =
                          student.wrongWords['$lNum'] ?? [];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131D2E),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isFullyDone
                                ? const Color(0xFF10B981).withOpacity(0.5)
                                : isPartiallyDone
                                    ? const Color(0xFFF59E0B).withOpacity(0.4)
                                    : const Color(0xFF1E293B),
                            width: isFullyDone ? 1.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isFullyDone
                                            ? const Color(0xFF10B981)
                                                .withOpacity(0.18)
                                            : const Color(0xFF1E293B),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'درس ${toPersianDigits(lNum)}',
                                        style: TextStyle(
                                          fontFamily: 'Tahoma',
                                          color: isFullyDone
                                              ? const Color(0xFF34D399)
                                              : const Color(0xFF94A3B8),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      lTitle,
                                      style: const TextStyle(
                                        fontFamily: 'Tahoma',
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (isFullyDone)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981)
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xFF10B981)
                                              .withOpacity(0.4)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle_rounded,
                                            color: Color(0xFF10B981),
                                            size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          'تکمیل شده',
                                          style: TextStyle(
                                            fontFamily: 'Tahoma',
                                            color: Color(0xFF34D399),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else if (isPartiallyDone)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF59E0B)
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xFFF59E0B)
                                              .withOpacity(0.4)),
                                    ),
                                    child: Text(
                                      '${toPersianDigits(doneCount)} از ${toPersianDigits(partsCount)} قسمت ⏳',
                                      style: const TextStyle(
                                        fontFamily: 'Tahoma',
                                        color: Color(0xFFFBBF24),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'انجام نشده ⭕',
                                      style: TextStyle(
                                        fontFamily: 'Tahoma',
                                        color: Color(0xFF64748B),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Divider(color: Color(0xFF1E293B), height: 1),
                            const SizedBox(height: 8),
                            ...List.generate(l.parts.length, (pIndex) {
                              final p = l.parts[pIndex];
                              final partDone = partsStatus[pIndex];
                              final label =
                                  'قسمت ${toPersianDigits(p.partNumber)}: ${p.title} ${p.emoji}';

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      partDone
                                          ? Icons.check_circle_rounded
                                          : Icons.radio_button_unchecked_rounded,
                                      color: partDone
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFF475569),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontFamily: 'Tahoma',
                                          color: partDone
                                              ? const Color(0xFFE2E8F0)
                                              : const Color(0xFF64748B),
                                          fontSize: 11,
                                          fontWeight: partDone
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      partDone ? 'انجام شده ✓' : 'انجام نشده',
                                      style: TextStyle(
                                        fontFamily: 'Tahoma',
                                        color: partDone
                                            ? const Color(0xFF10B981)
                                            : const Color(0xFF64748B),
                                        fontSize: 10,
                                        fontWeight: partDone
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: mistakes.isNotEmpty
                                    ? const Color(0xFFEF4444).withOpacity(0.08)
                                    : const Color(0xFF0B1120),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: mistakes.isNotEmpty
                                      ? const Color(0xFFEF4444)
                                          .withOpacity(0.25)
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        mistakes.isNotEmpty
                                            ? Icons.warning_amber_rounded
                                            : Icons.spellcheck_rounded,
                                        color: mistakes.isNotEmpty
                                            ? const Color(0xFFF87171)
                                            : const Color(0xFF64748B),
                                        size: 15,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        mistakes.isNotEmpty
                                            ? 'موارد اشتباه نیازمند تمرین:'
                                            : 'گزارش خطاهای ثبت‌شده:',
                                        style: TextStyle(
                                          fontFamily: 'Tahoma',
                                          color: mistakes.isNotEmpty
                                              ? const Color(0xFFFCA5A5)
                                              : const Color(0xFF64748B),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  if (mistakes.isNotEmpty)
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: mistakes.map((w) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEF4444)
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: const Color(0xFFEF4444)
                                                  .withOpacity(0.35),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.close_rounded,
                                                  color: Color(0xFFF87171),
                                                  size: 12),
                                              const SizedBox(width: 4),
                                              Text(
                                                w,
                                                style: const TextStyle(
                                                  fontFamily: 'Tahoma',
                                                  color: Color(0xFFFECACA),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  else if (partsStatus.isNotEmpty &&
                                      partsStatus.last)
                                    const Row(
                                      children: [
                                        Icon(Icons.stars_rounded,
                                            color: Color(0xFF10B981),
                                            size: 14),
                                        SizedBox(width: 6),
                                        Text(
                                          'عالی! بدون هیچ خطایی انجام شده است ✨',
                                          style: TextStyle(
                                            fontFamily: 'Tahoma',
                                            color: Color(0xFF34D399),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    const Text(
                                      'هنوز در این درس خطایی ثبت نشده است.',
                                      style: TextStyle(
                                        fontFamily: 'Tahoma',
                                        color: Color(0xFF64748B),
                                        fontSize: 10,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF334155)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF475569)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.pop(context),
                        child: const Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close_rounded,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'بستن گزارش و بازگشت',
                                style: TextStyle(
                                  fontFamily: 'Tahoma',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
