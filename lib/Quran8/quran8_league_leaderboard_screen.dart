import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../managers/auth_manager.dart';
import 'quran8_league_manager.dart';
import 'quran8_battle_manager.dart';
import 'quran8_battle_split_screen.dart';

class Quran8LeagueLeaderboardScreen extends StatefulWidget {
  final Quran8ClassModel quranClass;
  final bool isTeacher;
  final bool isAdmin;

  const Quran8LeagueLeaderboardScreen({
    super.key,
    required this.quranClass,
    this.isTeacher = false,
    this.isAdmin = false,
  });

  @override
  State<Quran8LeagueLeaderboardScreen> createState() =>
      _Quran8LeagueLeaderboardScreenState();
}

class _Quran8LeagueLeaderboardScreenState
    extends State<Quran8LeagueLeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _trophyAnimController;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;

  late Quran8ClassModel _currentClass;
  List<Quran8BattleModel> _myBattles = [];

  @override
  void initState() {
    super.initState();
    _currentClass = widget.quranClass;

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

    final battles = await Quran8BattleManager.getBattlesForStudent(
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
        await Quran8LeagueManager.enrollOrUpdateCurrentUser(_currentClass.classCode);
    if (updated != null && mounted) {
      setState(() {
        _currentClass = updated;
      });
    }
    await _loadBattles();
  }

  bool _checkIsCurrentUser(Quran8StudentModel student) {
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
          backgroundColor: const Color(0xFF0F1A15),
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
      await Quran8LeagueManager.logoutStudent();
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final students = List<Quran8StudentModel>.from(_currentClass.students);
    students.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));

    final me = _getCurrentUserStudent();
    final myRank = me != null ? students.indexOf(me) + 1 : 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF061510),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1A15),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'باشگاه قهرمانان قرآن هشتم 🏆',
            style: TextStyle(
              fontFamily: 'Tahoma',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFF10B981)),
              tooltip: 'همگام‌سازی',
              onPressed: _refreshClassData,
            ),
            if (!widget.isTeacher && !widget.isAdmin)
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                tooltip: 'خروج از کلاس',
                onPressed: _confirmLogoutStudent,
              ),
          ],
        ),
        body: RefreshIndicator(
          color: const Color(0xFF10B981),
          backgroundColor: const Color(0xFF0F1A15),
          onRefresh: _refreshClassData,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              _buildClassBanner(),
              const SizedBox(height: 14),

              if (_myBattles.isNotEmpty) ...[
                _buildActiveBattlesSection(),
                const SizedBox(height: 14),
              ],

              if (!widget.isTeacher && !widget.isAdmin && me != null) ...[
                _buildCurrentUserHeroCard(me, myRank),
                const SizedBox(height: 18),
              ],

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  children: [
                    const Text('📊', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    const Text(
                      'رتبه‌بندی دانش‌آموزان کلاس',
                      style: TextStyle(
                        fontFamily: 'Tahoma',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4)),
                      ),
                      child: Text(
                        '${toPersianDigits(students.length)} نفر',
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF34D399),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              if (students.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1A15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: const Center(
                    child: Text(
                      'هنوز دانش‌آموزی عضو این کلاس نشده است.',
                      style: TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFF94A3B8),
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
              else
                ...students.asMap().entries.map((entry) {
                  final rank = entry.key + 1;
                  final s = entry.value;
                  return _buildStudentTile(s, rank);
                }),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Quran8StudentModel? _getCurrentUserStudent() {
    try {
      return _currentClass.students.firstWhere((s) => _checkIsCurrentUser(s));
    } catch (_) {
      return null;
    }
  }

  Widget _buildClassBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF0F172A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _trophyAnimController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: Transform.rotate(
                  angle: _rotateAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFFFFE082), Color(0xFFFFA000)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB703).withOpacity(0.5),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Text('🏆', style: TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentClass.title,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.tag_rounded, size: 14, color: Color(0xFF34D399)),
                    const SizedBox(width: 4),
                    Text(
                      'کد کلاس: ${toPersianDigits(_currentClass.classCode)}',
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserHeroCard(Quran8StudentModel me, int rank) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF065F46), Color(0xFF047857), Color(0xFF0B1A15)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF34D399), width: 1.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF064E3B),
            ),
            child: Center(
              child: (me.avatar != null && me.avatar!.isNotEmpty)
                  ? ClipOval(
                      child: Image.asset(
                        me.avatar!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person_rounded, color: Colors.white, size: 26),
                      ),
                    )
                  : const Icon(Icons.person_rounded, color: Colors.white, size: 26),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        me.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'شما',
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'سطح ${toPersianDigits(me.level)}  •  ${toPersianDigits(me.coins)} سکه XP',
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 11,
                    color: Color(0xFFA7F3D0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF064E3B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF34D399)),
            ),
            child: Column(
              children: [
                const Text(
                  'رتبه شما',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 9,
                    color: Color(0xFF6EE7B7),
                  ),
                ),
                Text(
                  '#${toPersianDigits(rank)}',
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveBattlesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              Text('⚔️', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Text(
                'مسابقات و چالش‌های فعال شما',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        ..._myBattles.map((b) => _buildBattleCard(b)),
      ],
    );
  }

  Widget _buildBattleCard(Quran8BattleModel battle) {
    final me = _getCurrentUserStudent();
    final String myId = me?.id.trim() ??
        (AuthManager.phoneNumber.trim().isNotEmpty
            ? AuthManager.phoneNumber.trim()
            : AuthManager.userName.trim());
    final String myName = me?.name.trim() ?? AuthManager.userName.trim();

    final bool isChallenger =
        battle.challengerId == myId || battle.challengerName == myName;
    final bool isCompleted = battle.status == 'completed';

    String statusText;
    Color statusColor;
    String actionBtnText;
    VoidCallback? onAction;

    if (!isCompleted) {
      if (isChallenger) {
        statusText = 'در انتظار بازی حریف (${battle.opponentName})';
        statusColor = const Color(0xFFF59E0B);
        actionBtnText = 'مشاهده وضعیت چالش ⏱️';
        onAction = () => _openBattleSplitScreen(battle);
      } else {
        statusText = 'درخواست رقابت از طرف ${battle.challengerName}!';
        statusColor = const Color(0xFF10B981);
        actionBtnText = 'پاسخ به رقابت (شروع بازی) ⚔️';
        onAction = () => _playBattleAsOpponent(battle);
      }
    } else {
      final amIWinner = battle.isWinner(myId, myName);
      final amILoser = battle.isLoser(myId, myName);
      final isClaimed = battle.isWinnerClaimedBy(myId, myName);

      if (battle.winnerType == BattleWinnerType.tie) {
        statusText = 'نتیجه: مساوی شد! 🤝 (هر دو برنده)';
        statusColor = const Color(0xFF10B981);
      } else if (amIWinner) {
        statusText = 'نتیجه: شما برنده شدید! 🏆';
        statusColor = const Color(0xFF10B981);
      } else {
        statusText = 'نتیجه: حریف برنده شد';
        statusColor = const Color(0xFFEF4444);
      }

      actionBtnText = (amIWinner && !isClaimed)
          ? 'مشاهده و دریافت جایزه ۱۰۰ سکه 🎁'
          : 'مشاهده نتیجه رقابت 📊';
      onAction = () => _openBattleSplitScreen(battle);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1A15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                battle.lessonTitle,
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${battle.partTitle})',
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  fontSize: 10,
                  color: Color(0xFF34D399),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isCompleted ? 'پایان‌یافته' : 'در جریان',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            statusText,
            style: TextStyle(
              fontFamily: 'Tahoma',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: statusColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onAction,
              child: Text(
                actionBtnText,
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openBattleSplitScreen(Quran8BattleModel battle) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Quran8BattleSplitScreen(
          battle: battle,
          onBackToLeaderboard: () => _refreshClassData(),
        ),
      ),
    );
    _refreshClassData();
  }

  void _playBattleAsOpponent(Quran8BattleModel battle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Quran8BattleManager.buildGameScreenForBattle(
          lessonIndex: battle.lessonIndex,
          partIndex: battle.partIndex,
          onComplete: (coins, timeTaken) async {
            Navigator.pop(context);

            final updated = await Quran8BattleManager.submitOpponentResult(
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

  Widget _buildStudentTile(Quran8StudentModel student, int rank) {
    final bool isMe = _checkIsCurrentUser(student);

    Widget rankWidget;
    if (rank == 1) {
      rankWidget = const Text('🥇', style: TextStyle(fontSize: 22));
    } else if (rank == 2) {
      rankWidget = const Text('🥈', style: TextStyle(fontSize: 22));
    } else if (rank == 3) {
      rankWidget = const Text('🥉', style: TextStyle(fontSize: 22));
    } else {
      rankWidget = Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            toPersianDigits(rank),
            style: const TextStyle(
              fontFamily: 'Tahoma',
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8),
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF064E3B).withOpacity(0.4) : const Color(0xFF0F1A15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe ? const Color(0xFF10B981) : const Color(0xFF1E293B),
          width: isMe ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          rankWidget,
          const SizedBox(width: 10),

          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1E293B),
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
                            const Icon(Icons.person_rounded, color: Colors.white, size: 20),
                      ),
                    )
                  : const Icon(Icons.person_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        student.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isMe ? const Color(0xFF34D399) : Colors.white,
                        ),
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'شما',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF34D399),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'سطح ${toPersianDigits(student.level)}  •  ${toPersianDigits(student.coins)} سکه XP',
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),

          if (!widget.isTeacher && !widget.isAdmin && !isMe)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF047857), Color(0xFF10B981)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('⚔️', style: TextStyle(fontSize: 14)),
              ),
              tooltip: 'درخواست رقابت',
              onPressed: () => _showChallengeBottomSheet(student),
            ),
        ],
      ),
    );
  }

  void _showChallengeBottomSheet(Quran8StudentModel opponent) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Color(0xFF061510),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(
                top: BorderSide(color: Color(0xFF10B981), width: 2),
              ),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF334155),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      const Text('⚔️', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'درخواست رقابت با ${opponent.name}',
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'درس و بخش مورد نظر برای مسابقه ۱ دقیقه‌ای را انتخاب کنید:',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: 12,
                    itemBuilder: (context, idx) =>
                        _buildLessonPickerCard(ctx, idx, opponent),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLessonPickerCard(
      BuildContext ctx, int lessonIdx, Quran8StudentModel opponent) {
    final lessonTitle = Quran8BattleManager.getLessonTitle(lessonIdx);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1A15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor: const Color(0xFF10B981),
          iconColor: const Color(0xFF34D399),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                toPersianDigits(lessonIdx + 1),
                style: const TextStyle(
                  fontFamily: 'Tahoma',
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF34D399),
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
                    onTap: () =>
                        _launchChallengeGame(ctx, lessonIdx, 1, opponent),
                  ),
                  const SizedBox(height: 8),
                  _buildPartActionItem(
                    ctx: ctx,
                    partNum: 2,
                    title: 'قسمت دوم: بازی دیوار آتشین',
                    icon: '🔥',
                    color: const Color(0xFFF97316),
                    onTap: () =>
                        _launchChallengeGame(ctx, lessonIdx, 2, opponent),
                  ),
                  const SizedBox(height: 8),
                  _buildPartActionItem(
                    ctx: ctx,
                    partNum: 3,
                    title: 'قسمت سوم: بازی موشک و شهاب‌سنگ',
                    icon: '🚀',
                    color: const Color(0xFF8B5CF6),
                    onTap: () =>
                        _launchChallengeGame(ctx, lessonIdx, 3, opponent),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    Quran8StudentModel opponent,
  ) {
    Navigator.pop(ctx);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Quran8BattleManager.buildGameScreenForBattle(
          lessonIndex: lessonIdx,
          partIndex: partIdx,
          onComplete: (coins, timeTaken) async {
            Navigator.pop(context);

            final currentUserId = AuthManager.phoneNumber.trim().isNotEmpty
                ? AuthManager.phoneNumber.trim()
                : AuthManager.userName.trim();
            final currentUserName = AuthManager.userName.trim();

            Quran8StudentModel currentStudent;
            try {
              currentStudent = _currentClass.students.firstWhere(
                (s) => _checkIsCurrentUser(s),
              );
            } catch (_) {
              currentStudent = Quran8StudentModel(
                id: currentUserId,
                name: currentUserName.isNotEmpty ? currentUserName : 'من',
                coins: AuthManager.coins,
                level: 1,
                avatar: AuthManager.userAvatar,
              );
            }

            final newBattle = await Quran8BattleManager.createBattle(
              classCode: _currentClass.classCode,
              challenger: currentStudent,
              opponent: opponent,
              lessonIndex: lessonIdx,
              partIndex: partIdx,
              lessonTitle: Quran8BattleManager.getLessonTitle(lessonIdx),
              partTitle: Quran8BattleManager.getPartName(partIdx),
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
}
