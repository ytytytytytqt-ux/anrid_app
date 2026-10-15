import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../managers/auth_manager.dart';
import 'quran7_battle_manager.dart';

class Quran7BattleSplitScreen extends StatefulWidget {
  final Quran7BattleModel battle;
  final VoidCallback? onBackToLeaderboard;

  const Quran7BattleSplitScreen({
    super.key,
    required this.battle,
    this.onBackToLeaderboard,
  });

  @override
  State<Quran7BattleSplitScreen> createState() => _Quran7BattleSplitScreenState();
}

class _Quran7BattleSplitScreenState extends State<Quran7BattleSplitScreen>
    with SingleTickerProviderStateMixin {
  late Quran7BattleModel _currentBattle;
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _currentBattle = widget.battle;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _refreshBattle();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _refreshBattle() async {
    final fresh = await Quran7BattleManager.getBattleById(_currentBattle.id);
    if (fresh != null && mounted) {
      setState(() {
        _currentBattle = fresh;
      });
    }
  }

  bool _isCurrentUser(String studentId, String studentName) {
    if (AuthManager.phoneNumber.trim().isNotEmpty &&
        studentId == AuthManager.phoneNumber.trim()) {
      return true;
    }
    if (AuthManager.userName.trim().isNotEmpty &&
        studentName == AuthManager.userName.trim()) {
      return true;
    }
    return false;
  }

  String _toPersianDigits(dynamic input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    String result = input.toString();
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], persian[i]);
    }
    return result;
  }

  Future<void> _handleClaimReward() async {
    setState(() => _isLoading = true);
    HapticFeedback.heavyImpact();

    final success = await Quran7BattleManager.claimWinnerReward(
      battleId: _currentBattle.id,
      studentId: AuthManager.phoneNumber.trim().isNotEmpty
          ? AuthManager.phoneNumber.trim()
          : AuthManager.userName.trim(),
      studentName: AuthManager.userName.trim(),
    );

    await _refreshBattle();
    setState(() => _isLoading = false);
    widget.onBackToLeaderboard?.call();

    if (mounted) {
      if (success) {
        showDialog(
          context: context,
          builder: (ctx) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: const Color(0xFF131D2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: Color(0xFF10B981), width: 2),
              ),
              title: const Row(
                children: [
                  Text('🎁', style: TextStyle(fontSize: 28)),
                  SizedBox(width: 10),
                  Text(
                    'تبریک قهرمان!',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              content: const Text(
                '۱۰۰ سکه به حساب شما اضافه شد و رتبه شما در جدول باشگاه قهرمانان ۱ پله صعود کرد! 🚀✨',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Color(0xFFE2E8F0),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'عالیه!',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'جایزه قبلاً دریافت شده است یا خطایی رخ داد.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Tahoma'),
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _handleAcknowledgeDefeat() async {
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    await Quran7BattleManager.acknowledgeLoserDefeat(
      battleId: _currentBattle.id,
      studentId: AuthManager.phoneNumber.trim().isNotEmpty
          ? AuthManager.phoneNumber.trim()
          : AuthManager.userName.trim(),
      studentName: AuthManager.userName.trim(),
    );

    await _refreshBattle();
    setState(() => _isLoading = false);

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF131D2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
            title: const Row(
              children: [
                Text('🛡️', style: TextStyle(fontSize: 26)),
                SizedBox(width: 10),
                Text(
                  'اعلام شکست',
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
              'شکست شما در این رقابت با شجاعت اعلام شد. برای مسابقات بعدی تمرین کن و قوی‌تر برگرد! 💪',
              style: TextStyle(
                fontFamily: 'Tahoma',
                color: Color(0xFFCBD5E1),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('متوجه شدم',
                    style: TextStyle(fontFamily: 'Tahoma', color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _handleDeleteBattleAndReset() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF131D2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
          ),
          title: const Row(
            children: [
              Text('🗑️', style: TextStyle(fontSize: 24)),
              SizedBox(width: 10),
              Text(
                'حذف صفحه رقابت',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: const Text(
            'با حذف این صفحه رقابت، وضعیت جدول فقط برای شما به حالت عادی بازمی‌گردد و دکمه «درخواست رقابت» برای شما مجدداً فعال می‌شود.\nآیا مطمئن هستید؟',
            style: TextStyle(
              fontFamily: 'Tahoma',
              color: Color(0xFFCBD5E1),
              fontSize: 12,
              height: 1.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('انصراف',
                  style: TextStyle(fontFamily: 'Tahoma', color: Colors.white60)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                'بله، حذف و بازگشت',
                style: TextStyle(
                  fontFamily: 'Tahoma',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    final myId = AuthManager.phoneNumber.trim().isNotEmpty
        ? AuthManager.phoneNumber.trim()
        : AuthManager.userName.trim();
    final myName = AuthManager.userName.trim();
    final myPhone = AuthManager.phoneNumber.trim();

    await Quran7BattleManager.dismissBattleForUser(
      battleId: _currentBattle.id,
      studentId: myId,
      studentName: myName,
      phoneNumber: myPhone.isNotEmpty ? myPhone : null,
    );

    widget.onBackToLeaderboard?.call();

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'صفحه رقابت برای شما حذف شد و وضعیت به حالت عادی بازگشت. ✨',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Tahoma'),
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUserChallenger = _isCurrentUser(
      _currentBattle.challengerId,
      _currentBattle.challengerName,
    );
    final String currentUserId = AuthManager.phoneNumber.trim().isNotEmpty
        ? AuthManager.phoneNumber.trim()
        : AuthManager.userName.trim();
    final String currentUserName = AuthManager.userName.trim();

    final bool isCompleted = _currentBattle.status == 'completed';
    final winnerType = _currentBattle.winnerType;
    final bool amIWinner = _currentBattle.isWinner(currentUserId, currentUserName);
    final bool amILoser = _currentBattle.isLoser(currentUserId, currentUserName);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0F1D),
        appBar: AppBar(
          backgroundColor: const Color(0xFF131D2E),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
            onPressed: () {
              widget.onBackToLeaderboard?.call();
              Navigator.pop(context);
            },
          ),
          title: const Text(
            '⚔️ نتیجه رقابت دونفره',
            style: TextStyle(
              fontFamily: 'Tahoma',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // نوار مشخصات درس و بخش
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Text('📖', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentBattle.lessonTitle,
                            style: const TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _currentBattle.partTitle,
                            style: const TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 11,
                              color: Color(0xFF38BDF8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0xFF10B981).withOpacity(0.2)
                            : const Color(0xFFF59E0B).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCompleted
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                      child: Text(
                        isCompleted ? 'پایان رقابت 🏁' : 'در حال رقابت ⏳',
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: isCompleted
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // بخش نصف نصف / دو طرف رقابت
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // کادرهای مقایسه رو در رو
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // طرف راست: کاربر
                          Expanded(
                            child: _buildPlayerCard(
                              title: isUserChallenger
                                  ? _currentBattle.challengerName
                                  : _currentBattle.opponentName,
                              avatar: isUserChallenger
                                  ? _currentBattle.challengerAvatar
                                  : _currentBattle.opponentAvatar,
                              isCurrentUser: true,
                              coins: isUserChallenger
                                  ? _currentBattle.challengerCoins
                                  : _currentBattle.opponentCoins,
                              timeSeconds: isUserChallenger
                                  ? _currentBattle.challengerTimeSeconds
                                  : _currentBattle.opponentTimeSeconds,
                              isFinished: isUserChallenger
                                  ? _currentBattle.challengerFinished
                                  : _currentBattle.opponentFinished,
                              isWinner: isCompleted &&
                                  (isUserChallenger
                                      ? (winnerType == BattleWinnerType.challenger ||
                                          winnerType == BattleWinnerType.tie)
                                      : (winnerType == BattleWinnerType.opponent ||
                                          winnerType == BattleWinnerType.tie)),
                              isLoser: isCompleted &&
                                  (isUserChallenger
                                      ? (winnerType == BattleWinnerType.opponent)
                                      : (winnerType == BattleWinnerType.challenger)),
                            ),
                          ),

                          // نشان VS در وسط
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 60),
                            child: ScaleTransition(
                              scale: _pulseAnimation,
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFEF4444),
                                      Color(0xFF8B5CF6)
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFEF4444)
                                          .withOpacity(0.5),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'VS',
                                    style: TextStyle(
                                      fontFamily: 'Tahoma',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // طرف چپ: حریف
                          Expanded(
                            child: _buildPlayerCard(
                              title: isUserChallenger
                                  ? _currentBattle.opponentName
                                  : _currentBattle.challengerName,
                              avatar: isUserChallenger
                                  ? _currentBattle.opponentAvatar
                                  : _currentBattle.challengerAvatar,
                              isCurrentUser: false,
                              coins: isUserChallenger
                                  ? _currentBattle.opponentCoins
                                  : _currentBattle.challengerCoins,
                              timeSeconds: isUserChallenger
                                  ? _currentBattle.opponentTimeSeconds
                                  : _currentBattle.challengerTimeSeconds,
                              isFinished: isUserChallenger
                                  ? _currentBattle.opponentFinished
                                  : _currentBattle.challengerFinished,
                              isWinner: isCompleted &&
                                  (!isUserChallenger
                                      ? (winnerType == BattleWinnerType.challenger ||
                                          winnerType == BattleWinnerType.tie)
                                      : (winnerType == BattleWinnerType.opponent ||
                                          winnerType == BattleWinnerType.tie)),
                              isLoser: isCompleted &&
                                  (!isUserChallenger
                                      ? (winnerType == BattleWinnerType.opponent)
                                      : (winnerType == BattleWinnerType.challenger)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // کارت خلاصه وضعیت و نتیجه نهایی
                      _buildSummaryBanner(
                        isCompleted: isCompleted,
                        amIWinner: amIWinner,
                        amILoser: amILoser,
                        winnerType: winnerType,
                      ),

                      const SizedBox(height: 24),

                      // دکمه‌های اقدام
                      if (isCompleted) ...[
                        if (amIWinner) ...[
                          _buildWinnerClaimButton(),
                          const SizedBox(height: 12),
                        ],
                        if (amILoser) ...[
                          _buildLoserDefeatButton(),
                          const SizedBox(height: 12),
                        ],
                        _buildResetToNormalButton(),
                        const SizedBox(height: 12),
                      ],

                      // دکمه بازگشت به جدول لیگ
                      _buildReturnButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCard({
    required String title,
    required String? avatar,
    required bool isCurrentUser,
    required int coins,
    required int timeSeconds,
    required bool isFinished,
    required bool isWinner,
    required bool isLoser,
  }) {
    Color borderColor = const Color(0xFF1E293B);
    Color glowColor = Colors.transparent;

    if (isWinner) {
      borderColor = const Color(0xFF10B981);
      glowColor = const Color(0xFF10B981).withOpacity(0.3);
    } else if (isLoser) {
      borderColor = const Color(0xFFEF4444);
      glowColor = const Color(0xFFEF4444).withOpacity(0.2);
    } else if (isCurrentUser) {
      borderColor = const Color(0xFF00E5FF);
      glowColor = const Color(0xFF00E5FF).withOpacity(0.2);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          if (glowColor != Colors.transparent)
            BoxShadow(
              color: glowColor,
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          // برچسب هویت
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? const Color(0xFF00E5FF).withOpacity(0.18)
                  : const Color(0xFF64748B).withOpacity(0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isCurrentUser ? 'شما' : 'حریف',
              style: TextStyle(
                fontFamily: 'Tahoma',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isCurrentUser
                    ? const Color(0xFF00E5FF)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // آواتار دایره‌ای
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E293B),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Center(
                  child: (avatar != null && avatar.isNotEmpty)
                      ? ClipOval(
                          child: Image.asset(
                            avatar,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                ),
              ),
              if (isWinner)
                const Positioned(
                  top: -12,
                  right: -4,
                  child: Text('👑', style: TextStyle(fontSize: 22)),
                ),
              if (isLoser)
                const Positioned(
                  top: -10,
                  right: -4,
                  child: Text('💔', style: TextStyle(fontSize: 18)),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // نام
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Tahoma',
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),

          // آمار مسابقه
          if (!isFinished) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: const Column(
                children: [
                  Text('⏳', style: TextStyle(fontSize: 22)),
                  SizedBox(height: 6),
                  Text(
                    'در انتظار بازی...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 10,
                      color: Color(0xFFF59E0B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // سکه‌های به دست آمده
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFB703).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    'سکه‌های کسب‌شده',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 9,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 15)),
                      const SizedBox(width: 4),
                      Text(
                        _toPersianDigits(coins),
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFFB703),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // زمان صرف‌شده
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    'زمان سپری‌شده',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 9,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 15, color: Color(0xFF00E5FF)),
                      const SizedBox(width: 4),
                      Text(
                        '${_toPersianDigits(timeSeconds)} ثانیه',
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF00E5FF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryBanner({
    required bool isCompleted,
    required bool amIWinner,
    required bool amILoser,
    required BattleWinnerType winnerType,
  }) {
    if (!isCompleted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.5)),
        ),
        child: const Column(
          children: [
            Text('⏳', style: TextStyle(fontSize: 28)),
            SizedBox(height: 8),
            Text(
              'اطلاعات شما با موفقیت ثبت شد!',
              style: TextStyle(
                fontFamily: 'Tahoma',
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'به محض اینکه حریف وارد لیگ شود و این مسابقه ۱ دقیقه‌ای را انجام دهد، برنده نهایی مشخص خواهد شد.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tahoma',
                fontSize: 11,
                color: Color(0xFF94A3B8),
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    // هر دو بازی کردند
    String headline = '';
    String subline = '';
    Color glowColor = Colors.transparent;

    if (winnerType == BattleWinnerType.tie) {
      headline = '🤝 رقابت مساوی شد! هر دو برنده هستید!';
      subline = 'سکه و زمان هر دو دقیقاً برابر شد. هر دو بازیکن جایزه می‌گیرند!';
      glowColor = const Color(0xFF10B981);
    } else if (amIWinner) {
      headline = '🎉 پیروزی شکوهمند! شما برنده شدید!';
      if (_currentBattle.challengerCoins != _currentBattle.opponentCoins) {
        headline += ' 🏆';
        subline = 'به دلیل کسب سکه بیشتر در مسابقه، پیروز شدید!';
      } else {
        headline += ' ⚡';
        subline = 'سکه‌ها برابر بود، اما شما بازی را در زمان کمتری تمام کردید!';
      }
      glowColor = const Color(0xFF10B981);
    } else {
      headline = '💔 شکست در رقابت';
      subline = 'حریف شما در این دور عملکرد بهتری داشت. برای رقابت بعدی آماده شو!';
      glowColor = const Color(0xFFEF4444);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: glowColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: glowColor, width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            headline,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tahoma',
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: amIWinner || winnerType == BattleWinnerType.tie
                  ? const Color(0xFF34D399)
                  : const Color(0xFFF87171),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subline,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Tahoma',
              fontSize: 11,
              color: Color(0xFFE2E8F0),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerClaimButton() {
    final String currentUserId = AuthManager.phoneNumber.trim().isNotEmpty
        ? AuthManager.phoneNumber.trim()
        : AuthManager.userName.trim();
    final String currentUserName = AuthManager.userName.trim();
    final bool claimed =
        _currentBattle.isWinnerClaimedBy(currentUserId, currentUserName);

    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: claimed
            ? LinearGradient(
                colors: [Colors.grey.shade700, Colors.grey.shade800],
              )
            : const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
        boxShadow: claimed
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: (claimed || _isLoading) ? null : _handleClaimReward,
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        claimed ? '✅' : '🎁',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          claimed
                              ? 'جایزه (۱۰۰ سکه و ارتقای ۱ رتبه) دریافت شد'
                              : 'دریافت 100 سکه جایزه و بالا رفتن 1 رتبه در لیست باشگاه قهرمانان',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Tahoma',
                            fontSize: 11,
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

  Widget _buildLoserDefeatButton() {
    final bool acknowledged = _currentBattle.loserAcknowledged;

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: acknowledged
            ? LinearGradient(
                colors: [Colors.grey.shade800, Colors.grey.shade900],
              )
            : const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
              ),
        boxShadow: acknowledged
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFFEF4444).withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: (acknowledged || _isLoading) ? null : _handleAcknowledgeDefeat,
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('❌', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        acknowledged
                            ? 'شکست نسبت به طرف مقابل اعلام شد'
                            : 'اعلام شکست و باخت نسبت به طرف مقابل',
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetToNormalButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFF991B1B)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: _isLoading ? null : _handleDeleteBattleAndReset,
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_sweep_rounded,
                          color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'حذف صفحه رقابت و بازگشت به حالت عادی',
                        style: TextStyle(
                          fontFamily: 'Tahoma',
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildReturnButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            widget.onBackToLeaderboard?.call();
            Navigator.pop(context);
          },
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_forward_rounded,
                    size: 16, color: Color(0xFF94A3B8)),
                SizedBox(width: 8),
                Text(
                  'بازگشت به باشگاه قهرمانان',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
