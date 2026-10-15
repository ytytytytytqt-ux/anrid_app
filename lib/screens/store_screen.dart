import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../managers/auth_manager.dart';

class StoreScreen extends StatefulWidget {
  final VoidCallback? onStoreUpdated;

  const StoreScreen({super.key, this.onStoreUpdated});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // آواتارهای فروشگاه (10 تا 17)
  final List<Map<String, dynamic>> _storeAvatars = [
    {'path': 'image/avatar/10.webp', 'price': 1},
    {'path': 'image/avatar/11.webp', 'price': 1},
    {'path': 'image/avatar/12.webp', 'price': 1},
    {'path': 'image/avatar/13.webp', 'price': 1},
    {'path': 'image/avatar/14.webp', 'price': 1},
    {'path': 'image/avatar/15.webp', 'price': 1},
    {'path': 'image/avatar/16.webp', 'price': 1},
    {'path': 'image/avatar/17.webp', 'price': 1},
  ];

  // ۵ تم رنگی جذاب (سرمه‌ای تیره پیش‌فرض، صورتی ایرانی، آبی استقلالی، قرمز پرسپولیسی، بنفش درخشان)
  final List<Map<String, dynamic>> _storeThemes = [
    {
      'id': 'royal_purple',
      'name': 'سرمه‌ای تیره (پیش‌فرض)',
      'gradient': [const Color(0xFF1E293B), const Color(0xFF0F172A)],
      'price': 0,
    },
    {
      'id': 'persian_pink',
      'name': 'صورتی ایرانی',
      'gradient': [const Color(0xFFFF3FA4), const Color(0xFFC71585)],
      'price': 1,
    },
    {
      'id': 'electric_blue',
      'name': 'آبی استقلالی',
      'gradient': [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
      'price': 1,
    },
    {
      'id': 'persepolis_red',
      'name': 'قرمز پرسپولیسی',
      'gradient': [const Color(0xFFEF4444), const Color(0xFF991B1B)],
      'price': 1,
    },
    {
      'id': 'radiant_purple',
      'name': 'بنفش درخشان',
      'gradient': [const Color(0xFFA855F7), const Color(0xFF7C3AED)],
      'price': 1,
    },
  ];

  // آیتم‌های ویژه (نوع سوم)
  final List<Map<String, dynamic>> _vipItems = [
    {
      'id': 'golden_notes',
      'title': 'جزوات طلایی شب امتحان + پشتیبانی اختصاصی ⚡',
      'desc': 'سلاح مخفی شب امتحان! کمترین زمان مطالعه با بالاترین نمره 🚀',
      'price': 1,
      'image': 'image/100.webp',
    },
    {
      'id': 'infinite_memory',
      'title': 'عملیات حافظه بی‌نهایت 🧠',
      'desc': 'مغزت رو آپدیت کن! تکنیک‌های مخفی حافظه در یک چالش برای اینکه هیچ‌وقت درس‌ها یادت نره. 💡',
      'price': 1,
      'image': 'image/102.webp',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // رنگ تم هدر فروشگاه بر اساس انتخاب کاربر
  Color _getThemeDarkColor() {
    switch (AuthManager.currentTheme) {
      case 'persian_pink':
      case 'pastel_pink':
        return const Color(0xFFC71585); // صورتی ایرانی
      case 'electric_blue':
        return const Color(0xFF1E40AF); // آبی استقلالی
      case 'persepolis_red':
        return const Color(0xFF991B1B); // قرمز پرسپولیسی
      case 'radiant_purple':
        return const Color(0xFF7C3AED); // بنفش درخشان
      default:
        return const Color(0xFF0F172A); // سرمه‌ای تیره / پیش‌فرض
    }
  }

  // رنگ پس‌زمینه کادرها و تب‌ها بر اساس تم انتخابی
  Color _getThemeCardColor() {
    switch (AuthManager.currentTheme) {
      case 'persian_pink':
      case 'pastel_pink':
        return const Color(0xFF831843);
      case 'electric_blue':
        return const Color(0xFF1D4ED8);
      case 'persepolis_red':
        return const Color(0xFFB91C1C);
      case 'radiant_purple':
        return const Color(0xFF9333EA);
      default:
        return const Color(0xFF1E293B);
    }
  }

  // گرادینت دکمه‌ها و ایندیکاتور بر اساس تم انتخابی
  List<Color> _getThemeAccentGradient() {
    switch (AuthManager.currentTheme) {
      case 'persian_pink':
      case 'pastel_pink':
        return [const Color(0xFFFF3FA4), const Color(0xFFC71585)];
      case 'electric_blue':
        return [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)];
      case 'persepolis_red':
        return [const Color(0xFFEF4444), const Color(0xFF991B1B)];
      case 'radiant_purple':
        return [const Color(0xFFA855F7), const Color(0xFF7C3AED)];
      default:
        return [const Color(0xFF7C3AED), const Color(0xFF4F46E5)];
    }
  }

  // کادر هشدار حرفه‌ای و جذاب برای کمبود سکه
  void _showInsufficientCoinsSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Text('🪙', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سکه‌ی کافی نداری!',
                    style: TextStyle(fontFamily: 'Tahoma', fontWeight: FontWeight.w900, fontSize: 13, color: Colors.white),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'با شرکت در چالش‌ها و درس‌ها سکه بیشتری به دست آور.',
                    style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFFFEE2E2)),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // مدال فوق‌العاده رمزآلود، حرفه‌ای و ماجراجویی «طومار اژدها» برای جزوات طلایی شب امتحان
  void _showSecretDragonScrollModal(BuildContext context) {
    final List<Map<String, String>> supportPlatforms = [
      {
        'name': 'ارسال کلمه "طومار اژدها" در ایتا',
        'source': 'image/eitaa_bale/1.webp',
        'url': 'https://eitaa.com/App_game_Lesson',
      },
      {
        'name': 'ارسال کلمه "طومار اژدها" در بله',
        'source': 'image/eitaa_bale/2.webp',
        'url': 'https://ble.ir/App_game_Lesson',
      },
      {
        'name': 'ارسال پیامک کلمه "طومار اژدها"',
        'source': 'image/eitaa_bale/4.webp',
        'url': 'sms:09050341218?body=طومار اژدها',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B), Color(0xFF16092F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFC084FC).withOpacity(0.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC084FC),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF311042),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC084FC).withOpacity(0.5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Text('🐉📜', style: TextStyle(fontSize: 36)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'قفل طومار اژدها شکسته شد! ⚡',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E1065).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF9333EA)),
                  ),
                  child: const Text(
                    'کلمه «طومار اژدها» رو بفرست تا فایل فوق‌محرمانه تقدیمت بشه و دیگه نگران شب امتحان نباشی',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF3E8FF),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'پایگاه ارتباطی خود را برای دریافت گنجینه انتخاب کنید:',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 16),
                ...supportPlatforms.map((platform) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF231F3D), Color(0xFF1E1B4B)],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.5), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          Navigator.pop(ctx);

                          if (!platform['url']!.toString().startsWith('sms:')) {
                            await Clipboard.setData(const ClipboardData(text: 'طومار اژدها'));
                          }

                          final Uri url = Uri.parse(platform['url']!);
                          try {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('امکان باز کردن لینک وجود ندارد.')),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.asset(
                                  platform['source']!,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  platform['name']!,
                                  style: const TextStyle(
                                    fontFamily: 'Tahoma',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Icon(Icons.flash_on_rounded, color: Color(0xFFC084FC), size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // مدال فوق‌العاده حرفه‌ای، خفن، گیمینگ و سایبرپانک «ماتریکس» برای عملیات حافظه بی‌نهایت
  void _showMatrixMemoryModal(BuildContext context) {
    final List<Map<String, String>> supportPlatforms = [
      {
        'name': 'ارسال کلمه "ماتریکس" در ایتا',
        'source': 'image/eitaa_bale/1.webp',
        'url': 'https://eitaa.com/App_game_Lesson',
      },
      {
        'name': 'ارسال کلمه "ماتریکس" در بله',
        'source': 'image/eitaa_bale/2.webp',
        'url': 'https://ble.ir/App_game_Lesson',
      },
      {
        'name': 'ارسال پیامک کلمه "ماتریکس"',
        'source': 'image/eitaa_bale/4.webp',
        'url': 'sms:09050341218?body=ماتریکس',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF030712), Color(0xFF0F172A), Color(0xFF022C22)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFF34D399), width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.5),
                  blurRadius: 35,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF34D399),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF064E3B),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF34D399).withOpacity(0.6),
                        blurRadius: 25,
                      ),
                    ],
                  ),
                  child: const Text('🧠⚡', style: TextStyle(fontSize: 36)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'فروپاشیِ ماتریکس آغاز شد! 💥',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF065F46).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                  ),
                  child: const Text(
                    'کلمه ماتریکس رو بفرست تا از ماتریکسِ خوندن و فراموش کردن خارج بشی!',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD1FAE5),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'پایگاه اتصال امن خود را انتخاب کنید:',
                  style: TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 16),
                ...supportPlatforms.map((platform) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF064E3B), Color(0xFF022C22)],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF34D399).withOpacity(0.6), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          Navigator.pop(ctx);

                          if (!platform['url']!.toString().startsWith('sms:')) {
                            await Clipboard.setData(const ClipboardData(text: 'ماتریکس'));
                          }

                          final Uri url = Uri.parse(platform['url']!);
                          try {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('امکان باز کردن لینک وجود ندارد.')),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.asset(
                                  platform['source']!,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  platform['name']!,
                                  style: const TextStyle(
                                    fontFamily: 'Tahoma',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Icon(Icons.bolt_rounded, color: Color(0xFF34D399), size: 22),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeDarkColor = _getThemeDarkColor();
    final themeCardColor = _getThemeCardColor();
    final accentGradient = _getThemeAccentGradient();

    return SafeArea(
      child: Column(
        children: [
          // هدر فروشگاه با رنگ داینامیک هماهنگ با تم انتخابی
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: themeDarkColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(color: themeDarkColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'فروشگاه 🛒',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: themeCardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 4),
                      Text(
                        '${AuthManager.coins}',
                        style: const TextStyle(fontFamily: 'Tahoma', fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFF59E0B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // تب‌بار فروشگاه (آواتارها، تم‌های رنگی، آیتم‌های ویژه)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            height: 48,
            decoration: BoxDecoration(
              color: themeCardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                gradient: LinearGradient(colors: accentGradient),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: accentGradient.first.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF94A3B8),
              labelStyle: const TextStyle(fontFamily: 'Tahoma', fontSize: 12, fontWeight: FontWeight.w900),
              unselectedLabelStyle: const TextStyle(fontFamily: 'Tahoma', fontSize: 11, fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'آواتارها 👤'),
                Tab(text: 'تم‌های رنگی 🎨'),
                Tab(text: 'آیتم‌های ویژه ⭐'),
              ],
            ),
          ),

          // محتوای تب‌ها
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvatarsTab(accentGradient.first),
                _buildThemesTab(),
                _buildVipItemsTab(accentGradient),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دکمه ۳بعدی فوق‌العاده حرفه‌ای و خفن برای آیتم‌های ویژه (هم‌خانواده با آواتارها)
  Widget _buildVipEpicButton({
    required String text,
    required VoidCallback onTap,
    required bool isPurchased,
  }) {
    final List<Color> gradientColors = isPurchased
        ? [const Color(0xFF059669), const Color(0xFF10B981)] // سبز زمردی درخشان برای دریافت کن
        : [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)]; // بنفش کپسولی کاملاً هم‌خانواده با دکمه آواتارها

    return _buildEpicCapsuleButton(
      text: text,
      onTap: onTap,
      gradientColors: gradientColors,
      isCurrent: isPurchased,
    );
  }

  // ویجت دکمه‌ی کپسولی حرفه‌ای برای آواتارها
  Widget _buildEpicCapsuleButton({
    required String text,
    required VoidCallback onTap,
    required List<Color> gradientColors,
    bool isCurrent = false,
  }) {
    return Container(
      width: 120,
      height: 38,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCurrent
              ? [const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)]
              : gradientColors,
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isCurrent ? Colors.black : gradientColors.first).withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Tahoma',
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: isCurrent ? const Color(0xFF334155) : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // تب اول: خرید آواتار
  Widget _buildAvatarsTab(Color accentColor) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.90,
      ),
      itemCount: _storeAvatars.length,
      itemBuilder: (context, index) {
        final item = _storeAvatars[index];
        final path = item['path'] as String;
        final price = item['price'] as int;
        final bool isUnlocked = AuthManager.unlockedAvatars.contains(path);
        final bool isCurrent = AuthManager.userAvatar == path;

        final List<Color> btnGradient = isUnlocked
            ? [const Color(0xFF10B981), const Color(0xFF059669)]
            : [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 6)),
            ],
            border: Border.all(
              color: isCurrent ? accentColor : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isCurrent ? [accentColor, Colors.purple] : [Colors.grey.shade300, Colors.grey.shade400],
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    path,
                    width: 62,
                    height: 62,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 62,
                        height: 62,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.person, size: 32, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _buildEpicCapsuleButton(
                text: isCurrent ? 'فعال' : (isUnlocked ? 'انتخاب 🎯' : '🪙 $price'),
                isCurrent: isCurrent,
                gradientColors: btnGradient,
                onTap: () {
                  setState(() {
                    if (isUnlocked) {
                      AuthManager.userAvatar = path;
                      AuthManager.save();
                    } else {
                      if (AuthManager.coins >= price) {
                        AuthManager.coins -= price;
                        AuthManager.unlockedAvatars.add(path);
                        AuthManager.userAvatar = path;
                        AuthManager.save();
                      } else {
                        _showInsufficientCoinsSnack(context);
                      }
                    }
                  });
                  if (widget.onStoreUpdated != null) {
                    widget.onStoreUpdated!();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // تب دوم: تم‌های رنگی (دکمه‌های گلس‌مورفیسم تیره)
  Widget _buildThemesTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _storeThemes.length,
      itemBuilder: (context, index) {
        final theme = _storeThemes[index];
        final id = theme['id'] as String;
        final name = theme['name'] as String;
        final gradient = theme['gradient'] as List<Color>;
        final price = theme['price'] as int;
        
        final bool isUnlocked = AuthManager.unlockedThemes.contains(id);
        final bool isCurrentTheme = AuthManager.currentTheme == id;

        String buttonText = isCurrentTheme ? 'فعال' : (isUnlocked ? 'انتخاب' : '🪙 $price');

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient, begin: Alignment.centerRight, end: Alignment.centerLeft),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(color: gradient.first.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 5)),
            ],
            border: Border.all(
              color: isCurrentTheme ? Colors.white : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🎨', style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(fontFamily: 'Tahoma', fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                  _GlassmorphismThemeBuyButton(
                    text: buttonText,
                    onTap: () {
                      setState(() {
                        if (isUnlocked) {
                          AuthManager.currentTheme = id;
                          AuthManager.save();
                        } else {
                          if (AuthManager.coins >= price) {
                            AuthManager.coins -= price;
                            AuthManager.unlockedThemes.add(id);
                            AuthManager.currentTheme = id;
                            AuthManager.save();
                          } else {
                            _showInsufficientCoinsSnack(context);
                          }
                        }
                      });
                      if (widget.onStoreUpdated != null) {
                        widget.onStoreUpdated!();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // تب سوم: آیتم‌های ویژه (دکمه‌های خرید کاملاً هم‌خانواده با آواتارها با قابلیت «دریافت کن 🎁»)
  Widget _buildVipItemsTab(List<Color> accentGradient) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _vipItems.length,
      itemBuilder: (context, index) {
        final item = _vipItems[index];
        final id = item['id'] as String;
        final title = item['title'] as String;
        final desc = item['desc'] as String;
        final price = item['price'] as int;
        final imagePath = item['image'] as String;
        final bool isPurchased = AuthManager.purchasedVipItems.contains(id);

        final double imgSize = imagePath == 'image/102.webp' ? 145 : 135;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1B4B), Color(0xFF311042)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.25), blurRadius: 15, offset: const Offset(0, 6)),
            ],
            border: Border.all(color: const Color(0xFFC084FC).withOpacity(0.4), width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // سمت چپ: عنوان، توضیحات و دکمه خرید هم‌خانواده با آواتارها
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontFamily: 'Tahoma', fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: const TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFFCBD5E1), height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildVipEpicButton(
                          text: isPurchased ? 'دریافت کن 🎁' : '🪙 $price',
                          isPurchased: isPurchased,
                          onTap: () {
                            if (!isPurchased) {
                              if (AuthManager.coins >= price) {
                                setState(() {
                                  AuthManager.coins -= price;
                                  AuthManager.purchasedVipItems.add(id);
                                  AuthManager.save();
                                });
                              } else {
                                _showInsufficientCoinsSnack(context);
                                return;
                              }
                            }
                            if (widget.onStoreUpdated != null) {
                              widget.onStoreUpdated!();
                            }
                            if (id == 'golden_notes') {
                              _showSecretDragonScrollModal(context);
                            } else if (id == 'infinite_memory') {
                              _showMatrixMemoryModal(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // سمت راست: تصویر بزرگ و جذاب اختصاصی
              Transform.translate(
                offset: Offset(0, id == 'infinite_memory' ? -10.0 : 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePath,
                    width: imgSize,
                    height: imgSize,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: imgSize,
                        height: imgSize,
                        color: Colors.white.withOpacity(0.1),
                        child: const Icon(Icons.image, color: Colors.white54, size: 44),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// دکمه خرید گلس‌مورفیسم تیره و کوچک‌تر برای بخش تم‌های رنگی
class _GlassmorphismThemeBuyButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _GlassmorphismThemeBuyButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isPrice = text.contains('🪙');
    String priceVal = text.replaceAll('🪙', '').trim();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 95,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: isPrice
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Text(
                      priceVal,
                      style: const TextStyle(
                        fontFamily: 'Tahoma',
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFBBF24),
                      ),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'Tahoma',
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
