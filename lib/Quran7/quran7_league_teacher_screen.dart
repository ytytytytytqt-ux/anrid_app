import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quran7_league_manager.dart';
import 'quran7_league_leaderboard_screen.dart';

class Quran7LeagueTeacherScreen extends StatefulWidget {
  final QuranClassModel quranClass;

  const Quran7LeagueTeacherScreen({super.key, required this.quranClass});

  @override
  State<Quran7LeagueTeacherScreen> createState() =>
      _Quran7LeagueTeacherScreenState();
}

class _Quran7LeagueTeacherScreenState extends State<Quran7LeagueTeacherScreen> {
  late QuranClassModel _currentClass;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _currentClass = widget.quranClass;
    _refreshData();
  }

  // همگام‌سازی سکه‌ها و اطلاعات تمام دانش‌آموزان با آخرین مقادیر
  Future<void> _refreshData() async {
    setState(() => _isSyncing = true);
    final updated =
        await Quran7LeagueManager.syncClassStudents(_currentClass.classCode);
    if (!mounted) return;
    setState(() {
      _isSyncing = false;
      if (updated != null) {
        _currentClass = updated;
      }
    });
  }

  // دیالوگ تأیید خروج از حساب معلم
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
      await Quran7LeagueManager.logoutTeacher();
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  // دیالوگ ویرایش نام کلاس
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
            title: const Row(
              children: [
                Icon(Icons.edit_note_rounded,
                    color: Color(0xFF38BDF8), size: 24),
                SizedBox(width: 8),
                Text(
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
                        borderSide: const BorderSide(
                            color: Color(0xFF38BDF8), width: 1.8),
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
                  final success = await Quran7LeagueManager.updateClassTitle(
                    _currentClass.classCode,
                    newTitle,
                  );

                  if (success && mounted) {
                    setState(() {
                      _currentClass = QuranClassModel(
                        classCode: _currentClass.classCode,
                        teacherCode: _currentClass.teacherCode,
                        title: newTitle,
                        createdAt: _currentClass.createdAt,
                        students: _currentClass.students,
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
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

  // دیالوگ تأیید حذف دانش‌آموز از کلاس
  void _confirmRemoveStudent(QuranStudentModel student) {
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
                final updated = await Quran7LeagueManager.removeStudentFromClass(
                  _currentClass.classCode,
                  student.id,
                );

                if (updated != null && mounted) {
                  setState(() {
                    _currentClass = updated;
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
    // مرتب‌سازی دانش‌آموزان صرفاً بر اساس زمان ورود به کلاس (هر کس زودتر وارد شده رتبه بالاتر)
    final List<QuranStudentModel> sortedStudents =
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
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('👨‍🏫', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'پنل دبیر قرآن هفتم',
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
              tooltip: 'خروج از حساب دبیر',
              onPressed: _confirmLogoutTeacher,
            ),
            IconButton(
              onPressed: _isSyncing ? null : _refreshData,
              icon: _isSyncing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF38BDF8),
                      ),
                    )
                  : const Icon(Icons.sync_rounded,
                      color: Color(0xFF38BDF8), size: 22),
              tooltip: 'به‌روزرسانی رتبه‌ها و سکه‌ها',
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          color: const Color(0xFF38BDF8),
          backgroundColor: const Color(0xFF131D2E),
          child: ListView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
              // کارت اطلاعات کلاس با امکان ویرایش نام کلاس
              _buildClassHeaderCard(),

              const SizedBox(height: 18),

              // دکمه ورود به جدول رتبه‌بندی
              _buildOpenLeaderboardButton(),

              const SizedBox(height: 24),

              // عنوان لیست دانش‌آموزان
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

              // لیست دانش‌آموزان به ترتیب رتبه با دکمه حذف
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
                        Icon(Icons.people_outline_rounded,
                            color: Color(0xFF64748B), size: 40),
                        SizedBox(height: 10),
                        Text(
                          'هنوز هیچ دانش‌آموزی با این کد وارد کلاس نشده است.',
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
                ...sortedStudents.asMap().entries.map((entry) {
                  final rank = entry.key + 1;
                  final student = entry.value;
                  return _buildStudentTile(student, rank);
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.2),
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
                  color: const Color(0xFF3B82F6).withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school_rounded,
                    color: Color(0xFF60A5FA), size: 24),
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
                    const Text(
                      'کلاس فعال لیگ قرآن هفتم',
                      style: TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFF93C5FD),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // دکمه ویرایش نام کلاس
              IconButton(
                onPressed: _showEditClassTitleDialog,
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A).withOpacity(0.7),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color(0xFF60A5FA).withOpacity(0.5)),
                  ),
                  child: const Icon(Icons.edit_rounded,
                      color: Color(0xFF93C5FD), size: 16),
                ),
                tooltip: 'ویرایش نام کلاس',
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),

          // کد کلاس ۵ رقمی برای دادن به دانش‌آموزان
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
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF38BDF8),
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
                  backgroundColor: const Color(0xFF0284C7),
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
        gradient: const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF00B4D8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B4D8).withOpacity(0.35),
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
                builder: (_) => Quran7LeagueLeaderboardScreen(
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

  // نشان رتبه (مدال برای ۳ نفر اول یا عدد برای بقیه)
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

  Widget _buildStudentTile(QuranStudentModel student, int rank) {
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
                // رتبه دانش‌آموز (مدال یا عدد)
                _buildRankBadge(rank),

                const SizedBox(width: 8),

                // آواتار
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

                // نام و سطح دانش‌آموز
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
                              color: const Color(0xFF38BDF8).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'کارنامه درس‌ها',
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF38BDF8),
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

                // تعداد سکه / XP
                Text(
                  '${toPersianDigits(student.coins)} XP',
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFF38BDF8),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 4),

                // دکمه حذف دانش‌آموز از کلاس
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

  // نمایش کارنامه و گزارش کامل درس‌ها و کلمات اشتباه دانش‌آموز برای معلم
  void _showStudentProgressDetails(QuranStudentModel student) {
    // شماره تماس دانش‌آموز جهت نمایش به معلم در کادر بالای کارنامه
    final String rawPhone = (student.phoneNumber != null &&
            student.phoneNumber!.trim().isNotEmpty)
        ? student.phoneNumber!.trim()
        : (student.id.startsWith('09') ||
                RegExp(r'^\d{11}$').hasMatch(student.id))
            ? student.id.trim()
            : '';

    // ۱۲ درس قرآن هفتم
    final List<Map<String, dynamic>> lessons = [
      {'num': 1, 'title': 'اَلدَّرْسُ الْأَوَّلُ', 'parts': 3},
      {'num': 2, 'title': 'اَلدَّرْسُ الثّاني', 'parts': 3},
      {'num': 3, 'title': 'اَلدَّرْسُ الثّالِثُ', 'parts': 3},
      {'num': 4, 'title': 'اَلدَّرْسُ الرّابِعُ', 'parts': 3},
      {'num': 5, 'title': 'اَلدَّرْسُ الْخامِسُ', 'parts': 3},
      {'num': 6, 'title': 'اَلدَّرْسُ السّادِسُ', 'parts': 3},
      {'num': 7, 'title': 'اَلدَّرْسُ السّابِعُ', 'parts': 3},
      {'num': 8, 'title': 'اَلدَّرْسُ الثّامِنُ', 'parts': 3},
      {'num': 9, 'title': 'اَلدَّرْسُ التّاسِعُ', 'parts': 3},
      {'num': 10, 'title': 'اَلدَّرْسُ الْعاشِِرُ', 'parts': 3},
      {'num': 11, 'title': 'اَلدَّرْسُ الْحادِی عَشَرَ', 'parts': 3},
      {'num': 12, 'title': 'اَلدَّرْسُ الثّانی عَشَرَ', 'parts': 3},
    ];

    // محاسبه درس‌های تکمیل‌شده
    int completedLessonsCount = 0;
    for (final l in lessons) {
      final int lNum = l['num'] as int;
      final int partsCount = l['parts'] as int;
      bool allPartsDone = true;
      for (int p = 1; p <= partsCount; p++) {
        final isPartDone = (student.completedParts['L${lNum}_P$p'] == true) ||
            (student.isCurrentUser &&
                Quran7LeagueManager.getAuthManagerQuran7PartCompleted(
                    lNum, p));
        if (!isPartDone) {
          allPartsDone = false;
          break;
        }
      }
      if (allPartsDone) {
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
                // نشانگر کشیدن بالا (Drag Handle)
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // هدر دانش‌آموز (آواتار، نام، شماره تلفن، سکه و تعداد درس‌های تکمیل‌شده)
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
                          color: const Color(0xFF38BDF8).withOpacity(0.3)),
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
                                    style: const TextStyle(
                                      fontFamily: 'Tahoma',
                                      color: Color(0xFF38BDF8),
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
                                color: completedLessonsCount == 12
                                    ? const Color(0xFF10B981).withOpacity(0.2)
                                    : const Color(0xFF0284C7).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: completedLessonsCount == 12
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFF38BDF8),
                                ),
                              ),
                              child: Text(
                                '${toPersianDigits(completedLessonsCount)} از ۱۲ درس',
                                style: TextStyle(
                                  fontFamily: 'Tahoma',
                                  color: completedLessonsCount == 12
                                      ? const Color(0xFF34D399)
                                      : const Color(0xFF38BDF8),
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
                            value: completedLessonsCount / 12.0,
                            minHeight: 6,
                            backgroundColor: const Color(0xFF1E293B),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              completedLessonsCount == 12
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF38BDF8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // نوار عنوان لیست درس‌ها
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  child: Row(
                    children: [
                      Icon(Icons.menu_book_rounded,
                          color: Color(0xFF94A3B8), size: 16),
                      SizedBox(width: 8),
                      Text(
                        'وضعیت بازی‌ها و پیشرفت درس‌های قرآن هفتم:',
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // لیست اسکرول‌پذیر ۱۲ درس با بخش‌ها و خطاهای ثبت‌شده
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 6),
                    physics: const BouncingScrollPhysics(),
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final l = lessons[index];
                      final int lNum = l['num'] as int;
                      final String lTitle = l['title'] as String;
                      final int partsCount = l['parts'] as int;

                      // بررسی وضعیت هر قسمت
                      final List<bool> partsStatus = [];
                      int doneCount = 0;
                      for (int p = 1; p <= partsCount; p++) {
                        final isDone = (student.completedParts['L${lNum}_P$p'] ==
                                true) ||
                            (student.isCurrentUser &&
                                Quran7LeagueManager
                                    .getAuthManagerQuran7PartCompleted(
                                        lNum, p));
                        partsStatus.add(isDone);
                        if (isDone) doneCount++;
                      }

                      final bool isFullyDone = doneCount == partsCount;
                      final bool isPartiallyDone =
                          doneCount > 0 && doneCount < partsCount;

                      // کلمات اشتباه قسمت سوم برای این درس
                      final List<String> mistakes =
                          student.wrongWords['$lNum'] ?? [];

                      // نام بازی‌های قسمت‌ها
                      final List<String> partLabels = [
                        'قسمت ۱: تطبیق کلمات و تصویر 🧩',
                        'قسمت ۲: دیوار آتشین لغات 🔥',
                        'قسمت ۳: پرتاب موشک و کلمات 🚀',
                      ];

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
                            // سطر عنوان درس و وضعیت کلی آن
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
                                // نشانگر وضعیت درس کلی
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

                            // لیست قسمت‌های این درس (۲ یا ۳ قسمت)
                            ...List.generate(partsCount, (pIndex) {
                              final partDone = partsStatus[pIndex];
                              final label = pIndex < partLabels.length
                                  ? partLabels[pIndex]
                                  : 'قسمت ${toPersianDigits(pIndex + 1)}';

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

                            // نمایش کلمات اشتباه قسمت ۳ (موشک و شهاب‌سنگ)
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
                                            ? 'کلمات اشتباه در قسمت ۳ (نیاز به تمرین):'
                                            : 'گزارش خطای قسمت ۳:',
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
                                  else if (partsStatus.length >= 3 &&
                                      partsStatus[2])
                                    const Row(
                                      children: [
                                        Icon(Icons.stars_rounded,
                                            color: Color(0xFF10B981),
                                            size: 14),
                                        SizedBox(width: 6),
                                        Text(
                                          'عالی! این قسمت بدون هیچ خطایی انجام شده است ✨',
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
                                      'هنوز در این قسمت خطایی ثبت نشده است.',
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

                // دکمه پایین: بستن و بازگشت به حالت عادی
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

