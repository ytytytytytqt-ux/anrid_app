import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import '../managers/auth_manager.dart';
import 'profile_screen.dart';
import 'store_screen.dart';
import '../Quran7/quran7_screen.dart';
import '../Quran7/quran7_league_manager.dart';
import '../Quran7/quran7_league_entry_screen.dart';
import '../Quran8/quran8_screen.dart';
import '../Quran8/quran8_data.dart';
import '../Quran8/quran8_league_manager.dart';
import '../Quran8/quran8_league_entry_screen.dart';
import '../Quran9/quran9_screen.dart';
import '../zaban_7/zaban7_screen.dart';
import '../zaban_8/zaban8_screen.dart';
import '../zaban_9/zaban9_screen.dart';
import '../Motaleat7/motaleat7_screen.dart';
import '../Motaleat8/motaleat8_screen.dart';
import '../Motaleat9/motaleat9_screen.dart';
import '../Payam7/payam7_screen.dart';
import '../Farsi7/farsi7_screen.dart';
import '../Farsi8/farsi8_screen.dart';
import '../Farsi9/farsi9_screen.dart';
import '../Payam8/payam8_screen.dart';
import '../Payam9/payam9_screen.dart';
import '../Olom7/olom7_screen.dart';
import '../Olom8/olom8_screen.dart';
import '../Olom9/olom9_screen.dart';
import '../League7/league7_screen.dart';
import '../League8/league8_screen.dart';
import '../League9/league9_screen.dart';
import '../Riyazi7/riyazi7_screen.dart';
import '../Riyazi8/riyazi8_screen.dart';
import '../Riyazi9/riyazi9_screen.dart';

class DanaProApp extends StatelessWidget {
  const DanaProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'دانا - آکادمی حرفه‌ای',
      theme: ThemeData(
        fontFamily: 'Tahoma',
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4C1D95),
          primary: const Color(0xFF4C1D95),
        ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox(),
        );
      },
      home: const ModernHomeScreen(),
    );
  }
}

// واژگان عربی هشتم - درس اول
final List<Map<String, String>> arabic8Lesson1Part1Vocab = [
  {'word': 'بَسيط', 'emoji': '🔹', 'translation': 'ساده'},
  {'word': 'اَلثَّامِن', 'emoji': '8️⃣', 'translation': 'هشتم'},
  {'word': 'حَافِلَة', 'emoji': '🚌', 'translation': 'اتوبوس'},
  {'word': 'حَلْوَانِيّ', 'emoji': '🧁', 'translation': 'شیرینی‌پروش'},
  {'word': 'رُزّ', 'emoji': '🍚', 'translation': 'برنج'},
  {'word': 'مَوْقِف', 'emoji': '🚏', 'translation': 'ایستگاه'},
  {'word': 'مُوَظَّف', 'emoji': '👨‍💼', 'translation': 'کارمند'},
  {'word': 'نَجَحَ', 'emoji': '🏆', 'translation': 'موفق شد'},
];

final List<Map<String, String>> arabic8Lesson1Part2Vocab = [
  {'word': 'بسيط', 'emoji': '🔹', 'translation': 'ساده'},
  {'word': 'الثامن', 'emoji': '8️⃣', 'translation': 'هشتم'},
  {'word': 'كرة القدم', 'emoji': '⚽', 'translation': 'فوتبال'},
  {'word': 'حافلة', 'emoji': '🚌', 'translation': 'اتوبوس'},
  {'word': 'حلوانی', 'emoji': '🧁', 'translation': 'شیرینی‌پروش'},
  {'word': 'رز', 'emoji': '🍚', 'translation': 'برنج'},
  {'word': 'موقف', 'emoji': '🚏', 'translation': 'ایستگاه'},
  {'word': 'موظف', 'emoji': '👨‍💼', 'translation': 'کارمند'},
  {'word': 'نجح', 'emoji': '🏆', 'translation': 'موفق شد'},
  {'word': 'سنة دراسية', 'emoji': '📚', 'translation': 'سال تحصیلی'},
  {'word': 'نصوص', 'emoji': '📄', 'translation': 'متن‌ها'},
  {'word': 'طباخ', 'emoji': '👨‍🍳', 'translation': 'آشپز'},
  {'word': 'طبختُ', 'emoji': '🍳', 'translation': 'پختم'},
  {'word': 'مراجعة', 'emoji': '🔄', 'translation': 'دوره کردن'},
  {'word': 'ممرض', 'emoji': '🩺', 'translation': 'پرستار'},
  {'word': 'رسائل', 'emoji': '✉️', 'translation': 'نامه‌ها'},
  {'word': 'زملاء', 'emoji': '🧑‍🤝‍🧑', 'translation': 'هم‌کلاسی‌ها'},
];

final List<Map<String, String>> arabic8Lesson1Part3Vocab = [
  {'ar': 'كُرَةُ الْقَدَمِ', 'fa': 'فوتبال', 'emoji': '⚽'},
  {'ar': 'سَنَة دِرَاسِيَّة', 'fa': 'سال تحصیلی', 'emoji': '📚'},
  {'ar': 'نُصُوص', 'fa': 'متن‌ها', 'emoji': '📄'},
  {'ar': 'طَبَّاخ', 'fa': 'آشپز', 'emoji': '👨‍🍳'},
  {'ar': 'طَبَخْتُ', 'fa': 'پختم', 'emoji': '🍳'},
  {'ar': 'مُرَاجَعَة', 'fa': 'دوره کردن', 'emoji': '🔄'},
  {'ar': 'مُمَرِّض', 'fa': 'پرستار', 'emoji': '🩺'},
  {'ar': 'رَسَائِل', 'fa': 'نامه‌ها (مفرد: رِسَالَة)', 'emoji': '✉️'},
  {'ar': 'زُمَلَاء', 'fa': 'هم‌کلاسی‌ها (مفرد: زَمِیل)', 'emoji': '🧑‍🤝‍🧑'},
  {'ar': 'كُرَة', 'fa': 'توپ', 'emoji': '🏐'},
  {'ar': 'قَدَم', 'fa': 'پا', 'emoji': '🦶'},
  {'ar': 'نَصّ', 'fa': 'متن', 'emoji': '📝'},
];

// واژگان دروس عربی پایه هفتم
final List<Map<String, String>> lesson1Part1Vocab = [
  {'word': 'أَب', 'emoji': '👨', 'translation': 'پدر'},
  {'word': 'أَبِي', 'emoji': '👨‍👦', 'translation': 'پدرم'},
  {'word': 'أُحِبُّ', 'emoji': '❤️', 'translation': 'دوست دارم'},
  {'word': 'أُمّ', 'emoji': '👩', 'translation': 'مادر'},
  {'word': 'أُمِّي', 'emoji': '👩‍👧', 'translation': 'مادرم'},
  {'word': 'أَنَا', 'emoji': '👤', 'translation': 'من'},
  {'word': 'هٰذَا', 'emoji': '🧑👉', 'translation': 'این [آقا/مذکر]'},
  {'word': 'هٰذِهِ', 'emoji': '👧👉', 'translation': 'این [خانم/مؤنث]'},
];

final List<Map<String, String>> lesson1Part2Vocab = [
  {'word': 'أب', 'emoji': '👨', 'translation': 'پدر'},
  {'word': 'أبي', 'emoji': '👨‍👦', 'translation': 'پدرم'},
  {'word': 'أحب', 'emoji': '❤️', 'translation': 'دوست دارم'},
  {'word': 'أم', 'emoji': '👩', 'translation': 'مادر'},
  {'word': 'أمي', 'emoji': '👩‍👧', 'translation': 'مادرم'},
  {'word': 'أنا', 'emoji': '👤', 'translation': 'من'},
  {'word': 'هذا', 'emoji': '🧑👉', 'translation': 'این [آقا/مذکر]'},
  {'word': 'هذه', 'emoji': '👧👉', 'translation': 'این [خانم/مؤنث]'},
];

final List<Map<String, String>> lesson1Part3Vocab = [
  {'ar': 'أَب', 'fa': 'پدر', 'emoji': '👨'},
  {'ar': 'أَبِي', 'fa': 'پدرم', 'emoji': '👨‍👦'},
  {'ar': 'أُحِبُّ', 'fa': 'دوست دارم', 'emoji': '❤️'},
  {'ar': 'أُمّ', 'fa': 'مادر', 'emoji': '👩'},
  {'ar': 'أُمِّي', 'fa': 'مادرم', 'emoji': '👩‍👧'},
  {'ar': 'أَنَا', 'fa': 'من', 'emoji': '👤'},
  {'ar': 'هٰذَا', 'fa': 'این [آقا/مذکر]', 'emoji': '🧑👉'},
  {'ar': 'هٰذِهِ', 'fa': 'این [خانم/مؤنث]', 'emoji': '👧👉'},
];

final List<Map<String, String>> lesson2Part1Vocab = [
  {'word': 'صَفّ', 'emoji': '🏫', 'translation': 'کلاس'},
  {'word': 'طالِب', 'emoji': '🧑‍🎓', 'translation': 'دانش‌آموز'},
  {'word': 'تِلْميذ', 'emoji': '🧑‍🎓', 'translation': 'دانش‌آموز'},
  {'word': 'تَلاميذ', 'emoji': '🧑‍🤝‍🧑', 'translation': 'دانش‌آموزان'},
  {'word': 'بِنتْ', 'emoji': '👧', 'translation': 'دختر'},
  {'word': 'وَلدَ', 'emoji': '👦', 'translation': 'پسر، فرزند'},
  {'word': 'غرفه', 'emoji': '🚪', 'translation': 'اتاق'},
  {'word': 'طبيب', 'emoji': '👨‍⚕️', 'translation': 'پزشک'},
];

final List<Map<String, String>> lesson2Part2Vocab = [
  {'word': 'لغه', 'emoji': '🗣️', 'translation': 'زبان'},
  {'word': 'حقيبه', 'emoji': '🎒', 'translation': 'کیف'},
  {'word': 'شجره', 'emoji': '🌳', 'translation': 'درخت'},
  {'word': 'اسمک', 'emoji': '👤', 'translation': 'نام تو'},
  {'word': 'اسمي', 'emoji': '🙋‍♂️', 'translation': 'نام من'},
];

final List<Map<String, String>> lesson2Part3Vocab = [
  {'ar': 'دخَلَ', 'emoji': '🚪', 'fa': 'داخل شد'},
  {'ar': 'مُبتَسِماً', 'emoji': '😊', 'fa': 'لبخندزنان'},
  {'ar': 'أَهْلاً وَ سَهْلاً', 'emoji': '🤝', 'fa': 'خوش آمدید'},
  {'ar': 'كَيفَ', 'emoji': '❓', 'fa': 'چطور؟ / چگونه؟'},
];

final List<Map<String, String>> lesson3Part1Vocab = [
  {'word': 'أحَسْنَتمُ', 'emoji': '🌟', 'translation': 'آفرین بر شما'},
  {'word': 'سَهْل', 'emoji': '🪶', 'translation': 'آسان'},
  {'word': 'أدَعْيةَ', 'emoji': '🤲', 'translation': 'جمعِ دُعاء'},
  {'word': 'صَعْب', 'emoji': '🏋️‍♂️', 'translation': 'سخت'},
  {'word': 'أعَزِائّي', 'emoji': '🫂', 'translation': 'عزيزانم'},
  {'word': 'کرُسّيّ', 'emoji': '🪑', 'translation': 'صندلی'},
  {'word': 'أفْضَل', 'emoji': '🥇', 'translation': 'برتر'},
  {'word': 'جَميل', 'emoji': '🎨', 'translation': 'زيبا'},
];

final List<Map<String, String>> lesson3Part2Vocab = [
  {'word': 'جدا', 'emoji': '💯', 'translation': 'بسیار'},
  {'word': 'لانها', 'emoji': '➡️', 'translation': 'برای اینکه آن'},
  {'word': 'افضل', 'emoji': '🥇', 'translation': 'برتر'},
  {'word': 'لفهم', 'emoji': '🧠', 'translation': 'برای فهمیدن'},
  {'word': 'لماذا', 'emoji': '❓', 'translation': 'چرا؟'},
];

final List<Map<String, String>> lesson3Part3Vocab = [
  {'ar': 'مَعَ', 'fa': 'همراهِ', 'emoji': '👥'},
  {'ar': 'تَکَلُّم', 'fa': 'سخن گفتن', 'emoji': '🗣️'},
  {'ar': 'مَمْزوج', 'fa': 'درآميخته', 'emoji': '🧪'},
  {'ar': 'ناطِقينَ', 'fa': 'سخنگويان', 'emoji': '🎙️'},
  {'ar': 'نتَعََلمَُّ', 'fa': 'ياد می گيريم', 'emoji': '✍️'},
];

final List<Map<String, String>> lesson4Part1Vocab = [
  {'word': 'اِبن', 'emoji': '👦', 'translation': 'پسر'},
  {'word': 'قَمَر', 'emoji': '🌙', 'translation': 'ماه'},
  {'word': 'جَبَل', 'emoji': '⛰️', 'translation': 'کوه'},
  {'word': 'لوَحَة', 'emoji': '🖼️', 'translation': 'تابلو'},
  {'word': 'مَکتَبَة', 'emoji': '📚', 'translation': 'کتابخانه'},
  {'word': 'وُلدي', 'emoji': '🧒', 'translation': 'پسرم، فرزندم'},
  {'word': 'أَهلاً بِكَ / بِكِ', 'emoji': '👋', 'translation': 'خوش آمدی'},
  {'word': 'اَلْمَرأَة / نِساء', 'emoji': '👩', 'translation': 'زن / زنان'},
];

final List<Map<String, String>> lesson4Part2Vocab = [
  {'word': 'شکرا لک', 'emoji': '🙏', 'translation': 'از تو سپاسگزارم'},
  {'word': 'ضیف', 'emoji': '👤', 'translation': 'میهمان'},
  {'word': 'احسنت', 'emoji': '👍', 'translation': 'آفرین بر تو'},
  {'word': 'قال', 'emoji': '🗣️', 'translation': 'گفت'},
  {'word': 'کبیر', 'emoji': '🐘', 'translation': 'بزرگ'},
  {'word': 'کثیر', 'emoji': '♾️', 'translation': 'بسیار'},
  {'word': 'ایضا', 'emoji': '➕', 'translation': 'همچنين'},
  {'word': 'ان', 'emoji': '❗', 'translation': 'همانا'},
  {'word': 'الی', 'emoji': '➡️', 'translation': 'به، به سوی ، تا'},
  {'word': 'کل شیء', 'emoji': '📦', 'translation': 'هر چیزی'},
  {'word': 'بعلمه', 'emoji': '🔬', 'translation': 'با علمش'},
  {'word': 'تلك', 'emoji': '👩👉', 'translation': 'آن (مؤنث)'},
  {'word': 'ذلك', 'emoji': '👨👉', 'translation': 'آن (مذکّر)'},
  {'word': 'هو', 'emoji': '👨', 'translation': 'او (مذکّر)'},
  {'word': 'هی', 'emoji': '👩', 'translation': 'او (مؤنث)'},
];

final List<Map<String, String>> lesson4Part3Vocab = [
  {'ar': 'تحُِبُّ', 'fa': 'دوست داری', 'emoji': '❤️'},
  {'ar': 'ذَهَبَتَ', 'fa': 'رفتی', 'emoji': '🚶‍♂️'},
  {'ar': 'ذَهَبَتُ', 'fa': 'رفتم', 'emoji': '🏃‍♂️'},
  {'ar': 'يُحِبُّ', 'fa': 'دوست دارد', 'emoji': '💖'},
  {'ar': 'ناجِح', 'fa': 'موفقّ', 'emoji': '🏆'},
];

final List<Map<String, String>> lesson5Part1Vocab = [
  {'word': 'أَمان', 'emoji': '🛡️', 'translation': 'امنيّت'},
  {'word': 'خَيْْر', 'emoji': '✨', 'translation': 'بهتر، بهترين، خوبی'},
  {'word': 'دَهْر', 'emoji': '⏳', 'translation': 'روزگار'},
  {'word': 'ذَهَب', 'emoji': '🪙', 'translation': 'طلا'},
  {'word': 'نَافِذَة', 'emoji': '🪟', 'translation': 'پنجره'},
  {'word': 'وَرْدَة', 'emoji': '🌹', 'translation': 'گُل'},
  {'word': 'اَلْمَرْء', 'emoji': '👤', 'translation': 'انسان، مرد'},
  {'word': 'مَسرور', 'emoji': '😊', 'translation': 'خوشحال'},
];

final List<Map<String, String>> lesson5Part2Vocab = [
  {'word': 'خیر من', 'emoji': '🙅‍♂️', 'translation': 'بهتر است از'},
  {'word': 'ذهبه', 'emoji': '🪙', 'translation': 'طلايش'},
  {'word': 'علیک', 'emoji': '⚠️', 'translation': 'بر تو، به زيانِ تو'},
  {'word': 'فخر', 'emoji': '🌟', 'translation': 'افتخار'},
  {'word': 'هما', 'emoji': '👥', 'translation': 'ایشان، آن دو، آنان'},
  {'word': 'هاذان', 'emoji': '👬', 'translation': 'این دو، این ها (مذکر)'},
  {'word': 'هاتان', 'emoji': '👭', 'translation': 'این دو، این ها (مؤنث)'},
  {'word': 'ک', 'emoji': '🙋‍♂️', 'translation': 'تو'},
  {'word': 'خشب', 'emoji': '🪵', 'translation': 'چوب'},
];

final List<Map<String, String>> lesson5Part3Vocab = [
  {'ar': 'خَشَب', 'fa': 'چوب (جمع: أخْشَاب)', 'emoji': '🪵'},
  {'ar': 'نَوافِذ', 'fa': 'پنجره (جمع)', 'emoji': '🪟'},
  {'ar': 'كراسيّ', 'fa': 'صندلی (جمع)', 'emoji': '🪑'},
  {'ar': 'يَوْم', 'fa': 'روز (جمع: أَيّام)', 'emoji': '☀️'},
  {'ar': 'كَلام', 'fa': 'سخن', 'emoji': '💬'},
];

final List<Map<String, String>> lesson6Part1Vocab = [
  {'word': 'فائِز', 'emoji': '🏆', 'translation': 'بَرنده'},
  {'word': 'فَلّّاح', 'emoji': '👨‍🌾', 'translation': 'کشاورز'},
  {'word': 'جالِس', 'emoji': '🪑', 'translation': 'نشسته'},
  {'word': 'واقفِ', 'emoji': '🧍‍♂️', 'translation': 'ايستاده'},
  {'word': 'کَنْز', 'emoji': '💎', 'translation': 'گنج'},
  {'word': 'مِفتاح', 'emoji': '🔑', 'translation': 'کلید'},
  {'word': 'حَجَر', 'emoji': '🪨', 'translation': 'سنگ'},
  {'word': 'حديقَة', 'emoji': '🏡', 'translation': 'باغ'},
];

final List<Map<String, String>> lesson6Part2Vocab = [
  {'word': 'اوسط', 'emoji': '🎯', 'translation': 'ميانه ترين'},
  {'word': 'اولئک', 'emoji': '👈', 'translation': 'آنان، آن'},
  {'word': 'سبعين', 'emoji': '7️⃣0️⃣', 'translation': 'هفتاد'},
  {'word': 'صداقة', 'emoji': '🤝', 'translation': 'دوستی ها'},
  {'word': 'صغر', 'emoji': '👶', 'translation': 'خُردسالی، کوچکی'},
  {'word': 'عداوة', 'emoji': '⚔️', 'translation': 'دشمنی کردن'},
  {'word': 'عند', 'emoji': '👫', 'translation': 'نزد، کنار'},
  {'word': 'ها', 'emoji': '👧', 'translation': 'او (مؤنث)'},
  {'word': 'أنتم', 'emoji': '👥', 'translation': 'شما'},
  {'word': 'نحن', 'emoji': '🙋‍♂️', 'translation': 'ما'},
  {'word': 'هولاء', 'emoji': '👇', 'translation': 'اينان، این ها، این'},
  {'word': 'هم', 'emoji': '👨‍👨‍👦', 'translation': 'ايشان، آنان (جمع مذکّر)'},
  {'word': 'هن', 'emoji': '👩‍👩‍👧', 'translation': 'ايشان، آنان (جمع مؤنّث)'},
  {'word': 'لاعب', 'emoji': '⚽', 'translation': 'بازيکن'},
];

final List<Map<String, String>> lesson6Part3Vocab = [
  {'ar': 'کُنوز', 'fa': 'گنج‌ها (جمعِ کنز)', 'emoji': '💎'},
  {'ar': 'مَفاتيح', 'fa': 'کلیدها (جمعِ مفتاح)', 'emoji': '🔑'},
  {'ar': 'أَحجار', 'fa': 'سنگ‌ها (جمعِ حجر)', 'emoji': '🪨'},
  {'ar': 'حَدائِق', 'fa': 'باغ‌ها (جمعِ حدیقة)', 'emoji': '🌳'},
  {'ar': 'سَنَوات', 'fa': 'سال‌ها (جمعِ سنة)', 'emoji': '📅'},
  {'ar': 'ذَهَبِيّ', 'fa': 'طلایی', 'emoji': '🥇'},
  {'ar': 'رِجال', 'fa': 'مردان', 'emoji': '👨'},
  {'ar': 'نَقْش', 'fa': 'کنده‌کاری', 'emoji': '✍️'},
  {'ar': 'صُورَة', 'fa': 'عکس', 'emoji': '🖼️'},
];

final List<Map<String, String>> lesson7Part1Vocab = [
  {'word': 'بائِع', 'emoji': '👨‍💼', 'translation': 'فروشنده'},
  {'word': 'قَريب', 'emoji': '📍', 'translation': 'نزديک'},
  {'word': 'بُسْتان', 'emoji': '🌳', 'translation': 'باغ'},
  {'word': 'قَرْيَة', 'emoji': '🏡', 'translation': 'روستا'},
  {'word': 'بَعيد', 'emoji': '🔭', 'translation': 'دور'},
  {'word': 'قَليل', 'emoji': '📉', 'translation': 'کم'},
  {'word': 'جَزاء', 'emoji': '🎁', 'translation': 'پاداش'},
  {'word': 'لِسان', 'emoji': '👅', 'translation': 'زبان'},
];

final List<Map<String, String>> lesson7Part2Vocab = [
  {'word': 'الا', 'emoji': '🚫', 'translation': 'به جز'},
  {'word': 'عنب', 'emoji': '🍇', 'translation': 'انگور'},
  {'word': 'انتما', 'emoji': '👥', 'translation': 'شما (شما دو تن)'},
  {'word': 'فندق', 'emoji': '🏢', 'translation': 'هتل (مثنّی مذکّر و مثنّی مؤنث)'},
  {'word': 'جندي', 'emoji': '🪖', 'translation': 'سرباز'},
  {'word': 'مدينة', 'emoji': '🏙️', 'translation': 'شهر'},
  {'word': 'رب', 'emoji': '🧐', 'translation': 'چه بسا'},
  {'word': 'رمان', 'emoji': '🔴', 'translation': 'انار'},
  {'word': 'هنا', 'emoji': '📍', 'translation': 'اينجا'},
  {'word': 'عمود', 'emoji': '🏛️', 'translation': 'ستون'},
  {'word': 'نسیان', 'emoji': '❌🧠', 'translation': 'فراموشی'},
  {'word': 'صلاة', 'emoji': '🧎‍♂️', 'translation': 'نماز'},
];

final List<Map<String, String>> lesson7Part3Vocab = [
  {'ar': 'بُسْتان', 'fa': 'باغ', 'emoji': '🌳'},
  {'ar': 'قَرْيَة', 'fa': 'روستا', 'emoji': '🏡'},
  {'ar': 'عنب', 'fa': 'انگور', 'emoji': '🍇'},
  {'ar': 'فندق', 'fa': 'هتل', 'emoji': '🏢'},
  {'ar': 'جندي', 'fa': 'سرباز', 'emoji': '🪖'},
  {'ar': 'مدينة', 'fa': 'شهر', 'emoji': '🏙️'},
  {'ar': 'رمان', 'fa': 'انار', 'emoji': '🔴'},
  {'ar': 'عمود', 'fa': 'ستون', 'emoji': '🏛️'},
];

final List<Map<String, String>> lesson8Part1Vocab = [
  {'word': 'أُخْت', 'emoji': '👧', 'translation': 'خواهر'},
  {'word': 'أَخ', 'emoji': '👦', 'translation': 'برادر'},
  {'word': 'سائِق', 'emoji': '🚗', 'translation': 'راننده'},
  {'word': 'أَرْض', 'emoji': '🌍', 'translation': 'زمين'},
  {'word': 'سَماء', 'emoji': '☁️', 'translation': 'آسمان'},
  {'word': 'سَيّارَة', 'emoji': '🚙', 'translation': 'خودرو'},
  {'word': 'کاتِب', 'emoji': '✍️', 'translation': 'نويسنده'},
  {'word': 'جَوّال', 'emoji': '📱', 'translation': 'تلفن همراه'},
];

final List<Map<String, String>> lesson8Part2Vocab = [
  {'word': 'سيد', 'emoji': '👨‍💼', 'translation': 'آقا، سَروَر'},
  {'word': 'سیدة', 'emoji': '👩‍💼', 'translation': 'خانم'},
  {'word': 'صديق', 'emoji': '🧑‍🤝‍🧑', 'translation': 'دوست'},
  {'word': 'أنتَ', 'emoji': '👦', 'translation': 'تو (مذکر)'},
  {'word': 'أنتِ', 'emoji': '👧', 'translation': 'تو (مؤنث)'},
  {'word': 'انتن', 'emoji': '👩‍👩‍👧', 'translation': 'شما (جمع مؤنّث)'},
  {'word': 'من', 'emoji': '❓', 'translation': 'چه کسی، چه کسانی'},
  {'word': 'لمن', 'emoji': '❓', 'translation': 'مالِ چه کسی، مالِ چه کسانی'},
  {'word': 'وحدة', 'emoji': '🧍', 'translation': 'تنهایی'},
];

final List<Map<String, String>> lesson8Part3Vocab = [
  {'ar': 'سَماوات', 'fa': 'آسمان‌ها (جمعِ سماء)', 'emoji': '☁️'},
  {'ar': 'أَصْدِقاء', 'fa': 'دوستان (جمعِ صديق)', 'emoji': '🧑‍🤝‍🧑'},
  {'ar': 'جَليسُ السّوءِ', 'fa': 'همنشينِ بد (سوء: بدی)', 'emoji': '😈'},
];

final List<Map<String, String>> lesson9Part1Vocab = [
  {'word': 'بَیت', 'emoji': '🏠', 'translation': 'خانه'},
  {'word': 'مِنْضَدَة', 'emoji': '🪑', 'translation': 'ميز'},
  {'word': 'رَخيصَة', 'emoji': '🏷️', 'translation': 'ارزان'},
  {'word': 'غاليَة', 'emoji': '💎', 'translation': 'گران، ارزشمند'},
  {'word': 'يَسار', 'emoji': '⬅️', 'translation': 'چپ'},
  {'word': 'يَمين', 'emoji': '➡️', 'translation': 'راست'},
  {'word': 'ماذا', 'emoji': '❓', 'translation': 'چه، چه چيز، چيست'},
  {'word': 'دَوَران', 'emoji': '🔄', 'translation': 'چرخيدن'},
];

final List<Map<String, String>> lesson9Part2Vocab = [
  {'word': 'ماذا', 'emoji': '❓', 'translation': 'چه، چه چيز، چيست'},
  {'word': 'انفع', 'emoji': '📈', 'translation': 'سودمندترين'},
  {'word': 'حول', 'emoji': '🌀', 'translation': 'اطراف'},
  {'word': 'دوران', 'emoji': '🔄', 'translation': 'چرخيدن'},
  {'word': 'هم', 'emoji': '👥', 'translation': 'ِشان، ِ آنان (جمع مذکّر)'},
  {'word': 'انفعهم', 'emoji': '🌟', 'translation': 'سودمندترينشان'},
  {'word': 'فاعله', 'emoji': '🛠️', 'translation': 'انجام دهنده اش'},
];

final List<Map<String, String>> lesson9Part3Vocab = [
  {'ar': 'ناس', 'fa': 'مردم', 'emoji': '👥'},
  {'ar': 'بَیت', 'fa': 'خانه', 'emoji': '🏠'},
  {'ar': 'مِنْضَدَة', 'fa': 'ميز', 'emoji': '🪑'},
  {'ar': 'رَخيصَة', 'fa': 'ارزان', 'emoji': '🏷️'},
  {'ar': 'غاليَة', 'fa': 'گران، ارزشمند', 'emoji': '💎'},
  {'ar': 'يَسار', 'fa': 'چپ', 'emoji': '⬅️'},
  {'ar': 'يَمين', 'fa': 'راست', 'emoji': '➡️'},
];

final List<Map<String, String>> lesson10Part1Vocab = [
  {'word': 'قَميص', 'emoji': '👕', 'translation': 'پيراهن'},
  {'word': 'سِروال', 'emoji': '👖', 'translation': 'شلوار'},
  {'word': 'سَفينَة', 'emoji': '🚢', 'translation': 'کشتی'},
  {'word': 'يَد', 'emoji': '✋', 'translation': 'دست'},
  {'word': 'باب', 'emoji': '🚪', 'translation': 'در'},
  {'word': 'قَدَم', 'emoji': '🦶', 'translation': 'پا'},
  {'word': 'أَمامَ', 'emoji': '⬆️', 'translation': 'روبه رو'},
  {'word': 'فَوْقَ', 'emoji': '⬆️', 'translation': 'بالا، رویِ'},
];

final List<Map<String, String>> lesson10Part2Vocab = [
  {'word': 'عليك به', 'emoji': '📌', 'translation': 'بر تو باد!، بر تو لازم است'},
  {'word': 'اين', 'emoji': '❓', 'translation': 'کجا'},
  {'word': 'من اين', 'emoji': '🌍', 'translation': 'اهلِ کجا، از کجا'},
  {'word': 'قريب من', 'emoji': '📍', 'translation': 'نزدیک به'},
  {'word': 'تحت', 'emoji': '⬇️', 'translation': 'زير'},
  {'word': 'جنب', 'emoji': '📍', 'translation': 'کنار'},
  {'word': 'خلف', 'emoji': '🔙', 'translation': 'پشت'},
  {'word': 'كم', 'emoji': '👨‍👨‍👦', 'translation': 'تان، ِ شما (جمع مذکّر)'},
  {'word': 'كما', 'emoji': '👥', 'translation': 'تان، ِ شما (مثنّیٰ)'},
  {'word': 'كنّ', 'emoji': '👩‍👩‍👧', 'translation': 'ِتان، ِ شما (جمع مؤنّث)'},
  {'word': 'وراء', 'emoji': '🔙', 'translation': 'پشت'},
  {'word': 'هناك', 'emoji': '📍', 'translation': 'آنجا'},
  {'word': 'علي اليسار', 'emoji': '⬅️', 'translation': 'سمت چپ'},
  {'word': 'علي اليمين', 'emoji': '➡️', 'translation': 'سمت راست'},
];

final List<Map<String, String>> lesson10Part3Vocab = [
  {'ar': 'أَقْدام', 'fa': 'پاها (مفرد: قَدَم)', 'emoji': '🦶'},
  {'ar': 'أَبْوَاب', 'fa': 'درها (جمعِ باب)', 'emoji': '🚪'},
  {'ar': 'قَميص', 'fa': 'پيراهن', 'emoji': '👕'},
  {'ar': 'سِروال', 'fa': 'شلوار', 'emoji': '👖'},
  {'ar': 'سَفينَة', 'fa': 'کشتی', 'emoji': '🚢'},
  {'ar': 'يَد', 'fa': 'دست', 'emoji': '✋'},
  {'ar': 'باب', 'fa': 'در', 'emoji': '🚪'},
  {'ar': 'غُراب', 'fa': 'کلاغ', 'emoji': '🐦‍⬛'},
  {'ar': 'بَقَرَة', 'fa': 'گاو ماده', 'emoji': '🐄'},
];

final List<Map<String, String>> lesson11Part1Vocab = [
  {'word': 'شَهْر', 'emoji': '🌙', 'translation': 'ماه'},
  {'word': 'أُسْبُوع', 'emoji': '📅', 'translation': 'هفته'},
  {'word': 'بَحْر', 'emoji': '🌊', 'translation': 'دریا'},
  {'word': 'مُصْحَف', 'emoji': '📖', 'translation': 'قرآن'},
  {'word': 'وَجَع', 'emoji': '🩹', 'translation': 'درد'},
  {'word': 'جَواز', 'emoji': '🪪', 'translation': 'گذرنامه'},
  {'word': 'حَقيبَة', 'emoji': '🧳', 'translation': 'کیف، چمدان'},
  {'word': 'وَجْه', 'emoji': '🙂', 'translation': 'چهره'},
];

final List<Map<String, String>> lesson11Part2Vocab = [
  {'word': 'اثنا عشر', 'emoji': '1️⃣2️⃣', 'translation': 'دوازده'},
  {'word': 'اثنان', 'emoji': '2️⃣', 'translation': 'دو'},
  {'word': 'احد عشر', 'emoji': '1️⃣1️⃣', 'translation': 'یازده'},
  {'word': 'اربعة', 'emoji': '4️⃣', 'translation': 'چهار'},
  {'word': 'خمسة', 'emoji': '5️⃣', 'translation': 'پنج'},
  {'word': 'سبعة', 'emoji': '7️⃣', 'translation': 'هفت'},
  {'word': 'ستة', 'emoji': '6️⃣', 'translation': 'شش'},
  {'word': 'الذي', 'emoji': '👤', 'translation': 'کسی که، که'},
  {'word': 'كم', 'emoji': '❓', 'translation': 'چند، چقدر'},
  {'word': 'تسعة', 'emoji': '9️⃣', 'translation': 'نُه'},
  {'word': 'ثلاثة', 'emoji': '3️⃣', 'translation': 'سه'},
  {'word': 'ثمانية', 'emoji': '8️⃣', 'translation': 'هشت'},
  {'word': 'عشرة', 'emoji': '🔟', 'translation': 'ده'},
  {'word': 'خلق', 'emoji': '🤲', 'translation': 'آفرید'},
  {'word': 'نظر', 'emoji': '👀', 'translation': 'نگاه'},
];

final List<Map<String, String>> lesson11Part3Vocab = [
  {'ar': 'شُهور', 'fa': 'ماه‌ها (جمعِ شهر)', 'emoji': '🗓️'},
  {'ar': 'بحار', 'fa': 'دریاها (جمعِ بحر)', 'emoji': '🌊'},
  {'ar': 'حَقائِب', 'fa': 'کیف‌ها، چمدان‌ها (جمعِ حقيبة)', 'emoji': '🧳'},
  {'ar': 'شَهْر', 'fa': 'ماه', 'emoji': '🌙'},
  {'ar': 'مُصْحَف', 'fa': 'قرآن', 'emoji': '📖'},
  {'ar': 'وَجَع', 'fa': 'درد', 'emoji': '🩹'},
  {'ar': 'جَواز', 'fa': 'گذرنامه', 'emoji': '🪪'},
  {'ar': 'عَلَم', 'fa': 'پرچم', 'emoji': '🇮🇷'},
  {'ar': 'أَلْوان', 'fa': 'رنگ‌ها', 'emoji': '🌈'},
  {'ar': 'نار', 'fa': 'آتش', 'emoji': '🔥'},
];

final List<Map<String, String>> lesson12Part1Vocab = [
  {'word': 'فُنْدُق', 'emoji': '🏢', 'translation': 'هتل'},
];

final List<Map<String, String>> lesson12Part2Vocab = [
  {'word': 'اسرة', 'emoji': '👨‍👩‍👧‍👦', 'translation': 'خانواده'},
  {'word': 'حوار', 'emoji': '💬', 'translation': 'گفت‌وگو'},
  {'word': 'فندق', 'emoji': '🏢', 'translation': 'هتل'},
  {'word': 'كِ', 'emoji': '👧', 'translation': 'تو (مؤنث)'},
  {'word': 'حالك', 'emoji': '👋', 'translation': 'حالت، حالِ تو'},
  {'word': 'انا بخير', 'emoji': '😊', 'translation': 'خوبم'},
  {'word': 'مع السلامة', 'emoji': '👋', 'translation': 'به سلامت'},
  {'word': 'نا', 'emoji': '👥', 'translation': 'ما'},
  {'word': 'هما', 'emoji': '👥', 'translation': 'ِشان، ِ آن‌ها، ِ آن دو'},
  {'word': 'صباح الخير', 'emoji': '🌅', 'translation': 'صبح به‌خیر'},
  {'word': 'صباح النور', 'emoji': '☀️', 'translation': 'صبح به‌خیر (در پاسخ)'},
];

final List<Map<String, String>> lesson12Part3Vocab = [
  {'ar': 'أُسْرَة', 'fa': 'خانواده', 'emoji': '👨‍👩‍👧‍👦'},
  {'ar': 'حِوار', 'fa': 'گفت‌وگو', 'emoji': '💬'},
  {'ar': 'فُنْدُق', 'fa': 'هتل', 'emoji': '🏢'},
];

final List<Map<String, String>> lesson13Part1Vocab = [
  {'word': 'أَخَذَ', 'emoji': '🫴', 'translation': 'گرفت، برداشت'},
  {'word': 'اِشْتَریٰ', 'emoji': '🛒', 'translation': 'خرید'},
  {'word': 'عَباءَة', 'emoji': '🧕', 'translation': 'چادر'},
  {'word': 'عَلَم', 'emoji': '🇮🇷', 'translation': 'پرچم'},
  {'word': 'فُسْتان', 'emoji': '👗', 'translation': 'پیراهن زنانه'},
  {'word': 'مَلابِس', 'emoji': '👕', 'translation': 'لباس‌ها'},
  {'word': 'سوق', 'emoji': '🛍️', 'translation': 'بازار'},
  {'word': 'رِسالَة', 'emoji': '✉️', 'translation': 'نامه'},
];

final List<Map<String, String>> lesson13Part2Vocab = [
  {'word': 'اشتریتُ', 'emoji': '🛒', 'translation': 'خریدم'},
  {'word': 'اشتريتَ', 'emoji': '🙋‍♂️', 'translation': 'خریدی (مذکّر)'},
  {'word': 'اشتريتِ', 'emoji': '🙋‍♀️', 'translation': 'خریدی (مؤنث)'},
  {'word': 'شکرأ جزیلا', 'emoji': '🙏', 'translation': 'بسیار متشکّرم'},
  {'word': 'اکل', 'emoji': '🍽️', 'translation': 'خورد'},
  {'word': 'اکلتَ', 'emoji': '🍽️', 'translation': 'خوردی (مذکر)'},
  {'word': 'غسل', 'emoji': '🚿', 'translation': 'شست'},
  {'word': 'ام', 'emoji': '🔀', 'translation': 'یا'},
  {'word': 'بقي', 'emoji': '⏳', 'translation': 'ماند'},
  {'word': 'بقیت', 'emoji': '🧍‍♂️', 'translation': 'ماندی'},
  {'word': 'کان', 'emoji': '⏱️', 'translation': 'بود'},
  {'word': 'لا فرق', 'emoji': '⚖️', 'translation': 'هیچ فرقی نیست'},
  {'word': 'وحدكَ', 'emoji': '🧍‍♂️', 'translation': 'تو به تنهایی (مذکر)'},
  {'word': 'وحدكِ', 'emoji': '🧍‍♀️', 'translation': 'تو به تنهایی (مؤنث)'},
  {'word': 'سعر', 'emoji': '🤌', 'translation': 'قیمت'},
];

final List<Map<String, String>> lesson13Part3Vocab = [
  {'ar': 'تُفّاح، تُفّاحَة', 'fa': 'سیب، سیب‌ها', 'emoji': '🍏'},
  {'ar': 'اکلتُ', 'fa': 'خوردم', 'emoji': '😋'},
  {'ar': 'كتب', 'fa': 'نوشت', 'emoji': '✍️'},
  {'ar': 'ذهب', 'fa': 'رفت', 'emoji': '🚶‍♂️'},
  {'ar': 'ذكر', 'fa': 'یاد کرد', 'emoji': '💭'},
  {'ar': 'قرأ', 'fa': 'خواند', 'emoji': '📖'},
  {'ar': 'رفع', 'fa': 'بالا برد، برداشت', 'emoji': '⬆️'},
  {'ar': 'سِعْر', 'fa': 'قیمت', 'emoji': '🤌'},
];

final List<Map<String, String>> lesson14Part1Vocab = [
  {'word': 'فَتَحَ', 'emoji': '🚪', 'translation': 'باز کرد'},
  {'word': 'بَحَثَ عَنْ', 'emoji': '🔍', 'translation': 'دنبالِ... گشت'},
  {'word': 'طَرَقَ', 'emoji': '✊', 'translation': 'کوبید'},
  {'word': 'رَجَعَ', 'emoji': '🔙', 'translation': 'برگشت'},
  {'word': 'وَصَلَ', 'emoji': '🏁', 'translation': 'رسید'},
  {'word': 'وَجَدَ', 'emoji': '🔎', 'translation': 'پیدا کرد'},
  {'word': 'لَعِبَ', 'emoji': '🎮', 'translation': 'بازی کرد'},
  {'word': 'ثُمَّ', 'emoji': '⏭️', 'translation': 'سپس'},
];

final List<Map<String, String>> lesson14Part2Vocab = [
  {'word': 'قرب من', 'emoji': '📍', 'translation': 'نزدیک شد به'},
  {'word': 'لعب', 'emoji': '🎮', 'translation': 'بازی کرد'},
  {'word': 'من', 'emoji': '👤', 'translation': 'هر کس، کسی که'},
  {'word': 'واجب', 'emoji': '📋', 'translation': 'تکلیف، وظیفه'},
  {'word': 'ثم', 'emoji': '⏭️', 'translation': 'سپس'},
  {'word': 'فتحت', 'emoji': '🚪', 'translation': 'باز کرد (مؤنث)'},
];

final List<Map<String, String>> lesson14Part3Vocab = [
  {'ar': 'سلم', 'fa': 'سالم ماند', 'emoji': '💚'},
  {'ar': 'طَرَقَ', 'fa': 'کوبید', 'emoji': '✊'},
  {'ar': 'رَجَعَ', 'fa': 'برگشت', 'emoji': '🔙'},
  {'ar': 'وَصَلَ', 'fa': 'رسید', 'emoji': '🏁'},
  {'ar': 'وَجَدَ', 'fa': 'پیدا کرد', 'emoji': '🔎'},
];

final List<Map<String, String>> lesson15Part1Vocab = [
  {'word': 'فَاكِهَة', 'emoji': '🍎', 'translation': 'میوه (جمع: فَواكِه)'},
  {'word': 'جَلَسَ', 'emoji': '🪑', 'translation': 'نشست'},
  {'word': 'حَفِظَ', 'emoji': '🧠', 'translation': 'حفظ کرد'},
  {'word': 'صَنَعَ', 'emoji': '🛠️', 'translation': 'ساخت'},
  {'word': 'ضَرَبَ', 'emoji': '👋', 'translation': 'زد'},
  {'word': 'عَبَرَ', 'emoji': '🚸', 'translation': 'عبور کرد'},
  {'word': 'عَرَفَ', 'emoji': '💡', 'translation': 'شناخت، دانست'},
  {'word': 'وَقَفَ', 'emoji': '🛑', 'translation': 'ایستاد'},
];

final List<Map<String, String>> lesson15Part2Vocab = [
  {'word': 'عفوا', 'emoji': '🙏', 'translation': 'ببخشید'},
  {'word': 'بارد', 'emoji': '🧊', 'translation': 'سرد'},
  {'word': 'جو', 'emoji': '🌤️', 'translation': 'هوا'},
  {'word': 'حدود', 'emoji': '🌐', 'translation': 'مرزها'},
  {'word': 'حزن', 'emoji': '😔', 'translation': 'غمگین شد'},
  {'word': 'عمل', 'emoji': '💻', 'translation': 'کار کرد'},
  {'word': 'فرح', 'emoji': '😄', 'translation': 'خوشحال شد'},
  {'word': 'لبس', 'emoji': '🧥', 'translation': 'پوشید'},
  {'word': 'نسي', 'emoji': '💭', 'translation': 'فراموش کرد'},
  {'word': 'نصر', 'emoji': '🤝', 'translation': 'یاری کرد'},
  {'word': 'والد', 'emoji': '👨', 'translation': 'پدر'},
  {'word': 'والدة', 'emoji': '👩', 'translation': 'مادر'},
  {'word': 'وقع', 'emoji': '🍂', 'translation': 'افتاد'},
  {'word': 'إلى اللقاء', 'emoji': '👋', 'translation': 'به امید دیدار'},
  {'word': 'صعد', 'emoji': '🧗', 'translation': 'بالا رفت'},
];

final List<Map<String, String>> lesson15Part3Vocab = [
  {'ar': 'آلِهَة', 'fa': 'خدایان (مفرد: إلٰه)', 'emoji': '🕋'},
  {'ar': 'جلَسنا', 'fa': 'نشستیم', 'emoji': '🪑'},
  {'ar': 'حفظكم اللّٰه', 'fa': 'خدا شما را حفظ کند', 'emoji': '🤲'},
  {'ar': 'شعر بِـ', 'fa': 'احساسِ ... کرد', 'emoji': '💓'},
  {'ar': 'قطع', 'fa': 'برید', 'emoji': '✂️'},
  {'ar': 'إِلى اللقاء', 'fa': 'به امید دیدار', 'emoji': '👋'},
  {'ar': 'صَعَدَ', 'fa': 'بالا رفت', 'emoji': '🧗'},
];

final List<Map<String, String>> lesson16Part1Vocab = [
  {'word': 'بَدَأَ بِ', 'emoji': '▶️', 'translation': 'شروع کرد به'},
  {'word': 'جَمَعَ', 'emoji': '🧺', 'translation': 'جمع کرد'},
  {'word': 'أکْبَر', 'emoji': '🐘', 'translation': 'بزرگ‌تر'},
  {'word': 'سَمَحَ لِ', 'emoji': '✅', 'translation': 'اجازه داد به'},
  {'word': 'مُساعَدَة', 'emoji': '🤝', 'translation': 'کمک'},
  {'word': 'زَوجَة', 'emoji': '👩‍❤️‍👨', 'translation': 'همسر'},
  {'word': 'مَمْلوءٌ بِ', 'emoji': '🧪', 'translation': 'پر از'},
  {'word': 'حارّ', 'emoji': '🔥', 'translation': 'گرم (ضدّ بارِد)'},
];

final List<Map<String, String>> lesson16Part2Vocab = [
  {'word': 'ایتها', 'emoji': '🙋‍♀️', 'translation': 'ای (برای مؤنث)'},
  {'word': 'ایها', 'emoji': '🙋‍♂️', 'translation': 'ای (برای مذکر)'},
  {'word': 'به', 'emoji': '🔗', 'translation': 'به وسیله‌ی، با'},
  {'word': 'جمعتما', 'emoji': '👥', 'translation': 'جمع کردید'},
];

final List<Map<String, String>> lesson16Part3Vocab = [
  {'ar': 'اخوات', 'fa': 'خواهران (مفرد: أُخت)', 'emoji': '👧👧'},
  {'ar': 'اخوان', 'fa': 'دو برادر (مثنّیٰ)', 'emoji': '👦👦'},
  {'ar': 'اخوة', 'fa': 'برادران (جمعِ أَخ)', 'emoji': '👦👦👦'},
];

final List<Map<String, String>> lesson17Part1Vocab = [
  {'word': 'اِبتِسام', 'emoji': '😊', 'translation': 'لبخند'},
  {'word': 'سَمَكَة', 'emoji': '🐟', 'translation': 'ماهی (جمع: سَمَك، سْماك)'},
  {'word': 'شَبَکَة', 'emoji': '🕸️', 'translation': 'تور'},
  {'word': 'جاءَ', 'emoji': '🏃‍♂️', 'translation': 'آمد'},
  {'word': 'قبیح', 'emoji': '😈', 'translation': 'زشت'},
  {'word': 'علم', 'emoji': '🧠', 'translation': 'دانست'},
  {'word': 'خائِف', 'emoji': '😰', 'translation': 'ترسیده، ترسان'},
  {'word': 'نَظَرَ', 'emoji': '👀', 'translation': 'نگاه کرد'},
];

final List<Map<String, String>> lesson17Part2Vocab = [
  {'word': 'علم أن', 'emoji': '💡', 'translation': 'دانست که'},
  {'word': 'قذف', 'emoji': '🤾‍♂️', 'translation': 'انداخت یا پرتاب کرد'},
  {'word': 'وحید', 'emoji': '🧍‍♂️', 'translation': 'تنها'},
  {'word': 'أقرب', 'emoji': '📍', 'translation': 'نزدیک‌تر، نزدیک‌ترین'},
  {'word': 'مسيرة', 'emoji': '🚶', 'translation': 'راهپیمایی'},
  {'word': 'ساعدکم الله', 'emoji': '🤝', 'translation': 'خسته نباشید'},
];

final List<Map<String, String>> lesson17Part3Vocab = [
  {'ar': 'شبکة کبیرة', 'fa': 'تور بزرگ', 'emoji': '🕸️'},
  {'ar': 'هَرَبَ', 'fa': 'فرار کرد', 'emoji': '🏃‍♂️'},
  {'ar': 'حزین', 'fa': 'غمگین', 'emoji': '😔'},
  {'ar': 'خافَ', 'fa': 'ترسید', 'emoji': '😨'},
];

final List<Map<String, String>> lesson18Part1Vocab = [
  {'word': 'بارد', 'emoji': '🧊', 'translation': 'سرد'},
  {'word': 'سَمَكَة', 'emoji': '🐟', 'translation': 'ماهی'},
  {'word': 'خافَ', 'emoji': '😨', 'translation': 'ترسید'},
  {'word': 'ذاهِب', 'emoji': '🚶‍♂️', 'translation': 'رفته'},
  {'word': 'حارّ', 'emoji': '🔥', 'translation': 'گرم'},
  {'word': 'صَنَعَ', 'emoji': '🛠️', 'translation': 'ساخت'},
  {'word': 'رَجَعَ', 'emoji': '🔙', 'translation': 'برگشت'},
  {'word': 'حَصَدَ', 'emoji': '🌾', 'translation': 'درو کرد'},
];

final List<Map<String, String>> lesson18Part2Vocab = [
  {'word': 'اقرب', 'emoji': '🧲', 'translation': 'نزدیک‌تر'},
  {'word': 'مسيرة', 'emoji': '🚶‍♂️', 'translation': 'راهپیمایی'},
  {'word': 'ساعدکم الله', 'emoji': '👏', 'translation': 'خسته نباشید'},
  {'word': 'يوجد', 'emoji': '🔸', 'translation': 'وجود دارد'},
];

final List<Map<String, String>> lesson18Part3Vocab = [
  {'ar': 'وَجَدَ', 'fa': 'پیدا کرد', 'emoji': '🔎'},
  {'ar': 'وقع', 'fa': 'افتاد', 'emoji': '🍂'},
  {'ar': 'سَمَحَ لِ', 'fa': 'اجازه داد به (به خاطر حرف اضافه‌ی «لِ»)', 'emoji': '✅'},
  {'ar': 'قَذَفَ', 'fa': 'انداخت، پرتاب کرد', 'emoji': '🤾‍♂️'},
  {'ar': 'شَعَرَ بِ', 'fa': 'احساسِ ... کرد', 'emoji': '💓'},
  {'ar': 'جِدّاً', 'fa': 'بسیار، خیلی', 'emoji': '💯'},
];

final List<Map<String, String>> lesson19Part1Vocab = [
  {'word': 'أَبْيَض', 'emoji': '⬜', 'translation': 'سفید'},
  {'word': 'أَحْمَر', 'emoji': '🟥', 'translation': 'سرخ'},
  {'word': 'أَخْضَر', 'emoji': '🟩', 'translation': 'سبز'},
  {'word': 'أَزْرَق', 'emoji': '🟦', 'translation': 'آبی'},
  {'word': 'أَسْوَد', 'emoji': '⬛', 'translation': 'سیاه'},
  {'word': 'أَصْفَر', 'emoji': '🟨', 'translation': 'زرد'},
  {'word': 'أَمْسِ', 'emoji': '⏪', 'translation': 'دیروز'},
  {'word': 'اَلْيَوْم', 'emoji': '⏱️', 'translation': 'امروز'},
];

final List<Map<String, String>> lesson19Part2Vocab = [
  {'word': 'ابيض', 'emoji': '⬜', 'translation': 'سفید'},
  {'word': 'احمر', 'emoji': '🟥', 'translation': 'سرخ'},
  {'word': 'اخضر', 'emoji': '🟩', 'translation': 'سبز'},
  {'word': 'ازرق', 'emoji': '🟦', 'translation': 'آبی'},
  {'word': 'اسود', 'emoji': '⬛', 'translation': 'سیاه'},
  {'word': 'اصفر', 'emoji': '🟨', 'translation': 'زرد'},
  {'word': 'امس', 'emoji': '⏪', 'translation': 'دیروز'},
  {'word': 'اليوم', 'emoji': '⏱️', 'translation': 'امروز'},
  {'word': 'غداً', 'emoji': '⏩', 'translation': 'فردا'},
  {'word': 'يوم', 'emoji': '📅', 'translation': 'روز'},
];

final List<Map<String, String>> lesson19Part3Vocab = [
  {'ar': 'أَلْوان', 'fa': 'رنگ‌ها (مفرد: لَوْن)', 'emoji': '🎨'},
  {'ar': 'اَلسَّبْت', 'fa': 'شنبه', 'emoji': '0️⃣ 🗓️'},
  {'ar': 'اَلْأَحَد', 'fa': 'یکشنبه', 'emoji': '1️⃣ 🗓️'},
  {'ar': 'اَلْإِثْنَيْنِ', 'fa': 'دوشنبه', 'emoji': '2️⃣ 🗓️'},
  {'ar': 'اَلثُّلَاثَاء', 'fa': 'سه‌شنبه', 'emoji': '3️⃣ 🗓️'},
  {'ar': 'اَلْأَرْبِعَاء', 'fa': 'چهارشنبه', 'emoji': '4️⃣ 🗓️'},
  {'ar': 'اَلْخَمِيس', 'fa': 'پنجشنبه', 'emoji': '5️⃣ 🗓️'},
  {'ar': 'رَبِيع', 'fa': 'بهار', 'emoji': '🌸'},
  {'ar': 'صَيْف', 'fa': 'تابستان', 'emoji': '☀️'},
  {'ar': 'خَرِيف', 'fa': 'پاییز', 'emoji': '🍂'},
  {'ar': 'شِتاء', 'fa': 'زمستان', 'emoji': '❄️'},
  {'ar': 'حَياة', 'fa': 'زندگی', 'emoji': '🌱'},
];

final List<Map<String, String>> lesson20Part1Vocab = [];

final List<Map<String, String>> lesson20Part2Vocab = [
  {'word': 'انا', 'emoji': '🧑‍💻', 'translation': 'من'},
  {'word': 'انتَ', 'emoji': '👦 👉', 'translation': 'تو (مذکر)'},
  {'word': 'انتِ', 'emoji': '👧 👉', 'translation': 'تو (مونث)'},
  {'word': 'هو', 'emoji': '👨', 'translation': 'او'},
  {'word': 'هی', 'emoji': '👩', 'translation': 'او'},
  {'word': 'نحن', 'emoji': '👥', 'translation': 'ما'},
  {'word': 'انتم', 'emoji': '👨👨👨 👉', 'translation': 'شما'},
  {'word': 'انتن', 'emoji': '👩‍👩‍👩 👉', 'translation': 'شما (مونث)'},
  {'word': 'انتما', 'emoji': '👫 👉', 'translation': 'شما دو نفر'},
  {'word': 'هم', 'emoji': '👨👨👨', 'translation': 'ایشان'},
  {'word': 'هن', 'emoji': '👩‍👩‍👩', 'translation': 'ایشان (مونث)'},
  {'word': 'هما', 'emoji': '👫', 'translation': 'آن دو نفر'},
];

final List<Map<String, String>> lesson20Part3Vocab = [
  {'ar': 'كَتَبْتُ', 'fa': 'نوشتم', 'emoji': '🧑‍💻'},
  {'ar': 'كَتَبْتَ', 'fa': 'نوشتی (مذکر)', 'emoji': '👦 👉'},
  {'ar': 'كَتَبْتِ', 'fa': 'نوشتی (مونث)', 'emoji': '👧 👉'},
  {'ar': 'كَتَبَ', 'fa': 'نوشت (مذکر)', 'emoji': '👨'},
  {'ar': 'كَتَبَتْ', 'fa': 'نوشت (مونث)', 'emoji': '👩'},
  {'ar': 'كَتَبْنَا', 'fa': 'نوشتیم', 'emoji': '👥'},
  {'ar': 'كَتَبْتُمْ', 'fa': 'نوشتید (جمع مذکر)', 'emoji': '👨👨👨 👉'},
  {'ar': 'كَتَبْتُنَّ', 'fa': 'نوشتید (جمع مونث)', 'emoji': '👩‍👩‍👩 👉'},
  {'ar': 'كَتَبْتُمَا', 'fa': 'نوشتید (مثنی)', 'emoji': '👫 👉'},
  {'ar': 'كَتَبُوا', 'fa': 'نوشتند (جمع مذکر)', 'emoji': '👨👨👨'},
  {'ar': 'كَتَبْنَ', 'fa': 'نوشتند (جمع مونث)', 'emoji': '👩‍👩‍👩'},
  {'ar': 'كَتَبَا', 'fa': 'نوشتند (مثنی مذکر)', 'emoji': '👬'},
  {'ar': 'كَتَبَتَا', 'fa': 'نوشتند (مثنی مونث)', 'emoji': '👭'},
];

class ModernHomeScreen extends StatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  State<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends State<ModernHomeScreen> with SingleTickerProviderStateMixin {
  int _currentGrade = AuthManager.selectedGrade; // تنها منبع حقیقت مرکزی
  int _bottomNavIndex = 0; // پیش‌فرض: خانه
  bool _isDialogShowing = false; // برای جلوگیری از نمایش چندباره کادر تبریک
  
  // دیتابیس دروس برای ۳ پایه مجزا
  final Map<int, List<Map<String, dynamic>>> _gradeSubjects = {
    0: [
      {'title': 'ریاضیات هفتم', 'image': 'image/3.webp', 'color': const Color(0xFFF43F5E), 'progress': 0.0, 'progressText': '0%', 'reward': '+۲۰ 🪙'},
      {'title': 'علوم تجربی هفتم', 'image': 'image/4.webp', 'color': const Color(0xFF64748B), 'progress': 0.0, 'progressText': '0%', 'reward': '+۱۵ 🪙'},
      {'title': 'ادبیات فارسی هفتم', 'image': 'image/2.webp', 'color': const Color(0xFFC89657), 'progress': 0.0, 'progressText': '0%', 'reward': '+۱۰ 🪙'},
      {'title': 'زبان انگلیسی هفتم', 'image': 'image/5.webp', 'color': const Color(0xFF0284C7), 'progress': 0.0, 'progressText': '0%', 'reward': '+۲۰ 🪙'},
      {'title': 'عربی هفتم', 'image': 'image/7.webp', 'color': const Color(0xFFF97316), 'progress': 0.0, 'progressText': '0%', 'reward': '+۱۰ 🪙'},
      {'title': 'قرآن هفتم', 'image': 'image/8.webp', 'color': const Color(0xFF10B981), 'progress': 0.0, 'progressText': '0%', 'reward': '+۳۰ 🪙'},
      {'title': 'پیام‌های آسمان هفتم', 'image': 'image/9.webp', 'color': const Color(0xFF8B5CF6), 'progress': 0.0, 'progressText': '0%', 'reward': '+۲۰ 🪙'},
      {'title': 'مطالعات اجتماعی هفتم', 'image': 'image/6.webp', 'color': const Color(0xFF06B6D4), 'progress': 0.0, 'progressText': '0%', 'reward': '+۲۵ 🪙'},
    ],
    1: [
      {'title': 'ریاضیات هشتم', 'image': 'image/3.webp', 'color': const Color(0xFFF43F5E), 'progress': 0.0, 'progressText': '0%', 'reward': '+۳۰ 🪙'},
      {'title': 'علوم تجربی هشتم', 'image': 'image/4.webp', 'color': const Color(0xFF64748B), 'progress': 0.0, 'progressText': '0%', 'reward': '+۲۵ 🪙'},
      {'title': 'ادبیات فارسی هشتم', 'image': 'image/2.webp', 'color': const Color(0xFFC89657), 'progress': 0.0, 'progressText': '0%', 'reward': '+۲۰ 🪙'},
      {'title': 'زبان انگلیسی هشتم', 'image': 'image/5.webp', 'color': const Color(0xFF0284C7), 'progress': 0.0, 'progressText': '0%', 'reward': '+۳۵ 🪙'},
      {'title': 'عربی هشتم', 'image': 'image/7.webp', 'color': const Color(0xFFF97316), 'progress': 0.0, 'progressText': '0%', 'reward': '+۱۵ 🪙'},
      {'title': 'قرآن هشتم', 'image': 'image/8.webp', 'color': const Color(0xFF10B981), 'progress': 0.0, 'progressText': '0%', 'reward': '+۴۰ 🪙'},
      {'title': 'پیام‌های آسمان هشتم', 'image': 'image/9.webp', 'color': const Color(0xFF8B5CF6), 'progress': 0.0, 'progressText': '0%', 'reward': '+۲۵ 🪙'},
      {'title': 'مطالعات اجتماعی هشتم', 'image': 'image/6.webp', 'color': const Color(0xFF06B6D4), 'progress': 0.0, 'progressText': '0%', 'reward': '+۳۰ 🪙'},
    ],
    2: [
      {'title': 'ریاضیات نهم', 'image': 'image/3.webp', 'color': const Color(0xFFF43F5E), 'progress': 0.0, 'progressText': '0%', 'reward': '+۵۰ 🪙'},
      {'title': 'علوم تجربی نهم', 'image': 'image/4.webp', 'color': const Color(0xFF64748B), 'progress': 0.0, 'progressText': '0%', 'reward': '+۴۵ 🪙'},
      {'title': 'ادبیات فارسی نهم', 'image': 'image/2.webp', 'color': const Color(0xFFC89657), 'progress': 0.0, 'progressText': '0%', 'reward': '+۴۰ 🪙'},
      {'title': 'زبان انگلیسی نهم', 'image': 'image/5.webp', 'color': const Color(0xFF0284C7), 'progress': 0.0, 'progressText': '0%', 'reward': '+۴۰ 🪙'},
      {'title': 'عربی نهم', 'image': 'image/7.webp', 'color': const Color(0xFFF97316), 'progress': 0.0, 'progressText': '0%', 'reward': '+۳۰ 🪙'},
      {'title': 'قرآن نهم', 'image': 'image/8.webp', 'color': const Color(0xFF10B981), 'progress': 0.0, 'progressText': '0%', 'reward': '+۵۰ 🪙'},
      {'title': 'پیام‌های آسمان نهم', 'image': 'image/9.webp', 'color': const Color(0xFF8B5CF6), 'progress': 0.0, 'progressText': '0%', 'reward': '+۳۵ 🪙'},
      {'title': 'مطالعات اجتماعی نهم', 'image': 'image/6.webp', 'color': const Color(0xFF06B6D4), 'progress': 0.0, 'progressText': '0%', 'reward': '+۵۰ 🪙'},
    ],
  };

  final List<Map<String, String>> _grades = [
    {'title': 'هفتم', 'subtitle': 'پایه'},
    {'title': 'هشتم', 'subtitle': 'پایه'},
    {'title': 'نهم', 'subtitle': 'پایه'},
  ];

  late PageController _gradePageController;

  @override
  void initState() {
    super.initState();
    _currentGrade = AuthManager.selectedGrade;
    _gradePageController = PageController(initialPage: _currentGrade);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentGrade = AuthManager.selectedGrade;
    if (_gradePageController.hasClients) {
      if (_gradePageController.page?.round() != _currentGrade) {
        _gradePageController.jumpToPage(_currentGrade);
      }
    }
  }

  @override
  void dispose() {
    _gradePageController.dispose();
    super.dispose();
  }

  // کمکی برای بارگذاری درست آواتار
  ImageProvider _getAvatarProvider(String path) {
    if (path.isEmpty) {
      return const AssetImage('image/avatar/1.webp');
    }
    return AssetImage(path);
  }

  @override
  Widget build(BuildContext context) {
    _currentGrade = AuthManager.selectedGrade;

    // پنهان کردن کامل نوار ناوبری پایین در صفحه ورود/ثبت‌نام (وقتی کاربر لاگین نکرده و روی تب پروفایل است)
    final bool hideBottomNav = (_bottomNavIndex == 3 && !AuthManager.isLoggedIn);

    // بررسی هدیه خوش‌آمدگویی: فقط و فقط وقتی کاربر وارد حساب شده، شماره دارد و هدیه معلق دارد
    if (AuthManager.isLoggedIn &&
        AuthManager.phoneNumber.isNotEmpty &&
        AuthManager.pendingWelcomeGift &&
        _bottomNavIndex == 0 &&
        !_isDialogShowing) {
      _isDialogShowing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWelcomeGiftDialog(context);
      });
    }

    return PopScope(
      canPop: _bottomNavIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _bottomNavIndex != 0) {
          setState(() {
            _bottomNavIndex = 0;
            _currentGrade = AuthManager.selectedGrade;
            _gradePageController.dispose();
            _gradePageController = PageController(initialPage: _currentGrade);
          });
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: _buildCurrentTabContent(),
            ),
            if (!hideBottomNav)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: _buildBottomNav(),
              ),
          ],
        ),
      ),
    );
  }

  // دیالوگ تبریک هدیه ثبت نام
  void _showWelcomeGiftDialog(BuildContext context) {
    if (!AuthManager.isLoggedIn || AuthManager.phoneNumber.isEmpty || !AuthManager.pendingWelcomeGift) {
      AuthManager.pendingWelcomeGift = false;
      _isDialogShowing = false;
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            backgroundColor: const Color(0xFF1E1B4B),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB703).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFFB703), width: 2),
                    ),
                    child: const Text('🎁', style: TextStyle(fontSize: 42)),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'هدیه ثبت نام',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'به خاطر پیوستن، پاداش ویژه به حسابتان واریز شد',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // کادر سکه (فقط سکه و در وسط)
                  Container(
                    width: 180,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFB703), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFB703).withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🪙', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: const Text(
                            '+500',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFFB703),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // دکمه شروع یادگیری با انرژی مضاعف
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          setState(() {
                            AuthManager.pendingWelcomeGift = false;
                            AuthManager.save();
                            _isDialogShowing = false;
                          });
                          Navigator.pop(context);
                        },
                        child: const Center(
                          child: Text(
                            'شروع یادگیری با انرژی مضاعف 🚀',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentTabContent() {
    _currentGrade = AuthManager.selectedGrade;
    switch (_bottomNavIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildEmptyPage('لیگ برتر 🏆', Icons.emoji_events_rounded);
      case 2:
        return StoreScreen(onStoreUpdated: () => setState(() {}));
      case 3:
        return ProfileScreen(
          isStandalone: false,
          onGoHome: () => setState(() {
            _bottomNavIndex = 0;
            _currentGrade = AuthManager.selectedGrade;
            _gradePageController.dispose();
            _gradePageController = PageController(initialPage: _currentGrade);
          }),
          onGradeChanged: (newGrade) {
            setState(() {
              _currentGrade = newGrade;
              AuthManager.selectedGrade = newGrade;
              AuthManager.save();
              if (_gradePageController.hasClients) {
                _gradePageController.jumpToPage(newGrade);
              }
            });
          },
          onProfileUpdated: () {
            setState(() {});
          },
        );
      default:
        return _buildHomePage();
    }
  }

  // ۱. صفحه خانه (با PageView برای اسکرول افقی بدون باگ)
  Widget _buildHomePage() {
    _currentGrade = AuthManager.selectedGrade;
    if (_gradePageController.hasClients && _gradePageController.page?.round() != _currentGrade) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_gradePageController.hasClients) {
          _gradePageController.jumpToPage(_currentGrade);
        }
      });
    }

    return Column(
      children: [
        _buildTopDashboardSection(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PageView.builder(
              controller: _gradePageController,
              itemCount: 3,
              onPageChanged: (index) {
                if (_currentGrade != index) {
                  setState(() {
                    _currentGrade = index;
                    AuthManager.selectedGrade = index;
                    AuthManager.save();
                  });
                }
              },
              itemBuilder: (context, gradeIndex) {
                final currentSubjects = _gradeSubjects[gradeIndex]!;
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: _buildLeagueBanner(gradeIndex),
                      ),
                    ),
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildSubjectCard(currentSubjects[index]);
                        },
                        childCount: currentSubjects.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 16),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPage(String title, IconData icon) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF4C1D95).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 50, color: const Color(0xFF4C1D95)),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 8),
            Text('این بخش هنوز ساخته نشده است.', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  // داشبورد بالای صفحه خانه (نمایش سکه و الماس صفر قبل از ورود)
  Widget _buildTopDashboardSection() {
    String displayName = AuthManager.userName.isEmpty ? 'دانش‌آموز نابغه' : AuthManager.userName;
    _currentGrade = AuthManager.selectedGrade;

    return Container(
      padding: const EdgeInsets.only(top: 38, left: 20, right: 20, bottom: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x330F172A),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: ProfileScreen(
                              isStandalone: true,
                              onGoHome: () => Navigator.pop(context),
                              onGradeChanged: (newGrade) {
                                setState(() {
                                  _currentGrade = newGrade;
                                  AuthManager.selectedGrade = newGrade;
                                  AuthManager.save();
                                });
                              },
                              onProfileUpdated: () {
                                setState(() {
                                  _currentGrade = AuthManager.selectedGrade;
                                  if (_gradePageController.hasClients) {
                                    _gradePageController.jumpToPage(_currentGrade);
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ).then((_) {
                        if (mounted) {
                          setState(() {
                            _currentGrade = AuthManager.selectedGrade;
                            AuthManager.save();
                            if (_gradePageController.hasClients) {
                              _gradePageController.jumpToPage(_currentGrade);
                            }
                          });
                        }
                      });
                    },
                    child: SizedBox(
                      width: 52,
                      height: 52,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipOval(
                            child: Image(
                              image: _getAvatarProvider(AuthManager.userAvatar),
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF818CF8), width: 2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: const Row(
                          children: [
                            Text('🔥 سطح ۸', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFF43F5E))),
                            SizedBox(width: 3),
                            Text('• قهرمان', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    Text(
                      '${AuthManager.coins}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                    ),
                    const SizedBox(width: 2),
                    const Text('🪙', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // انتخابگر پایه‌ها
          Container(
            height: 46,
            padding: const EdgeInsets.all(4),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  left: _getTabPosition(context),
                  top: 0,
                  bottom: 0,
                  width: (MediaQuery.of(context).size.width - 48) / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4F46E5).withOpacity(0.5),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: List.generate(_grades.length, (index) {
                    final isSelected = _currentGrade == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentGrade = index;
                            AuthManager.selectedGrade = index;
                            AuthManager.save();
                            if (_gradePageController.hasClients) {
                              _gradePageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: isSelected ? 13 : 12,
                              fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_grades[index]['subtitle']!, style: TextStyle(fontSize: isSelected ? 9 : 9, fontWeight: FontWeight.normal)),
                                const SizedBox(width: 3),
                                Text(_grades[index]['title']!),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getTabPosition(BuildContext context) {
    final double totalWidth = MediaQuery.of(context).size.width - 48;
    final double tabWidth = totalWidth / 3;
    if (_currentGrade == 0) return tabWidth * 2;
    if (_currentGrade == 1) return tabWidth * 1;
    return 0;
  }

  // بنر مسابقه
  Widget _buildLeagueBanner([int? gradeIndex]) {
    final int currentGrade = gradeIndex ?? _currentGrade;
    String titleText = 'لیگ نخبگان فضایی هفتم';
    Widget targetScreen = const League7Screen();

    if (currentGrade == 1) {
      titleText = 'لیگ نخبگان فضایی هشتم';
      targetScreen = const League8Screen();
    } else if (currentGrade == 2) {
      titleText = 'لیگ نخبگان فضایی نهم';
      targetScreen = const League9Screen();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: const DecorationImage(
          image: AssetImage('image/10.webp'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4C1D95).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetScreen),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  const Color(0xFF2E1065).withOpacity(0.9),
                  const Color(0xFF4C1D95).withOpacity(0.7),
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text('🏆', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Text(
                          titleText,
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Text('۱ روز ⏳', style: TextStyle(color: Colors.white, fontSize: 9)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF8C00).withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => targetScreen),
                        );
                      },
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('⚡', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 6),
                            Text(
                              'شروع طوفانی چالش امروز',
                              style: TextStyle(
                                color: Color(0xFF312E81),
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  // محاسبه پیشرفت واقعی دروس بر اساس بخش‌های پاس شده (تیک سبز)
  Map<String, dynamic> _getSubjectProgress(String title) {
    int completedCount = 0;
    int totalCount = 0;

    switch (title) {
      // ===== پایه هفتم =====
      case 'ریاضیات هفتم':
      case 'ریاضی هفتم':
        final list = [
          AuthManager.riyazi7Chapter1Completed,
          AuthManager.riyazi7Chapter2Completed,
          AuthManager.riyazi7Chapter3Completed,
          AuthManager.riyazi7Chapter4Completed,
          AuthManager.riyazi7Chapter5Completed,
          AuthManager.riyazi7Chapter6Completed,
          AuthManager.riyazi7Chapter7Completed,
          AuthManager.riyazi7Chapter8Completed,
          AuthManager.riyazi7Chapter9Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'علوم تجربی هفتم':
        final list = [
          AuthManager.olom7Lesson1Part1Completed,
          AuthManager.olom7Lesson1Part2Completed,
          AuthManager.olom7Lesson1Part3Completed,
          AuthManager.olom7Lesson2Part1Completed,
          AuthManager.olom7Lesson2Part2Completed,
          AuthManager.olom7Lesson2Part3Completed,
          AuthManager.olom7Lesson3Part1Completed,
          AuthManager.olom7Lesson3Part2Completed,
          AuthManager.olom7Lesson3Part3Completed,
          AuthManager.olom7Lesson4Part1Completed,
          AuthManager.olom7Lesson4Part2Completed,
          AuthManager.olom7Lesson4Part3Completed,
          AuthManager.olom7Lesson5Part1Completed,
          AuthManager.olom7Lesson5Part2Completed,
          AuthManager.olom7Lesson5Part3Completed,
          AuthManager.olom7Lesson6Part1Completed,
          AuthManager.olom7Lesson6Part2Completed,
          AuthManager.olom7Lesson6Part3Completed,
          AuthManager.olom7Lesson7Part1Completed,
          AuthManager.olom7Lesson7Part2Completed,
          AuthManager.olom7Lesson7Part3Completed,
          AuthManager.olom7Lesson8Part1Completed,
          AuthManager.olom7Lesson8Part2Completed,
          AuthManager.olom7Lesson8Part3Completed,
          AuthManager.olom7Lesson9Part1Completed,
          AuthManager.olom7Lesson9Part2Completed,
          AuthManager.olom7Lesson9Part3Completed,
          AuthManager.olom7Lesson10Part1Completed,
          AuthManager.olom7Lesson10Part2Completed,
          AuthManager.olom7Lesson10Part3Completed,
          AuthManager.olom7Lesson11Part1Completed,
          AuthManager.olom7Lesson11Part2Completed,
          AuthManager.olom7Lesson11Part3Completed,
          AuthManager.olom7Lesson12Part1Completed,
          AuthManager.olom7Lesson12Part2Completed,
          AuthManager.olom7Lesson12Part3Completed,
          AuthManager.olom7Lesson13Part1Completed,
          AuthManager.olom7Lesson13Part2Completed,
          AuthManager.olom7Lesson13Part3Completed,
          AuthManager.olom7Lesson14Part1Completed,
          AuthManager.olom7Lesson14Part2Completed,
          AuthManager.olom7Lesson14Part3Completed,
          AuthManager.olom7Lesson15Part1Completed,
          AuthManager.olom7Lesson15Part2Completed,
          AuthManager.olom7Lesson15Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'ادبیات فارسی هفتم':
      case 'فارسی هفتم':
        final list = [
          AuthManager.farsi7Lesson1Part1Completed,
          AuthManager.farsi7Lesson1Part2Completed,
          AuthManager.farsi7Lesson1Part3Completed,
          AuthManager.farsi7Lesson2Part1Completed,
          AuthManager.farsi7Lesson2Part2Completed,
          AuthManager.farsi7Lesson2Part3Completed,
          AuthManager.farsi7Lesson3Part1Completed,
          AuthManager.farsi7Lesson3Part2Completed,
          AuthManager.farsi7Lesson3Part3Completed,
          AuthManager.farsi7Lesson4Part1Completed,
          AuthManager.farsi7Lesson4Part2Completed,
          AuthManager.farsi7Lesson4Part3Completed,
          AuthManager.farsi7Lesson5Part1Completed,
          AuthManager.farsi7Lesson5Part2Completed,
          AuthManager.farsi7Lesson5Part3Completed,
          AuthManager.farsi7Lesson6Part1Completed,
          AuthManager.farsi7Lesson6Part2Completed,
          AuthManager.farsi7Lesson6Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'زبان انگلیسی هفتم':
        final list = [
          AuthManager.zaban7WelcomePart1Completed,
          AuthManager.zaban7WelcomePart2Completed,
          AuthManager.zaban7WelcomePart3Completed,
          AuthManager.zaban7Lesson1Part1Completed,
          AuthManager.zaban7Lesson1Part2Completed,
          AuthManager.zaban7Lesson1Part3Completed,
          AuthManager.zaban7Lesson3Part1Completed,
          AuthManager.zaban7Lesson3Part2Completed,
          AuthManager.zaban7Lesson3Part3Completed,
          AuthManager.zaban7Lesson4Part1Completed,
          AuthManager.zaban7Lesson4Part2Completed,
          AuthManager.zaban7Lesson4Part3Completed,
          AuthManager.zaban7Lesson5Part1Completed,
          AuthManager.zaban7Lesson5Part2Completed,
          AuthManager.zaban7Lesson5Part3Completed,
          AuthManager.zaban7Lesson6Part1Completed,
          AuthManager.zaban7Lesson6Part2Completed,
          AuthManager.zaban7Lesson6Part3Completed,
          AuthManager.zaban7Lesson7Part1Completed,
          AuthManager.zaban7Lesson7Part2Completed,
          AuthManager.zaban7Lesson7Part3Completed,
          AuthManager.zaban7Lesson8Part1Completed,
          AuthManager.zaban7Lesson8Part2Completed,
          AuthManager.zaban7Lesson8Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'عربی هفتم':
        final list = [
          AuthManager.lesson1Part1Completed,
          AuthManager.lesson1Part2Completed,
          AuthManager.lesson1Part3Completed,
          AuthManager.lesson2Part1Completed,
          AuthManager.lesson2Part2Completed,
          AuthManager.lesson2Part3Completed,
          AuthManager.lesson3Part1Completed,
          AuthManager.lesson3Part2Completed,
          AuthManager.lesson3Part3Completed,
          AuthManager.lesson4Part1Completed,
          AuthManager.lesson4Part2Completed,
          AuthManager.lesson4Part3Completed,
          AuthManager.lesson5Part1Completed,
          AuthManager.lesson5Part2Completed,
          AuthManager.lesson5Part3Completed,
          AuthManager.lesson6Part1Completed,
          AuthManager.lesson6Part2Completed,
          AuthManager.lesson6Part3Completed,
          AuthManager.lesson7Part1Completed,
          AuthManager.lesson7Part2Completed,
          AuthManager.lesson7Part3Completed,
          AuthManager.lesson8Part1Completed,
          AuthManager.lesson8Part2Completed,
          AuthManager.lesson8Part3Completed,
          AuthManager.lesson9Part1Completed,
          AuthManager.lesson9Part2Completed,
          AuthManager.lesson9Part3Completed,
          AuthManager.lesson10Part1Completed,
          AuthManager.lesson10Part2Completed,
          AuthManager.lesson10Part3Completed,
          AuthManager.lesson11Part1Completed,
          AuthManager.lesson11Part2Completed,
          AuthManager.lesson11Part3Completed,
          AuthManager.lesson12Part1Completed,
          AuthManager.lesson12Part2Completed,
          AuthManager.lesson12Part3Completed,
          AuthManager.lesson13Part1Completed,
          AuthManager.lesson13Part2Completed,
          AuthManager.lesson13Part3Completed,
          AuthManager.lesson14Part1Completed,
          AuthManager.lesson14Part2Completed,
          AuthManager.lesson14Part3Completed,
          AuthManager.lesson15Part1Completed,
          AuthManager.lesson15Part2Completed,
          AuthManager.lesson15Part3Completed,
          AuthManager.lesson16Part1Completed,
          AuthManager.lesson16Part2Completed,
          AuthManager.lesson16Part3Completed,
          AuthManager.lesson17Part1Completed,
          AuthManager.lesson17Part2Completed,
          AuthManager.lesson17Part3Completed,
          AuthManager.lesson20Part1Completed,
          AuthManager.lesson20Part2Completed,
          AuthManager.lesson20Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'قرآن هفتم':
        final list = [
          AuthManager.quran7Lesson1Part1Completed,
          AuthManager.quran7Lesson1Part2Completed,
          AuthManager.quran7Lesson1Part3Completed,
          AuthManager.quran7Lesson2Part1Completed,
          AuthManager.quran7Lesson2Part2Completed,
          AuthManager.quran7Lesson2Part3Completed,
          AuthManager.quran7Lesson3Part1Completed,
          AuthManager.quran7Lesson3Part2Completed,
          AuthManager.quran7Lesson3Part3Completed,
          AuthManager.quran7Lesson4Part1Completed,
          AuthManager.quran7Lesson4Part2Completed,
          AuthManager.quran7Lesson4Part3Completed,
          AuthManager.quran7Lesson5Part1Completed,
          AuthManager.quran7Lesson5Part2Completed,
          AuthManager.quran7Lesson5Part3Completed,
          AuthManager.quran7Lesson6Part1Completed,
          AuthManager.quran7Lesson6Part2Completed,
          AuthManager.quran7Lesson6Part3Completed,
          AuthManager.quran7Lesson7Part1Completed,
          AuthManager.quran7Lesson7Part2Completed,
          AuthManager.quran7Lesson7Part3Completed,
          AuthManager.quran7Lesson8Part1Completed,
          AuthManager.quran7Lesson8Part2Completed,
          AuthManager.quran7Lesson8Part3Completed,
          AuthManager.quran9Lesson9Part1Completed, // will be quran7Lesson9
          AuthManager.quran7Lesson9Part1Completed,
          AuthManager.quran7Lesson9Part2Completed,
          AuthManager.quran7Lesson9Part3Completed,
          AuthManager.quran7Lesson10Part1Completed,
          AuthManager.quran7Lesson10Part2Completed,
          AuthManager.quran7Lesson10Part3Completed,
          AuthManager.quran7Lesson11Part1Completed,
          AuthManager.quran7Lesson11Part2Completed,
          AuthManager.quran7Lesson11Part3Completed,
          AuthManager.quran7Lesson12Part1Completed,
          AuthManager.quran7Lesson12Part2Completed,
          AuthManager.quran7Lesson12Part3Completed,
        ];
        // Ensure accurate list without duplicates:
        final quran7Unique = [
          AuthManager.quran7Lesson1Part1Completed,
          AuthManager.quran7Lesson1Part2Completed,
          AuthManager.quran7Lesson1Part3Completed,
          AuthManager.quran7Lesson2Part1Completed,
          AuthManager.quran7Lesson2Part2Completed,
          AuthManager.quran7Lesson2Part3Completed,
          AuthManager.quran7Lesson3Part1Completed,
          AuthManager.quran7Lesson3Part2Completed,
          AuthManager.quran7Lesson3Part3Completed,
          AuthManager.quran7Lesson4Part1Completed,
          AuthManager.quran7Lesson4Part2Completed,
          AuthManager.quran7Lesson4Part3Completed,
          AuthManager.quran7Lesson5Part1Completed,
          AuthManager.quran7Lesson5Part2Completed,
          AuthManager.quran7Lesson5Part3Completed,
          AuthManager.quran7Lesson6Part1Completed,
          AuthManager.quran7Lesson6Part2Completed,
          AuthManager.quran7Lesson6Part3Completed,
          AuthManager.quran7Lesson7Part1Completed,
          AuthManager.quran7Lesson7Part2Completed,
          AuthManager.quran7Lesson7Part3Completed,
          AuthManager.quran7Lesson8Part1Completed,
          AuthManager.quran7Lesson8Part2Completed,
          AuthManager.quran7Lesson8Part3Completed,
          AuthManager.quran7Lesson9Part1Completed,
          AuthManager.quran7Lesson9Part2Completed,
          AuthManager.quran7Lesson9Part3Completed,
          AuthManager.quran7Lesson10Part1Completed,
          AuthManager.quran7Lesson10Part2Completed,
          AuthManager.quran7Lesson10Part3Completed,
          AuthManager.quran7Lesson11Part1Completed,
          AuthManager.quran7Lesson11Part2Completed,
          AuthManager.quran7Lesson11Part3Completed,
          AuthManager.quran7Lesson12Part1Completed,
          AuthManager.quran7Lesson12Part2Completed,
          AuthManager.quran7Lesson12Part3Completed,
        ];
        totalCount = quran7Unique.length;
        completedCount = quran7Unique.where((c) => c).length;
        break;

      case 'پیام‌های آسمان هفتم':
        final list = [
          AuthManager.payam7Lesson1Part1Completed,
          AuthManager.payam7Lesson1Part2Completed,
          AuthManager.payam7Lesson1Part3Completed,
          AuthManager.payam7Lesson2Part1Completed,
          AuthManager.payam7Lesson2Part2Completed,
          AuthManager.payam7Lesson2Part3Completed,
          AuthManager.payam7Lesson3Part1Completed,
          AuthManager.payam7Lesson3Part2Completed,
          AuthManager.payam7Lesson3Part3Completed,
          AuthManager.payam7Lesson4Part1Completed,
          AuthManager.payam7Lesson4Part2Completed,
          AuthManager.payam7Lesson4Part3Completed,
          AuthManager.payam7Lesson5Part1Completed,
          AuthManager.payam7Lesson5Part2Completed,
          AuthManager.payam7Lesson5Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'مطالعات اجتماعی هفتم':
        final list = [
          AuthManager.motaleat7Lesson1Part1Completed,
          AuthManager.motaleat7Lesson1Part2Completed,
          AuthManager.motaleat7Lesson1Part3Completed,
          AuthManager.motaleat7Lesson2Part1Completed,
          AuthManager.motaleat7Lesson2Part2Completed,
          AuthManager.motaleat7Lesson2Part3Completed,
          AuthManager.motaleat7Lesson3Part1Completed,
          AuthManager.motaleat7Lesson3Part2Completed,
          AuthManager.motaleat7Lesson3Part3Completed,
          AuthManager.motaleat7Lesson4Part1Completed,
          AuthManager.motaleat7Lesson4Part2Completed,
          AuthManager.motaleat7Lesson4Part3Completed,
          AuthManager.motaleat7Lesson5Part1Completed,
          AuthManager.motaleat7Lesson5Part2Completed,
          AuthManager.motaleat7Lesson5Part3Completed,
          AuthManager.motaleat7Lesson6Part1Completed,
          AuthManager.motaleat7Lesson6Part2Completed,
          AuthManager.motaleat7Lesson6Part3Completed,
          AuthManager.motaleat7Lesson7Part1Completed,
          AuthManager.motaleat7Lesson7Part2Completed,
          AuthManager.motaleat7Lesson7Part3Completed,
          AuthManager.motaleat7Lesson8Part1Completed,
          AuthManager.motaleat7Lesson8Part2Completed,
          AuthManager.motaleat7Lesson8Part3Completed,
          AuthManager.motaleat7Lesson9Part1Completed,
          AuthManager.motaleat7Lesson9Part2Completed,
          AuthManager.motaleat7Lesson9Part3Completed,
          AuthManager.motaleat7Lesson10Part1Completed,
          AuthManager.motaleat7Lesson10Part2Completed,
          AuthManager.motaleat7Lesson10Part3Completed,
          AuthManager.motaleat7Lesson11Part1Completed,
          AuthManager.motaleat7Lesson11Part2Completed,
          AuthManager.motaleat7Lesson11Part3Completed,
          AuthManager.motaleat7Lesson12Part1Completed,
          AuthManager.motaleat7Lesson12Part2Completed,
          AuthManager.motaleat7Lesson12Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      // ===== پایه هشتم =====
      case 'ریاضیات هشتم':
      case 'ریاضی هشتم':
        final list = [
          AuthManager.riyazi8Chapter1Completed,
          AuthManager.riyazi8Chapter2Completed,
          AuthManager.riyazi8Chapter3Completed,
          AuthManager.riyazi8Chapter4Completed,
          AuthManager.riyazi8Chapter5Completed,
          AuthManager.riyazi8Chapter6Completed,
          AuthManager.riyazi8Chapter7Completed,
          AuthManager.riyazi8Chapter8Completed,
          AuthManager.riyazi8Chapter9Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'علوم تجربی هشتم':
        final list = [
          AuthManager.olom8Lesson1Part1Completed,
          AuthManager.olom8Lesson1Part2Completed,
          AuthManager.olom8Lesson1Part3Completed,
          AuthManager.olom8Lesson2Part1Completed,
          AuthManager.olom8Lesson2Part2Completed,
          AuthManager.olom8Lesson2Part3Completed,
          AuthManager.olom8Lesson3Part1Completed,
          AuthManager.olom8Lesson3Part2Completed,
          AuthManager.olom8Lesson3Part3Completed,
          AuthManager.olom8Lesson4Part1Completed,
          AuthManager.olom8Lesson4Part2Completed,
          AuthManager.olom8Lesson4Part3Completed,
          AuthManager.olom8Lesson5Part1Completed,
          AuthManager.olom8Lesson5Part2Completed,
          AuthManager.olom8Lesson5Part3Completed,
          AuthManager.olom8Lesson6Part1Completed,
          AuthManager.olom8Lesson6Part2Completed,
          AuthManager.olom8Lesson6Part3Completed,
          AuthManager.olom8Lesson7Part1Completed,
          AuthManager.olom8Lesson7Part2Completed,
          AuthManager.olom8Lesson7Part3Completed,
          AuthManager.olom8Lesson8Part1Completed,
          AuthManager.olom8Lesson8Part2Completed,
          AuthManager.olom8Lesson8Part3Completed,
          AuthManager.olom8Lesson9Part1Completed,
          AuthManager.olom8Lesson9Part2Completed,
          AuthManager.olom8Lesson9Part3Completed,
          AuthManager.olom8Lesson10Part1Completed,
          AuthManager.olom8Lesson10Part2Completed,
          AuthManager.olom8Lesson10Part3Completed,
          AuthManager.olom8Lesson11Part1Completed,
          AuthManager.olom8Lesson11Part2Completed,
          AuthManager.olom8Lesson11Part3Completed,
          AuthManager.olom8Lesson12Part1Completed,
          AuthManager.olom8Lesson12Part2Completed,
          AuthManager.olom8Lesson12Part3Completed,
          AuthManager.olom8Lesson13Part1Completed,
          AuthManager.olom8Lesson13Part2Completed,
          AuthManager.olom8Lesson13Part3Completed,
          AuthManager.olom8Lesson14Part1Completed,
          AuthManager.olom8Lesson14Part2Completed,
          AuthManager.olom8Lesson14Part3Completed,
          AuthManager.olom8Lesson15Part1Completed,
          AuthManager.olom8Lesson15Part2Completed,
          AuthManager.olom8Lesson15Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'ادبیات فارسی هشتم':
      case 'فارسی هشتم':
        final list = [
          AuthManager.farsi8Lesson1Part1Completed,
          AuthManager.farsi8Lesson1Part2Completed,
          AuthManager.farsi8Lesson1Part3Completed,
          AuthManager.farsi8Lesson2Part1Completed,
          AuthManager.farsi8Lesson2Part2Completed,
          AuthManager.farsi8Lesson2Part3Completed,
          AuthManager.farsi8Lesson3Part1Completed,
          AuthManager.farsi8Lesson3Part2Completed,
          AuthManager.farsi8Lesson3Part3Completed,
          AuthManager.farsi8Lesson4Part1Completed,
          AuthManager.farsi8Lesson4Part2Completed,
          AuthManager.farsi8Lesson4Part3Completed,
          AuthManager.farsi8Lesson5Part1Completed,
          AuthManager.farsi8Lesson5Part2Completed,
          AuthManager.farsi8Lesson5Part3Completed,
          AuthManager.farsi8Lesson6Part1Completed,
          AuthManager.farsi8Lesson6Part2Completed,
          AuthManager.farsi8Lesson6Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'زبان انگلیسی هشتم':
        final list = [
          AuthManager.zaban8Lesson1Part2Completed,
          AuthManager.zaban8Lesson1Part3Completed,
          AuthManager.zaban8Lesson2Part1Completed,
          AuthManager.zaban8Lesson2Part2Completed,
          AuthManager.zaban8Lesson2Part3Completed,
          AuthManager.zaban8Lesson3Part1Completed,
          AuthManager.zaban8Lesson3Part2Completed,
          AuthManager.zaban8Lesson3Part3Completed,
          AuthManager.zaban8Lesson4Part1Completed,
          AuthManager.zaban8Lesson4Part2Completed,
          AuthManager.zaban8Lesson4Part3Completed,
          AuthManager.zaban8Lesson5Part1Completed,
          AuthManager.zaban8Lesson5Part2Completed,
          AuthManager.zaban8Lesson5Part3Completed,
          AuthManager.zaban8Lesson6Part1Completed,
          AuthManager.zaban8Lesson6Part2Completed,
          AuthManager.zaban8Lesson6Part3Completed,
          AuthManager.zaban8Lesson7Part1Completed,
          AuthManager.zaban8Lesson7Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'عربی هشتم':
        final list = [
          AuthManager.arabic8Lesson1Part1Completed,
          AuthManager.arabic8Lesson1Part2Completed,
          AuthManager.arabic8Lesson1Part3Completed,
          AuthManager.arabic8Lesson2Part1Completed,
          AuthManager.arabic8Lesson2Part2Completed,
          AuthManager.arabic8Lesson2Part3Completed,
          AuthManager.arabic8Lesson3Part1Completed,
          AuthManager.arabic8Lesson3Part2Completed,
          AuthManager.arabic8Lesson3Part3Completed,
          AuthManager.arabic8Lesson4Part1Completed,
          AuthManager.arabic8Lesson4Part2Completed,
          AuthManager.arabic8Lesson4Part3Completed,
          AuthManager.arabic8Lesson5Part1Completed,
          AuthManager.arabic8Lesson5Part2Completed,
          AuthManager.arabic8Lesson5Part3Completed,
          AuthManager.arabic8Lesson6Part1Completed,
          AuthManager.arabic8Lesson6Part2Completed,
          AuthManager.arabic8Lesson6Part3Completed,
          AuthManager.arabic8Lesson7Part1Completed,
          AuthManager.arabic8Lesson7Part2Completed,
          AuthManager.arabic8Lesson7Part3Completed,
          AuthManager.arabic8Lesson8Part1Completed,
          AuthManager.arabic8Lesson8Part2Completed,
          AuthManager.arabic8Lesson8Part3Completed,
          AuthManager.arabic8Lesson9Part1Completed,
          AuthManager.arabic8Lesson9Part2Completed,
          AuthManager.arabic8Lesson9Part3Completed,
          AuthManager.arabic8Lesson10Part2Completed,
          AuthManager.arabic8Lesson10Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'قرآن هشتم':
        final list = [
          AuthManager.quran8Lesson1Part1Completed,
          AuthManager.quran8Lesson1Part2Completed,
          AuthManager.quran8Lesson1Part3Completed,
          AuthManager.quran8Lesson2Part1Completed,
          AuthManager.quran8Lesson2Part2Completed,
          AuthManager.quran8Lesson2Part3Completed,
          AuthManager.quran8Lesson3Part1Completed,
          AuthManager.quran8Lesson3Part2Completed,
          AuthManager.quran8Lesson3Part3Completed,
          AuthManager.quran8Lesson4Part1Completed,
          AuthManager.quran8Lesson4Part2Completed,
          AuthManager.quran8Lesson4Part3Completed,
          AuthManager.quran8Lesson5Part1Completed,
          AuthManager.quran8Lesson5Part2Completed,
          AuthManager.quran8Lesson5Part3Completed,
          AuthManager.quran8Lesson6Part1Completed,
          AuthManager.quran8Lesson6Part2Completed,
          AuthManager.quran8Lesson6Part3Completed,
          AuthManager.quran8Lesson7Part1Completed,
          AuthManager.quran8Lesson7Part2Completed,
          AuthManager.quran8Lesson7Part3Completed,
          AuthManager.quran8Lesson8Part1Completed,
          AuthManager.quran8Lesson8Part2Completed,
          AuthManager.quran8Lesson8Part3Completed,
          AuthManager.quran8Lesson9Part1Completed,
          AuthManager.quran8Lesson9Part2Completed,
          AuthManager.quran8Lesson9Part3Completed,
          AuthManager.quran8Lesson10Part1Completed,
          AuthManager.quran8Lesson10Part2Completed,
          AuthManager.quran8Lesson10Part3Completed,
          AuthManager.quran8Lesson11Part1Completed,
          AuthManager.quran8Lesson11Part2Completed,
          AuthManager.quran8Lesson11Part3Completed,
          AuthManager.quran8Lesson12Part1Completed,
          AuthManager.quran8Lesson12Part2Completed,
          AuthManager.quran8Lesson12Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'پیام‌های آسمان هشتم':
        final list = [
          AuthManager.payam8Lesson1Part1Completed,
          AuthManager.payam8Lesson1Part2Completed,
          AuthManager.payam8Lesson1Part3Completed,
          AuthManager.payam8Lesson2Part1Completed,
          AuthManager.payam8Lesson2Part2Completed,
          AuthManager.payam8Lesson2Part3Completed,
          AuthManager.payam8Lesson3Part1Completed,
          AuthManager.payam8Lesson3Part2Completed,
          AuthManager.payam8Lesson3Part3Completed,
          AuthManager.payam8Lesson4Part1Completed,
          AuthManager.payam8Lesson4Part2Completed,
          AuthManager.payam8Lesson4Part3Completed,
          AuthManager.payam8Lesson5Part1Completed,
          AuthManager.payam8Lesson5Part2Completed,
          AuthManager.payam8Lesson5Part3Completed,
          AuthManager.payam8Lesson6Part1Completed,
          AuthManager.payam8Lesson6Part2Completed,
          AuthManager.payam8Lesson6Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'مطالعات اجتماعی هشتم':
        final list = [
          AuthManager.motaleat8Lesson1Part1Completed,
          AuthManager.motaleat8Lesson1Part2Completed,
          AuthManager.motaleat8Lesson1Part3Completed,
          AuthManager.motaleat8Lesson2Part1Completed,
          AuthManager.motaleat8Lesson2Part2Completed,
          AuthManager.motaleat8Lesson2Part3Completed,
          AuthManager.motaleat8Lesson3Part1Completed,
          AuthManager.motaleat8Lesson3Part2Completed,
          AuthManager.motaleat8Lesson3Part3Completed,
          AuthManager.motaleat8Lesson4Part1Completed,
          AuthManager.motaleat8Lesson4Part2Completed,
          AuthManager.motaleat8Lesson4Part3Completed,
          AuthManager.motaleat8Lesson5Part1Completed,
          AuthManager.motaleat8Lesson5Part2Completed,
          AuthManager.motaleat8Lesson5Part3Completed,
          AuthManager.motaleat8Lesson6Part1Completed,
          AuthManager.motaleat8Lesson6Part2Completed,
          AuthManager.motaleat8Lesson6Part3Completed,
          AuthManager.motaleat8Lesson7Part1Completed,
          AuthManager.motaleat8Lesson7Part2Completed,
          AuthManager.motaleat8Lesson7Part3Completed,
          AuthManager.motaleat8Lesson8Part1Completed,
          AuthManager.motaleat8Lesson8Part2Completed,
          AuthManager.motaleat8Lesson8Part3Completed,
          AuthManager.motaleat8Lesson9Part1Completed,
          AuthManager.motaleat8Lesson9Part2Completed,
          AuthManager.motaleat8Lesson9Part3Completed,
          AuthManager.motaleat8Lesson10Part1Completed,
          AuthManager.motaleat8Lesson10Part2Completed,
          AuthManager.motaleat8Lesson10Part3Completed,
          AuthManager.motaleat8Lesson11Part1Completed,
          AuthManager.motaleat8Lesson11Part2Completed,
          AuthManager.motaleat8Lesson11Part3Completed,
          AuthManager.motaleat8Lesson12Part1Completed,
          AuthManager.motaleat8Lesson12Part2Completed,
          AuthManager.motaleat8Lesson12Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      // ===== پایه نهم =====
      case 'ریاضیات نهم':
      case 'ریاضی نهم':
        final list = [
          AuthManager.riyazi9Chapter1Completed,
          AuthManager.riyazi9Chapter2Completed,
          AuthManager.riyazi9Chapter3Completed,
          AuthManager.riyazi9Chapter4Completed,
          AuthManager.riyazi9Chapter5Completed,
          AuthManager.riyazi9Chapter6Completed,
          AuthManager.riyazi9Chapter7Completed,
          AuthManager.riyazi9Chapter8Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'علوم تجربی نهم':
        final list = [
          AuthManager.olom9Lesson1Part1Completed,
          AuthManager.olom9Lesson1Part2Completed,
          AuthManager.olom9Lesson1Part3Completed,
          AuthManager.olom9Lesson2Part1Completed,
          AuthManager.olom9Lesson2Part2Completed,
          AuthManager.olom9Lesson2Part3Completed,
          AuthManager.olom9Lesson3Part1Completed,
          AuthManager.olom9Lesson3Part2Completed,
          AuthManager.olom9Lesson3Part3Completed,
          AuthManager.olom9Lesson4Part1Completed,
          AuthManager.olom9Lesson4Part2Completed,
          AuthManager.olom9Lesson4Part3Completed,
          AuthManager.olom9Lesson5Part1Completed,
          AuthManager.olom9Lesson5Part2Completed,
          AuthManager.olom9Lesson5Part3Completed,
          AuthManager.olom9Lesson6Part1Completed,
          AuthManager.olom9Lesson6Part2Completed,
          AuthManager.olom9Lesson6Part3Completed,
          AuthManager.olom9Lesson7Part1Completed,
          AuthManager.olom9Lesson7Part2Completed,
          AuthManager.olom9Lesson7Part3Completed,
          AuthManager.olom9Lesson8Part1Completed,
          AuthManager.olom9Lesson8Part2Completed,
          AuthManager.olom9Lesson8Part3Completed,
          AuthManager.olom9Lesson9Part1Completed,
          AuthManager.olom9Lesson9Part2Completed,
          AuthManager.olom9Lesson9Part3Completed,
          AuthManager.olom9Lesson10Part1Completed,
          AuthManager.olom9Lesson10Part2Completed,
          AuthManager.olom9Lesson10Part3Completed,
          AuthManager.olom9Lesson11Part1Completed,
          AuthManager.olom9Lesson11Part2Completed,
          AuthManager.olom9Lesson11Part3Completed,
          AuthManager.olom9Lesson12Part1Completed,
          AuthManager.olom9Lesson12Part2Completed,
          AuthManager.olom9Lesson12Part3Completed,
          AuthManager.olom9Lesson13Part1Completed,
          AuthManager.olom9Lesson13Part2Completed,
          AuthManager.olom9Lesson13Part3Completed,
          AuthManager.olom9Lesson14Part1Completed,
          AuthManager.olom9Lesson14Part2Completed,
          AuthManager.olom9Lesson14Part3Completed,
          AuthManager.olom9Lesson15Part1Completed,
          AuthManager.olom9Lesson15Part2Completed,
          AuthManager.olom9Lesson15Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'ادبیات فارسی نهم':
      case 'فارسی نهم':
        final list = [
          AuthManager.farsi9Lesson1Part1Completed,
          AuthManager.farsi9Lesson1Part2Completed,
          AuthManager.farsi9Lesson1Part3Completed,
          AuthManager.farsi9Lesson2Part1Completed,
          AuthManager.farsi9Lesson2Part2Completed,
          AuthManager.farsi9Lesson2Part3Completed,
          AuthManager.farsi9Lesson3Part1Completed,
          AuthManager.farsi9Lesson3Part2Completed,
          AuthManager.farsi9Lesson3Part3Completed,
          AuthManager.farsi9Lesson4Part1Completed,
          AuthManager.farsi9Lesson4Part2Completed,
          AuthManager.farsi9Lesson4Part3Completed,
          AuthManager.farsi9Lesson5Part1Completed,
          AuthManager.farsi9Lesson5Part2Completed,
          AuthManager.farsi9Lesson5Part3Completed,
          AuthManager.farsi9Lesson6Part1Completed,
          AuthManager.farsi9Lesson6Part2Completed,
          AuthManager.farsi9Lesson6Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'زبان انگلیسی نهم':
        final list = [
          AuthManager.zaban9Lesson1Part1Completed,
          AuthManager.zaban9Lesson1Part3Completed,
          AuthManager.zaban9Lesson2Part1Completed,
          AuthManager.zaban9Lesson2Part3Completed,
          AuthManager.zaban9Lesson3Part1Completed,
          AuthManager.zaban9Lesson3Part3Completed,
          AuthManager.zaban9Lesson4Part1Completed,
          AuthManager.zaban9Lesson4Part3Completed,
          AuthManager.zaban9Lesson5Part1Completed,
          AuthManager.zaban9Lesson5Part3Completed,
          AuthManager.zaban9Lesson6Part1Completed,
          AuthManager.zaban9Lesson6Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'عربی نهم':
        final list = [
          AuthManager.arabic9Lesson1Part1Completed,
          AuthManager.arabic9Lesson1Part2Completed,
          AuthManager.arabic9Lesson1Part3Completed,
          AuthManager.arabic9Lesson2Part1Completed,
          AuthManager.arabic9Lesson2Part2Completed,
          AuthManager.arabic9Lesson2Part3Completed,
          AuthManager.arabic9Lesson3Part1Completed,
          AuthManager.arabic9Lesson3Part2Completed,
          AuthManager.arabic9Lesson3Part3Completed,
          AuthManager.arabic9Lesson4Part1Completed,
          AuthManager.arabic9Lesson4Part2Completed,
          AuthManager.arabic9Lesson4Part3Completed,
          AuthManager.arabic9Lesson5Part1Completed,
          AuthManager.arabic9Lesson5Part2Completed,
          AuthManager.arabic9Lesson5Part3Completed,
          AuthManager.arabic9Lesson6Part1Completed,
          AuthManager.arabic9Lesson6Part2Completed,
          AuthManager.arabic9Lesson6Part3Completed,
          AuthManager.arabic9Lesson7Part1Completed,
          AuthManager.arabic9Lesson7Part2Completed,
          AuthManager.arabic9Lesson7Part3Completed,
          AuthManager.arabic9Lesson8Part1Completed,
          AuthManager.arabic9Lesson8Part2Completed,
          AuthManager.arabic9Lesson8Part3Completed,
          AuthManager.arabic9Lesson9Part1Completed,
          AuthManager.arabic9Lesson9Part2Completed,
          AuthManager.arabic9Lesson9Part3Completed,
          AuthManager.arabic9Lesson10Part1Completed,
          AuthManager.arabic9Lesson10Part2Completed,
          AuthManager.arabic9Lesson10Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'قرآن نهم':
        final list = [
          AuthManager.quran9Lesson1Part2Completed,
          AuthManager.quran9Lesson1Part3Completed,
          AuthManager.quran9Lesson2Part1Completed,
          AuthManager.quran9Lesson2Part2Completed,
          AuthManager.quran9Lesson2Part3Completed,
          AuthManager.quran9Lesson3Part1Completed,
          AuthManager.quran9Lesson3Part2Completed,
          AuthManager.quran9Lesson3Part3Completed,
          AuthManager.quran9Lesson4Part1Completed,
          AuthManager.quran9Lesson4Part2Completed,
          AuthManager.quran9Lesson4Part3Completed,
          AuthManager.quran9Lesson5Part1Completed,
          AuthManager.quran9Lesson5Part2Completed,
          AuthManager.quran9Lesson5Part3Completed,
          AuthManager.quran9Lesson6Part1Completed,
          AuthManager.quran9Lesson6Part2Completed,
          AuthManager.quran9Lesson6Part3Completed,
          AuthManager.quran9Lesson7Part1Completed,
          AuthManager.quran9Lesson7Part2Completed,
          AuthManager.quran9Lesson7Part3Completed,
          AuthManager.quran9Lesson8Part1Completed,
          AuthManager.quran9Lesson8Part2Completed,
          AuthManager.quran9Lesson8Part3Completed,
          AuthManager.quran9Lesson9Part1Completed,
          AuthManager.quran9Lesson9Part2Completed,
          AuthManager.quran9Lesson9Part3Completed,
          AuthManager.quran9Lesson10Part1Completed,
          AuthManager.quran9Lesson10Part2Completed,
          AuthManager.quran9Lesson10Part3Completed,
          AuthManager.quran9Lesson11Part1Completed,
          AuthManager.quran9Lesson11Part2Completed,
          AuthManager.quran9Lesson11Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'پیام‌های آسمان نهم':
        final list = [
          AuthManager.payam9Lesson1Part1Completed,
          AuthManager.payam9Lesson1Part2Completed,
          AuthManager.payam9Lesson1Part3Completed,
          AuthManager.payam9Lesson2Part1Completed,
          AuthManager.payam9Lesson2Part2Completed,
          AuthManager.payam9Lesson2Part3Completed,
          AuthManager.payam9Lesson3Part1Completed,
          AuthManager.payam9Lesson3Part2Completed,
          AuthManager.payam9Lesson3Part3Completed,
          AuthManager.payam9Lesson4Part1Completed,
          AuthManager.payam9Lesson4Part2Completed,
          AuthManager.payam9Lesson4Part3Completed,
          AuthManager.payam9Lesson5Part1Completed,
          AuthManager.payam9Lesson5Part2Completed,
          AuthManager.payam9Lesson5Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;

      case 'مطالعات اجتماعی نهم':
        final list = [
          AuthManager.motaleat9Lesson1Part1Completed,
          AuthManager.motaleat9Lesson1Part2Completed,
          AuthManager.motaleat9Lesson1Part3Completed,
          AuthManager.motaleat9Lesson2Part1Completed,
          AuthManager.motaleat9Lesson2Part2Completed,
          AuthManager.motaleat9Lesson2Part3Completed,
          AuthManager.motaleat9Lesson3Part1Completed,
          AuthManager.motaleat9Lesson3Part2Completed,
          AuthManager.motaleat9Lesson3Part3Completed,
          AuthManager.motaleat9Lesson4Part1Completed,
          AuthManager.motaleat9Lesson4Part2Completed,
          AuthManager.motaleat9Lesson4Part3Completed,
          AuthManager.motaleat9Lesson5Part1Completed,
          AuthManager.motaleat9Lesson5Part2Completed,
          AuthManager.motaleat9Lesson5Part3Completed,
          AuthManager.motaleat9Lesson6Part1Completed,
          AuthManager.motaleat9Lesson6Part2Completed,
          AuthManager.motaleat9Lesson6Part3Completed,
          AuthManager.motaleat9Lesson7Part1Completed,
          AuthManager.motaleat9Lesson7Part2Completed,
          AuthManager.motaleat9Lesson7Part3Completed,
          AuthManager.motaleat9Lesson8Part1Completed,
          AuthManager.motaleat9Lesson8Part2Completed,
          AuthManager.motaleat9Lesson8Part3Completed,
          AuthManager.motaleat9Lesson9Part1Completed,
          AuthManager.motaleat9Lesson9Part2Completed,
          AuthManager.motaleat9Lesson9Part3Completed,
          AuthManager.motaleat9Lesson10Part1Completed,
          AuthManager.motaleat9Lesson10Part2Completed,
          AuthManager.motaleat9Lesson10Part3Completed,
          AuthManager.motaleat9Lesson11Part1Completed,
          AuthManager.motaleat9Lesson11Part2Completed,
          AuthManager.motaleat9Lesson11Part3Completed,
          AuthManager.motaleat9Lesson12Part1Completed,
          AuthManager.motaleat9Lesson12Part2Completed,
          AuthManager.motaleat9Lesson12Part3Completed,
        ];
        totalCount = list.length;
        completedCount = list.where((c) => c).length;
        break;
    }

    double progress = 0.0;
    String percentText = '0%';
    if (totalCount > 0) {
      if (completedCount == 0) {
        progress = 0.0;
        percentText = '0%';
      } else if (completedCount >= totalCount) {
        progress = 1.0;
        percentText = '100%';
      } else {
        progress = completedCount / totalCount;
        final double pct = progress * 100;
        final String formatted = pct.toStringAsFixed(1);
        if (formatted.endsWith('.0')) {
          percentText = '${pct.toInt()}%';
        } else {
          percentText = '$formatted%';
        }
      }
    }

    return {
      'progress': progress,
      'text': percentText,
      'completed': completedCount,
      'total': totalCount,
    };
  }

  // کارت‌های دروس
  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final color = subject['color'] as Color;
    final progressData = _getSubjectProgress(subject['title']);
    final double progress = progressData['progress'] as double;
    final String progressText = progressData['text'] as String;

    final bool isArabic7 = subject['title'] == 'عربی هفتم';
    final bool isArabic8 = subject['title'] == 'عربی هشتم';
    final bool isArabic9 = subject['title'] == 'عربی نهم';
    final bool isQuran7 = subject['title'] == 'قرآن هفتم';
    final bool isQuran8 = subject['title'] == 'قرآن هشتم';
    final bool isQuran9 = subject['title'] == 'قرآن نهم';
    final bool isZaban7 = subject['title'] == 'زبان انگلیسی هفتم';
    final bool isZaban8 = subject['title'] == 'زبان انگلیسی هشتم';
    final bool isZaban9 = subject['title'] == 'زبان انگلیسی نهم';
    final bool isMotaleat7 = subject['title'] == 'مطالعات اجتماعی هفتم';
    final bool isMotaleat8 = subject['title'] == 'مطالعات اجتماعی هشتم';
    final bool isMotaleat9 = subject['title'] == 'مطالعات اجتماعی نهم';
    final bool isFarsi7 = subject['title'] == 'ادبیات فارسی هفتم' || subject['title'] == 'فارسی هفتم';
    final bool isFarsi8 = subject['title'] == 'ادبیات فارسی هشتم' || subject['title'] == 'فارسی هشتم';
    final bool isFarsi9 = subject['title'] == 'ادبیات فارسی نهم' || subject['title'] == 'فارسی نهم';
    final bool isPayam7 = subject['title'] == 'پیام‌های آسمان هفتم';
    final bool isPayam8 = subject['title'] == 'پیام‌های آسمان هشتم';
    final bool isPayam9 = subject['title'] == 'پیام‌های آسمان نهم';
    final bool isOlom7 = subject['title'] == 'علوم تجربی هفتم';
    final bool isOlom8 = subject['title'] == 'علوم تجربی هشتم';
    final bool isOlom9 = subject['title'] == 'علوم تجربی نهم';
    final bool isRiyazi7 = subject['title'] == 'ریاضیات هفتم' || subject['title'] == 'ریاضی هفتم';
    final bool isRiyazi8 = subject['title'] == 'ریاضیات هشتم' || subject['title'] == 'ریاضی هشتم';
    final bool isRiyazi9 = subject['title'] == 'ریاضیات نهم' || subject['title'] == 'ریاضی نهم';

    return GestureDetector(
      onTap: () async {
        if (isArabic7) {
          await _showArabic7LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isArabic8) {
          await _showArabic8LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isArabic9) {
          await _showArabic9LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isQuran7) {
          final res = await showQuran7LessonsModal(context);
          if (res == 'open_league') {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const Quran7LeagueEntryScreen(),
              ),
            );
          }
          if (mounted) setState(() {});
        } else if (isQuran8) {
          final res = await showQuran8LessonsModal(context);
          if (res == 'open_league') {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const Quran8LeagueEntryScreen(),
              ),
            );
          }
          if (mounted) setState(() {});
        } else if (isQuran9) {
          await showQuran9LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isZaban7) {
          await showZaban7LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isZaban8) {
          await showZaban8LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isZaban9) {
          await showZaban9LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isFarsi7) {
          await showFarsi7LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isFarsi8) {
          await showFarsi8LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isFarsi9) {
          await showFarsi9LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isPayam7) {
          await showPayam7LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isPayam8) {
          await showPayam8LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isPayam9) {
          await showPayam9LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isMotaleat7) {
          await showMotaleat7LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isMotaleat8) {
          await showMotaleat8LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isMotaleat9) {
          await showMotaleat9LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isOlom7) {
          await showOlom7LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isOlom8) {
          await showOlom8LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isOlom9) {
          await showOlom9LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isRiyazi7) {
          await showRiyazi7LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isRiyazi8) {
          await showRiyazi8LessonsModal(context);
          if (mounted) setState(() {});
        } else if (isRiyazi9) {
          await showRiyazi9LessonsModal(context);
          if (mounted) setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ورود به ${subject['title']} 📚'),
              backgroundColor: color,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                    child: subject['image'].toString().startsWith('http')
                        ? Image.network(
                            subject['image'],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            subject['image'],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 1.0],
                        colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                      ),
                    ),
                  ),
                  // Reward badge removed
                  Positioned(
                    bottom: 10,
                    right: 10,
                    left: 10,
                    child: Text(
                      subject['title'],
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('پیشرفت', style: TextStyle(fontSize: 9, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                      Text(progressText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: color)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: color.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // نمایش مدال انتخاب بخش‌های دروس عربی هفتم
  void _showLesson1PartsSelectionModal(BuildContext context, {String lessonKey = 'lesson1', String lessonTitle = 'اَلدَّرسُ الْْأَوَّلُ'}) {
    bool p1Completed, p2Completed, p3Completed;
    List<Map<String, String>> p1Vocab, p2Vocab, p3Vocab;

    if (lessonKey == 'lesson20') {
      p1Completed = AuthManager.lesson20Part1Completed;
      p2Completed = AuthManager.lesson20Part2Completed;
      p3Completed = AuthManager.lesson20Part3Completed;
      p1Vocab = lesson20Part1Vocab;
      p2Vocab = lesson20Part2Vocab;
      p3Vocab = lesson20Part3Vocab;
    } else if (lessonKey == 'lesson19') {
      p1Completed = AuthManager.lesson19Part1Completed;
      p2Completed = AuthManager.lesson19Part2Completed;
      p3Completed = AuthManager.lesson19Part3Completed;
      p1Vocab = lesson19Part1Vocab;
      p2Vocab = lesson19Part2Vocab;
      p3Vocab = lesson19Part3Vocab;
    } else if (lessonKey == 'lesson18') {
      p1Completed = AuthManager.lesson18Part1Completed;
      p2Completed = AuthManager.lesson18Part2Completed;
      p3Completed = AuthManager.lesson18Part3Completed;
      p1Vocab = lesson18Part1Vocab;
      p2Vocab = lesson18Part2Vocab;
      p3Vocab = lesson18Part3Vocab;
    } else if (lessonKey == 'lesson17') {
      p1Completed = AuthManager.lesson17Part1Completed;
      p2Completed = AuthManager.lesson17Part2Completed;
      p3Completed = AuthManager.lesson17Part3Completed;
      p1Vocab = lesson17Part1Vocab;
      p2Vocab = lesson17Part2Vocab;
      p3Vocab = lesson17Part3Vocab;
    } else if (lessonKey == 'lesson16') {
      p1Completed = AuthManager.lesson16Part1Completed;
      p2Completed = AuthManager.lesson16Part2Completed;
      p3Completed = AuthManager.lesson16Part3Completed;
      p1Vocab = lesson16Part1Vocab;
      p2Vocab = lesson16Part2Vocab;
      p3Vocab = lesson16Part3Vocab;
    } else if (lessonKey == 'lesson15') {
      p1Completed = AuthManager.lesson15Part1Completed;
      p2Completed = AuthManager.lesson15Part2Completed;
      p3Completed = AuthManager.lesson15Part3Completed;
      p1Vocab = lesson15Part1Vocab;
      p2Vocab = lesson15Part2Vocab;
      p3Vocab = lesson15Part3Vocab;
    } else if (lessonKey == 'lesson14') {
      p1Completed = AuthManager.lesson14Part1Completed;
      p2Completed = AuthManager.lesson14Part2Completed;
      p3Completed = AuthManager.lesson14Part3Completed;
      p1Vocab = lesson14Part1Vocab;
      p2Vocab = lesson14Part2Vocab;
      p3Vocab = lesson14Part3Vocab;
    } else if (lessonKey == 'lesson13') {
      p1Completed = AuthManager.lesson13Part1Completed;
      p2Completed = AuthManager.lesson13Part2Completed;
      p3Completed = AuthManager.lesson13Part3Completed;
      p1Vocab = lesson13Part1Vocab;
      p2Vocab = lesson13Part2Vocab;
      p3Vocab = lesson13Part3Vocab;
    } else if (lessonKey == 'lesson12') {
      p1Completed = AuthManager.lesson12Part1Completed;
      p2Completed = AuthManager.lesson12Part2Completed;
      p3Completed = AuthManager.lesson12Part3Completed;
      p1Vocab = lesson12Part1Vocab;
      p2Vocab = lesson12Part2Vocab;
      p3Vocab = lesson12Part3Vocab;
    } else if (lessonKey == 'lesson11') {
      p1Completed = AuthManager.lesson11Part1Completed;
      p2Completed = AuthManager.lesson11Part2Completed;
      p3Completed = AuthManager.lesson11Part3Completed;
      p1Vocab = lesson11Part1Vocab;
      p2Vocab = lesson11Part2Vocab;
      p3Vocab = lesson11Part3Vocab;
    } else if (lessonKey == 'lesson10') {
      p1Completed = AuthManager.lesson10Part1Completed;
      p2Completed = AuthManager.lesson10Part2Completed;
      p3Completed = AuthManager.lesson10Part3Completed;
      p1Vocab = lesson10Part1Vocab;
      p2Vocab = lesson10Part2Vocab;
      p3Vocab = lesson10Part3Vocab;
    } else if (lessonKey == 'lesson9') {
      p1Completed = AuthManager.lesson9Part1Completed;
      p2Completed = AuthManager.lesson9Part2Completed;
      p3Completed = AuthManager.lesson9Part3Completed;
      p1Vocab = lesson9Part1Vocab;
      p2Vocab = lesson9Part2Vocab;
      p3Vocab = lesson9Part3Vocab;
    } else if (lessonKey == 'lesson8') {
      p1Completed = AuthManager.lesson8Part1Completed;
      p2Completed = AuthManager.lesson8Part2Completed;
      p3Completed = AuthManager.lesson8Part3Completed;
      p1Vocab = lesson8Part1Vocab;
      p2Vocab = lesson8Part2Vocab;
      p3Vocab = lesson8Part3Vocab;
    } else if (lessonKey == 'lesson7') {
      p1Completed = AuthManager.lesson7Part1Completed;
      p2Completed = AuthManager.lesson7Part2Completed;
      p3Completed = AuthManager.lesson7Part3Completed;
      p1Vocab = lesson7Part1Vocab;
      p2Vocab = lesson7Part2Vocab;
      p3Vocab = lesson7Part3Vocab;
    } else if (lessonKey == 'lesson6') {
      p1Completed = AuthManager.lesson6Part1Completed;
      p2Completed = AuthManager.lesson6Part2Completed;
      p3Completed = AuthManager.lesson6Part3Completed;
      p1Vocab = lesson6Part1Vocab;
      p2Vocab = lesson6Part2Vocab;
      p3Vocab = lesson6Part3Vocab;
    } else if (lessonKey == 'lesson5') {
      p1Completed = AuthManager.lesson5Part1Completed;
      p2Completed = AuthManager.lesson5Part2Completed;
      p3Completed = AuthManager.lesson5Part3Completed;
      p1Vocab = lesson5Part1Vocab;
      p2Vocab = lesson5Part2Vocab;
      p3Vocab = lesson5Part3Vocab;
    } else if (lessonKey == 'lesson4') {
      p1Completed = AuthManager.lesson4Part1Completed;
      p2Completed = AuthManager.lesson4Part2Completed;
      p3Completed = AuthManager.lesson4Part3Completed;
      p1Vocab = lesson4Part1Vocab;
      p2Vocab = lesson4Part2Vocab;
      p3Vocab = lesson4Part3Vocab;
    } else if (lessonKey == 'lesson3') {
      p1Completed = AuthManager.lesson3Part1Completed;
      p2Completed = AuthManager.lesson3Part2Completed;
      p3Completed = AuthManager.lesson3Part3Completed;
      p1Vocab = lesson3Part1Vocab;
      p2Vocab = lesson3Part2Vocab;
      p3Vocab = lesson3Part3Vocab;
    } else if (lessonKey == 'lesson2') {
      p1Completed = AuthManager.lesson2Part1Completed;
      p2Completed = AuthManager.lesson2Part2Completed;
      p3Completed = AuthManager.lesson2Part3Completed;
      p1Vocab = lesson2Part1Vocab;
      p2Vocab = lesson2Part2Vocab;
      p3Vocab = lesson2Part3Vocab;
    } else {
      p1Completed = AuthManager.lesson1Part1Completed;
      p2Completed = AuthManager.lesson1Part2Completed;
      p3Completed = AuthManager.lesson1Part3Completed;
      p1Vocab = lesson1Part1Vocab;
      p2Vocab = lesson1Part2Vocab;
      p3Vocab = lesson1Part3Vocab;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'عربی پایه هفتم - $lessonTitle 🌟',
                  style: const TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                if (lessonKey != 'lesson20' && lessonKey != 'lesson12') ...[
                  // قسمت اول: بازی تطبیق
                  _buildGamePartButton(
                    title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                    icon: '🧩',
                    color: const Color(0xFF14B8A6),
                    isCompleted: p1Completed,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArabicLesson1GameScreen(
                            lessonTitle: lessonTitle,
                            lessonKey: lessonKey,
                            customVocabulary: p1Vocab,
                          ),
                        ),
                      ).then((_) {
                        if (mounted) setState(() {});
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: lessonTitle,
                          lessonKey: lessonKey,
                          customWords: p2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: lessonTitle,
                          lessonKey: lessonKey,
                          customWords: p3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGamePartButton({required String title, required String icon, required Color color, required VoidCallback onTap, bool isCompleted = false}) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontFamily: 'Tahoma', fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
                if (isCompleted)
                  const Text('✅', style: TextStyle(fontSize: 18))
                else
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isArabic7LessonCompleted(String? lessonKey) {
    switch (lessonKey) {
      case 'lesson1':
        return AuthManager.lesson1Part1Completed && AuthManager.lesson1Part2Completed && AuthManager.lesson1Part3Completed;
      case 'lesson2':
        return AuthManager.lesson2Part1Completed && AuthManager.lesson2Part2Completed && AuthManager.lesson2Part3Completed;
      case 'lesson3':
        return AuthManager.lesson3Part1Completed && AuthManager.lesson3Part2Completed && AuthManager.lesson3Part3Completed;
      case 'lesson4':
        return AuthManager.lesson4Part1Completed && AuthManager.lesson4Part2Completed && AuthManager.lesson4Part3Completed;
      case 'lesson5':
        return AuthManager.lesson5Part1Completed && AuthManager.lesson5Part2Completed && AuthManager.lesson5Part3Completed;
      case 'lesson6':
        return AuthManager.lesson6Part1Completed && AuthManager.lesson6Part2Completed && AuthManager.lesson6Part3Completed;
      case 'lesson7':
        return AuthManager.lesson7Part1Completed && AuthManager.lesson7Part2Completed && AuthManager.lesson7Part3Completed;
      case 'lesson8':
        return AuthManager.lesson8Part1Completed && AuthManager.lesson8Part2Completed && AuthManager.lesson8Part3Completed;
      case 'lesson9':
        return AuthManager.lesson9Part1Completed && AuthManager.lesson9Part2Completed && AuthManager.lesson9Part3Completed;
      case 'lesson10':
        return AuthManager.lesson10Part1Completed && AuthManager.lesson10Part2Completed && AuthManager.lesson10Part3Completed;
      case 'lesson11':
        return AuthManager.lesson11Part1Completed && AuthManager.lesson11Part2Completed && AuthManager.lesson11Part3Completed;
      case 'lesson12':
        return AuthManager.lesson12Part1Completed && AuthManager.lesson12Part2Completed && AuthManager.lesson12Part3Completed;
      case 'lesson13':
        return AuthManager.lesson13Part1Completed && AuthManager.lesson13Part2Completed && AuthManager.lesson13Part3Completed;
      case 'lesson14':
        return AuthManager.lesson14Part1Completed && AuthManager.lesson14Part2Completed && AuthManager.lesson14Part3Completed;
      case 'lesson15':
        return AuthManager.lesson15Part1Completed && AuthManager.lesson15Part2Completed && AuthManager.lesson15Part3Completed;
      case 'lesson16':
        return AuthManager.lesson16Part1Completed && AuthManager.lesson16Part2Completed && AuthManager.lesson16Part3Completed;
      case 'lesson17':
        return AuthManager.lesson17Part1Completed && AuthManager.lesson17Part2Completed && AuthManager.lesson17Part3Completed;
      case 'lesson18':
        return AuthManager.lesson18Part1Completed && AuthManager.lesson18Part2Completed && AuthManager.lesson18Part3Completed;
      case 'lesson19':
        return AuthManager.lesson19Part1Completed && AuthManager.lesson19Part2Completed && AuthManager.lesson19Part3Completed;
      case 'lesson20':
        return AuthManager.lesson20Part1Completed && AuthManager.lesson20Part2Completed && AuthManager.lesson20Part3Completed;
      default:
        return false;
    }
  }

  bool _isArabic8LessonCompleted(int lessonNum) {
    switch (lessonNum) {
      case 1:
        return AuthManager.arabic8Lesson1Part1Completed && AuthManager.arabic8Lesson1Part2Completed && AuthManager.arabic8Lesson1Part3Completed;
      case 2:
        return AuthManager.arabic8Lesson2Part1Completed && AuthManager.arabic8Lesson2Part2Completed && AuthManager.arabic8Lesson2Part3Completed;
      case 3:
        return AuthManager.arabic8Lesson3Part1Completed && AuthManager.arabic8Lesson3Part2Completed && AuthManager.arabic8Lesson3Part3Completed;
      case 4:
        return AuthManager.arabic8Lesson4Part1Completed && AuthManager.arabic8Lesson4Part2Completed && AuthManager.arabic8Lesson4Part3Completed;
      case 5:
        return AuthManager.arabic8Lesson5Part1Completed && AuthManager.arabic8Lesson5Part2Completed && AuthManager.arabic8Lesson5Part3Completed;
      case 6:
        return AuthManager.arabic8Lesson6Part1Completed && AuthManager.arabic8Lesson6Part2Completed && AuthManager.arabic8Lesson6Part3Completed;
      case 7:
        return AuthManager.arabic8Lesson7Part1Completed && AuthManager.arabic8Lesson7Part2Completed && AuthManager.arabic8Lesson7Part3Completed;
      case 8:
        return AuthManager.arabic8Lesson8Part1Completed && AuthManager.arabic8Lesson8Part2Completed && AuthManager.arabic8Lesson8Part3Completed;
      case 9:
        return AuthManager.arabic8Lesson9Part1Completed && AuthManager.arabic8Lesson9Part2Completed && AuthManager.arabic8Lesson9Part3Completed;
      case 10:
        return AuthManager.arabic8Lesson10Part2Completed && AuthManager.arabic8Lesson10Part3Completed;
      default:
        return false;
    }
  }

  bool _isArabic9LessonCompleted(int lessonNum) {
    switch (lessonNum) {
      case 1:
        return AuthManager.arabic9Lesson1Part1Completed && AuthManager.arabic9Lesson1Part2Completed && AuthManager.arabic9Lesson1Part3Completed;
      case 2:
        return AuthManager.arabic9Lesson2Part1Completed && AuthManager.arabic9Lesson2Part2Completed && AuthManager.arabic9Lesson2Part3Completed;
      case 3:
        return AuthManager.arabic9Lesson3Part1Completed && AuthManager.arabic9Lesson3Part2Completed && AuthManager.arabic9Lesson3Part3Completed;
      case 4:
        return AuthManager.arabic9Lesson4Part1Completed && AuthManager.arabic9Lesson4Part2Completed && AuthManager.arabic9Lesson4Part3Completed;
      case 5:
        return AuthManager.arabic9Lesson5Part1Completed && AuthManager.arabic9Lesson5Part2Completed && AuthManager.arabic9Lesson5Part3Completed;
      case 6:
        return AuthManager.arabic9Lesson6Part1Completed && AuthManager.arabic9Lesson6Part2Completed && AuthManager.arabic9Lesson6Part3Completed;
      case 7:
        return AuthManager.arabic9Lesson7Part1Completed && AuthManager.arabic9Lesson7Part2Completed && AuthManager.arabic9Lesson7Part3Completed;
      case 8:
        return AuthManager.arabic9Lesson8Part1Completed && AuthManager.arabic9Lesson8Part2Completed && AuthManager.arabic9Lesson8Part3Completed;
      case 9:
        return AuthManager.arabic9Lesson9Part1Completed && AuthManager.arabic9Lesson9Part2Completed && AuthManager.arabic9Lesson9Part3Completed;
      case 10:
        return AuthManager.arabic9Lesson10Part1Completed && AuthManager.arabic9Lesson10Part2Completed && AuthManager.arabic9Lesson10Part3Completed;
      default:
        return false;
    }
  }

  // مودال لیست ۲۰ درس عربی هفتم
  Future<void> _showArabic7LessonsModal(BuildContext context) {
    final List<Map<String, String>> arabic7Lessons = [
      {'number': '01', 'key': 'lesson1', 'title': 'اَلدَّرسُ الْْأَوَّلُ', 'subtitle': ''},
      {'number': '02', 'key': 'lesson2', 'title': 'اَلدَّرسُ الثّاني', 'subtitle': ''},
      {'number': '03', 'key': 'lesson3', 'title': 'اَلدَّرْسُ الثّالِثُ', 'subtitle': ''},
      {'number': '04', 'key': 'lesson4', 'title': 'اَلدَّرْسُ الرّابِعُ', 'subtitle': ''},
      {'number': '05', 'key': 'lesson5', 'title': 'اَلدَّرْسُ الْخامِسُ', 'subtitle': ''},
      {'number': '06', 'key': 'lesson6', 'title': 'اَلدَّرْسُ السّادِسُ', 'subtitle': ''},
      {'number': '07', 'key': 'lesson7', 'title': 'اَلدَّرْسُ السّابِعُ', 'subtitle': ''},
      {'number': '08', 'key': 'lesson8', 'title': 'اَلدَّرْسُ الثّامِنُ', 'subtitle': ''},
      {'number': '09', 'key': 'lesson9', 'title': 'اَلدَّرْسُ التّاسِعُ', 'subtitle': ''},
      {'number': '10', 'key': 'lesson10', 'title': 'اَلدَّرْسُ الْعاشِِرُ', 'subtitle': ''},
      {'number': '11', 'key': 'lesson11', 'title': 'اَلدَّرْسُ الْحادي عَشََرَ', 'subtitle': ''},
      {'number': '12', 'key': 'lesson12', 'title': 'اَلدَّرْسُ الثّاني عَشََرَ', 'subtitle': ''},
      {'number': '13', 'key': 'lesson13', 'title': 'اَلدَّرْسُ الثّالِثَ عَشََرَ', 'subtitle': ''},
      {'number': '14', 'key': 'lesson14', 'title': 'اَلدَّرْسُ الرّابِعَ عَشََرَ', 'subtitle': ''},
      {'number': '15', 'key': 'lesson15', 'title': 'اَلدَّرْسُ الخْامِسَ عَشََرَ', 'subtitle': ''},
      {'number': '16', 'key': 'lesson16', 'title': 'اَلدَّرْسُ السّادِسَ عَشََرَ', 'subtitle': ''},
      {'number': '17', 'key': 'lesson17', 'title': 'اَلدَّرْسُ السّابِعَ عَشََرَ', 'subtitle': ''},
      {'number': '', 'key': 'lesson20', 'title': 'مُرورُ الْفِعْلِ الْمَاضِي', 'subtitle': ''},
    ];

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.82,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B), Color(0xFF0F172A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316).withOpacity(0.6), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF97316).withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF97316),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF97316).withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF97316), width: 1.5),
                      ),
                      child: const Text('📖', style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'کتاب عربی پایه هفتم 🇮🇶',
                            style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'لیست بازی 🎮 های هر درس',
                            style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(color: Colors.white24, thickness: 1),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: arabic7Lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = arabic7Lessons[index];
                      final bool isPlayable = index >= 0 && index <= 19;
                      final bool isCompleted = _isArabic7LessonCompleted(lesson['key']);

                      final Color itemAccentColor = isCompleted ? const Color(0xFF10B981) : const Color(0xFFF97316);
                      final List<Color> itemGradient = isCompleted
                          ? [const Color(0xFF064E3B).withValues(alpha: 0.75), const Color(0xFF0A2E20)]
                          : [const Color(0xFF231F3D), const Color(0xFF1E1B4B)];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: itemGradient,
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: itemAccentColor,
                            width: 2.0,
                          ),
                          boxShadow: isCompleted
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.pop(context);
                              final lessonKey = lesson['key'];
                              if (lessonKey != null && lessonKey.isNotEmpty) {
                                _showLesson1PartsSelectionModal(context, lessonKey: lessonKey, lessonTitle: lesson['title']!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('بازی ${lesson['title']} به زودی فعال می‌شود! 🚀'),
                                    backgroundColor: const Color(0xFFF97316),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: itemAccentColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (isCompleted ? const Color(0xFF10B981) : const Color(0xFFF97316)).withValues(alpha: 0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: isCompleted
                                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                                          : Text(
                                              lesson['number']!,
                                              style: const TextStyle(
                                                fontFamily: 'Tahoma',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lesson['title']!,
                                          style: const TextStyle(
                                            fontFamily: 'Tahoma',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isPlayable)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: itemAccentColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: itemAccentColor),
                                      ),
                                      child: Text(
                                        isCompleted ? 'تکمیل شده ✅' : 'شروع بازی 🎮',
                                        style: TextStyle(
                                          fontFamily: 'Tahoma',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isCompleted ? const Color(0xFF6EE7B7) : const Color(0xFFFDBA74),
                                        ),
                                      ),
                                    )
                                  else
                                    const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFF97316), size: 16),
                                ],
                              ),
                            ),
                          ),
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

  // مودال لیست دروس عربی هشتم
  Future<void> _showArabic8LessonsModal(BuildContext context) {
    final List<Map<String, String>> arabic8Lessons = [
      {'number': '01', 'title': 'اَلدَّرْسُ الْأَوَّلُ', 'subtitle': ''},
      {'number': '02', 'title': 'اَلدَّرْسُ الثّاني', 'subtitle': ''},
      {'number': '03', 'title': 'اَلدَّرْسُ الثّالِثُ', 'subtitle': ''},
      {'number': '04', 'title': 'اَلدَّرْسُ الرّابِعُ', 'subtitle': ''},
      {'number': '05', 'title': 'اَلدَّرْسُ الْخامِسُ', 'subtitle': ''},
      {'number': '06', 'title': 'اَلدَّرْسُ السّادِسُ', 'subtitle': ''},
      {'number': '07', 'title': 'اَلدَّرْسُ السّابِعُ', 'subtitle': ''},
      {'number': '08', 'title': 'اَلدَّرْسُ الثّامِنُ', 'subtitle': ''},
      {'number': '09', 'title': 'اَلدَّرْسُ التّاسِعُ', 'subtitle': ''},
      {'number': '10', 'title': 'اَلدَّرْسُ الْعاشِِرُ', 'subtitle': ''},
    ];

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.82,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B), Color(0xFF0F172A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316).withOpacity(0.6), width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF97316),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF97316).withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF97316), width: 1.5),
                      ),
                      child: const Text('📖', style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'کتاب عربی پایه هشتم 🇮🇶',
                            style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'لیست بازی 🎮 های هر درس',
                            style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(color: Colors.white24, thickness: 1),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: arabic8Lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = arabic8Lessons[index];
                      final bool isPlayable = index >= 0 && index <= 9;
                      final bool isCompleted = _isArabic8LessonCompleted(index + 1);

                      final Color itemAccentColor = isCompleted ? const Color(0xFF10B981) : const Color(0xFFF97316);
                      final List<Color> itemGradient = isCompleted
                          ? [const Color(0xFF064E3B).withValues(alpha: 0.75), const Color(0xFF0A2E20)]
                          : [const Color(0xFF231F3D), const Color(0xFF1E1B4B)];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: itemGradient,
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: itemAccentColor,
                            width: 2.0,
                          ),
                          boxShadow: isCompleted
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.pop(context);
                              if (index == 0) {
                                _showArabic8Lesson1PartsSelectionModal(context);
                              } else if (index == 1) {
                                _showArabic8Lesson2PartsSelectionModal(context);
                              } else if (index == 2) {
                                _showArabic8Lesson3PartsSelectionModal(context);
                              } else if (index == 3) {
                                _showArabic8Lesson4PartsSelectionModal(context);
                              } else if (index == 4) {
                                _showArabic8Lesson5PartsSelectionModal(context);
                              } else if (index == 5) {
                                _showArabic8Lesson6PartsSelectionModal(context);
                              } else if (index == 6) {
                                _showArabic8Lesson7PartsSelectionModal(context);
                              } else if (index == 7) {
                                _showArabic8Lesson8PartsSelectionModal(context);
                              } else if (index == 8) {
                                _showArabic8Lesson9PartsSelectionModal(context);
                              } else if (index == 9) {
                                _showArabic8Lesson10PartsSelectionModal(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('بازی ${lesson['title']} به زودی فعال می‌شود! 🚀'),
                                    backgroundColor: const Color(0xFFF97316),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: itemAccentColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: isCompleted
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFF10B981).withValues(alpha: 0.4),
                                                blurRadius: 8,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: isCompleted
                                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                                          : Text(
                                              lesson['number']!,
                                              style: const TextStyle(fontFamily: 'Tahoma', fontWeight: FontWeight.w900, color: Colors.white, fontSize: 13),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lesson['title']!,
                                          style: const TextStyle(fontFamily: 'Tahoma', fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isPlayable)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: itemAccentColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: itemAccentColor),
                                      ),
                                      child: Text(
                                        isCompleted ? 'تکمیل شده ✅' : 'شروع بازی 🎮',
                                        style: TextStyle(
                                          fontFamily: 'Tahoma',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isCompleted ? const Color(0xFF6EE7B7) : const Color(0xFFFDBA74),
                                        ),
                                      ),
                                    )
                                  else
                                    const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFF97316), size: 16),
                                ],
                              ),
                            ),
                          ),
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

  // مودال لیست دروس عربی نهم
  Future<void> _showArabic9LessonsModal(BuildContext context) {
    final List<Map<String, String>> arabic9Lessons = [
      {'number': '01', 'title': 'اَلدَّرْسُ الْأَوَّلُ', 'subtitle': ''},
      {'number': '02', 'title': 'اَلدَّرْسُ الثّاني', 'subtitle': ''},
      {'number': '03', 'title': 'اَلدَّرْسُ الثّالِثُ', 'subtitle': ''},
      {'number': '04', 'title': 'اَلدَّرْسُ الرّابِعُ', 'subtitle': ''},
      {'number': '05', 'title': 'اَلدَّرْسُ الْخامِسُ', 'subtitle': ''},
      {'number': '06', 'title': 'اَلدَّرْسُ السّادِسُ', 'subtitle': ''},
      {'number': '07', 'title': 'اَلدَّرْسُ السّابِعُ', 'subtitle': ''},
      {'number': '08', 'title': 'اَلدَّرْسُ الثّامِنُ', 'subtitle': ''},
      {'number': '09', 'title': 'اَلدَّرْسُ التّاسِعُ', 'subtitle': ''},
      {'number': '10', 'title': 'اَلدَّرْسُ الْعاشِِرُ', 'subtitle': ''},
    ];

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.82,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B), Color(0xFF0F172A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316).withOpacity(0.6), width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF97316),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF97316).withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF97316), width: 1.5),
                      ),
                      child: const Text('📖', style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'کتاب عربی پایه نهم 🇮🇶',
                            style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'لیست بازی 🎮 های هر درس',
                            style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(color: Colors.white24, thickness: 1),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: arabic9Lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = arabic9Lessons[index];
                      final bool isPlayable = index >= 0 && index <= 9;
                      final bool isCompleted = _isArabic9LessonCompleted(index + 1);

                      final Color itemAccentColor = isCompleted ? const Color(0xFF10B981) : const Color(0xFFF97316);
                      final List<Color> itemGradient = isCompleted
                          ? [const Color(0xFF064E3B).withValues(alpha: 0.75), const Color(0xFF0A2E20)]
                          : [const Color(0xFF231F3D), const Color(0xFF1E1B4B)];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: itemGradient,
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: itemAccentColor,
                            width: 2.0,
                          ),
                          boxShadow: isCompleted
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.pop(context);
                              if (index == 0) {
                                _showArabic9Lesson1PartsSelectionModal(context);
                              } else if (index == 1) {
                                _showArabic9Lesson2PartsSelectionModal(context);
                              } else if (index == 2) {
                                _showArabic9Lesson3PartsSelectionModal(context);
                              } else if (index == 3) {
                                _showArabic9Lesson4PartsSelectionModal(context);
                              } else if (index == 4) {
                                _showArabic9Lesson5PartsSelectionModal(context);
                              } else if (index == 5) {
                                _showArabic9Lesson6PartsSelectionModal(context);
                              } else if (index == 6) {
                                _showArabic9Lesson7PartsSelectionModal(context);
                              } else if (index == 7) {
                                _showArabic9Lesson8PartsSelectionModal(context);
                              } else if (index == 8) {
                                _showArabic9Lesson9PartsSelectionModal(context);
                              } else if (index == 9) {
                                _showArabic9Lesson10PartsSelectionModal(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('بازی ${lesson['title']} به زودی فعال می‌شود! 🚀'),
                                    backgroundColor: const Color(0xFFF97316),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: itemAccentColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: isCompleted
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFF10B981).withValues(alpha: 0.4),
                                                blurRadius: 8,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: isCompleted
                                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                                          : Text(
                                              lesson['number']!,
                                              style: const TextStyle(fontFamily: 'Tahoma', fontWeight: FontWeight.w900, color: Colors.white, fontSize: 13),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lesson['title']!,
                                          style: const TextStyle(fontFamily: 'Tahoma', fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
                                        ),
                                        if (lesson['subtitle']!.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            lesson['subtitle']!,
                                            style: const TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if (isPlayable)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: itemAccentColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: itemAccentColor),
                                      ),
                                      child: Text(
                                        isCompleted ? 'تکمیل شده ✅' : 'شروع بازی 🎮',
                                        style: TextStyle(
                                          fontFamily: 'Tahoma',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isCompleted ? const Color(0xFF6EE7B7) : const Color(0xFFFDBA74),
                                        ),
                                      ),
                                    )
                                  else
                                    const Icon(Icons.lock_outline_rounded, color: Color(0xFF94A3B8), size: 16),
                                ],
                              ),
                            ),
                          ),
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

  void _showArabic9Lesson1PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic9Lesson1Part1Completed;
    final bool p2Completed = AuthManager.arabic9Lesson1Part2Completed;
    final bool p3Completed = AuthManager.arabic9Lesson1Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه نهم - اَلدَّرْسُ الْأَوَّلُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْأَوَّلُ (نهم)',
                          lessonKey: 'arabic9_lesson1',
                          customVocabulary: AuthManager.arabic9Lesson1Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْأَوَّلُ (نهم)',
                          lessonKey: 'arabic9_lesson1',
                          customWords: AuthManager.arabic9Lesson1Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْأَوَّلُ (نهم)',
                          lessonKey: 'arabic9_lesson1',
                          customWords: AuthManager.arabic9Lesson1Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic9Lesson2PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic9Lesson2Part1Completed;
    final bool p2Completed = AuthManager.arabic9Lesson2Part2Completed;
    final bool p3Completed = AuthManager.arabic9Lesson2Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه نهم - اَلدَّرْسُ الثّاني 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّاني (نهم)',
                          lessonKey: 'arabic9_lesson2',
                          customVocabulary: AuthManager.arabic9Lesson2Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّاني (نهم)',
                          lessonKey: 'arabic9_lesson2',
                          customWords: AuthManager.arabic9Lesson2Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّاني (نهم)',
                          lessonKey: 'arabic9_lesson2',
                          customWords: AuthManager.arabic9Lesson2Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic9Lesson3PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic9Lesson3Part1Completed;
    final bool p2Completed = AuthManager.arabic9Lesson3Part2Completed;
    final bool p3Completed = AuthManager.arabic9Lesson3Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه نهم - اَلدَّرْسُ الثّالِثُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّالِثُ (نهم)',
                          lessonKey: 'arabic9_lesson3',
                          customVocabulary: AuthManager.arabic9Lesson3Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّالِثُ (نهم)',
                          lessonKey: 'arabic9_lesson3',
                          customWords: AuthManager.arabic9Lesson3Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّالِثُ (نهم)',
                          lessonKey: 'arabic9_lesson3',
                          customWords: AuthManager.arabic9Lesson3Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic9Lesson4PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic9Lesson4Part1Completed;
    final bool p2Completed = AuthManager.arabic9Lesson4Part2Completed;
    final bool p3Completed = AuthManager.arabic9Lesson4Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه نهم - اَلدَّرْسُ الرّابِعُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الرّابِعُ (نهم)',
                          lessonKey: 'arabic9_lesson4',
                          customVocabulary: AuthManager.arabic9Lesson4Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الرّابِعُ (نهم)',
                          lessonKey: 'arabic9_lesson4',
                          customWords: AuthManager.arabic9Lesson4Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الرّابِعُ (نهم)',
                          lessonKey: 'arabic9_lesson4',
                          customWords: AuthManager.arabic9Lesson4Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic9Lesson5PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic9Lesson5Part1Completed;
    final bool p2Completed = AuthManager.arabic9Lesson5Part2Completed;
    final bool p3Completed = AuthManager.arabic9Lesson5Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه نهم - اَلدَّرْسُ الْخامِسُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْخامِسُ (نهم)',
                          lessonKey: 'arabic9_lesson5',
                          customVocabulary: AuthManager.arabic9Lesson5Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْخامِسُ (نهم)',
                          lessonKey: 'arabic9_lesson5',
                          customWords: AuthManager.arabic9Lesson5Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْخامِسُ (نهم)',
                          lessonKey: 'arabic9_lesson5',
                          customWords: AuthManager.arabic9Lesson5Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic9Lesson6PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic9Lesson6Part1Completed;
    final bool p2Completed = AuthManager.arabic9Lesson6Part2Completed;
    final bool p3Completed = AuthManager.arabic9Lesson6Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه نهم - اَلدَّرْسُ السّادِسُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ السّادِسُ (نهم)',
                          lessonKey: 'arabic9_lesson6',
                          customVocabulary: AuthManager.arabic9Lesson6Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ السّادِسُ (نهم)',
                          lessonKey: 'arabic9_lesson6',
                          customWords: AuthManager.arabic9Lesson6Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ السّادِسُ (نهم)',
                          lessonKey: 'arabic9_lesson6',
                          customWords: AuthManager.arabic9Lesson6Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic9Lesson7PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic9Lesson7Part1Completed;
    final bool p2Completed = AuthManager.arabic9Lesson7Part2Completed;
    final bool p3Completed = AuthManager.arabic9Lesson7Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه نهم - اَلدَّرْسُ السّابِعُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ السّابِعُ (نهم)',
                          lessonKey: 'arabic9_lesson7',
                          customVocabulary: AuthManager.arabic9Lesson7Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ السّابِعُ (نهم)',
                          lessonKey: 'arabic9_lesson7',
                          customWords: AuthManager.arabic9Lesson7Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ السّابِعُ (نهم)',
                          lessonKey: 'arabic9_lesson7',
                          customWords: AuthManager.arabic9Lesson7Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic9Lesson8PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic9Lesson8Part1Completed;
    final bool p2Completed = AuthManager.arabic9Lesson8Part2Completed;
    final bool p3Completed = AuthManager.arabic9Lesson8Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه نهم - اَلدَّرْسُ الثّامِنُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّامِنُ (نهم)',
                          lessonKey: 'arabic9_lesson8',
                          customVocabulary: AuthManager.arabic9Lesson8Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّامِنُ (نهم)',
                          lessonKey: 'arabic9_lesson8',
                          customWords: AuthManager.arabic9Lesson8Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّامِنُ (نهم)',
                          lessonKey: 'arabic9_lesson8',
                          customWords: AuthManager.arabic9Lesson8Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic9Lesson9PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic9Lesson9Part1Completed;
    final bool p2Completed = AuthManager.arabic9Lesson9Part2Completed;
    final bool p3Completed = AuthManager.arabic9Lesson9Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه نهم - اَلدَّرْسُ التّاسِعُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ التّاسِعُ (نهم)',
                          lessonKey: 'arabic9_lesson9',
                          customVocabulary: AuthManager.arabic9Lesson9Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ التّاسِعُ (نهم)',
                          lessonKey: 'arabic9_lesson9',
                          customWords: AuthManager.arabic9Lesson9Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ التّاسِعُ (نهم)',
                          lessonKey: 'arabic9_lesson9',
                          customWords: AuthManager.arabic9Lesson9Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic9Lesson10PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic9Lesson10Part1Completed;
    final bool p2Completed = AuthManager.arabic9Lesson10Part2Completed;
    final bool p3Completed = AuthManager.arabic9Lesson10Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه نهم - اَلدَّرْسُ الْعاشِِرُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْعاشِِرُ (نهم)',
                          lessonKey: 'arabic9_lesson10',
                          customVocabulary: AuthManager.arabic9Lesson10Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْعاشِِرُ (نهم)',
                          lessonKey: 'arabic9_lesson10',
                          customWords: AuthManager.arabic9Lesson10Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْعاشِِرُ (نهم)',
                          lessonKey: 'arabic9_lesson10',
                          customWords: AuthManager.arabic9Lesson10Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic8Lesson1PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic8Lesson1Part1Completed;
    final bool p2Completed = AuthManager.arabic8Lesson1Part2Completed;
    final bool p3Completed = AuthManager.arabic8Lesson1Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه هشتم - اَلدَّرْسُ الْأَوَّلُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْأَوَّلُ (هشتم)',
                          lessonKey: 'arabic8_lesson1',
                          customVocabulary: arabic8Lesson1Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْأَوَّلُ (هشتم)',
                          lessonKey: 'arabic8_lesson1',
                          customWords: arabic8Lesson1Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْأَوَّلُ (هشتم)',
                          lessonKey: 'arabic8_lesson1',
                          customWords: arabic8Lesson1Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic8Lesson2PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic8Lesson2Part1Completed;
    final bool p2Completed = AuthManager.arabic8Lesson2Part2Completed;
    final bool p3Completed = AuthManager.arabic8Lesson2Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه هشتم - اَلدَّرْسُ الثّاني 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّاني (هشتم)',
                          lessonKey: 'arabic8_lesson2',
                          customVocabulary: AuthManager.arabic8Lesson2Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّاني (هشتم)',
                          lessonKey: 'arabic8_lesson2',
                          customWords: AuthManager.arabic8Lesson2Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّاني (هشتم)',
                          lessonKey: 'arabic8_lesson2',
                          customWords: AuthManager.arabic8Lesson2Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic8Lesson3PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic8Lesson3Part1Completed;
    final bool p2Completed = AuthManager.arabic8Lesson3Part2Completed;
    final bool p3Completed = AuthManager.arabic8Lesson3Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه هشتم - اَلدَّرْسُ الثّالِثُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّالِثُ (هشتم)',
                          lessonKey: 'arabic8_lesson3',
                          customVocabulary: AuthManager.arabic8Lesson3Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّالِثُ (هشتم)',
                          lessonKey: 'arabic8_lesson3',
                          customWords: AuthManager.arabic8Lesson3Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّالِثُ (هشتم)',
                          lessonKey: 'arabic8_lesson3',
                          customWords: AuthManager.arabic8Lesson3Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic8Lesson4PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic8Lesson4Part1Completed;
    final bool p2Completed = AuthManager.arabic8Lesson4Part2Completed;
    final bool p3Completed = AuthManager.arabic8Lesson4Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه هشتم - اَلدَّرْسُ الرّابِعُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الرّابِعُ (هشتم)',
                          lessonKey: 'arabic8_lesson4',
                          customVocabulary: AuthManager.arabic8Lesson4Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الرّابِعُ (هشتم)',
                          lessonKey: 'arabic8_lesson4',
                          customWords: AuthManager.arabic8Lesson4Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الرّابِعُ (هشتم)',
                          lessonKey: 'arabic8_lesson4',
                          customWords: AuthManager.arabic8Lesson4Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic8Lesson5PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic8Lesson5Part1Completed;
    final bool p2Completed = AuthManager.arabic8Lesson5Part2Completed;
    final bool p3Completed = AuthManager.arabic8Lesson5Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه هشتم - اَلدَّرْسُ الْخامِسُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْخامِسُ (هشتم)',
                          lessonKey: 'arabic8_lesson5',
                          customVocabulary: AuthManager.arabic8Lesson5Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْخامِسُ (هشتم)',
                          lessonKey: 'arabic8_lesson5',
                          customWords: AuthManager.arabic8Lesson5Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْخامِسُ (هشتم)',
                          lessonKey: 'arabic8_lesson5',
                          customWords: AuthManager.arabic8Lesson5Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic8Lesson6PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic8Lesson6Part1Completed;
    final bool p2Completed = AuthManager.arabic8Lesson6Part2Completed;
    final bool p3Completed = AuthManager.arabic8Lesson6Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه هشتم - اَلدَّرْسُ السّادِسُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ السّادِسُ (هشتم)',
                          lessonKey: 'arabic8_lesson6',
                          customVocabulary: AuthManager.arabic8Lesson6Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ السّادِسُ (هشتم)',
                          lessonKey: 'arabic8_lesson6',
                          customWords: AuthManager.arabic8Lesson6Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ السّادِسُ (هشتم)',
                          lessonKey: 'arabic8_lesson6',
                          customWords: AuthManager.arabic8Lesson6Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic8Lesson7PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic8Lesson7Part1Completed;
    final bool p2Completed = AuthManager.arabic8Lesson7Part2Completed;
    final bool p3Completed = AuthManager.arabic8Lesson7Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه هشتم - اَلدَّرْسُ السّابِعُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ السّابِعُ (هشتم)',
                          lessonKey: 'arabic8_lesson7',
                          customVocabulary: AuthManager.arabic8Lesson7Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ السّابِعُ (هشتم)',
                          lessonKey: 'arabic8_lesson7',
                          customWords: AuthManager.arabic8Lesson7Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ السّابِعُ (هشتم)',
                          lessonKey: 'arabic8_lesson7',
                          customWords: AuthManager.arabic8Lesson7Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic8Lesson8PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic8Lesson8Part1Completed;
    final bool p2Completed = AuthManager.arabic8Lesson8Part2Completed;
    final bool p3Completed = AuthManager.arabic8Lesson8Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه هشتم - اَلدَّرْسُ الثّامِنُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّامِنُ (هشتم)',
                          lessonKey: 'arabic8_lesson8',
                          customVocabulary: AuthManager.arabic8Lesson8Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّامِنُ (هشتم)',
                          lessonKey: 'arabic8_lesson8',
                          customWords: AuthManager.arabic8Lesson8Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الثّامِنُ (هشتم)',
                          lessonKey: 'arabic8_lesson8',
                          customWords: AuthManager.arabic8Lesson8Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic8Lesson9PartsSelectionModal(BuildContext context) {
    final bool p1Completed = AuthManager.arabic8Lesson9Part1Completed;
    final bool p2Completed = AuthManager.arabic8Lesson9Part2Completed;
    final bool p3Completed = AuthManager.arabic8Lesson9Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه هشتم - اَلدَّرْسُ التّاسِعُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت اول: بازی تطبیق
                _buildGamePartButton(
                  title: 'قسمت اول: بازی تطبیق کلمات و ایموجی',
                  icon: '🧩',
                  color: const Color(0xFF14B8A6),
                  isCompleted: p1Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1GameScreen(
                          lessonTitle: 'اَلدَّرْسُ التّاسِعُ (هشتم)',
                          lessonKey: 'arabic8_lesson9',
                          customVocabulary: AuthManager.arabic8Lesson9Part1Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ التّاسِعُ (هشتم)',
                          lessonKey: 'arabic8_lesson9',
                          customWords: AuthManager.arabic8Lesson9Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ التّاسِعُ (هشتم)',
                          lessonKey: 'arabic8_lesson9',
                          customWords: AuthManager.arabic8Lesson9Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArabic8Lesson10PartsSelectionModal(BuildContext context) {
    final bool p2Completed = AuthManager.arabic8Lesson10Part2Completed;
    final bool p3Completed = AuthManager.arabic8Lesson10Part3Completed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F071E), Color(0xFF1E1B4B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عربی پایه هشتم - اَلدَّرْسُ الْعاشِِرُ 🌟',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'لطفاً بخش بازی مورد نظر خود را انتخاب کنید:',
                  style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 20),
                // قسمت دوم: بازی دیوار آتشین
                _buildGamePartButton(
                  title: 'قسمت دوم: بازی دیوار آتشین 🔥',
                  icon: '🔥',
                  color: const Color(0xFFF97316),
                  isCompleted: p2Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part2FirewallGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْعاشِِرُ (هشتم)',
                          lessonKey: 'arabic8_lesson10',
                          customWords: AuthManager.arabic8Lesson10Part2Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
                const SizedBox(height: 12),
                // قسمت سوم: بازی موشک و شهاب‌سنگ
                _buildGamePartButton(
                  title: 'قسمت سوم: بازی موشک و شهاب‌سنگ 🚀',
                  icon: '🚀',
                  color: const Color(0xFF8B5CF6),
                  isCompleted: p3Completed,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArabicLesson1Part3RocketGameScreen(
                          lessonTitle: 'اَلدَّرْسُ الْعاشِِرُ (هشتم)',
                          lessonKey: 'arabic8_lesson10',
                          customWords: AuthManager.arabic8Lesson10Part3Vocab,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // نوار ناوبری پایین
  Widget _buildBottomNav() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_rounded, 'خانه', 0),
          _buildNavItem(Icons.emoji_events_rounded, '', 1),
          _buildNavItem(Icons.storefront_rounded, 'فروشگاه', 2),
          _buildNavItem(Icons.person_rounded, '', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _bottomNavIndex == index;

    return GestureDetector(
      onTap: () => setState(() {
        _bottomNavIndex = index;
        if (index == 0) {
          _currentGrade = AuthManager.selectedGrade;
          _gradePageController.dispose();
          _gradePageController = PageController(initialPage: _currentGrade);
        }
      }),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF60A5FA) : const Color(0xFF94A3B8),
              size: isSelected ? 23 : 21,
            ),
            if (isSelected && label.isNotEmpty) const SizedBox(height: 4),
            if (isSelected && label.isNotEmpty)
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF60A5FA),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// صفحه بازی پازل تطبیق کلمات عربی (پویا برای درس اول و دوم)
// ==========================================
class ArabicLesson1GameScreen extends StatefulWidget {
  final String lessonTitle;
  final List<Map<String, String>>? customVocabulary;
  final String lessonKey;
  final bool isChallengeMode;
  final int challengeTimeLimitSeconds;
  final void Function(int coinsEarned, int timeTakenSeconds)? onChallengeComplete;

  const ArabicLesson1GameScreen({
    super.key,
    required this.lessonTitle,
    this.customVocabulary,
    this.lessonKey = 'lesson1',
    this.isChallengeMode = false,
    this.challengeTimeLimitSeconds = 60,
    this.onChallengeComplete,
  });

  @override
  State<ArabicLesson1GameScreen> createState() => _ArabicLesson1GameScreenState();
}

class _ArabicLesson1GameScreenState extends State<ArabicLesson1GameScreen> {
  late final List<Map<String, String>> _vocabularyPairs;

  late List<Map<String, dynamic>> _tiles;
  Map<String, dynamic>? _firstSelectedTile;
  bool _isChecking = false;
  int _hintsRemaining = 3;
  int _matchedPairsCount = 0;
  int _sessionCoins = 0;
  
  String? _floatingMessage;
  Color _floatingMessageColor = Colors.green;

  Timer? _mismatchTimer;
  Timer? _hintTimer;
  Timer? _challengeCountdownTimer;
  int _challengeSecondsLeft = 60;
  bool _challengeEnded = false;

  void _finishChallenge() {
    if (_challengeEnded) return;
    _challengeEnded = true;
    _challengeCountdownTimer?.cancel();
    final int finalCoins = math.max(0, _sessionCoins);
    final int timeTaken = math.max(1, widget.challengeTimeLimitSeconds - _challengeSecondsLeft);
    if (widget.onChallengeComplete != null) {
      widget.onChallengeComplete!(finalCoins, timeTaken);
    } else {
      Navigator.pop(context, {'coins': finalCoins, 'timeTaken': timeTaken});
    }
  }

  Widget _buildChallengeTopTimer() {
    final int sec = _challengeSecondsLeft;
    final bool isLow = sec <= 10;
    final String timeStr = '00:${sec.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isLow ? Colors.red.withOpacity(0.25) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLow ? Colors.redAccent : const Color(0xFF00E5FF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isLow ? Colors.redAccent : const Color(0xFF00E5FF)).withOpacity(0.35),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_rounded,
            size: 18,
            color: isLow ? Colors.redAccent : const Color(0xFF00E5FF),
          ),
          const SizedBox(width: 8),
          Text(
            timeStr,
            style: TextStyle(
              fontFamily: 'Tahoma',
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: isLow ? Colors.redAccent : Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mismatchTimer?.cancel();
    _hintTimer?.cancel();
    _challengeCountdownTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _vocabularyPairs = widget.customVocabulary ?? lesson1Part1Vocab;
    _initGame();
    if (widget.isChallengeMode) {
      _challengeSecondsLeft = widget.challengeTimeLimitSeconds;
      _challengeCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        if (_challengeSecondsLeft > 0) {
          setState(() {
            _challengeSecondsLeft--;
          });
          if (_challengeSecondsLeft <= 0) {
            timer.cancel();
            _finishChallenge();
          }
        }
      });
    }
    bool isCompleted = widget.lessonKey.contains('zaban9_lesson6') ? AuthManager.zaban9Lesson6Part1Completed :
                       widget.lessonKey.contains('zaban9_lesson5') ? AuthManager.zaban9Lesson5Part1Completed :
                       widget.lessonKey.contains('zaban9_lesson4') ? AuthManager.zaban9Lesson4Part1Completed :
                       widget.lessonKey.contains('zaban9_lesson3') ? AuthManager.zaban9Lesson3Part1Completed :
                       widget.lessonKey.contains('zaban9_lesson2') ? AuthManager.zaban9Lesson2Part1Completed :
                       widget.lessonKey.contains('zaban9_lesson1') ? AuthManager.zaban9Lesson1Part1Completed :
                       widget.lessonKey.contains('zaban8_lesson7') ? AuthManager.zaban8Lesson7Part1Completed :
                       widget.lessonKey.contains('zaban8_lesson6') ? AuthManager.zaban8Lesson6Part1Completed :
                       widget.lessonKey.contains('zaban8_lesson5') ? AuthManager.zaban8Lesson5Part1Completed :
                       widget.lessonKey.contains('zaban8_lesson4') ? AuthManager.zaban8Lesson4Part1Completed :
                       widget.lessonKey.contains('zaban8_lesson3') ? AuthManager.zaban8Lesson3Part1Completed :
                       widget.lessonKey.contains('zaban7_lesson8') ? AuthManager.zaban7Lesson8Part1Completed :
                       widget.lessonKey.contains('zaban7_lesson6') ? AuthManager.zaban7Lesson6Part1Completed :
                       widget.lessonKey.contains('zaban7_lesson5') ? AuthManager.zaban7Lesson5Part1Completed :
                       widget.lessonKey.contains('zaban7_lesson4') ? AuthManager.zaban7Lesson4Part1Completed :
                       widget.lessonKey.contains('zaban7_welcome') ? AuthManager.zaban7WelcomePart1Completed :
                       widget.lessonKey.contains('zaban7_lesson1') ? AuthManager.zaban7Lesson1Part1Completed :
                       widget.lessonKey.contains('quran9_lesson11') ? AuthManager.quran9Lesson11Part1Completed :
                       widget.lessonKey.contains('quran9_lesson10') ? AuthManager.quran9Lesson10Part1Completed :
                       widget.lessonKey.contains('quran9_lesson9') ? AuthManager.quran9Lesson9Part1Completed :
                       widget.lessonKey.contains('quran9_lesson8') ? AuthManager.quran9Lesson8Part1Completed :
                       widget.lessonKey.contains('quran9_lesson7') ? AuthManager.quran9Lesson7Part1Completed :
                       widget.lessonKey.contains('quran9_lesson6') ? AuthManager.quran9Lesson6Part1Completed :
                       widget.lessonKey.contains('quran9_lesson5') ? AuthManager.quran9Lesson5Part1Completed :
                       widget.lessonKey.contains('quran9_lesson4') ? AuthManager.quran9Lesson4Part1Completed :
                       widget.lessonKey.contains('quran9_lesson3') ? AuthManager.quran9Lesson3Part1Completed :
                       widget.lessonKey.contains('quran9_lesson2') ? AuthManager.quran9Lesson2Part1Completed :
                       widget.lessonKey.contains('quran8_lesson12') ? AuthManager.quran8Lesson12Part1Completed :
                       widget.lessonKey.contains('quran8_lesson11') ? AuthManager.quran8Lesson11Part1Completed :
                       widget.lessonKey.contains('quran8_lesson10') ? AuthManager.quran8Lesson10Part1Completed :
                       widget.lessonKey.contains('quran8_lesson9') ? AuthManager.quran8Lesson9Part1Completed :
                       widget.lessonKey.contains('quran8_lesson8') ? AuthManager.quran8Lesson8Part1Completed :
                       widget.lessonKey.contains('quran8_lesson7') ? AuthManager.quran8Lesson7Part1Completed :
                       widget.lessonKey.contains('quran8_lesson6') ? AuthManager.quran8Lesson6Part1Completed :
                       widget.lessonKey.contains('quran8_lesson5') ? AuthManager.quran8Lesson5Part1Completed :
                       widget.lessonKey.contains('quran8_lesson4') ? AuthManager.quran8Lesson4Part1Completed :
                       widget.lessonKey.contains('quran8_lesson3') ? AuthManager.quran8Lesson3Part1Completed :
                       widget.lessonKey.contains('quran8_lesson2') ? AuthManager.quran8Lesson2Part1Completed :
                       widget.lessonKey.contains('quran8_lesson1') ? AuthManager.quran8Lesson1Part1Completed :
                       widget.lessonKey.contains('quran7_lesson12') ? AuthManager.quran7Lesson12Part1Completed :
                       widget.lessonKey.contains('quran7_lesson11') ? AuthManager.quran7Lesson11Part1Completed :
                       widget.lessonKey.contains('quran7_lesson10') ? AuthManager.quran7Lesson10Part1Completed :
                       widget.lessonKey.contains('quran7_lesson9') ? AuthManager.quran7Lesson9Part1Completed :
                       widget.lessonKey.contains('quran7_lesson8') ? AuthManager.quran7Lesson8Part1Completed :
                       widget.lessonKey.contains('quran7_lesson7') ? AuthManager.quran7Lesson7Part1Completed :
                       widget.lessonKey.contains('quran7_lesson6') ? AuthManager.quran7Lesson6Part1Completed :
                       widget.lessonKey.contains('quran7_lesson5') ? AuthManager.quran7Lesson5Part1Completed :
                       widget.lessonKey.contains('quran7_lesson4') ? AuthManager.quran7Lesson4Part1Completed :
                       widget.lessonKey.contains('quran7_lesson3') ? AuthManager.quran7Lesson3Part1Completed :
                       widget.lessonKey.contains('quran7_lesson2') ? AuthManager.quran7Lesson2Part1Completed :
                       (widget.lessonKey.contains('quran7_lesson1') || (widget.lessonTitle.contains('قرآن') && widget.lessonTitle.contains('درس اول'))) ? AuthManager.quran7Lesson1Part1Completed :
                       widget.lessonKey == 'arabic9_lesson10' ? AuthManager.arabic9Lesson10Part1Completed :
                       widget.lessonKey == 'arabic9_lesson9' ? AuthManager.arabic9Lesson9Part1Completed :
                       widget.lessonKey == 'arabic9_lesson8' ? AuthManager.arabic9Lesson8Part1Completed :
                       widget.lessonKey == 'arabic9_lesson7' ? AuthManager.arabic9Lesson7Part1Completed :
                       widget.lessonKey == 'arabic9_lesson6' ? AuthManager.arabic9Lesson6Part1Completed :
                       widget.lessonKey == 'arabic9_lesson5' ? AuthManager.arabic9Lesson5Part1Completed :
                       widget.lessonKey == 'arabic9_lesson4' ? AuthManager.arabic9Lesson4Part1Completed :
                       widget.lessonKey == 'arabic9_lesson3' ? AuthManager.arabic9Lesson3Part1Completed :
                       widget.lessonKey == 'arabic9_lesson2' ? AuthManager.arabic9Lesson2Part1Completed :
                       widget.lessonKey == 'arabic9_lesson1' ? AuthManager.arabic9Lesson1Part1Completed :
                       widget.lessonKey == 'arabic8_lesson9' ? AuthManager.arabic8Lesson9Part1Completed :
                       widget.lessonKey == 'arabic8_lesson8' ? AuthManager.arabic8Lesson8Part1Completed :
                       widget.lessonKey == 'arabic8_lesson7' ? AuthManager.arabic8Lesson7Part1Completed :
                       widget.lessonKey == 'arabic8_lesson6' ? AuthManager.arabic8Lesson6Part1Completed :
                       widget.lessonKey == 'arabic8_lesson5' ? AuthManager.arabic8Lesson5Part1Completed :
                       widget.lessonKey == 'arabic8_lesson4' ? AuthManager.arabic8Lesson4Part1Completed :
                       widget.lessonKey == 'arabic8_lesson3' ? AuthManager.arabic8Lesson3Part1Completed :
                       widget.lessonKey == 'arabic8_lesson2' ? AuthManager.arabic8Lesson2Part1Completed :
                       widget.lessonKey == 'arabic8_lesson1' ? AuthManager.arabic8Lesson1Part1Completed :
                       widget.lessonKey == 'lesson19' ? AuthManager.lesson19Part1Completed :
                       widget.lessonKey == 'lesson18' ? AuthManager.lesson18Part1Completed :
                       widget.lessonKey == 'lesson17' ? AuthManager.lesson17Part1Completed :
                       widget.lessonKey == 'lesson16' ? AuthManager.lesson16Part1Completed :
                       widget.lessonKey == 'lesson15' ? AuthManager.lesson15Part1Completed :
                       widget.lessonKey == 'lesson14' ? AuthManager.lesson14Part1Completed :
                       widget.lessonKey == 'lesson13' ? AuthManager.lesson13Part1Completed :
                       widget.lessonKey == 'lesson12' ? AuthManager.lesson12Part1Completed :
                       widget.lessonKey == 'lesson11' ? AuthManager.lesson11Part1Completed :
                       widget.lessonKey == 'lesson10' ? AuthManager.lesson10Part1Completed :
                       widget.lessonKey == 'lesson9' ? AuthManager.lesson9Part1Completed :
                       widget.lessonKey == 'lesson8' ? AuthManager.lesson8Part1Completed :
                       widget.lessonKey == 'lesson7' ? AuthManager.lesson7Part1Completed :
                       widget.lessonKey == 'lesson6' ? AuthManager.lesson6Part1Completed :
                       widget.lessonKey == 'lesson5' ? AuthManager.lesson5Part1Completed :
                       widget.lessonKey == 'lesson4' ? AuthManager.lesson4Part1Completed :
                       widget.lessonKey == 'lesson3' ? AuthManager.lesson3Part1Completed :
                       widget.lessonKey == 'lesson2' ? AuthManager.lesson2Part1Completed :
                       AuthManager.lesson1Part1Completed;
    if (!widget.isChallengeMode && !widget.lessonKey.contains('battle')) {
      if (isCompleted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showReplayWarningDialog();
        });
      }
    }
  }

  void _showReplayWarningDialog() {
    if (widget.isChallengeMode || widget.lessonKey.contains('battle')) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: const Color(0xFF1E1B4B),
            title: const Row(
              children: [
                Text('⚠️', style: TextStyle(fontSize: 28)),
                SizedBox(width: 10),
                Text('توجه', style: TextStyle(fontFamily: 'Tahoma', color: Colors.white, fontWeight: FontWeight.w900)),
              ],
            ),
            content: const Text(
              'شما این بازی رو تا آخر رفتید و اینبار سکه نمی‌گیرید!',
              style: TextStyle(fontFamily: 'Tahoma', color: Color(0xFFCBD5E1), fontSize: 13, height: 1.5),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEA580C)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text('متوجه شدم', style: TextStyle(fontFamily: 'Tahoma', color: Colors.white, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _initGame() {
    _mismatchTimer?.cancel();
    _hintTimer?.cancel();
    List<Map<String, dynamic>> tempTiles = [];
    for (int i = 0; i < _vocabularyPairs.length; i++) {
      final pair = _vocabularyPairs[i];
      tempTiles.add({
        'id': i,
        'type': 'emoji',
        'content': pair['emoji']!,
        'isFlipped': false,
        'isMatched': false,
      });
      tempTiles.add({
        'id': i,
        'type': 'word',
        'content': pair['word']!,
        'isFlipped': false,
        'isMatched': false,
      });
    }
    tempTiles.shuffle(math.Random());
    _tiles = tempTiles;
    _matchedPairsCount = 0;
    _firstSelectedTile = null;
    _isChecking = false;
  }

  void _showFloatingFeedback(String msg, Color color) {
    setState(() {
      _floatingMessage = msg;
      _floatingMessageColor = color;
    });
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _floatingMessage = null;
        });
      }
    });
  }

  void _useHint() {
    if (_hintsRemaining <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('راهنمایی به اتمام رسیده است!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _hintsRemaining--;
    });

    setState(() {
      for (var tile in _tiles) {
        if (!tile['isMatched']) {
          tile['isFlipped'] = true;
        }
      }
    });

    _hintTimer?.cancel();
    _hintTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          for (var tile in _tiles) {
            if (!tile['isMatched']) {
              tile['isFlipped'] = false;
            }
          }
        });
      }
    });
  }

  void _onTileTap(int index) {
    if (_isChecking) return;
    final tile = _tiles[index];
    if (tile['isFlipped'] || tile['isMatched']) return;

    setState(() {
      tile['isFlipped'] = true;
    });

    if (_firstSelectedTile == null) {
      _firstSelectedTile = tile;
    } else {
      final firstTile = _firstSelectedTile!;
      final secondTile = tile;
      _firstSelectedTile = null;

      if (firstTile['id'] == secondTile['id'] &&
          firstTile['type'] != secondTile['type']) {
        setState(() {
          firstTile['isMatched'] = true;
          secondTile['isMatched'] = true;
          _matchedPairsCount++;
          _sessionCoins += 10;
        });

        if (_matchedPairsCount == _vocabularyPairs.length) {
          Timer(const Duration(milliseconds: 500), () {
            if (mounted) _showVictoryDialog();
          });
        }
      } else {
        setState(() {
          _isChecking = true;
        });
        _mismatchTimer = Timer(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              if (!firstTile['isMatched']) firstTile['isFlipped'] = false;
              if (!secondTile['isMatched']) secondTile['isFlipped'] = false;
              _isChecking = false;
            });
          }
        });
      }
    }
  }

  void _showEpicVictoryDialog({
    required int sessionCoins,
    required bool alreadyCompleted,
    required String titleText,
    required String buttonText,
    required VoidCallback onNext,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            backgroundColor: const Color(0xFF1E1B4B),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E1065), Color(0xFF1E1B4B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: alreadyCompleted ? const Color(0xFFF97316) : const Color(0xFFFFB703), width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: (alreadyCompleted ? const Color(0xFFF97316) : const Color(0xFFFFB703)).withOpacity(0.4),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: (alreadyCompleted ? const Color(0xFFF97316) : const Color(0xFFFFB703)).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: alreadyCompleted ? const Color(0xFFF97316) : const Color(0xFFFFB703), width: 2),
                    ),
                    child: Text(alreadyCompleted ? '⚠️' : '🏆', style: const TextStyle(fontSize: 44)),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    alreadyCompleted ? 'تکرار مأموریت' : titleText,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alreadyCompleted
                        ? 'شما این بازی را قبلاً تا آخر رفته‌اید و این بار سکه دریافت نمی‌کنید!'
                        : 'عالی بود! شما مرحله را با موفقیت پشت سر گذاشتید و جوایز ارزنده‌ای کسب کردید',
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!alreadyCompleted) ...[
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFFFB703), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFB703).withOpacity(0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🪙', style: TextStyle(fontSize: 26)),
                          const SizedBox(width: 10),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              '+$sessionCoins',
                              style: const TextStyle(
                                fontFamily: 'Tahoma',
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFFB703),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.5),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () async {
                          await AuthManager.save();
                          Navigator.pop(context); // close dialog
                          onNext();
                        },
                        child: Center(
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showVictoryDialog() {
    if (widget.isChallengeMode || widget.lessonKey.contains('battle')) {
      _finishChallenge();
      return;
    }
    bool alreadyCompleted = widget.lessonKey.contains('zaban9_lesson6') ? AuthManager.zaban9Lesson6Part1Completed :
                            widget.lessonKey.contains('zaban9_lesson5') ? AuthManager.zaban9Lesson5Part1Completed :
                            widget.lessonKey.contains('zaban9_lesson4') ? AuthManager.zaban9Lesson4Part1Completed :
                            widget.lessonKey.contains('zaban9_lesson3') ? AuthManager.zaban9Lesson3Part1Completed :
                            widget.lessonKey.contains('zaban9_lesson2') ? AuthManager.zaban9Lesson2Part1Completed :
                            widget.lessonKey.contains('zaban9_lesson1') ? AuthManager.zaban9Lesson1Part1Completed :
                            widget.lessonKey.contains('zaban8_lesson7') ? AuthManager.zaban8Lesson7Part1Completed :
                            widget.lessonKey.contains('zaban8_lesson6') ? AuthManager.zaban8Lesson6Part1Completed :
                            widget.lessonKey.contains('zaban8_lesson5') ? AuthManager.zaban8Lesson5Part1Completed :
                            widget.lessonKey.contains('zaban8_lesson4') ? AuthManager.zaban8Lesson4Part1Completed :
                            widget.lessonKey.contains('zaban8_lesson3') ? AuthManager.zaban8Lesson3Part1Completed :
                            widget.lessonKey.contains('zaban7_lesson8') ? AuthManager.zaban7Lesson8Part1Completed :
                            widget.lessonKey.contains('zaban7_lesson6') ? AuthManager.zaban7Lesson6Part1Completed :
                            widget.lessonKey.contains('zaban7_lesson5') ? AuthManager.zaban7Lesson5Part1Completed :
                            widget.lessonKey.contains('zaban7_lesson4') ? AuthManager.zaban7Lesson4Part1Completed :
                            widget.lessonKey.contains('zaban7_welcome') ? AuthManager.zaban7WelcomePart1Completed :
                            widget.lessonKey.contains('zaban7_lesson1') ? AuthManager.zaban7Lesson1Part1Completed :
                            widget.lessonKey.contains('quran9_lesson11') ? AuthManager.quran9Lesson11Part1Completed :
                            widget.lessonKey.contains('quran9_lesson10') ? AuthManager.quran9Lesson10Part1Completed :
                            widget.lessonKey.contains('quran9_lesson9') ? AuthManager.quran9Lesson9Part1Completed :
                            widget.lessonKey.contains('quran9_lesson8') ? AuthManager.quran9Lesson8Part1Completed :
                            widget.lessonKey.contains('quran9_lesson7') ? AuthManager.quran9Lesson7Part1Completed :
                            widget.lessonKey.contains('quran9_lesson6') ? AuthManager.quran9Lesson6Part1Completed :
                            widget.lessonKey.contains('quran9_lesson5') ? AuthManager.quran9Lesson5Part1Completed :
                            widget.lessonKey.contains('quran9_lesson4') ? AuthManager.quran9Lesson4Part1Completed :
                            widget.lessonKey.contains('quran9_lesson3') ? AuthManager.quran9Lesson3Part1Completed :
                            widget.lessonKey.contains('quran9_lesson2') ? AuthManager.quran9Lesson2Part1Completed :
                            widget.lessonKey.contains('quran9_lesson1') ? AuthManager.quran9Lesson1Part2Completed :
                            widget.lessonKey.contains('quran8_lesson12') ? AuthManager.quran8Lesson12Part1Completed :
                            widget.lessonKey.contains('quran8_lesson11') ? AuthManager.quran8Lesson11Part1Completed :
                            widget.lessonKey.contains('quran8_lesson10') ? AuthManager.quran8Lesson10Part1Completed :
                            widget.lessonKey.contains('quran8_lesson9') ? AuthManager.quran8Lesson9Part1Completed :
                            widget.lessonKey.contains('quran8_lesson8') ? AuthManager.quran8Lesson8Part1Completed :
                            widget.lessonKey.contains('quran8_lesson7') ? AuthManager.quran8Lesson7Part1Completed :
                            widget.lessonKey.contains('quran8_lesson6') ? AuthManager.quran8Lesson6Part1Completed :
                            widget.lessonKey.contains('quran8_lesson5') ? AuthManager.quran8Lesson5Part1Completed :
                            widget.lessonKey.contains('quran8_lesson4') ? AuthManager.quran8Lesson4Part1Completed :
                            widget.lessonKey.contains('quran8_lesson3') ? AuthManager.quran8Lesson3Part1Completed :
                            widget.lessonKey.contains('quran8_lesson2') ? AuthManager.quran8Lesson2Part1Completed :
                            widget.lessonKey.contains('quran8_lesson1') ? AuthManager.quran8Lesson1Part1Completed :
                            widget.lessonKey.contains('quran7_lesson12') ? AuthManager.quran7Lesson12Part1Completed :
                            widget.lessonKey.contains('quran7_lesson11') ? AuthManager.quran7Lesson11Part1Completed :
                            widget.lessonKey.contains('quran7_lesson10') ? AuthManager.quran7Lesson10Part1Completed :
                            widget.lessonKey.contains('quran7_lesson9') ? AuthManager.quran7Lesson9Part1Completed :
                            widget.lessonKey.contains('quran7_lesson8') ? AuthManager.quran7Lesson8Part1Completed :
                            widget.lessonKey.contains('quran7_lesson7') ? AuthManager.quran7Lesson7Part1Completed :
                            widget.lessonKey.contains('quran7_lesson6') ? AuthManager.quran7Lesson6Part1Completed :
                            widget.lessonKey.contains('quran7_lesson5') ? AuthManager.quran7Lesson5Part1Completed :
                            widget.lessonKey.contains('quran7_lesson4') ? AuthManager.quran7Lesson4Part1Completed :
                            widget.lessonKey.contains('quran7_lesson3') ? AuthManager.quran7Lesson3Part1Completed :
                            widget.lessonKey.contains('quran7_lesson2') ? AuthManager.quran7Lesson2Part1Completed :
                            (widget.lessonKey.contains('quran7_lesson1') || (widget.lessonTitle.contains('قرآن') && widget.lessonTitle.contains('درس اول'))) ? AuthManager.quran7Lesson1Part1Completed :
                            widget.lessonKey == 'arabic9_lesson10' ? AuthManager.arabic9Lesson10Part1Completed :
                            widget.lessonKey == 'arabic9_lesson9' ? AuthManager.arabic9Lesson9Part1Completed :
                            widget.lessonKey == 'arabic9_lesson8' ? AuthManager.arabic9Lesson8Part1Completed :
                            widget.lessonKey == 'arabic9_lesson7' ? AuthManager.arabic9Lesson7Part1Completed :
                            widget.lessonKey == 'arabic9_lesson6' ? AuthManager.arabic9Lesson6Part1Completed :
                            widget.lessonKey == 'arabic9_lesson5' ? AuthManager.arabic9Lesson5Part1Completed :
                            widget.lessonKey == 'arabic9_lesson4' ? AuthManager.arabic9Lesson4Part1Completed :
                            widget.lessonKey == 'arabic9_lesson3' ? AuthManager.arabic9Lesson3Part1Completed :
                            widget.lessonKey == 'arabic9_lesson2' ? AuthManager.arabic9Lesson2Part1Completed :
                            widget.lessonKey == 'arabic9_lesson1' ? AuthManager.arabic9Lesson1Part1Completed :
                            widget.lessonKey == 'arabic8_lesson9' ? AuthManager.arabic8Lesson9Part1Completed :
                            widget.lessonKey == 'arabic8_lesson8' ? AuthManager.arabic8Lesson8Part1Completed :
                            widget.lessonKey == 'arabic8_lesson7' ? AuthManager.arabic8Lesson7Part1Completed :
                            widget.lessonKey == 'arabic8_lesson6' ? AuthManager.arabic8Lesson6Part1Completed :
                            widget.lessonKey == 'arabic8_lesson5' ? AuthManager.arabic8Lesson5Part1Completed :
                            widget.lessonKey == 'arabic8_lesson4' ? AuthManager.arabic8Lesson4Part1Completed :
                            widget.lessonKey == 'arabic8_lesson3' ? AuthManager.arabic8Lesson3Part1Completed :
                            widget.lessonKey == 'arabic8_lesson2' ? AuthManager.arabic8Lesson2Part1Completed :
                            widget.lessonKey == 'arabic8_lesson1' ? AuthManager.arabic8Lesson1Part1Completed :
                            widget.lessonKey == 'lesson19' ? AuthManager.lesson19Part1Completed :
                            widget.lessonKey == 'lesson18' ? AuthManager.lesson18Part1Completed :
                            widget.lessonKey == 'lesson17' ? AuthManager.lesson17Part1Completed :
                            widget.lessonKey == 'lesson16' ? AuthManager.lesson16Part1Completed :
                            widget.lessonKey == 'lesson15' ? AuthManager.lesson15Part1Completed :
                            widget.lessonKey == 'lesson14' ? AuthManager.lesson14Part1Completed :
                            widget.lessonKey == 'lesson13' ? AuthManager.lesson13Part1Completed :
                            widget.lessonKey == 'lesson12' ? AuthManager.lesson12Part1Completed :
                            widget.lessonKey == 'lesson11' ? AuthManager.lesson11Part1Completed :
                            widget.lessonKey == 'lesson10' ? AuthManager.lesson10Part1Completed :
                            widget.lessonKey == 'lesson9' ? AuthManager.lesson9Part1Completed :
                            widget.lessonKey == 'lesson8' ? AuthManager.lesson8Part1Completed :
                            widget.lessonKey == 'lesson7' ? AuthManager.lesson7Part1Completed :
                            widget.lessonKey == 'lesson6' ? AuthManager.lesson6Part1Completed :
                            widget.lessonKey == 'lesson5' ? AuthManager.lesson5Part1Completed :
                            widget.lessonKey == 'lesson4' ? AuthManager.lesson4Part1Completed :
                            widget.lessonKey == 'lesson3' ? AuthManager.lesson3Part1Completed :
                            widget.lessonKey == 'lesson2' ? AuthManager.lesson2Part1Completed :
                            AuthManager.lesson1Part1Completed;
    if (!alreadyCompleted) {
      setState(() {
        AuthManager.coins += _sessionCoins;
        if (widget.lessonKey.contains('zaban9_lesson6')) {
          AuthManager.zaban9Lesson6Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban9_lesson5')) {
          AuthManager.zaban9Lesson5Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban9_lesson4')) {
          AuthManager.zaban9Lesson4Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban9_lesson3')) {
          AuthManager.zaban9Lesson3Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban9_lesson2')) {
          AuthManager.zaban9Lesson2Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban9_lesson1')) {
          AuthManager.zaban9Lesson1Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban8_lesson7')) {
          AuthManager.zaban8Lesson7Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban8_lesson6')) {
          AuthManager.zaban8Lesson6Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban8_lesson5')) {
          AuthManager.zaban8Lesson5Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban8_lesson4')) {
          AuthManager.zaban8Lesson4Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban8_lesson3')) {
          AuthManager.zaban8Lesson3Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban7_lesson8')) {
          AuthManager.zaban7Lesson8Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban7_lesson6')) {
          AuthManager.zaban7Lesson6Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban7_lesson5')) {
          AuthManager.zaban7Lesson5Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban7_lesson4')) {
          AuthManager.zaban7Lesson4Part1Completed = true;
        } else if (widget.lessonKey.contains('zaban7_welcome')) {
          AuthManager.zaban7WelcomePart1Completed = true;
        } else if (widget.lessonKey.contains('zaban7_lesson1')) {
          AuthManager.zaban7Lesson1Part1Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson11')) {
          AuthManager.quran9Lesson11Part1Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson10')) {
          AuthManager.quran9Lesson10Part1Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson9')) {
          AuthManager.quran9Lesson9Part1Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson8')) {
          AuthManager.quran9Lesson8Part1Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson7')) {
          AuthManager.quran9Lesson7Part1Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson6')) {
          AuthManager.quran9Lesson6Part1Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson5')) {
          AuthManager.quran9Lesson5Part1Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson4')) {
          AuthManager.quran9Lesson4Part1Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson3')) {
          AuthManager.quran9Lesson3Part1Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson2')) {
          AuthManager.quran9Lesson2Part1Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson1')) {
          AuthManager.quran9Lesson1Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson12')) {
          AuthManager.quran8Lesson12Part1Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson11')) {
          AuthManager.quran8Lesson11Part1Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson10')) {
          AuthManager.quran8Lesson10Part1Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson9')) {
          AuthManager.quran8Lesson9Part1Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson8')) {
          AuthManager.quran8Lesson8Part1Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson7')) {
          AuthManager.quran8Lesson7Part1Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson6')) {
          AuthManager.quran8Lesson6Part1Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson5')) {
          AuthManager.quran8Lesson5Part1Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson4')) {
          AuthManager.quran8Lesson4Part1Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson3')) {
          AuthManager.quran8Lesson3Part1Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson2')) {
          AuthManager.quran8Lesson2Part1Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson1')) {
          AuthManager.quran8Lesson1Part1Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson12')) {
          AuthManager.quran7Lesson12Part1Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson11')) {
          AuthManager.quran7Lesson11Part1Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson10')) {
          AuthManager.quran7Lesson10Part1Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson9')) {
          AuthManager.quran7Lesson9Part1Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson8')) {
          AuthManager.quran7Lesson8Part1Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson7')) {
          AuthManager.quran7Lesson7Part1Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson6')) {
          AuthManager.quran7Lesson6Part1Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson5')) {
          AuthManager.quran7Lesson5Part1Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson4')) {
          AuthManager.quran7Lesson4Part1Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson3')) {
          AuthManager.quran7Lesson3Part1Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson2')) {
          AuthManager.quran7Lesson2Part1Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson1') || (widget.lessonTitle.contains('قرآن') && widget.lessonTitle.contains('درس اول'))) {
          AuthManager.quran7Lesson1Part1Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson10') {
          AuthManager.arabic9Lesson10Part1Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson9') {
          AuthManager.arabic9Lesson9Part1Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson8') {
          AuthManager.arabic9Lesson8Part1Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson7') {
          AuthManager.arabic9Lesson7Part1Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson6') {
          AuthManager.arabic9Lesson6Part1Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson5') {
          AuthManager.arabic9Lesson5Part1Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson4') {
          AuthManager.arabic9Lesson4Part1Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson3') {
          AuthManager.arabic9Lesson3Part1Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson2') {
          AuthManager.arabic9Lesson2Part1Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson1') {
          AuthManager.arabic9Lesson1Part1Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson9') {
          AuthManager.arabic8Lesson9Part1Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson8') {
          AuthManager.arabic8Lesson8Part1Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson7') {
          AuthManager.arabic8Lesson7Part1Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson6') {
          AuthManager.arabic8Lesson6Part1Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson5') {
          AuthManager.arabic8Lesson5Part1Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson4') {
          AuthManager.arabic8Lesson4Part1Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson3') {
          AuthManager.arabic8Lesson3Part1Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson2') {
          AuthManager.arabic8Lesson2Part1Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson1') {
          AuthManager.arabic8Lesson1Part1Completed = true;
        } else if (widget.lessonKey == 'lesson19') {
          AuthManager.lesson19Part1Completed = true;
        } else if (widget.lessonKey == 'lesson18') {
          AuthManager.lesson18Part1Completed = true;
        } else if (widget.lessonKey == 'lesson17') {
          AuthManager.lesson17Part1Completed = true;
        } else if (widget.lessonKey == 'lesson16') {
          AuthManager.lesson16Part1Completed = true;
        } else if (widget.lessonKey == 'lesson15') {
          AuthManager.lesson15Part1Completed = true;
        } else if (widget.lessonKey == 'lesson14') {
          AuthManager.lesson14Part1Completed = true;
        } else if (widget.lessonKey == 'lesson13') {
          AuthManager.lesson13Part1Completed = true;
        } else if (widget.lessonKey == 'lesson12') {
          AuthManager.lesson12Part1Completed = true;
        } else if (widget.lessonKey == 'lesson11') {
          AuthManager.lesson11Part1Completed = true;
        } else if (widget.lessonKey == 'lesson10') {
          AuthManager.lesson10Part1Completed = true;
        } else if (widget.lessonKey == 'lesson9') {
          AuthManager.lesson9Part1Completed = true;
        } else if (widget.lessonKey == 'lesson8') {
          AuthManager.lesson8Part1Completed = true;
        } else if (widget.lessonKey == 'lesson7') {
          AuthManager.lesson7Part1Completed = true;
        } else if (widget.lessonKey == 'lesson6') {
          AuthManager.lesson6Part1Completed = true;
        } else if (widget.lessonKey == 'lesson5') {
          AuthManager.lesson5Part1Completed = true;
        } else if (widget.lessonKey == 'lesson4') {
          AuthManager.lesson4Part1Completed = true;
        } else if (widget.lessonKey == 'lesson3') {
          AuthManager.lesson3Part1Completed = true;
        } else if (widget.lessonKey == 'lesson2') {
          AuthManager.lesson2Part1Completed = true;
        } else {
          AuthManager.lesson1Part1Completed = true;
        }
        AuthManager.save();
      });
    }

    _showEpicVictoryDialog(
      sessionCoins: _sessionCoins,
      alreadyCompleted: alreadyCompleted,
      titleText: 'پیروزی درخشان بخش اول! 🌟',
      buttonText: 'دریافت سکه و بازگشت به صفحه خانه 🏠',
      onNext: () {
        AuthManager.save();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Directionality(textDirection: TextDirection.rtl, child: ModernHomeScreen())),
            (route) => false,
          );
        }
      },
    );
  }

  Future<bool> _onWillPop() async {
    bool? exitConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: const Color(0xFF1E1B4B),
            title: const Row(
              children: [
                Text('⚠️', style: TextStyle(fontSize: 28)),
                SizedBox(width: 10),
                Text('هشدار خروج', style: TextStyle(fontFamily: 'Tahoma', color: Colors.white, fontWeight: FontWeight.w900)),
              ],
            ),
            content: const Text(
              'تمام سکه‌هایی که جمع کردی از دست می‌ره!',
              style: TextStyle(fontFamily: 'Tahoma', color: Color(0xFFCBD5E1), fontSize: 13, height: 1.5),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFF991B1B)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text('متوجه شدم', style: TextStyle(fontFamily: 'Tahoma', color: Colors.white, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return exitConfirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFF0F071E),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E1B4B),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
              onPressed: () async {
                bool shouldExit = await _onWillPop();
                if (shouldExit && mounted) {
                  Navigator.pop(context);
                }
              },
            ),
            title: widget.isChallengeMode
                ? _buildChallengeTopTimer()
                : Text(
                    'بازی تطبیق: ${widget.lessonTitle}',
                    style: const TextStyle(fontFamily: 'Tahoma', fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
            actions: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.lightbulb_rounded, color: Color(0xFFFFB703), size: 28),
                    onPressed: _useHint,
                    tooltip: 'راهنما (-10 سکه)',
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text(
                        '$_hintsRemaining',
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        _sessionCoins < 0 ? '-${_sessionCoins.abs()}' : '$_sessionCoins',
                        style: const TextStyle(fontFamily: 'Tahoma', fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFF59E0B)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF1E1B4B), Color(0xFF311042)]),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFC084FC).withOpacity(0.4)),
                    ),
                    child: const Row(
                      children: [
                        Text('🎮', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'کارت‌های ایموجی و کلمات عربی را به هم متصل کن!',
                                style: TextStyle(fontFamily: 'Tahoma', fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'هر جور کردن صحیح = +۱۰ سکه | چراغ = ۱۰ ثانیه نمایش کارت‌ها',
                                style: TextStyle(fontFamily: 'Tahoma', fontSize: 10, color: Color(0xFFCBD5E1)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: _tiles.length,
                        itemBuilder: (context, index) {
                          final tile = _tiles[index];
                          final bool isFlipped = tile['isFlipped'] || tile['isMatched'];

                          return GestureDetector(
                            onTap: () => _onTileTap(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              decoration: BoxDecoration(
                                color: isFlipped ? Colors.white : const Color(0xFFF97316),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isFlipped ? Colors.black : const Color(0xFFF97316)).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(
                                  color: isFlipped ? const Color(0xFFCBD5E1) : const Color(0xFFFB923C),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: isFlipped
                                    ? FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text(
                                            tile['content'],
                                            style: TextStyle(
                                              fontFamily: 'Tahoma',
                                              fontSize: tile['type'] == 'emoji' ? 28 : 16,
                                              fontWeight: FontWeight.w900,
                                              color: tile['type'] == 'emoji' ? Colors.black87 : const Color(0xFF4C1D95),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        '?',
                                        style: TextStyle(
                                          fontFamily: 'Tahoma',
                                          fontSize: 32,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              if (_floatingMessage != null)
                Positioned(
                  top: 70,
                  right: 30,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, -20 * value),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _floatingMessageColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: _floatingMessageColor.withOpacity(0.5), blurRadius: 10),
                              ],
                            ),
                            child: Directionality(
                              textDirection: _floatingMessage!.startsWith('-') ? TextDirection.ltr : TextDirection.rtl,
                              child: Text(
                                _floatingMessage!,
                                style: const TextStyle(
                                  fontFamily: 'Tahoma',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// صفحه بازی پازل «دیوار آتشین» (پویا برای درس اول و دوم)
// ==========================================
class ArabicLesson1Part2FirewallGameScreen extends StatefulWidget {
  final String lessonTitle;
  final List<Map<String, String>>? customWords;
  final String lessonKey;
  final bool isChallengeMode;
  final int challengeTimeLimitSeconds;
  final void Function(int coinsEarned, int timeTakenSeconds)? onChallengeComplete;

  const ArabicLesson1Part2FirewallGameScreen({
    super.key,
    required this.lessonTitle,
    this.customWords,
    this.lessonKey = 'lesson1',
    this.isChallengeMode = false,
    this.challengeTimeLimitSeconds = 60,
    this.onChallengeComplete,
  });

  @override
  State<ArabicLesson1Part2FirewallGameScreen> createState() => _ArabicLesson1Part2FirewallGameScreenState();
}

class _ArabicLesson1Part2FirewallGameScreenState extends State<ArabicLesson1Part2FirewallGameScreen> {
  late final List<Map<String, String>> _words;

  int _currentIndex = 0;
  late List<String> _targetLetters;
  late List<Map<String, dynamic>> _scrambledLetters;
  late List<String?> _slots;
  bool _showFirewall = false;
  bool _isWrong = false;
  int _hintsRemaining = 3;
  int _sessionCoins = 0;
  String? _floatingMessage;
  Color _floatingMessageColor = Colors.green;

  Timer? _challengeCountdownTimer;
  int _challengeSecondsLeft = 60;
  bool _challengeEnded = false;

  void _finishChallenge() {
    if (_challengeEnded) return;
    _challengeEnded = true;
    _challengeCountdownTimer?.cancel();
    final int finalCoins = math.max(0, _sessionCoins);
    final int timeTaken = math.max(1, widget.challengeTimeLimitSeconds - _challengeSecondsLeft);
    if (widget.onChallengeComplete != null) {
      widget.onChallengeComplete!(finalCoins, timeTaken);
    } else {
      Navigator.pop(context, {'coins': finalCoins, 'timeTaken': timeTaken});
    }
  }

  Widget _buildChallengeTopTimer() {
    final int sec = _challengeSecondsLeft;
    final bool isLow = sec <= 10;
    final String timeStr = '00:${sec.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isLow ? Colors.red.withOpacity(0.25) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLow ? Colors.redAccent : const Color(0xFF00E5FF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isLow ? Colors.redAccent : const Color(0xFF00E5FF)).withOpacity(0.35),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_rounded,
            size: 18,
            color: isLow ? Colors.redAccent : const Color(0xFF00E5FF),
          ),
          const SizedBox(width: 8),
          Text(
            timeStr,
            style: TextStyle(
              fontFamily: 'Tahoma',
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: isLow ? Colors.redAccent : Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _challengeCountdownTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _words = widget.customWords ?? lesson1Part2Vocab;
    _loadCurrentWord();
    if (widget.isChallengeMode) {
      _challengeSecondsLeft = widget.challengeTimeLimitSeconds;
      _challengeCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        if (_challengeSecondsLeft > 0) {
          setState(() {
            _challengeSecondsLeft--;
          });
          if (_challengeSecondsLeft <= 0) {
            timer.cancel();
            _finishChallenge();
          }
        }
      });
    }
    bool isCompleted = widget.lessonKey.contains('zaban9_lesson6') ? AuthManager.zaban9Lesson6Part2Completed :
                       widget.lessonKey.contains('zaban9_lesson5') ? AuthManager.zaban9Lesson5Part2Completed :
                       widget.lessonKey.contains('zaban9_lesson4') ? AuthManager.zaban9Lesson4Part2Completed :
                       widget.lessonKey.contains('zaban9_lesson3') ? AuthManager.zaban9Lesson3Part2Completed :
                       widget.lessonKey.contains('zaban9_lesson2') ? AuthManager.zaban9Lesson2Part2Completed :
                       widget.lessonKey.contains('zaban9_lesson1') ? AuthManager.zaban9Lesson1Part2Completed :
                       widget.lessonKey.contains('zaban8_lesson7') ? AuthManager.zaban8Lesson7Part2Completed :
                       widget.lessonKey.contains('zaban8_lesson6') ? AuthManager.zaban8Lesson6Part2Completed :
                       widget.lessonKey.contains('zaban8_lesson5') ? AuthManager.zaban8Lesson5Part2Completed :
                       widget.lessonKey.contains('zaban8_lesson4') ? AuthManager.zaban8Lesson4Part2Completed :
                       widget.lessonKey.contains('zaban8_lesson3') ? AuthManager.zaban8Lesson3Part2Completed :
                       widget.lessonKey.contains('zaban8_lesson2') ? AuthManager.zaban8Lesson2Part2Completed :
                       widget.lessonKey.contains('zaban8_lesson1') ? AuthManager.zaban8Lesson1Part2Completed :
                       widget.lessonKey.contains('zaban7_lesson8') ? AuthManager.zaban7Lesson8Part2Completed :
                       widget.lessonKey.contains('zaban7_lesson7') ? AuthManager.zaban7Lesson7Part2Completed :
                       widget.lessonKey.contains('zaban7_lesson6') ? AuthManager.zaban7Lesson6Part2Completed :
                       widget.lessonKey.contains('zaban7_lesson5') ? AuthManager.zaban7Lesson5Part2Completed :
                       widget.lessonKey.contains('zaban7_lesson4') ? AuthManager.zaban7Lesson4Part2Completed :
                       widget.lessonKey.contains('zaban7_lesson3') ? AuthManager.zaban7Lesson3Part2Completed :
                       widget.lessonKey.contains('zaban7_welcome') ? AuthManager.zaban7WelcomePart2Completed :
                       widget.lessonKey.contains('zaban7_lesson1') ? AuthManager.zaban7Lesson1Part2Completed :
                       widget.lessonKey.contains('quran9_lesson11') ? AuthManager.quran9Lesson11Part2Completed :
                       widget.lessonKey.contains('quran9_lesson10') ? AuthManager.quran9Lesson10Part2Completed :
                       widget.lessonKey.contains('quran9_lesson9') ? AuthManager.quran9Lesson9Part2Completed :
                       widget.lessonKey.contains('quran9_lesson8') ? AuthManager.quran9Lesson8Part2Completed :
                       widget.lessonKey.contains('quran9_lesson7') ? AuthManager.quran9Lesson7Part2Completed :
                       widget.lessonKey.contains('quran9_lesson6') ? AuthManager.quran9Lesson6Part2Completed :
                       widget.lessonKey.contains('quran9_lesson5') ? AuthManager.quran9Lesson5Part2Completed :
                       widget.lessonKey.contains('quran9_lesson4') ? AuthManager.quran9Lesson4Part2Completed :
                       widget.lessonKey.contains('quran9_lesson3') ? AuthManager.quran9Lesson3Part2Completed :
                       widget.lessonKey.contains('quran9_lesson2') ? AuthManager.quran9Lesson2Part2Completed :
                       widget.lessonKey.contains('quran9_lesson1') ? AuthManager.quran9Lesson1Part2Completed :
                       widget.lessonKey.contains('quran8_lesson12') ? AuthManager.quran8Lesson12Part2Completed :
                       widget.lessonKey.contains('quran8_lesson11') ? AuthManager.quran8Lesson11Part2Completed :
                       widget.lessonKey.contains('quran8_lesson10') ? AuthManager.quran8Lesson10Part2Completed :
                       widget.lessonKey.contains('quran8_lesson9') ? AuthManager.quran8Lesson9Part2Completed :
                       widget.lessonKey.contains('quran8_lesson8') ? AuthManager.quran8Lesson8Part2Completed :
                       widget.lessonKey.contains('quran8_lesson7') ? AuthManager.quran8Lesson7Part2Completed :
                       widget.lessonKey.contains('quran8_lesson6') ? AuthManager.quran8Lesson6Part2Completed :
                       widget.lessonKey.contains('quran8_lesson5') ? AuthManager.quran8Lesson5Part2Completed :
                       widget.lessonKey.contains('quran8_lesson4') ? AuthManager.quran8Lesson4Part2Completed :
                       widget.lessonKey.contains('quran8_lesson3') ? AuthManager.quran8Lesson3Part2Completed :
                       widget.lessonKey.contains('quran8_lesson2') ? AuthManager.quran8Lesson2Part2Completed :
                       widget.lessonKey.contains('quran8_lesson1') ? AuthManager.quran8Lesson1Part2Completed :
                       widget.lessonKey.contains('quran7_lesson12') ? AuthManager.quran7Lesson12Part2Completed :
                       widget.lessonKey.contains('quran7_lesson11') ? AuthManager.quran7Lesson11Part2Completed :
                       widget.lessonKey.contains('quran7_lesson10') ? AuthManager.quran7Lesson10Part2Completed :
                       widget.lessonKey.contains('quran7_lesson9') ? AuthManager.quran7Lesson9Part2Completed :
                       widget.lessonKey.contains('quran7_lesson8') ? AuthManager.quran7Lesson8Part2Completed :
                       widget.lessonKey.contains('quran7_lesson7') ? AuthManager.quran7Lesson7Part2Completed :
                       widget.lessonKey.contains('quran7_lesson6') ? AuthManager.quran7Lesson6Part2Completed :
                       widget.lessonKey.contains('quran7_lesson5') ? AuthManager.quran7Lesson5Part2Completed :
                       widget.lessonKey.contains('quran7_lesson4') ? AuthManager.quran7Lesson4Part2Completed :
                       widget.lessonKey.contains('quran7_lesson3') ? AuthManager.quran7Lesson3Part2Completed :
                       widget.lessonKey.contains('quran7_lesson2') ? AuthManager.quran7Lesson2Part2Completed :
                       (widget.lessonKey.contains('quran7_lesson1') || (widget.lessonTitle.contains('قرآن') && widget.lessonTitle.contains('درس اول'))) ? AuthManager.quran7Lesson1Part2Completed :
                       widget.lessonKey == 'arabic9_lesson10' ? AuthManager.arabic9Lesson10Part2Completed :
                       widget.lessonKey == 'arabic9_lesson9' ? AuthManager.arabic9Lesson9Part2Completed :
                       widget.lessonKey == 'arabic9_lesson8' ? AuthManager.arabic9Lesson8Part2Completed :
                       widget.lessonKey == 'arabic9_lesson7' ? AuthManager.arabic9Lesson7Part2Completed :
                       widget.lessonKey == 'arabic9_lesson6' ? AuthManager.arabic9Lesson6Part2Completed :
                       widget.lessonKey == 'arabic9_lesson5' ? AuthManager.arabic9Lesson5Part2Completed :
                       widget.lessonKey == 'arabic9_lesson4' ? AuthManager.arabic9Lesson4Part2Completed :
                       widget.lessonKey == 'arabic9_lesson3' ? AuthManager.arabic9Lesson3Part2Completed :
                       widget.lessonKey == 'arabic9_lesson2' ? AuthManager.arabic9Lesson2Part2Completed :
                       widget.lessonKey == 'arabic9_lesson1' ? AuthManager.arabic9Lesson1Part2Completed :
                       widget.lessonKey == 'arabic8_lesson10' ? AuthManager.arabic8Lesson10Part2Completed :
                       widget.lessonKey == 'arabic8_lesson9' ? AuthManager.arabic8Lesson9Part2Completed :
                       widget.lessonKey == 'arabic8_lesson8' ? AuthManager.arabic8Lesson8Part2Completed :
                       widget.lessonKey == 'arabic8_lesson7' ? AuthManager.arabic8Lesson7Part2Completed :
                       widget.lessonKey == 'arabic8_lesson6' ? AuthManager.arabic8Lesson6Part2Completed :
                       widget.lessonKey == 'arabic8_lesson5' ? AuthManager.arabic8Lesson5Part2Completed :
                       widget.lessonKey == 'arabic8_lesson4' ? AuthManager.arabic8Lesson4Part2Completed :
                       widget.lessonKey == 'arabic8_lesson3' ? AuthManager.arabic8Lesson3Part2Completed :
                       widget.lessonKey == 'arabic8_lesson2' ? AuthManager.arabic8Lesson2Part2Completed :
                       widget.lessonKey == 'arabic8_lesson1' ? AuthManager.arabic8Lesson1Part2Completed :
                       widget.lessonKey == 'lesson20' ? AuthManager.lesson20Part2Completed :
                       widget.lessonKey == 'lesson19' ? AuthManager.lesson19Part2Completed :
                       widget.lessonKey == 'lesson18' ? AuthManager.lesson18Part2Completed :
                       widget.lessonKey == 'lesson17' ? AuthManager.lesson17Part2Completed :
                       widget.lessonKey == 'lesson16' ? AuthManager.lesson16Part2Completed :
                       widget.lessonKey == 'lesson15' ? AuthManager.lesson15Part2Completed :
                       widget.lessonKey == 'lesson14' ? AuthManager.lesson14Part2Completed :
                       widget.lessonKey == 'lesson13' ? AuthManager.lesson13Part2Completed :
                       widget.lessonKey == 'lesson12' ? AuthManager.lesson12Part2Completed :
                       widget.lessonKey == 'lesson11' ? AuthManager.lesson11Part2Completed :
                       widget.lessonKey == 'lesson10' ? AuthManager.lesson10Part2Completed :
                       widget.lessonKey == 'lesson9' ? AuthManager.lesson9Part2Completed :
                       widget.lessonKey == 'lesson8' ? AuthManager.lesson8Part2Completed :
                       widget.lessonKey == 'lesson7' ? AuthManager.lesson7Part2Completed :
                       widget.lessonKey == 'lesson6' ? AuthManager.lesson6Part2Completed :
                       widget.lessonKey == 'lesson5' ? AuthManager.lesson5Part2Completed :
                       widget.lessonKey == 'lesson4' ? AuthManager.lesson4Part2Completed :
                       widget.lessonKey == 'lesson3' ? AuthManager.lesson3Part2Completed :
                       widget.lessonKey == 'lesson2' ? AuthManager.lesson2Part2Completed :
                       AuthManager.lesson1Part2Completed;
    if (!widget.isChallengeMode && !widget.lessonKey.contains('battle')) {
      if (isCompleted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showReplayWarningDialog();
        });
      }
    }
  }

  void _showReplayWarningDialog() {
    if (widget.isChallengeMode || widget.lessonKey.contains('battle')) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: const Color(0xFF1E1B4B),
            title: const Row(
              children: [
                Text('⚠️', style: TextStyle(fontSize: 28)),
                SizedBox(width: 10),
                Text('توجه', style: TextStyle(fontFamily: 'Tahoma', color: Colors.white, fontWeight: FontWeight.w900)),
              ],
            ),
            content: const Text(
              'شما این بازی رو تا آخر رفتید و اینبار سکه نمی‌گیرید!',
              style: TextStyle(fontFamily: 'Tahoma', color: Color(0xFFCBD5E1), fontSize: 13, height: 1.5),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEA580C)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text('متوجه شدم', style: TextStyle(fontFamily: 'Tahoma', color: Colors.white, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _loadCurrentWord() {
    final wordObj = _words[_currentIndex];
    final String cleanWord = wordObj['word']!.replaceAll(' ', '');
    _targetLetters = cleanWord.runes.map((r) => String.fromCharCode(r)).toList();
    _slots = List.filled(_targetLetters.length, null);

    List<Map<String, dynamic>> tempLetters = [];
    for (int i = 0; i < _targetLetters.length; i++) {
      tempLetters.add({
        'id': i,
        'char': _targetLetters[i],
        'used': false,
      });
    }
    tempLetters.shuffle(math.Random());
    _scrambledLetters = tempLetters;
    _showFirewall = false;
    _isWrong = false;
  }

  void _useHint() {
    if (_hintsRemaining <= 0 || _showFirewall || _isWrong) return;

    setState(() {
      _hintsRemaining--;
      for (int i = 0; i < _targetLetters.length; i++) {
        _slots[i] = _targetLetters[i];
      }
      for (var l in _scrambledLetters) {
        l['used'] = true;
      }
    });

    Timer(const Duration(milliseconds: 300), () {
      _checkAnswerWithoutReward();
    });
  }

  void _onLetterTap(int scrambledIndex) {
    if (_scrambledLetters[scrambledIndex]['used'] || _showFirewall || _isWrong) return;

    int emptySlotIndex = _slots.indexOf(null);
    if (emptySlotIndex != -1) {
      setState(() {
        _slots[emptySlotIndex] = _scrambledLetters[scrambledIndex]['char'];
        _scrambledLetters[scrambledIndex]['used'] = true;
      });

      if (!_slots.contains(null)) {
        _checkAnswer();
      }
    }
  }

  void _onSlotTap(int slotIndex) {
    if (_slots[slotIndex] == null || _showFirewall || _isWrong) return;

    String charToRemove = _slots[slotIndex]!;
    setState(() {
      _slots[slotIndex] = null;
      for (var l in _scrambledLetters) {
        if (l['char'] == charToRemove && l['used']) {
          l['used'] = false;
          break;
        }
      }
    });
  }

  void _checkAnswerWithoutReward() {
    setState(() {
      _showFirewall = true;
    });

    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (_currentIndex < _words.length - 1) {
        setState(() {
          _currentIndex++;
          _loadCurrentWord();
        });
      } else {
        _showVictoryDialog();
      }
    });
  }

  void _checkAnswer() {
    String userAnswer = _slots.join('');
    String correctAnswer = _targetLetters.join('');

    if (userAnswer == correctAnswer) {
      setState(() {
        _showFirewall = true;
        _sessionCoins += 10;
      });

      Timer(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        if (_currentIndex < _words.length - 1) {
          setState(() {
            _currentIndex++;
            _loadCurrentWord();
          });
        } else {
          _showVictoryDialog();
        }
      });
    } else {
      setState(() {
        _isWrong = true;
      });

      Timer(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() {
          for (var l in _scrambledLetters) {
            l['used'] = false;
          }
          _slots = List.filled(_targetLetters.length, null);
          _isWrong = false;
        });
      });
    }
  }

  void _showFloatingFeedback(String msg, Color color) {
    setState(() {
      _floatingMessage = msg;
      _floatingMessageColor = color;
    });
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _floatingMessage = null;
        });
      }
    });
  }

  void _showEpicVictoryDialog({
    required int sessionCoins,
    required bool alreadyCompleted,
    required String titleText,
    required String buttonText,
    required VoidCallback onNext,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            backgroundColor: const Color(0xFF1E1B4B),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E1065), Color(0xFF1E1B4B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: alreadyCompleted ? const Color(0xFFF97316) : const Color(0xFFFFB703), width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: (alreadyCompleted ? const Color(0xFFF97316) : const Color(0xFFFFB703)).withOpacity(0.4),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: (alreadyCompleted ? const Color(0xFFF97316) : const Color(0xFFFFB703)).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: alreadyCompleted ? const Color(0xFFF97316) : const Color(0xFFFFB703), width: 2),
                    ),
                    child: Text(alreadyCompleted ? '⚠️' : '🏆', style: const TextStyle(fontSize: 44)),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    alreadyCompleted ? 'تکرار مأموریت' : titleText,
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alreadyCompleted
                        ? 'شما این بازی را قبلاً تا آخر رفته‌اید و این بار سکه دریافت نمی‌کنید!'
                        : 'عالی بود! شما مرحله را با موفقیت پشت سر گذاشتید و جوایز ارزنده‌ای کسب کردید',
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!alreadyCompleted) ...[
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFFFB703), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFB703).withOpacity(0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🪙', style: TextStyle(fontSize: 26)),
                          const SizedBox(width: 10),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              '+$sessionCoins',
                              style: const TextStyle(
                                fontFamily: 'Tahoma',
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFFB703),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.5),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          Navigator.pop(context); // close dialog
                          onNext();
                        },
                        child: Center(
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showVictoryDialog() {
    if (widget.isChallengeMode || widget.lessonKey.contains('battle')) {
      _finishChallenge();
      return;
    }
    bool alreadyCompleted = widget.lessonKey.contains('zaban9_lesson6') ? AuthManager.zaban9Lesson6Part2Completed :
                            widget.lessonKey.contains('zaban9_lesson5') ? AuthManager.zaban9Lesson5Part2Completed :
                            widget.lessonKey.contains('zaban9_lesson4') ? AuthManager.zaban9Lesson4Part2Completed :
                            widget.lessonKey.contains('zaban9_lesson3') ? AuthManager.zaban9Lesson3Part2Completed :
                            widget.lessonKey.contains('zaban9_lesson2') ? AuthManager.zaban9Lesson2Part2Completed :
                            widget.lessonKey.contains('zaban9_lesson1') ? AuthManager.zaban9Lesson1Part2Completed :
                            widget.lessonKey.contains('zaban8_lesson7') ? AuthManager.zaban8Lesson7Part2Completed :
                            widget.lessonKey.contains('zaban8_lesson6') ? AuthManager.zaban8Lesson6Part2Completed :
                            widget.lessonKey.contains('zaban8_lesson5') ? AuthManager.zaban8Lesson5Part2Completed :
                            widget.lessonKey.contains('zaban8_lesson4') ? AuthManager.zaban8Lesson4Part2Completed :
                            widget.lessonKey.contains('zaban8_lesson3') ? AuthManager.zaban8Lesson3Part2Completed :
                            widget.lessonKey.contains('zaban8_lesson2') ? AuthManager.zaban8Lesson2Part2Completed :
                            widget.lessonKey.contains('zaban8_lesson1') ? AuthManager.zaban8Lesson1Part2Completed :
                            widget.lessonKey.contains('zaban7_lesson8') ? AuthManager.zaban7Lesson8Part2Completed :
                            widget.lessonKey.contains('zaban7_lesson7') ? AuthManager.zaban7Lesson7Part2Completed :
                            widget.lessonKey.contains('zaban7_lesson6') ? AuthManager.zaban7Lesson6Part2Completed :
                            widget.lessonKey.contains('zaban7_lesson5') ? AuthManager.zaban7Lesson5Part2Completed :
                            widget.lessonKey.contains('zaban7_lesson4') ? AuthManager.zaban7Lesson4Part2Completed :
                            widget.lessonKey.contains('zaban7_lesson3') ? AuthManager.zaban7Lesson3Part2Completed :
                            widget.lessonKey.contains('zaban7_welcome') ? AuthManager.zaban7WelcomePart2Completed :
                            widget.lessonKey.contains('zaban7_lesson1') ? AuthManager.zaban7Lesson1Part2Completed :
                            widget.lessonKey.contains('quran9_lesson11') ? AuthManager.quran9Lesson11Part2Completed :
                            widget.lessonKey.contains('quran9_lesson10') ? AuthManager.quran9Lesson10Part2Completed :
                            widget.lessonKey.contains('quran9_lesson9') ? AuthManager.quran9Lesson9Part2Completed :
                            widget.lessonKey.contains('quran9_lesson8') ? AuthManager.quran9Lesson8Part2Completed :
                            widget.lessonKey.contains('quran9_lesson7') ? AuthManager.quran9Lesson7Part2Completed :
                            widget.lessonKey.contains('quran9_lesson6') ? AuthManager.quran9Lesson6Part2Completed :
                            widget.lessonKey.contains('quran9_lesson5') ? AuthManager.quran9Lesson5Part2Completed :
                            widget.lessonKey.contains('quran9_lesson4') ? AuthManager.quran9Lesson4Part2Completed :
                            widget.lessonKey.contains('quran9_lesson3') ? AuthManager.quran9Lesson3Part2Completed :
                            widget.lessonKey.contains('quran9_lesson2') ? AuthManager.quran9Lesson2Part2Completed :
                            widget.lessonKey.contains('quran9_lesson1') ? AuthManager.quran9Lesson1Part2Completed :
                            widget.lessonKey.contains('quran8_lesson12') ? AuthManager.quran8Lesson12Part2Completed :
                            widget.lessonKey.contains('quran8_lesson11') ? AuthManager.quran8Lesson11Part2Completed :
                            widget.lessonKey.contains('quran8_lesson10') ? AuthManager.quran8Lesson10Part2Completed :
                            widget.lessonKey.contains('quran8_lesson9') ? AuthManager.quran8Lesson9Part2Completed :
                            widget.lessonKey.contains('quran8_lesson8') ? AuthManager.quran8Lesson8Part2Completed :
                            widget.lessonKey.contains('quran8_lesson7') ? AuthManager.quran8Lesson7Part2Completed :
                            widget.lessonKey.contains('quran8_lesson6') ? AuthManager.quran8Lesson6Part2Completed :
                            widget.lessonKey.contains('quran8_lesson5') ? AuthManager.quran8Lesson5Part2Completed :
                            widget.lessonKey.contains('quran8_lesson4') ? AuthManager.quran8Lesson4Part2Completed :
                            widget.lessonKey.contains('quran8_lesson3') ? AuthManager.quran8Lesson3Part2Completed :
                            widget.lessonKey.contains('quran8_lesson2') ? AuthManager.quran8Lesson2Part2Completed :
                            widget.lessonKey.contains('quran8_lesson1') ? AuthManager.quran8Lesson1Part2Completed :
                            widget.lessonKey.contains('quran7_lesson12') ? AuthManager.quran7Lesson12Part2Completed :
                            widget.lessonKey.contains('quran7_lesson11') ? AuthManager.quran7Lesson11Part2Completed :
                            widget.lessonKey.contains('quran7_lesson10') ? AuthManager.quran7Lesson10Part2Completed :
                            widget.lessonKey.contains('quran7_lesson9') ? AuthManager.quran7Lesson9Part2Completed :
                            widget.lessonKey.contains('quran7_lesson8') ? AuthManager.quran7Lesson8Part2Completed :
                            widget.lessonKey.contains('quran7_lesson7') ? AuthManager.quran7Lesson7Part2Completed :
                            widget.lessonKey.contains('quran7_lesson6') ? AuthManager.quran7Lesson6Part2Completed :
                            widget.lessonKey.contains('quran7_lesson5') ? AuthManager.quran7Lesson5Part2Completed :
                            widget.lessonKey.contains('quran7_lesson4') ? AuthManager.quran7Lesson4Part2Completed :
                            widget.lessonKey.contains('quran7_lesson3') ? AuthManager.quran7Lesson3Part2Completed :
                            widget.lessonKey.contains('quran7_lesson2') ? AuthManager.quran7Lesson2Part2Completed :
                            (widget.lessonKey.contains('quran7_lesson1') || (widget.lessonTitle.contains('قرآن') && widget.lessonTitle.contains('درس اول'))) ? AuthManager.quran7Lesson1Part2Completed :
                            widget.lessonKey == 'arabic9_lesson10' ? AuthManager.arabic9Lesson10Part2Completed :
                            widget.lessonKey == 'arabic9_lesson9' ? AuthManager.arabic9Lesson9Part2Completed :
                            widget.lessonKey == 'arabic9_lesson8' ? AuthManager.arabic9Lesson8Part2Completed :
                            widget.lessonKey == 'arabic9_lesson7' ? AuthManager.arabic9Lesson7Part2Completed :
                            widget.lessonKey == 'arabic9_lesson6' ? AuthManager.arabic9Lesson6Part2Completed :
                            widget.lessonKey == 'arabic9_lesson5' ? AuthManager.arabic9Lesson5Part2Completed :
                            widget.lessonKey == 'arabic9_lesson4' ? AuthManager.arabic9Lesson4Part2Completed :
                            widget.lessonKey == 'arabic9_lesson3' ? AuthManager.arabic9Lesson3Part2Completed :
                            widget.lessonKey == 'arabic9_lesson2' ? AuthManager.arabic9Lesson2Part2Completed :
                            widget.lessonKey == 'arabic9_lesson1' ? AuthManager.arabic9Lesson1Part2Completed :
                            widget.lessonKey == 'arabic8_lesson10' ? AuthManager.arabic8Lesson10Part2Completed :
                            widget.lessonKey == 'arabic8_lesson9' ? AuthManager.arabic8Lesson9Part2Completed :
                            widget.lessonKey == 'arabic8_lesson8' ? AuthManager.arabic8Lesson8Part2Completed :
                            widget.lessonKey == 'arabic8_lesson7' ? AuthManager.arabic8Lesson7Part2Completed :
                            widget.lessonKey == 'arabic8_lesson6' ? AuthManager.arabic8Lesson6Part2Completed :
                            widget.lessonKey == 'arabic8_lesson5' ? AuthManager.arabic8Lesson5Part2Completed :
                            widget.lessonKey == 'arabic8_lesson4' ? AuthManager.arabic8Lesson4Part2Completed :
                            widget.lessonKey == 'arabic8_lesson3' ? AuthManager.arabic8Lesson3Part2Completed :
                            widget.lessonKey == 'arabic8_lesson2' ? AuthManager.arabic8Lesson2Part2Completed :
                            widget.lessonKey == 'arabic8_lesson1' ? AuthManager.arabic8Lesson1Part2Completed :
                            widget.lessonKey == 'lesson20' ? AuthManager.lesson20Part2Completed :
                            widget.lessonKey == 'lesson19' ? AuthManager.lesson19Part2Completed :
                            widget.lessonKey == 'lesson18' ? AuthManager.lesson18Part2Completed :
                            widget.lessonKey == 'lesson17' ? AuthManager.lesson17Part2Completed :
                            widget.lessonKey == 'lesson16' ? AuthManager.lesson16Part2Completed :
                            widget.lessonKey == 'lesson15' ? AuthManager.lesson15Part2Completed :
                            widget.lessonKey == 'lesson14' ? AuthManager.lesson14Part2Completed :
                            widget.lessonKey == 'lesson13' ? AuthManager.lesson13Part2Completed :
                            widget.lessonKey == 'lesson12' ? AuthManager.lesson12Part2Completed :
                            widget.lessonKey == 'lesson11' ? AuthManager.lesson11Part2Completed :
                            widget.lessonKey == 'lesson10' ? AuthManager.lesson10Part2Completed :
                            widget.lessonKey == 'lesson9' ? AuthManager.lesson9Part2Completed :
                            widget.lessonKey == 'lesson8' ? AuthManager.lesson8Part2Completed :
                            widget.lessonKey == 'lesson7' ? AuthManager.lesson7Part2Completed :
                            widget.lessonKey == 'lesson6' ? AuthManager.lesson6Part2Completed :
                            widget.lessonKey == 'lesson5' ? AuthManager.lesson5Part2Completed :
                            widget.lessonKey == 'lesson4' ? AuthManager.lesson4Part2Completed :
                            widget.lessonKey == 'lesson3' ? AuthManager.lesson3Part2Completed :
                            widget.lessonKey == 'lesson2' ? AuthManager.lesson2Part2Completed :
                            AuthManager.lesson1Part2Completed;
    if (!alreadyCompleted) {
      setState(() {
        AuthManager.coins += _sessionCoins;
        if (widget.lessonKey.contains('zaban9_lesson6')) {
          AuthManager.zaban9Lesson6Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban9_lesson5')) {
          AuthManager.zaban9Lesson5Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban9_lesson4')) {
          AuthManager.zaban9Lesson4Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban9_lesson3')) {
          AuthManager.zaban9Lesson3Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban9_lesson2')) {
          AuthManager.zaban9Lesson2Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban9_lesson1')) {
          AuthManager.zaban9Lesson1Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban8_lesson7')) {
          AuthManager.zaban8Lesson7Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban8_lesson6')) {
          AuthManager.zaban8Lesson6Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban8_lesson5')) {
          AuthManager.zaban8Lesson5Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban8_lesson4')) {
          AuthManager.zaban8Lesson4Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban8_lesson3')) {
          AuthManager.zaban8Lesson3Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban8_lesson2')) {
          AuthManager.zaban8Lesson2Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban8_lesson1')) {
          AuthManager.zaban8Lesson1Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban7_lesson8')) {
          AuthManager.zaban7Lesson8Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban7_lesson7')) {
          AuthManager.zaban7Lesson7Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban7_lesson6')) {
          AuthManager.zaban7Lesson6Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban7_lesson5')) {
          AuthManager.zaban7Lesson5Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban7_lesson4')) {
          AuthManager.zaban7Lesson4Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban7_lesson3')) {
          AuthManager.zaban7Lesson3Part2Completed = true;
        } else if (widget.lessonKey.contains('zaban7_welcome')) {
          AuthManager.zaban7WelcomePart2Completed = true;
        } else if (widget.lessonKey.contains('zaban7_lesson1')) {
          AuthManager.zaban7Lesson1Part2Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson11')) {
          AuthManager.quran9Lesson11Part2Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson10')) {
          AuthManager.quran9Lesson10Part2Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson9')) {
          AuthManager.quran9Lesson9Part2Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson8')) {
          AuthManager.quran9Lesson8Part2Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson7')) {
          AuthManager.quran9Lesson7Part2Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson6')) {
          AuthManager.quran9Lesson6Part2Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson5')) {
          AuthManager.quran9Lesson5Part2Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson4')) {
          AuthManager.quran9Lesson4Part2Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson3')) {
          AuthManager.quran9Lesson3Part2Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson2')) {
          AuthManager.quran9Lesson2Part2Completed = true;
        } else if (widget.lessonKey.contains('quran9_lesson1')) {
          AuthManager.quran9Lesson1Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson12')) {
          AuthManager.quran8Lesson12Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson11')) {
          AuthManager.quran8Lesson11Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson10')) {
          AuthManager.quran8Lesson10Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson9')) {
          AuthManager.quran8Lesson9Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson8')) {
          AuthManager.quran8Lesson8Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson7')) {
          AuthManager.quran8Lesson7Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson6')) {
          AuthManager.quran8Lesson6Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson5')) {
          AuthManager.quran8Lesson5Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson4')) {
          AuthManager.quran8Lesson4Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson3')) {
          AuthManager.quran8Lesson3Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson2')) {
          AuthManager.quran8Lesson2Part2Completed = true;
        } else if (widget.lessonKey.contains('quran8_lesson1')) {
          AuthManager.quran8Lesson1Part2Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson12')) {
          AuthManager.quran7Lesson12Part2Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson11')) {
          AuthManager.quran7Lesson11Part2Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson10')) {
          AuthManager.quran7Lesson10Part2Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson9')) {
          AuthManager.quran7Lesson9Part2Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson8')) {
          AuthManager.quran7Lesson8Part2Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson7')) {
          AuthManager.quran7Lesson7Part2Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson6')) {
          AuthManager.quran7Lesson6Part2Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson5')) {
          AuthManager.quran7Lesson5Part2Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson4')) {
          AuthManager.quran7Lesson4Part2Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson3')) {
          AuthManager.quran7Lesson3Part2Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson2')) {
          AuthManager.quran7Lesson2Part2Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson1') || (widget.lessonTitle.contains('قرآن') && widget.lessonTitle.contains('درس اول'))) {
          AuthManager.quran7Lesson1Part2Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson10') {
          AuthManager.arabic9Lesson10Part2Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson9') {
          AuthManager.arabic9Lesson9Part2Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson8') {
          AuthManager.arabic9Lesson8Part2Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson7') {
          AuthManager.arabic9Lesson7Part2Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson6') {
          AuthManager.arabic9Lesson6Part2Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson5') {
          AuthManager.arabic9Lesson5Part2Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson4') {
          AuthManager.arabic9Lesson4Part2Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson3') {
          AuthManager.arabic9Lesson3Part2Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson2') {
          AuthManager.arabic9Lesson2Part2Completed = true;
        } else if (widget.lessonKey == 'arabic9_lesson1') {
          AuthManager.arabic9Lesson1Part2Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson10') {
          AuthManager.arabic8Lesson10Part2Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson9') {
          AuthManager.arabic8Lesson9Part2Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson8') {
          AuthManager.arabic8Lesson8Part2Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson7') {
          AuthManager.arabic8Lesson7Part2Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson6') {
          AuthManager.arabic8Lesson6Part2Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson5') {
          AuthManager.arabic8Lesson5Part2Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson4') {
          AuthManager.arabic8Lesson4Part2Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson3') {
          AuthManager.arabic8Lesson3Part2Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson2') {
          AuthManager.arabic8Lesson2Part2Completed = true;
        } else if (widget.lessonKey == 'arabic8_lesson1') {
          AuthManager.arabic8Lesson1Part2Completed = true;
        } else if (widget.lessonKey == 'lesson20') {
          AuthManager.lesson20Part2Completed = true;
        } else if (widget.lessonKey == 'lesson19') {
          AuthManager.lesson19Part2Completed = true;
        } else if (widget.lessonKey == 'lesson18') {
          AuthManager.lesson18Part2Completed = true;
        } else if (widget.lessonKey == 'lesson17') {
          AuthManager.lesson17Part2Completed = true;
        } else if (widget.lessonKey == 'lesson16') {
          AuthManager.lesson16Part2Completed = true;
        } else if (widget.lessonKey == 'lesson15') {
          AuthManager.lesson15Part2Completed = true;
        } else if (widget.lessonKey == 'lesson14') {
          AuthManager.lesson14Part2Completed = true;
        } else if (widget.lessonKey == 'lesson13') {
          AuthManager.lesson13Part2Completed = true;
        } else if (widget.lessonKey == 'lesson12') {
          AuthManager.lesson12Part2Completed = true;
        } else if (widget.lessonKey == 'lesson11') {
          AuthManager.lesson11Part2Completed = true;
        } else if (widget.lessonKey == 'lesson10') {
          AuthManager.lesson10Part2Completed = true;
        } else if (widget.lessonKey == 'lesson9') {
          AuthManager.lesson9Part2Completed = true;
        } else if (widget.lessonKey == 'lesson8') {
          AuthManager.lesson8Part2Completed = true;
        } else if (widget.lessonKey == 'lesson7') {
          AuthManager.lesson7Part2Completed = true;
        } else if (widget.lessonKey == 'lesson6') {
          AuthManager.lesson6Part2Completed = true;
        } else if (widget.lessonKey == 'lesson5') {
          AuthManager.lesson5Part2Completed = true;
        } else if (widget.lessonKey == 'lesson4') {
          AuthManager.lesson4Part2Completed = true;
        } else if (widget.lessonKey == 'lesson3') {
          AuthManager.lesson3Part2Completed = true;
        } else if (widget.lessonKey == 'lesson2') {
          AuthManager.lesson2Part2Completed = true;
        } else {
          AuthManager.lesson1Part2Completed = true;
        }
        AuthManager.save();
      });
    }

    _showEpicVictoryDialog(
      sessionCoins: _sessionCoins,
      alreadyCompleted: alreadyCompleted,
      titleText: 'شکستن دیوار آتشین! 🔥',
      buttonText: 'دریافت سکه و بازگشت به صفحه خانه 🏠',
      onNext: () {
        AuthManager.save();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Directionality(textDirection: TextDirection.rtl, child: ModernHomeScreen())),
            (route) => false,
          );
        }
      },
    );
  }

  Future<bool> _onWillPop() async {
    bool? exitConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: const Color(0xFF1E1B4B),
            title: const Row(
              children: [
                Text('⚠️', style: TextStyle(fontSize: 28)),
                SizedBox(width: 10),
                Text('هشدار خروج', style: TextStyle(fontFamily: 'Tahoma', color: Colors.white, fontWeight: FontWeight.w900)),
              ],
            ),
            content: const Text(
              'تمام سکه‌هایی که جمع کردی از دست می‌ره!',
              style: TextStyle(fontFamily: 'Tahoma', color: Color(0xFFCBD5E1), fontSize: 13, height: 1.5),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFF991B1B)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text('متوجه شدم', style: TextStyle(fontFamily: 'Tahoma', color: Colors.white, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return exitConfirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final wordObj = _words[_currentIndex];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFF0F071E),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E1B4B),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
              onPressed: () async {
                bool shouldExit = await _onWillPop();
                if (shouldExit && mounted) {
                  Navigator.pop(context);
                }
              },
            ),
            title: widget.isChallengeMode
                ? _buildChallengeTopTimer()
                : Text(
                    'دیوار آتشین: ${widget.lessonTitle}',
                    style: const TextStyle(fontFamily: 'Tahoma', fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
            actions: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.lightbulb_rounded, color: Color(0xFFFFB703), size: 28),
                    onPressed: _useHint,
                    tooltip: 'راهنما (-10 سکه و حل خودکار)',
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text(
                        '$_hintsRemaining',
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        _sessionCoins < 0 ? '-${_sessionCoins.abs()}' : '$_sessionCoins',
                        style: const TextStyle(fontFamily: 'Tahoma', fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFF59E0B)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF2E1065), Color(0xFF1E1B4B)]),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFF97316).withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'مرحله ${_currentIndex + 1} از ${_words.length}',
                          style: const TextStyle(fontFamily: 'Tahoma', fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF97316).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            wordObj['translation']!,
                            style: const TextStyle(fontFamily: 'Tahoma', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFDBA74)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Emoji at top
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B4B),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF97316), width: 2),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFFF97316).withOpacity(0.4), blurRadius: 20),
                      ],
                    ),
                    child: Text(
                      wordObj['emoji']!,
                      style: TextStyle(
                        fontSize: 48,
                        color: wordObj['emoji'] == '┬┬' ? const Color(0xFFF59E0B) : Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Empty Target Slots
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: _showFirewall
                        ? BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFF34D399), width: 3),
                            boxShadow: [
                              BoxShadow(color: Colors.green.withOpacity(0.8), blurRadius: 30, spreadRadius: 5),
                            ],
                          )
                        : _isWrong
                            ? BoxDecoration(
                                color: const Color(0xFFDC2626).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: const Color(0xFFEF4444), width: 3),
                                boxShadow: [
                                  BoxShadow(color: Colors.red.withOpacity(0.8), blurRadius: 30, spreadRadius: 5),
                                ],
                              )
                            : null,
                    child: Directionality(
                      textDirection: widget.lessonKey.contains('zaban') ? TextDirection.ltr : TextDirection.rtl,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: List.generate(_slots.length, (index) {
                          final char = _slots[index];
                          return GestureDetector(
                            onTap: () => _onSlotTap(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: char != null ? ( _showFirewall ? const Color(0xFFD1FAE5) : (_isWrong ? const Color(0xFFFEE2E2) : Colors.white) ) : const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _showFirewall ? const Color(0xFF059669) : (_isWrong ? Colors.red : const Color(0xFF94A3B8)),
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  char ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Tahoma',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: _showFirewall ? const Color(0xFF065F46) : (_isWrong ? const Color(0xFF991B1B) : const Color(0xFF0F172A)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  if (_showFirewall)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        '🔥 دیوار آتشین شکسته شد! +10 سکه 🪙',
                        style: TextStyle(fontFamily: 'Tahoma', fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF34D399)),
                      ),
                    ),

                  const Spacer(),

                  // Scrambled Letter Tiles
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF160E35),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'برای چیدن حروف در کادر بالا، روی آن‌ها ضربه بزنید:',
                          style: TextStyle(fontFamily: 'Tahoma', fontSize: 11, color: Color(0xFF94A3B8)),
                        ),
                        const SizedBox(height: 16),
                        Directionality(
                          textDirection: widget.lessonKey.contains('zaban') ? TextDirection.ltr : TextDirection.rtl,
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: List.generate(_scrambledLetters.length, (index) {
                              final letterObj = _scrambledLetters[index];
                              final bool isUsed = letterObj['used'];

                              return Opacity(
                                opacity: isUsed ? 0.35 : 1.0,
                                child: GestureDetector(
                                  onTap: () => _onLetterTap(index),
                                  child: Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: isUsed ? const Color(0xFF334155) : const Color(0xFFF97316),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isUsed ? Colors.transparent : const Color(0xFFFB923C),
                                        width: 2,
                                      ),
                                      boxShadow: isUsed
                                          ? []
                                          : [
                                              BoxShadow(
                                                color: const Color(0xFFF97316).withOpacity(0.5),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        letterObj['char'],
                                        style: const TextStyle(
                                          fontFamily: 'Tahoma',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (_floatingMessage != null)
                Positioned(
                  top: 70,
                  right: 30,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, -20 * value),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _floatingMessageColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: _floatingMessageColor.withOpacity(0.5), blurRadius: 10),
                              ],
                            ),
                            child: Directionality(
                              textDirection: _floatingMessage!.startsWith('-') ? TextDirection.ltr : TextDirection.rtl,
                              child: Text(
                                _floatingMessage!,
                                style: const TextStyle(
                                  fontFamily: 'Tahoma',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// صفحه بازی قسمت سوم (پویا برای درس اول و دوم)
// ==========================================
class ArabicLesson1Part3RocketGameScreen extends StatefulWidget {
  final String lessonTitle;
  final List<Map<String, String>>? customWords;
  final String lessonKey;
  final bool isChallengeMode;
  final int challengeTimeLimitSeconds;
  final void Function(int coinsEarned, int timeTakenSeconds)? onChallengeComplete;

  const ArabicLesson1Part3RocketGameScreen({
    super.key,
    required this.lessonTitle,
    this.customWords,
    this.lessonKey = 'lesson1',
    this.isChallengeMode = false,
    this.challengeTimeLimitSeconds = 60,
    this.onChallengeComplete,
  });

  @override
  State<ArabicLesson1Part3RocketGameScreen> createState() => _ArabicLesson1Part3RocketGameScreenState();
}

class _ArabicLesson1Part3RocketGameScreenState extends State<ArabicLesson1Part3RocketGameScreen> {
  late final List<Map<String, String>> _wordsToLoad;
  late final WebViewController controller;
  bool _isLoading = true;
  String? _errorMessage;

  Timer? _challengeCountdownTimer;
  int _challengeSecondsLeft = 60;
  bool _challengeEnded = false;
  int _challengeSessionCoins = 0;

  Future<void> _finishChallenge() async {
    if (_challengeEnded) return;
    _challengeEnded = true;
    _challengeCountdownTimer?.cancel();
    int coins = _challengeSessionCoins;
    try {
      final result = await controller.runJavaScriptReturningResult("coins");
      String cleanResult = result.toString().replaceAll('"', '').trim();
      final int? jsCoins = int.tryParse(cleanResult);
      if (jsCoins != null && jsCoins > coins) {
        coins = jsCoins;
      }
    } catch (_) {}
    final int timeTaken = math.max(1, widget.challengeTimeLimitSeconds - _challengeSecondsLeft);
    if (widget.onChallengeComplete != null) {
      widget.onChallengeComplete!(coins, timeTaken);
    } else {
      Navigator.pop(context, {'coins': coins, 'timeTaken': timeTaken});
    }
  }

  Widget _buildChallengeTopTimer() {
    final int sec = _challengeSecondsLeft;
    final bool isLow = sec <= 10;
    final String timeStr = '00:${sec.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isLow ? Colors.red.withOpacity(0.25) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLow ? Colors.redAccent : const Color(0xFF00E5FF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isLow ? Colors.redAccent : const Color(0xFF00E5FF)).withOpacity(0.35),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_rounded,
            size: 18,
            color: isLow ? Colors.redAccent : const Color(0xFF00E5FF),
          ),
          const SizedBox(width: 8),
          Text(
            timeStr,
            style: TextStyle(
              fontFamily: 'Tahoma',
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: isLow ? Colors.redAccent : Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _challengeCountdownTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isChallengeMode) {
      _challengeSecondsLeft = widget.challengeTimeLimitSeconds;
      _challengeCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        if (_challengeSecondsLeft > 0) {
          setState(() {
            _challengeSecondsLeft--;
          });
          if (_challengeSecondsLeft <= 0) {
            timer.cancel();
            _finishChallenge();
          }
        }
      });
    }
    _wordsToLoad = List<Map<String, String>>.from(widget.customWords ?? lesson1Part3Vocab);
    if (widget.lessonKey.contains('zaban7_lesson3')) {
      _wordsToLoad.shuffle(math.Random());
    }
    bool isCompleted = widget.lessonKey.contains('zaban9_lesson6') ? AuthManager.zaban9Lesson6Part3Completed :
                       widget.lessonKey.contains('zaban9_lesson5') ? AuthManager.zaban9Lesson5Part3Completed :
                       widget.lessonKey.contains('zaban9_lesson4') ? AuthManager.zaban9Lesson4Part3Completed :
                       widget.lessonKey.contains('zaban9_lesson3') ? AuthManager.zaban9Lesson3Part3Completed :
                       widget.lessonKey.contains('zaban9_lesson2') ? AuthManager.zaban9Lesson2Part3Completed :
                       widget.lessonKey.contains('zaban9_lesson1') ? AuthManager.zaban9Lesson1Part3Completed :
                       widget.lessonKey.contains('zaban8_lesson7') ? AuthManager.zaban8Lesson7Part3Completed :
                       widget.lessonKey.contains('zaban8_lesson6') ? AuthManager.zaban8Lesson6Part3Completed :
                       widget.lessonKey.contains('zaban8_lesson5') ? AuthManager.zaban8Lesson5Part3Completed :
                       widget.lessonKey.contains('zaban8_lesson4') ? AuthManager.zaban8Lesson4Part3Completed :
                       widget.lessonKey.contains('zaban8_lesson3') ? AuthManager.zaban8Lesson3Part3Completed :
                       widget.lessonKey.contains('zaban8_lesson2') ? AuthManager.zaban8Lesson2Part3Completed :
                       widget.lessonKey.contains('zaban8_lesson1') ? AuthManager.zaban8Lesson1Part3Completed :
                       widget.lessonKey.contains('zaban7_lesson8') ? AuthManager.zaban7Lesson8Part3Completed :
                       widget.lessonKey.contains('zaban7_lesson7') ? AuthManager.zaban7Lesson7Part3Completed :
                       widget.lessonKey.contains('zaban7_lesson6') ? AuthManager.zaban7Lesson6Part3Completed :
                       widget.lessonKey.contains('zaban7_lesson5') ? AuthManager.zaban7Lesson5Part3Completed :
                       widget.lessonKey.contains('zaban7_lesson4') ? AuthManager.zaban7Lesson4Part3Completed :
                       widget.lessonKey.contains('zaban7_lesson3') ? AuthManager.zaban7Lesson3Part3Completed :
                       widget.lessonKey.contains('zaban7_welcome') ? AuthManager.zaban7WelcomePart3Completed :
                       widget.lessonKey.contains('zaban7_lesson1') ? AuthManager.zaban7Lesson1Part3Completed :
                       widget.lessonKey.contains('quran9_lesson11') ? AuthManager.quran9Lesson11Part3Completed :
                       widget.lessonKey.contains('quran9_lesson10') ? AuthManager.quran9Lesson10Part3Completed :
                       widget.lessonKey.contains('quran9_lesson9') ? AuthManager.quran9Lesson9Part3Completed :
                       widget.lessonKey.contains('quran9_lesson8') ? AuthManager.quran9Lesson8Part3Completed :
                       widget.lessonKey.contains('quran9_lesson7') ? AuthManager.quran9Lesson7Part3Completed :
                       widget.lessonKey.contains('quran9_lesson6') ? AuthManager.quran9Lesson6Part3Completed :
                       widget.lessonKey.contains('quran9_lesson5') ? AuthManager.quran9Lesson5Part3Completed :
                       widget.lessonKey.contains('quran9_lesson4') ? AuthManager.quran9Lesson4Part3Completed :
                       widget.lessonKey.contains('quran9_lesson3') ? AuthManager.quran9Lesson3Part3Completed :
                       widget.lessonKey.contains('quran9_lesson2') ? AuthManager.quran9Lesson2Part3Completed :
                       widget.lessonKey.contains('quran9_lesson1') ? AuthManager.quran9Lesson1Part3Completed :
                       widget.lessonKey.contains('quran8_lesson12') ? AuthManager.quran8Lesson12Part3Completed :
                       widget.lessonKey.contains('quran8_lesson11') ? AuthManager.quran8Lesson11Part3Completed :
                       widget.lessonKey.contains('quran8_lesson10') ? AuthManager.quran8Lesson10Part3Completed :
                       widget.lessonKey.contains('quran8_lesson9') ? AuthManager.quran8Lesson9Part3Completed :
                       widget.lessonKey.contains('quran8_lesson8') ? AuthManager.quran8Lesson8Part3Completed :
                       widget.lessonKey.contains('quran8_lesson7') ? AuthManager.quran8Lesson7Part3Completed :
                       widget.lessonKey.contains('quran8_lesson6') ? AuthManager.quran8Lesson6Part3Completed :
                       widget.lessonKey.contains('quran8_lesson5') ? AuthManager.quran8Lesson5Part3Completed :
                       widget.lessonKey.contains('quran8_lesson4') ? AuthManager.quran8Lesson4Part3Completed :
                       widget.lessonKey.contains('quran8_lesson3') ? AuthManager.quran8Lesson3Part3Completed :
                       widget.lessonKey.contains('quran8_lesson2') ? AuthManager.quran8Lesson2Part3Completed :
                       widget.lessonKey.contains('quran8_lesson1') ? AuthManager.quran8Lesson1Part3Completed :
                       widget.lessonKey.contains('quran7_lesson12') ? AuthManager.quran7Lesson12Part3Completed :
                       widget.lessonKey.contains('quran7_lesson11') ? AuthManager.quran7Lesson11Part3Completed :
                       widget.lessonKey.contains('quran7_lesson10') ? AuthManager.quran7Lesson10Part3Completed :
                       widget.lessonKey.contains('quran7_lesson9') ? AuthManager.quran7Lesson9Part3Completed :
                       widget.lessonKey.contains('quran7_lesson8') ? AuthManager.quran7Lesson8Part3Completed :
                       widget.lessonKey.contains('quran7_lesson7') ? AuthManager.quran7Lesson7Part3Completed :
                       widget.lessonKey.contains('quran7_lesson6') ? AuthManager.quran7Lesson6Part3Completed :
                       widget.lessonKey.contains('quran7_lesson5') ? AuthManager.quran7Lesson5Part3Completed :
                       widget.lessonKey.contains('quran7_lesson4') ? AuthManager.quran7Lesson4Part3Completed :
                       widget.lessonKey.contains('quran7_lesson3') ? AuthManager.quran7Lesson3Part3Completed :
                       widget.lessonKey.contains('quran7_lesson2') ? AuthManager.quran7Lesson2Part3Completed :
                       (widget.lessonKey.contains('quran7_lesson1') || (widget.lessonTitle.contains('قرآن') && widget.lessonTitle.contains('درس اول'))) ? AuthManager.quran7Lesson1Part3Completed :
                       widget.lessonKey == 'arabic9_lesson10' ? AuthManager.arabic9Lesson10Part3Completed :
                       widget.lessonKey == 'arabic9_lesson9' ? AuthManager.arabic9Lesson9Part3Completed :
                       widget.lessonKey == 'arabic9_lesson8' ? AuthManager.arabic9Lesson8Part3Completed :
                       widget.lessonKey == 'arabic9_lesson7' ? AuthManager.arabic9Lesson7Part3Completed :
                       widget.lessonKey == 'arabic9_lesson6' ? AuthManager.arabic9Lesson6Part3Completed :
                       widget.lessonKey == 'arabic9_lesson5' ? AuthManager.arabic9Lesson5Part3Completed :
                       widget.lessonKey == 'arabic9_lesson4' ? AuthManager.arabic9Lesson4Part3Completed :
                       widget.lessonKey == 'arabic9_lesson3' ? AuthManager.arabic9Lesson3Part3Completed :
                       widget.lessonKey == 'arabic9_lesson2' ? AuthManager.arabic9Lesson2Part3Completed :
                       widget.lessonKey == 'arabic9_lesson1' ? AuthManager.arabic9Lesson1Part3Completed :
                       widget.lessonKey == 'arabic8_lesson10' ? AuthManager.arabic8Lesson10Part3Completed :
                       widget.lessonKey == 'arabic8_lesson9' ? AuthManager.arabic8Lesson9Part3Completed :
                       widget.lessonKey == 'arabic8_lesson8' ? AuthManager.arabic8Lesson8Part3Completed :
                       widget.lessonKey == 'arabic8_lesson7' ? AuthManager.arabic8Lesson7Part3Completed :
                       widget.lessonKey == 'arabic8_lesson6' ? AuthManager.arabic8Lesson6Part3Completed :
                       widget.lessonKey == 'arabic8_lesson5' ? AuthManager.arabic8Lesson5Part3Completed :
                       widget.lessonKey == 'arabic8_lesson4' ? AuthManager.arabic8Lesson4Part3Completed :
                       widget.lessonKey == 'arabic8_lesson3' ? AuthManager.arabic8Lesson3Part3Completed :
                       widget.lessonKey == 'arabic8_lesson2' ? AuthManager.arabic8Lesson2Part3Completed :
                       widget.lessonKey == 'arabic8_lesson1' ? AuthManager.arabic8Lesson1Part3Completed :
                       widget.lessonKey == 'lesson20' ? AuthManager.lesson20Part3Completed :
                       widget.lessonKey == 'lesson19' ? AuthManager.lesson19Part3Completed :
                       widget.lessonKey == 'lesson18' ? AuthManager.lesson18Part3Completed :
                       widget.lessonKey == 'lesson17' ? AuthManager.lesson17Part3Completed :
                       widget.lessonKey == 'lesson16' ? AuthManager.lesson16Part3Completed :
                       widget.lessonKey == 'lesson15' ? AuthManager.lesson15Part3Completed :
                       widget.lessonKey == 'lesson14' ? AuthManager.lesson14Part3Completed :
                       widget.lessonKey == 'lesson13' ? AuthManager.lesson13Part3Completed :
                       widget.lessonKey == 'lesson12' ? AuthManager.lesson12Part3Completed :
                       widget.lessonKey == 'lesson11' ? AuthManager.lesson11Part3Completed :
                       widget.lessonKey == 'lesson10' ? AuthManager.lesson10Part3Completed :
                       widget.lessonKey == 'lesson9' ? AuthManager.lesson9Part3Completed :
                       widget.lessonKey == 'lesson8' ? AuthManager.lesson8Part3Completed :
                       widget.lessonKey == 'lesson7' ? AuthManager.lesson7Part3Completed :
                       widget.lessonKey == 'lesson6' ? AuthManager.lesson6Part3Completed :
                       widget.lessonKey == 'lesson5' ? AuthManager.lesson5Part3Completed :
                       widget.lessonKey == 'lesson4' ? AuthManager.lesson4Part3Completed :
                       widget.lessonKey == 'lesson3' ? AuthManager.lesson3Part3Completed :
                       widget.lessonKey == 'lesson2' ? AuthManager.lesson2Part3Completed :
                       AuthManager.lesson1Part3Completed;
    if (!widget.isChallengeMode && !widget.lessonKey.contains('battle')) {
      if (isCompleted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showReplayWarningDialog();
        });
      }
    }
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'CoinChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final int? earnedCoins = int.tryParse(message.message);
          if (widget.isChallengeMode || widget.lessonKey.contains('battle')) {
            if (earnedCoins != null && earnedCoins > 0) {
              _challengeSessionCoins = earnedCoins;
            }
            _finishChallenge();
            return;
          }
          if (earnedCoins != null && earnedCoins > 0) {
            bool alreadyCompleted = widget.lessonKey.contains('zaban9_lesson6') ? AuthManager.zaban9Lesson6Part3Completed :
                                    widget.lessonKey.contains('zaban9_lesson5') ? AuthManager.zaban9Lesson5Part3Completed :
                                    widget.lessonKey.contains('zaban9_lesson4') ? AuthManager.zaban9Lesson4Part3Completed :
                                    widget.lessonKey.contains('zaban9_lesson3') ? AuthManager.zaban9Lesson3Part3Completed :
                                    widget.lessonKey.contains('zaban9_lesson2') ? AuthManager.zaban9Lesson2Part3Completed :
                                    widget.lessonKey.contains('zaban9_lesson1') ? AuthManager.zaban9Lesson1Part3Completed :
                                    widget.lessonKey.contains('zaban8_lesson7') ? AuthManager.zaban8Lesson7Part3Completed :
                                    widget.lessonKey.contains('zaban8_lesson6') ? AuthManager.zaban8Lesson6Part3Completed :
                                    widget.lessonKey.contains('zaban8_lesson5') ? AuthManager.zaban8Lesson5Part3Completed :
                                    widget.lessonKey.contains('zaban8_lesson4') ? AuthManager.zaban8Lesson4Part3Completed :
                                    widget.lessonKey.contains('zaban8_lesson3') ? AuthManager.zaban8Lesson3Part3Completed :
                                    widget.lessonKey.contains('zaban8_lesson2') ? AuthManager.zaban8Lesson2Part3Completed :
                                    widget.lessonKey.contains('zaban8_lesson1') ? AuthManager.zaban8Lesson1Part3Completed :
                                    widget.lessonKey.contains('zaban7_lesson8') ? AuthManager.zaban7Lesson8Part3Completed :
                                    widget.lessonKey.contains('zaban7_lesson7') ? AuthManager.zaban7Lesson7Part3Completed :
                                    widget.lessonKey.contains('zaban7_lesson6') ? AuthManager.zaban7Lesson6Part3Completed :
                                    widget.lessonKey.contains('zaban7_lesson5') ? AuthManager.zaban7Lesson5Part3Completed :
                                    widget.lessonKey.contains('zaban7_lesson4') ? AuthManager.zaban7Lesson4Part3Completed :
                                    widget.lessonKey.contains('zaban7_lesson3') ? AuthManager.zaban7Lesson3Part3Completed :
                                    widget.lessonKey.contains('zaban7_welcome') ? AuthManager.zaban7WelcomePart3Completed :
                                    widget.lessonKey.contains('zaban7_lesson1') ? AuthManager.zaban7Lesson1Part3Completed :
                                    widget.lessonKey.contains('quran9_lesson11') ? AuthManager.quran9Lesson11Part3Completed :
                                    widget.lessonKey.contains('quran9_lesson10') ? AuthManager.quran9Lesson10Part3Completed :
                                    widget.lessonKey.contains('quran9_lesson9') ? AuthManager.quran9Lesson9Part3Completed :
                                    widget.lessonKey.contains('quran9_lesson8') ? AuthManager.quran9Lesson8Part3Completed :
                                    widget.lessonKey.contains('quran9_lesson7') ? AuthManager.quran9Lesson7Part3Completed :
                                    widget.lessonKey.contains('quran9_lesson6') ? AuthManager.quran9Lesson6Part3Completed :
                                    widget.lessonKey.contains('quran9_lesson5') ? AuthManager.quran9Lesson5Part3Completed :
                                    widget.lessonKey.contains('quran9_lesson4') ? AuthManager.quran9Lesson4Part3Completed :
                                    widget.lessonKey.contains('quran9_lesson3') ? AuthManager.quran9Lesson3Part3Completed :
                                    widget.lessonKey.contains('quran9_lesson2') ? AuthManager.quran9Lesson2Part3Completed :
                                    widget.lessonKey.contains('quran9_lesson1') ? AuthManager.quran9Lesson1Part3Completed :
                                    widget.lessonKey.contains('quran8_lesson12') ? AuthManager.quran8Lesson12Part3Completed :
                                    widget.lessonKey.contains('quran8_lesson11') ? AuthManager.quran8Lesson11Part3Completed :
                                    widget.lessonKey.contains('quran8_lesson10') ? AuthManager.quran8Lesson10Part3Completed :
                                    widget.lessonKey.contains('quran8_lesson9') ? AuthManager.quran8Lesson9Part3Completed :
                                    widget.lessonKey.contains('quran8_lesson8') ? AuthManager.quran8Lesson8Part3Completed :
                                    widget.lessonKey.contains('quran8_lesson7') ? AuthManager.quran8Lesson7Part3Completed :
                                    widget.lessonKey.contains('quran8_lesson6') ? AuthManager.quran8Lesson6Part3Completed :
                                    widget.lessonKey.contains('quran8_lesson5') ? AuthManager.quran8Lesson5Part3Completed :
                                    widget.lessonKey.contains('quran8_lesson4') ? AuthManager.quran8Lesson4Part3Completed :
                                    widget.lessonKey.contains('quran8_lesson3') ? AuthManager.quran8Lesson3Part3Completed :
                                    widget.lessonKey.contains('quran8_lesson2') ? AuthManager.quran8Lesson2Part3Completed :
                                    widget.lessonKey.contains('quran8_lesson1') ? AuthManager.quran8Lesson1Part3Completed :
                                    widget.lessonKey.contains('quran7_lesson12') ? AuthManager.quran7Lesson12Part3Completed :
                                    widget.lessonKey.contains('quran7_lesson11') ? AuthManager.quran7Lesson11Part3Completed :
                                    widget.lessonKey.contains('quran7_lesson10') ? AuthManager.quran7Lesson10Part3Completed :
                                    widget.lessonKey.contains('quran7_lesson9') ? AuthManager.quran7Lesson9Part3Completed :
                                    widget.lessonKey.contains('quran7_lesson8') ? AuthManager.quran7Lesson8Part3Completed :
                                    widget.lessonKey.contains('quran7_lesson7') ? AuthManager.quran7Lesson7Part3Completed :
                                    widget.lessonKey.contains('quran7_lesson6') ? AuthManager.quran7Lesson6Part3Completed :
                                    widget.lessonKey.contains('quran7_lesson5') ? AuthManager.quran7Lesson5Part3Completed :
                                    widget.lessonKey.contains('quran7_lesson4') ? AuthManager.quran7Lesson4Part3Completed :
                                    widget.lessonKey.contains('quran7_lesson3') ? AuthManager.quran7Lesson3Part3Completed :
                                    widget.lessonKey.contains('quran7_lesson2') ? AuthManager.quran7Lesson2Part3Completed :
                                    (widget.lessonKey.contains('quran7_lesson1') || (widget.lessonTitle.contains('قرآن') && widget.lessonTitle.contains('درس اول'))) ? AuthManager.quran7Lesson1Part3Completed :
                                    widget.lessonKey == 'arabic9_lesson10' ? AuthManager.arabic9Lesson10Part3Completed :
                                    widget.lessonKey == 'arabic9_lesson9' ? AuthManager.arabic9Lesson9Part3Completed :
                                    widget.lessonKey == 'arabic9_lesson8' ? AuthManager.arabic9Lesson8Part3Completed :
                                    widget.lessonKey == 'arabic9_lesson7' ? AuthManager.arabic9Lesson7Part3Completed :
                                    widget.lessonKey == 'arabic9_lesson6' ? AuthManager.arabic9Lesson6Part3Completed :
                                    widget.lessonKey == 'arabic9_lesson5' ? AuthManager.arabic9Lesson5Part3Completed :
                                    widget.lessonKey == 'arabic9_lesson4' ? AuthManager.arabic9Lesson4Part3Completed :
                                    widget.lessonKey == 'arabic9_lesson3' ? AuthManager.arabic9Lesson3Part3Completed :
                                    widget.lessonKey == 'arabic9_lesson2' ? AuthManager.arabic9Lesson2Part3Completed :
                                    widget.lessonKey == 'arabic9_lesson1' ? AuthManager.arabic9Lesson1Part3Completed :
                                    widget.lessonKey == 'arabic8_lesson10' ? AuthManager.arabic8Lesson10Part3Completed :
                                    widget.lessonKey == 'arabic8_lesson9' ? AuthManager.arabic8Lesson9Part3Completed :
                                    widget.lessonKey == 'arabic8_lesson8' ? AuthManager.arabic8Lesson8Part3Completed :
                                    widget.lessonKey == 'arabic8_lesson7' ? AuthManager.arabic8Lesson7Part3Completed :
                                    widget.lessonKey == 'arabic8_lesson6' ? AuthManager.arabic8Lesson6Part3Completed :
                                    widget.lessonKey == 'arabic8_lesson5' ? AuthManager.arabic8Lesson5Part3Completed :
                                    widget.lessonKey == 'arabic8_lesson4' ? AuthManager.arabic8Lesson4Part3Completed :
                                    widget.lessonKey == 'arabic8_lesson3' ? AuthManager.arabic8Lesson3Part3Completed :
                                    widget.lessonKey == 'arabic8_lesson2' ? AuthManager.arabic8Lesson2Part3Completed :
                                    widget.lessonKey == 'arabic8_lesson1' ? AuthManager.arabic8Lesson1Part3Completed :
                                    widget.lessonKey == 'lesson20' ? AuthManager.lesson20Part3Completed :
                                    widget.lessonKey == 'lesson19' ? AuthManager.lesson19Part3Completed :
                                    widget.lessonKey == 'lesson18' ? AuthManager.lesson18Part3Completed :
                                    widget.lessonKey == 'lesson17' ? AuthManager.lesson17Part3Completed :
                                    widget.lessonKey == 'lesson16' ? AuthManager.lesson16Part3Completed :
                                    widget.lessonKey == 'lesson15' ? AuthManager.lesson15Part3Completed :
                                    widget.lessonKey == 'lesson14' ? AuthManager.lesson14Part3Completed :
                                    widget.lessonKey == 'lesson13' ? AuthManager.lesson13Part3Completed :
                                    widget.lessonKey == 'lesson12' ? AuthManager.lesson12Part3Completed :
                                    widget.lessonKey == 'lesson11' ? AuthManager.lesson11Part3Completed :
                                    widget.lessonKey == 'lesson10' ? AuthManager.lesson10Part3Completed :
                                    widget.lessonKey == 'lesson9' ? AuthManager.lesson9Part3Completed :
                                    widget.lessonKey == 'lesson8' ? AuthManager.lesson8Part3Completed :
                                    widget.lessonKey == 'lesson7' ? AuthManager.lesson7Part3Completed :
                                    widget.lessonKey == 'lesson6' ? AuthManager.lesson6Part3Completed :
                                    widget.lessonKey == 'lesson5' ? AuthManager.lesson5Part3Completed :
                                    widget.lessonKey == 'lesson4' ? AuthManager.lesson4Part3Completed :
                                    widget.lessonKey == 'lesson3' ? AuthManager.lesson3Part3Completed :
                                    widget.lessonKey == 'lesson2' ? AuthManager.lesson2Part3Completed :
                                    AuthManager.lesson1Part3Completed;
            if (!alreadyCompleted) {
              setState(() {
                AuthManager.coins += earnedCoins; // or finalCoins
                if (widget.lessonKey.contains('zaban9_lesson6')) {
                  AuthManager.zaban9Lesson6Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban9_lesson5')) {
                  AuthManager.zaban9Lesson5Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban9_lesson4')) {
                  AuthManager.zaban9Lesson4Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban9_lesson3')) {
                  AuthManager.zaban9Lesson3Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban9_lesson2')) {
                  AuthManager.zaban9Lesson2Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban9_lesson1')) {
                  AuthManager.zaban9Lesson1Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban8_lesson7')) {
                  AuthManager.zaban8Lesson7Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban8_lesson6')) {
                  AuthManager.zaban8Lesson6Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban8_lesson5')) {
                  AuthManager.zaban8Lesson5Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban8_lesson4')) {
                  AuthManager.zaban8Lesson4Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban8_lesson3')) {
                  AuthManager.zaban8Lesson3Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban8_lesson2')) {
                  AuthManager.zaban8Lesson2Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban8_lesson1')) {
                  AuthManager.zaban8Lesson1Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban7_lesson8')) {
                  AuthManager.zaban7Lesson8Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban7_lesson7')) {
                  AuthManager.zaban7Lesson7Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban7_lesson6')) {
                  AuthManager.zaban7Lesson6Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban7_lesson5')) {
                  AuthManager.zaban7Lesson5Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban7_lesson4')) {
                  AuthManager.zaban7Lesson4Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban7_lesson3')) {
                  AuthManager.zaban7Lesson3Part3Completed = true;
                } else if (widget.lessonKey.contains('zaban7_welcome')) {
                  AuthManager.zaban7WelcomePart3Completed = true;
                } else if (widget.lessonKey.contains('zaban7_lesson1')) {
                  AuthManager.zaban7Lesson1Part3Completed = true;
                } else if (widget.lessonKey.contains('quran9_lesson11')) {
                  AuthManager.quran9Lesson11Part3Completed = true;
                } else if (widget.lessonKey.contains('quran9_lesson10')) {
                  AuthManager.quran9Lesson10Part3Completed = true;
                } else if (widget.lessonKey.contains('quran9_lesson9')) {
                  AuthManager.quran9Lesson9Part3Completed = true;
                } else if (widget.lessonKey.contains('quran9_lesson8')) {
                  AuthManager.quran9Lesson8Part3Completed = true;
                } else if (widget.lessonKey.contains('quran9_lesson7')) {
                  AuthManager.quran9Lesson7Part3Completed = true;
                } else if (widget.lessonKey.contains('quran9_lesson6')) {
                  AuthManager.quran9Lesson6Part3Completed = true;
                } else if (widget.lessonKey.contains('quran9_lesson5')) {
                  AuthManager.quran9Lesson5Part3Completed = true;
                } else if (widget.lessonKey.contains('quran9_lesson4')) {
                  AuthManager.quran9Lesson4Part3Completed = true;
                } else if (widget.lessonKey.contains('quran9_lesson3')) {
                  AuthManager.quran9Lesson3Part3Completed = true;
                } else if (widget.lessonKey.contains('quran9_lesson2')) {
                  AuthManager.quran9Lesson2Part3Completed = true;
                } else if (widget.lessonKey.contains('quran9_lesson1')) {
                  AuthManager.quran9Lesson1Part3Completed = true;
                } else if (widget.lessonKey.contains('quran8_lesson12')) {
                  AuthManager.quran8Lesson12Part3Completed = true;
                } else if (widget.lessonKey.contains('quran8_lesson11')) {
                  AuthManager.quran8Lesson11Part3Completed = true;
                } else if (widget.lessonKey.contains('quran8_lesson10')) {
                  AuthManager.quran8Lesson10Part3Completed = true;
                } else if (widget.lessonKey.contains('quran8_lesson9')) {
                  AuthManager.quran8Lesson9Part3Completed = true;
                } else if (widget.lessonKey.contains('quran8_lesson8')) {
                  AuthManager.quran8Lesson8Part3Completed = true;
                } else if (widget.lessonKey.contains('quran8_lesson7')) {
                  AuthManager.quran8Lesson7Part3Completed = true;
                } else if (widget.lessonKey.contains('quran8_lesson6')) {
                  AuthManager.quran8Lesson6Part3Completed = true;
                } else if (widget.lessonKey.contains('quran8_lesson5')) {
                  AuthManager.quran8Lesson5Part3Completed = true;
                } else if (widget.lessonKey.contains('quran8_lesson4')) {
                  AuthManager.quran8Lesson4Part3Completed = true;
                } else if (widget.lessonKey.contains('quran8_lesson3')) {
                  AuthManager.quran8Lesson3Part3Completed = true;
                } else if (widget.lessonKey.contains('quran8_lesson2')) {
                  AuthManager.quran8Lesson2Part3Completed = true;
                } else if (widget.lessonKey.contains('quran8_lesson1')) {
                  AuthManager.quran8Lesson1Part3Completed = true;
                } else if (widget.lessonKey.contains('quran7_lesson12')) {
                  AuthManager.quran7Lesson12Part3Completed = true;
                } else if (widget.lessonKey.contains('quran7_lesson11')) {
                  AuthManager.quran7Lesson11Part3Completed = true;
                } else if (widget.lessonKey.contains('quran7_lesson10')) {
                  AuthManager.quran7Lesson10Part3Completed = true;
                } else if (widget.lessonKey.contains('quran7_lesson9')) {
                  AuthManager.quran7Lesson9Part3Completed = true;
                } else if (widget.lessonKey.contains('quran7_lesson8')) {
                  AuthManager.quran7Lesson8Part3Completed = true;
                } else if (widget.lessonKey.contains('quran7_lesson7')) {
                  AuthManager.quran7Lesson7Part3Completed = true;
                } else if (widget.lessonKey.contains('quran7_lesson6')) {
                  AuthManager.quran7Lesson6Part3Completed = true;
                } else if (widget.lessonKey.contains('quran7_lesson5')) {
                  AuthManager.quran7Lesson5Part3Completed = true;
                } else if (widget.lessonKey.contains('quran7_lesson4')) {
                  AuthManager.quran7Lesson4Part3Completed = true;
                } else if (widget.lessonKey.contains('quran7_lesson3')) {
                  AuthManager.quran7Lesson3Part3Completed = true;
                } else if (widget.lessonKey.contains('quran7_lesson2')) {
                  AuthManager.quran7Lesson2Part3Completed = true;
                } else if (widget.lessonKey.contains('quran7_lesson1') || (widget.lessonTitle.contains('قرآن') && widget.lessonTitle.contains('درس اول'))) {
                  AuthManager.quran7Lesson1Part3Completed = true;
                } else if (widget.lessonKey == 'arabic9_lesson10') {
                  AuthManager.arabic9Lesson10Part3Completed = true;
                } else if (widget.lessonKey == 'arabic9_lesson9') {
                  AuthManager.arabic9Lesson9Part3Completed = true;
                } else if (widget.lessonKey == 'arabic9_lesson8') {
                  AuthManager.arabic9Lesson8Part3Completed = true;
                } else if (widget.lessonKey == 'arabic9_lesson7') {
                  AuthManager.arabic9Lesson7Part3Completed = true;
                } else if (widget.lessonKey == 'arabic9_lesson6') {
                  AuthManager.arabic9Lesson6Part3Completed = true;
                } else if (widget.lessonKey == 'arabic9_lesson5') {
                  AuthManager.arabic9Lesson5Part3Completed = true;
                } else if (widget.lessonKey == 'arabic9_lesson4') {
                  AuthManager.arabic9Lesson4Part3Completed = true;
                } else if (widget.lessonKey == 'arabic9_lesson3') {
                  AuthManager.arabic9Lesson3Part3Completed = true;
                } else if (widget.lessonKey == 'arabic9_lesson2') {
                  AuthManager.arabic9Lesson2Part3Completed = true;
                } else if (widget.lessonKey == 'arabic9_lesson1') {
                  AuthManager.arabic9Lesson1Part3Completed = true;
                } else if (widget.lessonKey == 'arabic8_lesson10') {
                  AuthManager.arabic8Lesson10Part3Completed = true;
                } else if (widget.lessonKey == 'arabic8_lesson9') {
                  AuthManager.arabic8Lesson9Part3Completed = true;
                } else if (widget.lessonKey == 'arabic8_lesson8') {
                  AuthManager.arabic8Lesson8Part3Completed = true;
                } else if (widget.lessonKey == 'arabic8_lesson7') {
                  AuthManager.arabic8Lesson7Part3Completed = true;
                } else if (widget.lessonKey == 'arabic8_lesson6') {
                  AuthManager.arabic8Lesson6Part3Completed = true;
                } else if (widget.lessonKey == 'arabic8_lesson5') {
                  AuthManager.arabic8Lesson5Part3Completed = true;
                } else if (widget.lessonKey == 'arabic8_lesson4') {
                  AuthManager.arabic8Lesson4Part3Completed = true;
                } else if (widget.lessonKey == 'arabic8_lesson3') {
                  AuthManager.arabic8Lesson3Part3Completed = true;
                } else if (widget.lessonKey == 'arabic8_lesson2') {
                  AuthManager.arabic8Lesson2Part3Completed = true;
                } else if (widget.lessonKey == 'arabic8_lesson1') {
                  AuthManager.arabic8Lesson1Part3Completed = true;
                } else if (widget.lessonKey == 'lesson20') {
                  AuthManager.lesson20Part3Completed = true;
                } else if (widget.lessonKey == 'lesson19') {
                  AuthManager.lesson19Part3Completed = true;
                } else if (widget.lessonKey == 'lesson18') {
                  AuthManager.lesson18Part3Completed = true;
                } else if (widget.lessonKey == 'lesson17') {
                  AuthManager.lesson17Part3Completed = true;
                } else if (widget.lessonKey == 'lesson16') {
                  AuthManager.lesson16Part3Completed = true;
                } else if (widget.lessonKey == 'lesson15') {
                  AuthManager.lesson15Part3Completed = true;
                } else if (widget.lessonKey == 'lesson14') {
                  AuthManager.lesson14Part3Completed = true;
                } else if (widget.lessonKey == 'lesson13') {
                  AuthManager.lesson13Part3Completed = true;
                } else if (widget.lessonKey == 'lesson12') {
                  AuthManager.lesson12Part3Completed = true;
                } else if (widget.lessonKey == 'lesson11') {
                  AuthManager.lesson11Part3Completed = true;
                } else if (widget.lessonKey == 'lesson10') {
                  AuthManager.lesson10Part3Completed = true;
                } else if (widget.lessonKey == 'lesson9') {
                  AuthManager.lesson9Part3Completed = true;
                } else if (widget.lessonKey == 'lesson8') {
                  AuthManager.lesson8Part3Completed = true;
                } else if (widget.lessonKey == 'lesson7') {
                  AuthManager.lesson7Part3Completed = true;
                } else if (widget.lessonKey == 'lesson6') {
                  AuthManager.lesson6Part3Completed = true;
                } else if (widget.lessonKey == 'lesson5') {
                  AuthManager.lesson5Part3Completed = true;
                } else if (widget.lessonKey == 'lesson4') {
                  AuthManager.lesson4Part3Completed = true;
                } else if (widget.lessonKey == 'lesson3') {
                  AuthManager.lesson3Part3Completed = true;
                } else if (widget.lessonKey == 'lesson2') {
                  AuthManager.lesson2Part3Completed = true;
                } else {
                  AuthManager.lesson1Part3Completed = true;
                }
                AuthManager.save();
              });
              if (mounted) {
                _showVictoryRewardDialog(earnedCoins, false);
              }
            } else {
              if (mounted) {
                _showVictoryRewardDialog(0, true);
              }
            }
          }
        },
      )
      ..addJavaScriptChannel(
        'MistakeChannel',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final data = jsonDecode(message.message);
            final word = data['word'] as String? ?? '';
            final meaning = data['meaning'] as String? ?? '';
            if (word.isNotEmpty) {
              if (widget.lessonKey.contains('quran8')) {
                Quran8LeagueManager.recordMistake(widget.lessonKey, word, meaning);
              } else {
                Quran7LeagueManager.recordMistake(widget.lessonKey, word, meaning);
              }
            }
          } catch (e) {
            debugPrint('MistakeChannel error: $e');
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            if (mounted) setState(() => _isLoading = false);
            
            final String wordsJson = jsonEncode(_wordsToLoad);
            controller.runJavaScript('window.setGameWords($wordsJson, "${widget.lessonKey}");');

            // چند مرحله تاخیر (debounce) جهت تنظیم دقیق ابعاد و موقعیت شهاب‌سنگ‌ها در لود اولیه
            for (int delay in [100, 300, 600, 1000]) {
              Future.delayed(Duration(milliseconds: delay), () {
                if (mounted) {
                  controller.runJavaScript('''
                    window.dispatchEvent(new Event("resize"));
                    if (typeof resize === "function") { resize(); }
                    if (typeof onResize === "function") { onResize(); }
                    if (typeof init === "function") { init(); }
                  ''');
                }
              });
            }
            debugPrint('WebView page finished loading: $url');
          },
          onWebResourceError: (error) {
            debugPrint('WebView error: ${error.description}, errorCode: ${error.errorCode}, errorType: ${error.errorType}');
            if (mounted) {
              setState(() {
                _isLoading = false;
                _errorMessage = error.description;
              });
            }
          },
        ),
      );

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController androidController = controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    _loadHtmlAsset();
  }

  Future<void> _loadHtmlAsset() async {
    try {
      String htmlContent = await rootBundle.loadString('assets/html/arabi7/711.html');
      
      if (!htmlContent.contains('name="viewport"')) {
        htmlContent = htmlContent.replaceFirst(
          '<head>',
          '<head>\n<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">',
        );
      }

      await controller.loadHtmlString(htmlContent);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _showReplayWarningDialog() {
    if (widget.isChallengeMode || widget.lessonKey.contains('battle')) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: const Color(0xFF1E1B4B),
            title: const Row(
              children: [
                Text('⚠️', style: TextStyle(fontSize: 28)),
                SizedBox(width: 10),
                Text('توجه', style: TextStyle(fontFamily: 'Tahoma', color: Colors.white, fontWeight: FontWeight.w900)),
              ],
            ),
            content: const Text(
              'شما این بازی رو تا آخر رفتید و اینبار سکه نمی‌گیرید!',
              style: TextStyle(fontFamily: 'Tahoma', color: Color(0xFFCBD5E1), fontSize: 13, height: 1.5),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEA580C)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text('متوجه شدم', style: TextStyle(fontFamily: 'Tahoma', color: Colors.white, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVictoryRewardDialog(int finalCoins, bool isAlreadyCompleted) {
    if (widget.isChallengeMode || widget.lessonKey.contains('battle')) {
      _finishChallenge();
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            backgroundColor: const Color(0xFF1E1B4B),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E1065), Color(0xFF1E1B4B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: isAlreadyCompleted ? const Color(0xFFF97316) : const Color(0xFFFFB703), width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: (isAlreadyCompleted ? const Color(0xFFF97316) : const Color(0xFFFFB703)).withOpacity(0.4),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: (isAlreadyCompleted ? const Color(0xFFF97316) : const Color(0xFFFFB703)).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: isAlreadyCompleted ? const Color(0xFFF97316) : const Color(0xFFFFB703), width: 2),
                    ),
                    child: Text(isAlreadyCompleted ? '⚠️' : '🏆', style: const TextStyle(fontSize: 44)),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    isAlreadyCompleted ? 'تکرار مأموریت' : 'پایان درخشان مأموریت! 🌟',
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isAlreadyCompleted
                        ? 'شما این بازی را قبلاً تا آخر رفته‌اید و این بار سکه دریافت نمی‌کنید!'
                        : 'شما با موفقیت بازی را به اتمام رساندید و جوایز ارزنده‌ای کسب کردید',
                    style: const TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!isAlreadyCompleted) ...[
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFFFB703), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFB703).withOpacity(0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🪙', style: TextStyle(fontSize: 26)),
                          const SizedBox(width: 10),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              '+$finalCoins',
                              style: const TextStyle(
                                fontFamily: 'Tahoma',
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFFB703),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.5),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          AuthManager.save();
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Directionality(textDirection: TextDirection.rtl, child: ModernHomeScreen())),
                              (route) => false,
                            );
                          }
                        },
                        child: const Center(
                          child: Text(
                            'بازگشت به لیست دروس 🚀',
                            style: TextStyle(
                              fontFamily: 'Tahoma',
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    try {
      final result = await controller.runJavaScriptReturningResult("coins");
      String cleanResult = result.toString().replaceAll('"', '').trim();
      final int finalCoins = int.tryParse(cleanResult) ?? 0;
      if (finalCoins > 0) {
        bool alreadyCompleted = false;
        if (widget.lessonKey.contains('quran9_lesson4')) {
          alreadyCompleted = AuthManager.quran9Lesson4Part3Completed;
        } else if (widget.lessonKey.contains('quran9_lesson3')) {
          alreadyCompleted = AuthManager.quran9Lesson3Part3Completed;
        } else if (widget.lessonKey.contains('quran9_lesson2')) {
          alreadyCompleted = AuthManager.quran9Lesson2Part3Completed;
        } else if (widget.lessonKey.contains('quran9_lesson1')) {
          alreadyCompleted = AuthManager.quran9Lesson1Part3Completed;
        } else if (widget.lessonKey.contains('quran8_lesson12')) {
          alreadyCompleted = AuthManager.quran8Lesson12Part3Completed;
        } else if (widget.lessonKey.contains('quran8_lesson11')) {
          alreadyCompleted = AuthManager.quran8Lesson11Part3Completed;
        } else if (widget.lessonKey.contains('quran8_lesson10')) {
          alreadyCompleted = AuthManager.quran8Lesson10Part3Completed;
        } else if (widget.lessonKey.contains('quran8_lesson9')) {
          alreadyCompleted = AuthManager.quran8Lesson9Part3Completed;
        } else if (widget.lessonKey.contains('quran8_lesson8')) {
          alreadyCompleted = AuthManager.quran8Lesson8Part3Completed;
        } else if (widget.lessonKey.contains('quran8_lesson7')) {
          alreadyCompleted = AuthManager.quran8Lesson7Part3Completed;
        } else if (widget.lessonKey.contains('quran8_lesson6')) {
          alreadyCompleted = AuthManager.quran8Lesson6Part3Completed;
        } else if (widget.lessonKey.contains('quran8_lesson5')) {
          alreadyCompleted = AuthManager.quran8Lesson5Part3Completed;
        } else if (widget.lessonKey.contains('quran8_lesson4')) {
          alreadyCompleted = AuthManager.quran8Lesson4Part3Completed;
        } else if (widget.lessonKey.contains('quran8_lesson3')) {
          alreadyCompleted = AuthManager.quran8Lesson3Part3Completed;
        } else if (widget.lessonKey.contains('quran8_lesson2')) {
          alreadyCompleted = AuthManager.quran8Lesson2Part3Completed;
        } else if (widget.lessonKey.contains('quran8_lesson1')) {
          alreadyCompleted = AuthManager.quran8Lesson1Part3Completed;
        } else if (widget.lessonKey.contains('quran7_lesson12')) {
          alreadyCompleted = AuthManager.quran7Lesson12Part3Completed;
        } else if (widget.lessonKey.contains('quran7_lesson11')) {
          alreadyCompleted = AuthManager.quran7Lesson11Part3Completed;
        } else if (widget.lessonKey.contains('quran7_lesson10')) {
          alreadyCompleted = AuthManager.quran7Lesson10Part3Completed;
        } else if (widget.lessonKey.contains('quran7_lesson9')) {
          alreadyCompleted = AuthManager.quran7Lesson9Part3Completed;
        } else if (widget.lessonKey.contains('quran7_lesson8')) {
          alreadyCompleted = AuthManager.quran7Lesson8Part3Completed;
        } else if (widget.lessonKey.contains('quran7_lesson7')) {
          alreadyCompleted = AuthManager.quran7Lesson7Part3Completed;
        } else if (widget.lessonKey.contains('quran7_lesson6')) {
          alreadyCompleted = AuthManager.quran7Lesson6Part3Completed;
        } else if (widget.lessonKey.contains('quran7_lesson5')) {
          alreadyCompleted = AuthManager.quran7Lesson5Part3Completed;
        } else if (widget.lessonKey.contains('quran7_lesson4')) {
          alreadyCompleted = AuthManager.quran7Lesson4Part3Completed;
        } else if (widget.lessonKey.contains('quran7_lesson3')) {
          alreadyCompleted = AuthManager.quran7Lesson3Part3Completed;
        } else if (widget.lessonKey.contains('quran7_lesson2')) {
          alreadyCompleted = AuthManager.quran7Lesson2Part3Completed;
        } else if (widget.lessonKey.contains('quran7_lesson1') || (widget.lessonTitle.contains('قرآن') && widget.lessonTitle.contains('درس اول'))) {
          alreadyCompleted = AuthManager.quran7Lesson1Part3Completed;
        } else if (widget.lessonKey == 'arabic8_lesson1') {
          alreadyCompleted = AuthManager.arabic8Lesson1Part3Completed;
        } else if (widget.lessonKey == 'lesson20') {
          alreadyCompleted = AuthManager.lesson20Part3Completed;
        } else if (widget.lessonKey == 'lesson19') {
          alreadyCompleted = AuthManager.lesson19Part3Completed;
        } else if (widget.lessonKey == 'lesson18') {
          alreadyCompleted = AuthManager.lesson18Part3Completed;
        } else if (widget.lessonKey == 'lesson17') {
          alreadyCompleted = AuthManager.lesson17Part3Completed;
        } else if (widget.lessonKey == 'lesson16') {
          alreadyCompleted = AuthManager.lesson16Part3Completed;
        } else if (widget.lessonKey == 'lesson15') {
          alreadyCompleted = AuthManager.lesson15Part3Completed;
        } else if (widget.lessonKey == 'lesson14') {
          alreadyCompleted = AuthManager.lesson14Part3Completed;
        } else if (widget.lessonKey == 'lesson13') {
          alreadyCompleted = AuthManager.lesson13Part3Completed;
        } else if (widget.lessonKey == 'lesson12') {
          alreadyCompleted = AuthManager.lesson12Part3Completed;
        } else if (widget.lessonKey == 'lesson11') {
          alreadyCompleted = AuthManager.lesson11Part3Completed;
        } else if (widget.lessonKey == 'lesson10') {
          alreadyCompleted = AuthManager.lesson10Part3Completed;
        } else if (widget.lessonKey == 'lesson9') {
          alreadyCompleted = AuthManager.lesson9Part3Completed;
        } else if (widget.lessonKey == 'lesson8') {
          alreadyCompleted = AuthManager.lesson8Part3Completed;
        } else if (widget.lessonKey == 'lesson7') {
          alreadyCompleted = AuthManager.lesson7Part3Completed;
        } else if (widget.lessonKey == 'lesson6') {
          alreadyCompleted = AuthManager.lesson6Part3Completed;
        } else if (widget.lessonKey == 'lesson5') {
          alreadyCompleted = AuthManager.lesson5Part3Completed;
        } else if (widget.lessonKey == 'lesson4') {
          alreadyCompleted = AuthManager.lesson4Part3Completed;
        } else if (widget.lessonKey == 'lesson3') {
          alreadyCompleted = AuthManager.lesson3Part3Completed;
        } else if (widget.lessonKey == 'lesson2') {
          alreadyCompleted = AuthManager.lesson2Part3Completed;
        } else {
          alreadyCompleted = AuthManager.lesson1Part3Completed;
        }
        if (!alreadyCompleted) {
          setState(() {
            AuthManager.coins += finalCoins;
            if (widget.lessonKey.contains('quran9_lesson4')) {
              AuthManager.quran9Lesson4Part3Completed = true;
            } else if (widget.lessonKey.contains('quran9_lesson3')) {
              AuthManager.quran9Lesson3Part3Completed = true;
            } else if (widget.lessonKey.contains('quran9_lesson2')) {
              AuthManager.quran9Lesson2Part3Completed = true;
            } else if (widget.lessonKey.contains('quran9_lesson1')) {
              AuthManager.quran9Lesson1Part3Completed = true;
            } else if (widget.lessonKey.contains('quran8_lesson12')) {
              AuthManager.quran8Lesson12Part3Completed = true;
            } else if (widget.lessonKey.contains('quran8_lesson11')) {
              AuthManager.quran8Lesson11Part3Completed = true;
            } else if (widget.lessonKey.contains('quran8_lesson10')) {
              AuthManager.quran8Lesson10Part3Completed = true;
            } else if (widget.lessonKey.contains('quran8_lesson9')) {
              AuthManager.quran8Lesson9Part3Completed = true;
            } else if (widget.lessonKey.contains('quran8_lesson8')) {
              AuthManager.quran8Lesson8Part3Completed = true;
            } else if (widget.lessonKey.contains('quran8_lesson7')) {
              AuthManager.quran8Lesson7Part3Completed = true;
            } else if (widget.lessonKey.contains('quran8_lesson6')) {
              AuthManager.quran8Lesson6Part3Completed = true;
            } else if (widget.lessonKey.contains('quran8_lesson5')) {
              AuthManager.quran8Lesson5Part3Completed = true;
            } else if (widget.lessonKey.contains('quran8_lesson4')) {
              AuthManager.quran8Lesson4Part3Completed = true;
            } else if (widget.lessonKey.contains('quran8_lesson3')) {
              AuthManager.quran8Lesson3Part3Completed = true;
            } else if (widget.lessonKey.contains('quran8_lesson2')) {
              AuthManager.quran8Lesson2Part3Completed = true;
            } else if (widget.lessonKey.contains('quran8_lesson1')) {
              AuthManager.quran8Lesson1Part3Completed = true;
            } else if (widget.lessonKey.contains('quran7_lesson12')) {
              AuthManager.quran7Lesson12Part3Completed = true;
            } else if (widget.lessonKey.contains('quran7_lesson11')) {
              AuthManager.quran7Lesson11Part3Completed = true;
            } else if (widget.lessonKey.contains('quran7_lesson10')) {
              AuthManager.quran7Lesson10Part3Completed = true;
            } else if (widget.lessonKey.contains('quran7_lesson9')) {
              AuthManager.quran7Lesson9Part3Completed = true;
            } else if (widget.lessonKey.contains('quran7_lesson8')) {
              AuthManager.quran7Lesson8Part3Completed = true;
            } else if (widget.lessonKey.contains('quran7_lesson7')) {
              AuthManager.quran7Lesson7Part3Completed = true;
            } else if (widget.lessonKey.contains('quran7_lesson6')) {
              AuthManager.quran7Lesson6Part3Completed = true;
            } else if (widget.lessonKey.contains('quran7_lesson5')) {
              AuthManager.quran7Lesson5Part3Completed = true;
        } else if (widget.lessonKey.contains('quran7_lesson4')) {
              AuthManager.quran7Lesson4Part3Completed = true;
            } else if (widget.lessonKey.contains('quran7_lesson3')) {
              AuthManager.quran7Lesson3Part3Completed = true;
            } else if (widget.lessonKey.contains('quran7_lesson2')) {
              AuthManager.quran7Lesson2Part3Completed = true;
            } else if (widget.lessonKey.contains('quran7_lesson1') || (widget.lessonTitle.contains('قرآن') && widget.lessonTitle.contains('درس اول'))) {
              AuthManager.quran7Lesson1Part3Completed = true;
            } else if (widget.lessonKey == 'arabic8_lesson1') {
              AuthManager.arabic8Lesson1Part3Completed = true;
            } else if (widget.lessonKey == 'lesson20') {
              AuthManager.lesson20Part3Completed = true;
            } else if (widget.lessonKey == 'lesson19') {
              AuthManager.lesson19Part3Completed = true;
            } else if (widget.lessonKey == 'lesson18') {
              AuthManager.lesson18Part3Completed = true;
            } else if (widget.lessonKey == 'lesson17') {
              AuthManager.lesson17Part3Completed = true;
            } else if (widget.lessonKey == 'lesson16') {
              AuthManager.lesson16Part3Completed = true;
            } else if (widget.lessonKey == 'lesson15') {
              AuthManager.lesson15Part3Completed = true;
            } else if (widget.lessonKey == 'lesson14') {
              AuthManager.lesson14Part3Completed = true;
            } else if (widget.lessonKey == 'lesson13') {
              AuthManager.lesson13Part3Completed = true;
            } else if (widget.lessonKey == 'lesson12') {
              AuthManager.lesson12Part3Completed = true;
            } else if (widget.lessonKey == 'lesson11') {
              AuthManager.lesson11Part3Completed = true;
            } else if (widget.lessonKey == 'lesson10') {
              AuthManager.lesson10Part3Completed = true;
            } else if (widget.lessonKey == 'lesson9') {
              AuthManager.lesson9Part3Completed = true;
            } else if (widget.lessonKey == 'lesson8') {
              AuthManager.lesson8Part3Completed = true;
            } else if (widget.lessonKey == 'lesson7') {
              AuthManager.lesson7Part3Completed = true;
            } else if (widget.lessonKey == 'lesson6') {
              AuthManager.lesson6Part3Completed = true;
            } else if (widget.lessonKey == 'lesson5') {
              AuthManager.lesson5Part3Completed = true;
            } else if (widget.lessonKey == 'lesson4') {
              AuthManager.lesson4Part3Completed = true;
            } else if (widget.lessonKey == 'lesson3') {
              AuthManager.lesson3Part3Completed = true;
            } else if (widget.lessonKey == 'lesson2') {
              AuthManager.lesson2Part3Completed = true;
            } else {
              AuthManager.lesson1Part3Completed = true;
            }
            AuthManager.save();
          });
          if (mounted) {
            _showVictoryRewardDialog(finalCoins, false);
            return false;
          }
        } else {
          if (mounted) {
            _showVictoryRewardDialog(0, true);
            return false;
          }
        }
      }
    } catch (_) {}
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E1B4B),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
              onPressed: () async {
                await _onWillPop();
                if (mounted) {
                  Navigator.pop(context);
                }
              },
            ),
            title: widget.isChallengeMode
                ? _buildChallengeTopTimer()
                : Text(
                    'بازی قسمت سوم: ${widget.lessonTitle}',
                    style: const TextStyle(fontFamily: 'Tahoma', fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
          ),
          body: SizedBox.expand(
            child: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (_isLoading)
                  Container(
                    color: const Color(0xFF0F071E),
                    child: const Center(
                      child: CircularProgressIndicator(color: Color(0xFF14B8A6)),
                    ),
                  ),
                if (_errorMessage != null)
                  Container(
                    color: const Color(0xFF0F071E),
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'خطا در بارگذاری بازی:\n$_errorMessage',
                        style: const TextStyle(fontFamily: 'Tahoma', color: Colors.redAccent, fontSize: 13),
                        textAlign: TextAlign.center,
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
}