import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../managers/auth_manager.dart';
import 'league_models.dart';
import 'league_config.dart';
import 'league_storage_manager.dart';
import 'league_battle_manager.dart';
import 'league_battle_split_screen.dart';

class UniversalLeagueLeaderboardScreen extends StatefulWidget {
  final LeagueSubjectConfig config;
  final LeagueClassModel quranClass;
  final bool isTeacher;

  const UniversalLeagueLeaderboardScreen({
    super.key,
    required this.config,
    required this.quranClass,
    this.isTeacher = false,
  });

  @override
  State<UniversalLeagueLeaderboardScreen> createState() =>
      _UniversalLeagueLeaderboardScreenState();
}

class _UniversalLeagueLeaderboardScreenState
    extends State<UniversalLeagueLeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late LeagueClassModel _currentClass;
  bool _isLoading = false;

  List<LeagueBattleModel> _pendingReceivedBattles = [];
  List<LeagueBattleModel> _completedBattles = [];
  List<LeagueBattleModel> _pendingSentBattles = [];

  late AnimationController _trophyAnimController;
  late Animation<double> _trophyScaleAnim;

  @override
  void initState() {
    super.initState();
    _currentClass = widget.quranClass;

    _trophyAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _trophyScaleAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _trophyAnimController,
        curve: Curves.easeInOut,
      ),
    );

    _refreshAllData();
  }

  @override
  void dispose() {
    _trophyAnimController.dispose();
    super.dispose();
  }

  Future<void> _refreshAllData() async {
    setState(() => _isLoading = true);

    final updatedClass = await UniversalLeagueManager.syncClassStudents(
      config: widget.config,
      classCode: _currentClass.classCode,
    );

    final myPhone = AuthManager.phoneNumber.trim();
    final myName = AuthManager.userName.trim();
    final myId = myPhone.isNotEmpty ? myPhone : myName;

    final pendingReceived =
        await UniversalBattleManager.getPendingBattlesForStudent(
      subjectId: widget.config.subjectId,
      classCode: _currentClass.classCode,
      studentId: myId,
      studentName: myName,
      phoneNumber: myPhone,
    );

    final completed =
        await UniversalBattleManager.getCompletedBattlesForStudent(
      subjectId: widget.config.subjectId,
      classCode: _currentClass.classCode,
      studentId: myId,
      studentName: myName,
      phoneNumber: myPhone,
    );

    final pendingSent =
        await UniversalBattleManager.getPendingSentBattlesByStudent(
      subjectId: widget.config.subjectId,
      classCode: _currentClass.classCode,
      studentId: myId,
      studentName: myName,
      phoneNumber: myPhone,
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (updatedClass != null) {
        _currentClass = updatedClass;
      }
      _pendingReceivedBattles = pendingReceived;
      _completedBattles = completed;
      _pendingSentBattles = pendingSent;
    });
  }

  void _openBattleSplitScreen(LeagueBattleModel battle, bool isChallenger) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UniversalBattleSplitScreen(
          config: widget.config,
          battle: battle,
          isChallenger: isChallenger,
        ),
      ),
    ).then((_) => _refreshAllData());
  }

  // دیالوگ شروع چالش دونفره با یک دانش‌آموز دیگر
  void _showChallengeSelectLessonModal(LeagueStudentModel targetOpponent) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              border: Border(
                top: BorderSide(color: Color(0xFF1E293B), width: 1.5),
              ),
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
                  children: [
                    const Text('⚔️', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'چالش رقابت دونفره با ${targetOpponent.name}',
                            style: const TextStyle(
                              fontFamily: 'Tahoma',
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'درس و بازی مورد نظر خود از ${widget.config.subjectTitle} را انتخاب کنید:',
                            style: const TextStyle(
                              fontFamily: 'Tahoma',
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: Color(0xFF1E293B)),
                const SizedBox(height: 8),

                // لیست دروس و پارت‌های موجود در کانفیگ
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.config.lessons.length,
                    itemBuilder: (context, lIdx) {
                      final lesson = widget.config.lessons[lIdx];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131D2E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: ExpansionTile(
                          shape: const Border(),
                          collapsedShape: const Border(),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: widget.config.primaryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              toPersianDigits(lesson.lessonNumber),
                              style: TextStyle(
                                fontFamily: 'Tahoma',
                                color: widget.config.accentColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            lesson.title,
                            style: const TextStyle(
                              fontFamily: 'Tahoma',
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: lesson.parts.asMap().entries.map((pEntry) {
                            final pIdx = pEntry.key;
                            final part = pEntry.value;
                            return ListTile(
                              leading: Text(part.emoji,
                                  style: const TextStyle(fontSize: 18)),
                              title: Text(
                                part.title,
                                style: const TextStyle(
                                  fontFamily: 'Tahoma',
                                  color: Color(0xFFE2E8F0),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  _startBattleAsChallenger(
                                    targetOpponent: targetOpponent,
                                    lessonIndex: lIdx,
                                    partIndex: pIdx,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: widget.config.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                ),
                                child: const Text(
                                  'شروع 🚀',
                                  style: TextStyle(
                                    fontFamily: 'Tahoma',
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
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

  // اجرای بازی ۱ دقیقه‌ای به عنوان چالش‌گر و ثبت در دیتابیس
  void _startBattleAsChallenger({
    required LeagueStudentModel targetOpponent,
    required int lessonIndex,
    required int partIndex,
  }) {
    final myPhone = AuthManager.phoneNumber.trim();
    final myName = AuthManager.userName.trim().isNotEmpty
        ? AuthManager.userName.trim()
        : 'دانش‌آموز';
    final myId = myPhone.isNotEmpty ? myPhone : myName;

    if (widget.config.buildBattleGameScreen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('بازی رقابت برای این درس به‌زودی اضافه می‌شود.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final gameScreen = widget.config.buildBattleGameScreen!(
      context: context,
      lessonIndex: lessonIndex,
      partIndex: partIndex,
      battleKey: '${widget.config.subjectId}_l${lessonIndex + 1}_p${partIndex + 1}_battle',
      challengerName: myName,
      challengerAvatar: AuthManager.userAvatar,
      opponentName: targetOpponent.name,
      opponentAvatar: targetOpponent.avatar,
      challengerScore: 0,
      onGameFinished: (int score, int remainingSeconds) async {
        Navigator.pop(context);
        final battle = await UniversalBattleManager.createBattle(
          subjectId: widget.config.subjectId,
          classCode: _currentClass.classCode,
          lessonIndex: lessonIndex,
          partIndex: partIndex,
          challengerId: myId,
          challengerName: myName,
          challengerAvatar: AuthManager.userAvatar,
          challengerPhone: myPhone,
          challengerScore: score,
          challengerRemainingSeconds: remainingSeconds,
          opponentId: targetOpponent.id,
          opponentName: targetOpponent.name,
          opponentAvatar: targetOpponent.avatar,
          opponentPhone: targetOpponent.phoneNumber,
        );

        _openBattleSplitScreen(battle, true);
      },
    );

    Navigator.push(context, MaterialPageRoute(builder: (_) => gameScreen));
  }

  // پاسخ به دعوت نبرد به عنوان حریف
  void _respondToBattleAsOpponent(LeagueBattleModel battle) {
    if (widget.config.buildBattleGameScreen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('بازی رقابت برای این درس به‌زودی اضافه می‌شود.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final gameScreen = widget.config.buildBattleGameScreen!(
      context: context,
      lessonIndex: battle.lessonIndex,
      partIndex: battle.partIndex,
      battleKey: '${widget.config.subjectId}_l${battle.lessonIndex + 1}_p${battle.partIndex + 1}_battle',
      challengerName: battle.challengerName,
      challengerAvatar: battle.challengerAvatar,
      opponentName: battle.opponentName,
      opponentAvatar: battle.opponentAvatar,
      challengerScore: battle.challengerScore,
      onGameFinished: (int score, int remainingSeconds) async {
        Navigator.pop(context);
        final updated = await UniversalBattleManager.submitOpponentResult(
          subjectId: widget.config.subjectId,
          battleId: battle.id,
          opponentScore: score,
          opponentRemainingSeconds: remainingSeconds,
        );
        if (updated != null) {
          _openBattleSplitScreen(updated, false);
        }
      },
    );

    Navigator.push(context, MaterialPageRoute(builder: (_) => gameScreen));
  }

  @override
  Widget build(BuildContext context) {
    final sortedStudents = List<LeagueStudentModel>.from(_currentClass.students)
      ..sort((a, b) => b.coins.compareTo(a.coins));

    final myPhone = AuthManager.phoneNumber.trim();
    final myName = AuthManager.userName.trim();

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
          ),
          title: Text(
            'باشگاه قهرمانان • ${widget.config.leagueTitle}',
            style: const TextStyle(
              fontFamily: 'Tahoma',
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            IconButton(
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.refresh_rounded,
                      color: Colors.white, size: 22),
              onPressed: _isLoading ? null : _refreshAllData,
            ),
          ],
        ),
        body: RefreshIndicator(
          color: widget.config.primaryColor,
          backgroundColor: const Color(0xFF1E293B),
          onRefresh: _refreshAllData,
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // هدر کاپ قهرمانی
              _buildTrophyHeaderCard(),

              const SizedBox(height: 16),

              // بخش نبردهای فعال (پاسخ به رقابت، نتیجه رقابت، در انتظار حریف)
              if (_pendingReceivedBattles.isNotEmpty ||
                  _completedBattles.isNotEmpty ||
                  _pendingSentBattles.isNotEmpty) ...[
                _buildActiveBattlesSection(),
                const SizedBox(height: 20),
              ],

              // عنوان رتبه‌بندی دانش‌آموزان
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'رتبه‌بندی دانش‌آموزان کلاس',
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
                      '${toPersianDigits(sortedStudents.length)} قهرمان',
                      style: TextStyle(
                        fontFamily: 'Tahoma',
                        color: widget.config.accentColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // لیست دانش‌آموزان
              if (sortedStudents.isEmpty)
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131D2E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: const Center(
                    child: Text(
                      'هنوز دانش‌آموزی در این کلاس حضور ندارد.',
                      style: TextStyle(
                        fontFamily: 'Tahoma',
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              else
                ...sortedStudents.asMap().entries.map((entry) {
                  final rank = entry.key + 1;
                  final s = entry.value;
                  final bool isMe =
                      (myPhone.isNotEmpty && s.id == myPhone) ||
                      (s.name == myName);

                  return _buildStudentCard(
                    student: s,
                    rank: rank,
                    isMe: isMe,
                    onChallengeTap: (widget.isTeacher || isMe)
                        ? null
                        : () => _showChallengeSelectLessonModal(s),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrophyHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.config.gradientColors,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: widget.config.primaryColor.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ScaleTransition(
            scale: _trophyScaleAnim,
            child: const Text('🏆', style: TextStyle(fontSize: 48)),
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
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'کد ورود کلاس: ${toPersianDigits(_currentClass.classCode)}',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    color: widget.config.accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
        const Text(
          'رقابت‌ها و چالش‌های فعال',
          style: TextStyle(
            fontFamily: 'Tahoma',
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),

        // ۱. درخواست‌های رقابت که برای من آمده (پاسخ به رقابت)
        ..._pendingReceivedBattles.map((b) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.config.primaryColor),
            ),
            child: Row(
              children: [
                const Text('⚔️', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'درخواست رقابت از طرف ${b.challengerName}',
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'درس ${toPersianDigits(b.lessonIndex + 1)} • پارت ${toPersianDigits(b.partIndex + 1)}',
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          color: widget.config.accentColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _respondToBattleAsOpponent(b),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.config.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                  ),
                  child: const Text('پاسخ به رقابت 🎮',
                      style: TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 11,
                          color: Colors.white)),
                ),
              ],
            ),
          );
        }),

        // ۲. رقابت‌های پایان‌یافته (مشاهده نتیجه رقابت)
        ..._completedBattles.map((b) {
          final myPhone = AuthManager.phoneNumber.trim();
          final myName = AuthManager.userName.trim();
          final isChallenger =
              (myPhone.isNotEmpty && b.challengerId == myPhone) ||
              b.challengerName == myName;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF131D2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نتیجه رقابت با ${isChallenger ? b.opponentName : b.challengerName}',
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'درس ${toPersianDigits(b.lessonIndex + 1)} • پارت ${toPersianDigits(b.partIndex + 1)}',
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          color: Color(0xFF94A3B8),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _openBattleSplitScreen(b, isChallenger),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: widget.config.accentColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                  ),
                  child: Text('مشاهده نتیجه 📊',
                      style: TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 11,
                          color: widget.config.accentColor)),
                ),
              ],
            ),
          );
        }),

        // ۳. درخواست‌های ارسالی من که منتظر پاسخ حریف هستند
        ..._pendingSentBattles.map((b) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF131D2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                const Text('⏳', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'درخواست شما برای ${b.opponentName} ارسال شد (در انتظار حریف)',
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFFCBD5E1),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStudentCard({
    required LeagueStudentModel student,
    required int rank,
    required bool isMe,
    VoidCallback? onChallengeTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isMe
            ? widget.config.primaryColor.withOpacity(0.12)
            : const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe
              ? widget.config.primaryColor
              : const Color(0xFF1E293B),
        ),
      ),
      child: Row(
        children: [
          // نشان رتبه (مدال برای ۳ نفر اول یا شماره)
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

          // نام دانش‌آموز
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(شما)',
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          color: widget.config.accentColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  'سطح ${toPersianDigits(student.level)}',
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    color: Color(0xFF64748B),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // سکه / XP
          Text(
            '${toPersianDigits(student.coins)} XP',
            style: TextStyle(
              fontFamily: 'Tahoma',
              color: widget.config.accentColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          // دکمه درخواست چالش رقابت
          if (onChallengeTap != null) ...[
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onChallengeTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: widget.config.accentColor,
                side: BorderSide(color: widget.config.primaryColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
              child: const Text('رقابت ⚔️',
                  style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    if (rank == 1) {
      return const Text('🥇', style: TextStyle(fontSize: 22));
    } else if (rank == 2) {
      return const Text('🥈', style: TextStyle(fontSize: 22));
    } else if (rank == 3) {
      return const Text('🥉', style: TextStyle(fontSize: 22));
    }
    return SizedBox(
      width: 24,
      child: Center(
        child: Text(
          toPersianDigits(rank),
          style: const TextStyle(
            fontFamily: 'Tahoma',
            color: Color(0xFF94A3B8),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
