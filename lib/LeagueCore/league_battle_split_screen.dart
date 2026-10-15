import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../managers/auth_manager.dart';
import 'league_models.dart';
import 'league_config.dart';
import 'league_battle_manager.dart';

class UniversalBattleSplitScreen extends StatefulWidget {
  final LeagueSubjectConfig config;
  final LeagueBattleModel battle;
  final bool isChallenger;

  const UniversalBattleSplitScreen({
    super.key,
    required this.config,
    required this.battle,
    required this.isChallenger,
  });

  @override
  State<UniversalBattleSplitScreen> createState() =>
      _UniversalBattleSplitScreenState();
}

class _UniversalBattleSplitScreenState extends State<UniversalBattleSplitScreen>
    with SingleTickerProviderStateMixin {
  late LeagueBattleModel _battle;
  bool _isClaimingReward = false;
  bool _isDismissing = false;
  late AnimationController _badgeAnimController;
  late Animation<double> _badgeScaleAnim;

  @override
  void initState() {
    super.initState();
    _battle = widget.battle;

    _badgeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _badgeScaleAnim = Tween<double>(begin: 0.94, end: 1.06).animate(
      CurvedAnimation(
        parent: _badgeAnimController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _badgeAnimController.dispose();
    super.dispose();
  }

  Future<void> _handleClaimReward() async {
    if (_isClaimingReward) return;
    setState(() => _isClaimingReward = true);

    final success = await UniversalBattleManager.claimWinnerReward(
      subjectId: widget.config.subjectId,
      battleId: _battle.id,
      isChallenger: widget.isChallenger,
    );

    if (!mounted) return;
    setState(() => _isClaimingReward = false);

    if (success) {
      HapticFeedback.heavyImpact();
      setState(() {
        _battle = widget.isChallenger
            ? _battle.copyWith(challengerClaimed: true, winnerClaimed: true)
            : _battle.copyWith(opponentClaimed: true, winnerClaimed: true);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Text('🎉', style: TextStyle(fontSize: 22)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'تبریک! ۱۰۰ سکه طلا جایزه برنده به حساب شما افزوده شد و ۱ رتبه در جدول ارتقا یافتید!',
                    style: TextStyle(
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
          backgroundColor: widget.config.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _handleDismissBattle() async {
    if (_isDismissing) return;
    setState(() => _isDismissing = true);

    final currentId = AuthManager.phoneNumber.trim().isNotEmpty
        ? AuthManager.phoneNumber.trim()
        : AuthManager.userName.trim();

    await UniversalBattleManager.dismissBattleForStudent(
      subjectId: widget.config.subjectId,
      battleId: _battle.id,
      studentId: currentId,
      studentName: AuthManager.userName.trim(),
      phoneNumber: AuthManager.phoneNumber.trim(),
    );

    if (!mounted) return;
    HapticFeedback.lightImpact();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = _battle.status == LeagueBattleStatus.completed;
    final bool iWon = isCompleted && _battle.isCurrentUserWinner(widget.isChallenger);
    final bool isDraw = isCompleted && _battle.isDraw();
    final bool iClaimed =
        widget.isChallenger ? _battle.challengerClaimed : _battle.opponentClaimed;

    String lessonLabel = 'درس ${toPersianDigits(_battle.lessonIndex + 1)}';
    String partLabel = 'پارت ${toPersianDigits(_battle.partIndex + 1)}';
    if (_battle.lessonIndex < widget.config.lessons.length) {
      final l = widget.config.lessons[_battle.lessonIndex];
      lessonLabel = l.title;
      if (_battle.partIndex < l.parts.length) {
        partLabel = l.parts[_battle.partIndex].title;
      }
    }

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
            'نتیجه رقابت دونفره • $lessonLabel',
            style: const TextStyle(
              fontFamily: 'Tahoma',
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // نوار مشخصات چالش
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color(0xFF131D2E),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.config.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      '$lessonLabel  •  $partLabel',
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

              // بنر وضعیت برنده / بازنده / مساوی
              if (isCompleted)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDraw
                          ? [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)]
                          : iWon
                              ? [widget.config.darkColor, widget.config.primaryColor]
                              : [const Color(0xFF7F1D1D), const Color(0xFFDC2626)],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isDraw
                            ? '🤝 رقابت برابر و مساوی شد!'
                            : iWon
                                ? '🏆 پیروزی درخشان! شما برنده شدید'
                                : '🥈 تجربه ارزشمند! حریف شما پیروز شد',
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

              // بخش دونیمه بازیکنان و مقایسه
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        // نیمه اول: بازیکن ۱ (چالش‌گر)
                        Expanded(
                          child: _buildPlayerHalf(
                            name: _battle.challengerName,
                            avatar: _battle.challengerAvatar,
                            score: _battle.challengerScore,
                            remainingSeconds: _battle.challengerRemainingSeconds,
                            isMe: widget.isChallenger,
                            isWinner: isCompleted && _battle.isCurrentUserWinner(true),
                            roleLabel: 'درخواست‌کننده رقابت 🚀',
                          ),
                        ),
                        // نیمه دوم: بازیکن ۲ (حریف دعوت‌شده)
                        Expanded(
                          child: _buildPlayerHalf(
                            name: _battle.opponentName,
                            avatar: _battle.opponentAvatar,
                            score: _battle.opponentScore,
                            remainingSeconds: _battle.opponentRemainingSeconds,
                            isMe: !widget.isChallenger,
                            isWinner: isCompleted && _battle.isCurrentUserWinner(false),
                            roleLabel: 'حریف دعوت‌شده 🎯',
                          ),
                        ),
                      ],
                    ),

                    // نشانگر متحرک VS در میانه
                    ScaleTransition(
                      scale: _badgeScaleAnim,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: widget.config.gradientColors,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: widget.config.primaryColor.withOpacity(0.4),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Text(
                          'VS',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // دکمه‌های عملیاتی پایین صفحه
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF131D2E),
                  border: Border(top: BorderSide(color: Color(0xFF1E293B))),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // دکمه دریافت جایزه ۱۰۰ سکه
                    if (isCompleted && (iWon || isDraw)) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: iClaimed ? null : _handleClaimReward,
                          icon: Text(iClaimed ? '✓' : '🎁',
                              style: const TextStyle(fontSize: 18)),
                          label: Text(
                            iClaimed
                                ? 'جایزه ۱۰۰ سکه دریافت شد'
                                : 'دریافت ۱۰۰ سکه و ارتقای رتبه 🏆',
                            style: const TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: iClaimed
                                ? const Color(0xFF334155)
                                : widget.config.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // دکمه حذف صفحه رقابت و بازگشت به حالت عادی (مختص همین کاربر)
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: _isDismissing ? null : _handleDismissBattle,
                        icon: const Icon(Icons.delete_sweep_rounded,
                            size: 18, color: Color(0xFF94A3B8)),
                        label: const Text(
                          'حذف صفحه رقابت و بازگشت به حالت عادی',
                          style: TextStyle(
                            fontFamily: 'Tahoma',
                            color: Color(0xFFCBD5E1),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF334155)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerHalf({
    required String name,
    required String? avatar,
    required int? score,
    required int? remainingSeconds,
    required bool isMe,
    required bool isWinner,
    required String roleLabel,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isMe
            ? widget.config.primaryColor.withOpacity(0.08)
            : const Color(0xFF131D2E),
        border: Border.all(
          color: isWinner
              ? widget.config.accentColor.withOpacity(0.5)
              : const Color(0xFF1E293B),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E293B),
                  border: Border.all(
                    color: isWinner
                        ? const Color(0xFFFBBF24)
                        : widget.config.primaryColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: (avatar != null && avatar.isNotEmpty)
                      ? ClipOval(
                          child: Image.asset(
                            avatar,
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person_rounded,
                                    color: Color(0xFF94A3B8), size: 28),
                          ),
                        )
                      : const Icon(Icons.person_rounded,
                          color: Color(0xFF94A3B8), size: 28),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Tahoma',
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: widget.config.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'شما',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              color: widget.config.accentColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    roleLabel,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (score != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildScoreBadge('امتیاز', '${toPersianDigits(score)} XP',
                    const Color(0xFF38BDF8)),
                const SizedBox(width: 24),
                _buildScoreBadge(
                    'زمان باقی‌مانده',
                    '${toPersianDigits(remainingSeconds ?? 0)} ثانیه',
                    const Color(0xFFFBBF24)),
              ],
            )
          else
            const Text(
              '⏳ در انتظار انجام چالش توسط حریف...',
              style: TextStyle(
                fontFamily: 'Tahoma',
                color: Color(0xFFFBBF24),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScoreBadge(String title, String val, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Tahoma',
            color: Color(0xFF94A3B8),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          val,
          style: TextStyle(
            fontFamily: 'Tahoma',
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
