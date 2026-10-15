import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../managers/auth_manager.dart';
import 'quran7_league_manager.dart';
import 'quran7_battle_manager.dart';
import 'quran7_battle_split_screen.dart';

class Quran7LeagueLeaderboardScreen extends StatefulWidget {
  final QuranClassModel quranClass;
  final bool isTeacher;
  final bool isAdmin;

  const Quran7LeagueLeaderboardScreen({
    super.key,
    required this.quranClass,
    this.isTeacher = false,
    this.isAdmin = false,
  });

  @override
  State<Quran7LeagueLeaderboardScreen> createState() =>
      _Quran7LeagueLeaderboardScreenState();
}

class _Quran7LeagueLeaderboardScreenState
    extends State<Quran7LeagueLeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _trophyAnimController;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;

  late QuranClassModel _currentClass;
  List<Quran7BattleModel> _myBattles = [];

  @override
  void initState() {
    super.initState();
    _currentClass = widget.quranClass;

    // تنظیم کنترلر انیمیشن موشن ایموجی کاپ قهرمانی
    _trophyAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(
        parent: _trophyAnimController,
        curve: Curves.easeInOutSine,
      ),
    );

    _rotateAnimation = Tween<double>(begin: -0.07, end: 0.07).animate(
      CurvedAnimation(
        parent: _trophyAnimController,
        curve: Curves.easeInOutSine,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.12).animate(
      CurvedAnimation(
        parent: _trophyAnimController,
        curve: Curves.easeInOutSine,
      ),
    );

    _loadBattles();
  }

  Future<void> _loadBattles() async {
    final me = _getCurrentUserStudent();
    final currentUserId = (me?.id.trim().isNotEmpty ?? false)
        ? me!.id.trim()
        : (AuthManager.phoneNumber.trim().isNotEmpty
            ? AuthManager.phoneNumber.trim()
            : AuthManager.userName.trim());
    final currentUserName = (me?.name.trim().isNotEmpty ?? false)
        ? me!.name.trim()
        : AuthManager.userName.trim();
    final currentUserPhone = me?.phoneNumber ??
        (AuthManager.phoneNumber.trim().isNotEmpty
            ? AuthManager.phoneNumber.trim()
            : null);

    final battles = await Quran7BattleManager.getBattlesForStudent(
      classCode: _currentClass.classCode,
      studentId: currentUserId,
      studentName: currentUserName,
      phoneNumber: currentUserPhone,
    );
    if (mounted) {
      setState(() {
        _myBattles = battles;
      });
    }
  }

  @override
  void dispose() {
    _trophyAnimController.dispose();
    super.dispose();
  }

  Future<void> _refreshClassData() async {
    final updated =
        await Quran7LeagueManager.enrollOrUpdateCurrentUser(_currentClass.classCode);
    if (updated != null && mounted) {
      setState(() {
        _currentClass = updated;
      });
    }
    await _loadBattles();
  }

  bool _checkIsCurrentUser(QuranStudentModel student) {
    if (AuthManager.phoneNumber.trim().isNotEmpty &&
        student.id == AuthManager.phoneNumber.trim()) {
      return true;
    }
    if (AuthManager.userName.trim().isNotEmpty &&
        student.name == AuthManager.userName.trim()) {
      return true;
    }
    return student.isCurrentUser;
  }

  Future<void> _confirmLogoutStudent() async {
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
                'خروج از کلاس',
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
            'آیا می‌خواهید از این کلاس خارج شوید؟\nپس از خروج، ورود خودکار لغو شده و می‌توانید با کد کلاس دیگری عضو شوید.',
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
                'خروج از کلاس',
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
      await Quran7LeagueManager.logoutStudent();
      if (!mounted) return;
      Navigator.pop(context);
    }
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
        body: SafeArea(
          child: Column(
            children: [
              // هدر بالا همراه با دکمه بازگشت، عنوان و ایموجی کاپ با موشن حرفه‌ای
              _buildHeader(),

              // اطلاعات کلاس و کد
              _buildClassInfoBar(),

              const SizedBox(height: 10),

              // لیست رتبه‌بندی دانش‌آموزان
              Expanded(
                child: sortedStudents.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () async => _refreshClassData(),
                        color: const Color(0xFF00E5FF),
                        backgroundColor: const Color(0xFF131D2E),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          itemCount: sortedStudents.length,
                          itemBuilder: (context, index) {
                            final student = sortedStudents[index];
                            final rank = index + 1;
                            final displayScore = student.coins;

                            return _buildLeaderboardCard(
                              student: student,
                              rank: rank,
                              score: displayScore,
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // هدر بالایی با موشن خفن ایموجی کاپ
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // دکمه بازگشت جذاب
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.8),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white12),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),

          // عنوان به همراه ایموجی کاپ موشن‌دار در سمت راست
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'باشگاه قهرمانان',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),

              // ایموجی کاپ با موشن حرفه‌ای و افکت نوری
              AnimatedBuilder(
                animation: _trophyAnimController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: Transform.rotate(
                      angle: _rotateAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFACC15).withOpacity(0.35),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Text(
                            '🏆',
                            style: TextStyle(
                              fontSize: 26,
                              shadows: [
                                Shadow(
                                  color: Color(0xFFF59E0B),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // دکمه خروج از کلاس
              IconButton(
                tooltip: 'خروج از کلاس / تعویض کلاس',
                onPressed: _confirmLogoutStudent,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.18),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: Colors.redAccent.withOpacity(0.4)),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFFCA5A5),
                    size: 16,
                  ),
                ),
              ),

              // آیکون اشتراک کد کلاس
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Clipboard.setData(
                      ClipboardData(text: _currentClass.classCode));
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          'کد کلاس (${toPersianDigits(_currentClass.classCode)}) کپی شد!',
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: const Color(0xFF0284C7),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withOpacity(0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Icon(
                    Icons.copy_rounded,
                    color: Color(0xFF38BDF8),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // بار نمایش اطلاعات کلاس و کد
  Widget _buildClassInfoBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF131D2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.school_rounded,
                    color: Color(0xFF10B981), size: 16),
                const SizedBox(width: 6),
                Text(
                  _currentClass.title,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFFE2E8F0),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.4)),
              ),
              child: Text(
                'کد: ${toPersianDigits(_currentClass.classCode)}',
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  color: Color(0xFF38BDF8),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // آیتم رتبه‌بندی منطبق بر جزئیات تصویر
  Widget _buildLeaderboardCard({
    required QuranStudentModel student,
    required int rank,
    required int score,
  }) {
    final bool isUser = _checkIsCurrentUser(student);

    // اگر کاربر جاری باشد، دقیقاً با کادر فیروزه‌ای نئونی پایین جدول رندر می‌شود
    if (isUser) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1E2E),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF00E5FF), width: 1.8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00E5FF).withOpacity(0.25),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // سمت چپ: امتیاز کاربر با رنگ فیروزه‌ای
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    toPersianDigits(score),
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF00E5FF),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'XP',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF67E8F9),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // بخش میانی: نام کاربر با برچسب «شما» و سطح
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          student.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: const Color(0xFF00E5FF).withOpacity(0.6)),
                        ),
                        child: const Text(
                          'شما',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFF00E5FF),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // آواتار دایره‌ای با رنگ فیروزه‌ای روشن
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF00BCD4),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: (student.avatar != null && student.avatar!.isNotEmpty)
                    ? ClipOval(
                        child: Image.asset(
                          student.avatar!,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
              ),
            ),

            const SizedBox(width: 14),

            // نشان رتبه (مدال برای رتبه‌های ۱، ۲، ۳ یا عدد فیروزه‌ای برای رتبه‌های ۴ به بالا)
            SizedBox(
              width: 34,
              child: Center(
                child: _buildRankBadge(rank, isCurrentUser: true),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUser
              ? const Color(0xFF06B6D4)
              : const Color(0xFF1E293B).withOpacity(0.9),
          width: isUser ? 1.8 : 1.0,
        ),
        boxShadow: isUser
            ? [
                BoxShadow(
                  color: const Color(0xFF06B6D4).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // سمت چپ: امتیاز بزرگ و عبارت XP
          SizedBox(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  toPersianDigits(score),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 1),
                const Text(
                  'XP',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // بخش میانی: نام دانش‌آموز و سطح
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  student.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: isUser ? const Color(0xFF38BDF8) : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isUser) ...[
                  const SizedBox(height: 5),
                  _buildBattleButton(student),
                ],
              ],
            ),
          ),

          const SizedBox(width: 10),

          // آواتار دایره‌ای کاربر
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              shape: BoxShape.circle,
              border: Border.all(
                color: isUser
                    ? const Color(0xFF06B6D4)
                    : const Color(0xFF334155),
                width: 1.5,
              ),
            ),
            child: Center(
              child: (student.avatar != null && student.avatar!.isNotEmpty)
                  ? ClipOval(
                      child: Image.asset(
                        student.avatar!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.person_rounded,
                          color: Color(0xFF94A3B8),
                          size: 22,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.person_rounded,
                      color: Color(0xFF94A3B8),
                      size: 22,
                    ),
            ),
          ),

          const SizedBox(width: 14),

          // نشان رتبه (مدال برای رتبه‌های ۱، ۲، ۳ یا عدد رتبه برای سایرین)
          SizedBox(
            width: 34,
            child: Center(
              child: _buildRankBadge(rank),
            ),
          ),
        ],
      ),
    );
  }

  // نشان رتبه بر اساس مدال یا عدد
  Widget _buildRankBadge(int rank, {bool isCurrentUser = false}) {
    if (rank == 1) {
      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF59E0B).withOpacity(0.18),
          border: Border.all(color: const Color(0xFFFACC15), width: 1.8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFACC15).withOpacity(0.35),
              blurRadius: 8,
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFFFACC15),
            size: 20,
          ),
        ),
      );
    } else if (rank == 2) {
      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF94A3B8).withOpacity(0.18),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.8),
        ),
        child: const Center(
          child: Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFFCBD5E1),
            size: 20,
          ),
        ),
      );
    } else if (rank == 3) {
      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFB45309).withOpacity(0.18),
          border: Border.all(color: const Color(0xFFF97316), width: 1.8),
        ),
        child: const Center(
          child: Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFFFB923C),
            size: 20,
          ),
        ),
      );
    } else {
      return Text(
        toPersianDigits(rank),
        style: TextStyle(
          fontFamily: 'Tahoma',
          color: isCurrentUser
              ? const Color(0xFF00E5FF)
              : const Color(0xFF94A3B8),
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.group_off_rounded,
              color: Color(0xFF64748B), size: 48),
          const SizedBox(height: 12),
          const Text(
            'هنوز دانش‌آموزی در این کلاس ثبت نشده است',
            style: TextStyle(
              fontFamily: 'Tahoma',
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // بخش قابلیت‌های رقابت و نبرد دونفره (Battle Mode)
  // ==========================================

  QuranStudentModel? _getCurrentUserStudent() {
    try {
      return _currentClass.students.firstWhere(
        (s) => _checkIsCurrentUser(s),
      );
    } catch (_) {
      return null;
    }
  }

  bool _doesParticipantMatch(QuranStudentModel student, String pId, String pName) {
    final cleanPId = pId.trim();
    final cleanPName = pName.trim();
    final sId = student.id.trim();
    final sPhone = (student.phoneNumber ?? '').trim();
    final sName = student.name.trim();

    // اگر آیدی participant موجود است، باید با آیدی یا تلفن دانش‌آموز مطابقت کند
    if (cleanPId.isNotEmpty) {
      if (sId.isNotEmpty && cleanPId == sId) return true;
      if (sPhone.isNotEmpty && cleanPId == sPhone) return true;
      // اگر هر دو آیدی دارند اما متفاوتند، قطعاً این دانش‌آموز نیست
      if (sId.isNotEmpty && cleanPId != sId) return false;
    }

    // اگر تلفن دانش‌آموز ثبت شده و با cleanPName یا cleanPId یکی است
    if (sPhone.isNotEmpty && (cleanPId == sPhone || cleanPName == sPhone)) {
      return true;
    }

    // تطابق بر اساس نام فقط در حالتی که آیدی‌ها نامعتبر یا خالی باشند
    if (cleanPName.isNotEmpty && sName.isNotEmpty) {
      if (cleanPName == sName) {
        if (cleanPId.isNotEmpty && sId.isNotEmpty && cleanPId != sId) {
          return false;
        }
        return true;
      }
    }

    return false;
  }

  Quran7BattleModel? _findBattleForStudent(QuranStudentModel targetStudent) {
    final me = _getCurrentUserStudent();
    final myId = (me?.id.trim().isNotEmpty ?? false)
        ? me!.id.trim()
        : (AuthManager.phoneNumber.trim().isNotEmpty
            ? AuthManager.phoneNumber.trim()
            : AuthManager.userName.trim());
    final myPhone = me?.phoneNumber?.trim() ?? AuthManager.phoneNumber.trim();
    final myName = (me?.name.trim().isNotEmpty ?? false)
        ? me!.name.trim()
        : AuthManager.userName.trim();

    final meModel = me ??
        QuranStudentModel(
          id: myId,
          name: myName,
          coins: AuthManager.coins,
          level: 1,
          phoneNumber: myPhone.isNotEmpty ? myPhone : null,
        );

    // ۱. اولویت اول: بررسی وجود نبرد معلق (pending) دقیقاً بین این دو نفر
    for (final b in _myBattles) {
      if (b.status != 'pending') continue;
      if (b.isDismissedBy(myId, myName, myPhone)) continue;

      // حالت الف: من چلنجر هستم و این دانش‌آموز حریف است
      final iAmChallenger = _doesParticipantMatch(meModel, b.challengerId, b.challengerName);
      final targetIsOpponent = _doesParticipantMatch(targetStudent, b.opponentId, b.opponentName);
      if (iAmChallenger && targetIsOpponent) return b;

      // حالت ب: این دانش‌آموز چلنجر است و من حریف هستم
      final targetIsChallenger = _doesParticipantMatch(targetStudent, b.challengerId, b.challengerName);
      final iAmOpponent = _doesParticipantMatch(meModel, b.opponentId, b.opponentName);
      if (targetIsChallenger && iAmOpponent) return b;
    }

    // ۲. اولویت دوم: آخرین نبرد تکمیل شده دقیقاً بین این دو دانش‌آموز
    for (final b in _myBattles) {
      if (b.status == 'pending') continue;
      if (b.isDismissedBy(myId, myName, myPhone)) continue;

      final iAmChallenger = _doesParticipantMatch(meModel, b.challengerId, b.challengerName);
      final targetIsOpponent = _doesParticipantMatch(targetStudent, b.opponentId, b.opponentName);
      if (iAmChallenger && targetIsOpponent) return b;

      final targetIsChallenger = _doesParticipantMatch(targetStudent, b.challengerId, b.challengerName);
      final iAmOpponent = _doesParticipantMatch(meModel, b.opponentId, b.opponentName);
      if (targetIsChallenger && iAmOpponent) return b;
    }

    return null;
  }

  Widget _buildBattleButton(QuranStudentModel student) {
    final battle = _findBattleForStudent(student);

    String label = 'درخواست رقابت';
    Color startColor = const Color(0xFF8B5CF6);
    Color endColor = const Color(0xFF6D28D9);
    String emoji = '⚔️';

    if (battle != null) {
      if (battle.status == 'pending') {
        final me = _getCurrentUserStudent();
        final currentUserId = AuthManager.phoneNumber.trim().isNotEmpty
            ? AuthManager.phoneNumber.trim()
            : AuthManager.userName.trim();
        final currentUserName = AuthManager.userName.trim();

        final bool amIOpponent = (me != null &&
                _doesParticipantMatch(me, battle.opponentId, battle.opponentName)) ||
            battle.opponentId == currentUserId ||
            battle.opponentName == currentUserName;

        if (amIOpponent && !battle.opponentFinished) {
          label = 'پاسخ به رقابت';
          startColor = const Color(0xFFEF4444);
          endColor = const Color(0xFFDC2626);
          emoji = '🔥';
        } else {
          label = 'در انتظار حریف';
          startColor = const Color(0xFFF59E0B);
          endColor = const Color(0xFFD97706);
          emoji = '⏳';
        }
      } else {
        label = 'نتیجه رقابت';
        startColor = const Color(0xFF10B981);
        endColor = const Color(0xFF059669);
        emoji = '🏆';
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleBattleTap(student),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [startColor, endColor]),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: startColor.withOpacity(0.35),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBattleTap(QuranStudentModel student) {
    final battle = _findBattleForStudent(student);

    if (battle == null) {
      // ایجاد درخواست جدید
      _showBattleLessonPicker(student);
    } else if (battle.status == 'pending') {
      final me = _getCurrentUserStudent();
      final currentUserId = AuthManager.phoneNumber.trim().isNotEmpty
          ? AuthManager.phoneNumber.trim()
          : AuthManager.userName.trim();
      final currentUserName = AuthManager.userName.trim();

      final bool amIOpponent = (me != null &&
              _doesParticipantMatch(me, battle.opponentId, battle.opponentName)) ||
          battle.opponentId == currentUserId ||
          battle.opponentName == currentUserName;

      if (amIOpponent && !battle.opponentFinished) {
        // حریف است و باید بازی کند
        _playBattleAsOpponent(battle);
      } else {
        // چلنجر است و منتظر حریف
        _openBattleSplitScreen(battle);
      }
    } else {
      // بازی تمام شده
      _openBattleSplitScreen(battle);
    }
  }

  Future<void> _openBattleSplitScreen(Quran7BattleModel battle) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Quran7BattleSplitScreen(
          battle: battle,
          onBackToLeaderboard: () => _refreshClassData(),
        ),
      ),
    );
    _refreshClassData();
  }

  void _playBattleAsOpponent(Quran7BattleModel battle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Quran7BattleManager.buildGameScreenForBattle(
          lessonIndex: battle.lessonIndex,
          partIndex: battle.partIndex,
          onComplete: (coins, timeTaken) async {
            Navigator.pop(context); // بستن بازی

            final updated = await Quran7BattleManager.submitOpponentResult(
              battleId: battle.id,
              opponentCoins: coins,
              opponentTimeSeconds: timeTaken,
            );

            if (!mounted) return;
            if (updated != null) {
              await _openBattleSplitScreen(updated);
            }
            _refreshClassData();
          },
        ),
      ),
    );
  }

  void _showBattleLessonPicker(QuranStudentModel opponent) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(ctx).size.height * 0.82,
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(top: BorderSide(color: Color(0xFF8B5CF6), width: 2.5)),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 8),
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF8B5CF6), width: 1.5),
                        ),
                        child: const Text('⚔️', style: TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'درخواست رقابت با ${opponent.name}',
                              style: const TextStyle(
                                fontFamily: 'Tahoma',
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'یک درس و بخش را برای مسابقه ۱ دقیقه‌ای انتخاب کنید:',
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: 12,
                    itemBuilder: (context, lessonIdx) {
                      return _buildLessonPickerCard(ctx, lessonIdx, opponent);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLessonPickerCard(BuildContext ctx, int lessonIdx, QuranStudentModel opponent) {
    final lessonTitle = Quran7BattleManager.getLessonTitle(lessonIdx);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor: const Color(0xFF38BDF8),
          iconColor: const Color(0xFF8B5CF6),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                toPersianDigits(lessonIdx + 1),
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFC084FC),
                  fontSize: 14,
                ),
              ),
            ),
          ),
          title: Text(
            lessonTitle,
            style: const TextStyle(
              fontFamily: 'Tahoma',
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          subtitle: const Text(
            'دارای ۳ بخش مسابقه',
            style: TextStyle(
              fontFamily: 'Tahoma',
              fontSize: 10,
              color: Color(0xFF64748B),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 12),
              child: Column(
                children: [
                  _buildPartActionItem(
                    ctx: ctx,
                    partNum: 1,
                    title: 'قسمت اول: تطبیق کلمات و ایموجی',
                    icon: '🧩',
                    color: const Color(0xFF10B981),
                    onTap: () => _launchChallengeGame(ctx, lessonIdx, 1, opponent),
                  ),
                  const SizedBox(height: 8),
                  _buildPartActionItem(
                    ctx: ctx,
                    partNum: 2,
                    title: 'قسمت دوم: بازی دیوار آتشین',
                    icon: '🔥',
                    color: const Color(0xFFF97316),
                    onTap: () => _launchChallengeGame(ctx, lessonIdx, 2, opponent),
                  ),
                  const SizedBox(height: 8),
                  _buildPartActionItem(
                    ctx: ctx,
                    partNum: 3,
                    title: 'قسمت سوم: بازی موشک و شهاب‌سنگ',
                    icon: '🚀',
                    color: const Color(0xFF8B5CF6),
                    onTap: () => _launchChallengeGame(ctx, lessonIdx, 3, opponent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartActionItem({
    required BuildContext ctx,
    required int partNum,
    required String title,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'انتخاب ⚔️',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchChallengeGame(
    BuildContext ctx,
    int lessonIdx,
    int partIdx,
    QuranStudentModel opponent,
  ) {
    Navigator.pop(ctx); // بستن باتم‌شیت

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Quran7BattleManager.buildGameScreenForBattle(
          lessonIndex: lessonIdx,
          partIndex: partIdx,
          onComplete: (coins, timeTaken) async {
            Navigator.pop(context); // بستن صفحه بازی

            final currentUserId = AuthManager.phoneNumber.trim().isNotEmpty
                ? AuthManager.phoneNumber.trim()
                : AuthManager.userName.trim();
            final currentUserName = AuthManager.userName.trim();

            QuranStudentModel currentStudent;
            try {
              currentStudent = _currentClass.students.firstWhere(
                (s) => _checkIsCurrentUser(s),
              );
            } catch (_) {
              currentStudent = QuranStudentModel(
                id: currentUserId,
                name: currentUserName.isNotEmpty ? currentUserName : 'من',
                coins: AuthManager.coins,
                level: 1,
                avatar: AuthManager.userAvatar,
              );
            }

            final newBattle = await Quran7BattleManager.createBattle(
              classCode: _currentClass.classCode,
              challenger: currentStudent,
              opponent: opponent,
              lessonIndex: lessonIdx,
              partIndex: partIdx,
              lessonTitle: Quran7BattleManager.getLessonTitle(lessonIdx),
              partTitle: Quran7BattleManager.getPartName(partIdx),
              challengerCoins: coins,
              challengerTimeSeconds: timeTaken,
            );

            if (!mounted) return;
            await _openBattleSplitScreen(newBattle);
            _refreshClassData();
          },
        ),
      ),
    );
  }

  Widget _buildPendingChallengesBanner() {
    return const SizedBox.shrink();
  }
}
