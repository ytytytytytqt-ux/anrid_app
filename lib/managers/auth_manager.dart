import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

// مدیریت سراسری وضعیت ورود، پروفایل، کیف پول، آواتارها و تم‌های رنگی فروشگاه (بدون الماس، فقط سکه)
class AuthManager {
  static bool isLoggedIn = false;
  static String phoneNumber = '';
  static int selectedGrade = 1; // 0: هفتم, 1: هشتم, 2: نهم
  static String userName = ''; // نام کاربر
  static String userAvatar = ''; // مسیر آواتار انتخابی فعلی کاربر
  static int coins = 0; // سکه‌ها
  static bool pendingWelcomeGift = false; // پرچم نمایش هدیه ورود در صفحه خانه

  // آواتارهای پیش‌فرض رایگان
  static const List<String> defaultAvatars = [
    'image/avatar/1.webp',
    'image/avatar/2.webp',
    'image/avatar/3.webp',
    'image/avatar/4.webp',
    'image/avatar/5.webp',
    'image/avatar/7.webp',
    'image/avatar/8.webp',
    'image/avatar/9.webp',
  ];

  // آواتارهای بازشده کاربر
  static List<String> unlockedAvatars = [...defaultAvatars];

  // تم‌های رنگی بازشده کاربر
  static List<String> unlockedThemes = ['royal_purple'];

  // تم رنگی فعلی ناوبری و هدر
  static String currentTheme = 'royal_purple';

  // آیتم‌های ویژه خریداری‌شده
  static List<String> purchasedVipItems = [];

  // وضعیت تکمیل بازی‌های عربی هشتم (درس اول، دوم، سوم و چهارم)
  static bool arabic8Lesson1Part1Completed = false;
  static bool arabic8Lesson1Part2Completed = false;
  static bool arabic8Lesson1Part3Completed = false;
  static bool arabic8Lesson2Part1Completed = false;
  static bool arabic8Lesson2Part2Completed = false;
  static bool arabic8Lesson2Part3Completed = false;
  static bool arabic8Lesson3Part1Completed = false;
  static bool arabic8Lesson3Part2Completed = false;
  static bool arabic8Lesson3Part3Completed = false;
  static bool arabic8Lesson4Part1Completed = false;
  static bool arabic8Lesson4Part2Completed = false;
  static bool arabic8Lesson4Part3Completed = false;
  static bool arabic8Lesson5Part1Completed = false;
  static bool arabic8Lesson5Part2Completed = false;
  static bool arabic8Lesson5Part3Completed = false;
  static bool arabic8Lesson6Part1Completed = false;
  static bool arabic8Lesson6Part2Completed = false;
  static bool arabic8Lesson6Part3Completed = false;
  static bool arabic8Lesson7Part1Completed = false;
  static bool arabic8Lesson7Part2Completed = false;
  static bool arabic8Lesson7Part3Completed = false;
  static bool arabic8Lesson8Part1Completed = false;
  static bool arabic8Lesson8Part2Completed = false;
  static bool arabic8Lesson8Part3Completed = false;
  static bool arabic8Lesson9Part1Completed = false;
  static bool arabic8Lesson9Part2Completed = false;
  static bool arabic8Lesson9Part3Completed = false;
  static bool arabic8Lesson10Part1Completed = false;
  static bool arabic8Lesson10Part2Completed = false;
  static bool arabic8Lesson10Part3Completed = false;
  static bool arabic9Lesson1Part1Completed = false;
  static bool arabic9Lesson1Part2Completed = false;
  static bool arabic9Lesson1Part3Completed = false;
  static bool arabic9Lesson2Part1Completed = false;
  static bool arabic9Lesson2Part2Completed = false;
  static bool arabic9Lesson2Part3Completed = false;
  static bool arabic9Lesson3Part1Completed = false;
  static bool arabic9Lesson3Part2Completed = false;
  static bool arabic9Lesson3Part3Completed = false;
  static bool arabic9Lesson4Part1Completed = false;
  static bool arabic9Lesson4Part2Completed = false;
  static bool arabic9Lesson4Part3Completed = false;
  static bool arabic9Lesson5Part1Completed = false;
  static bool arabic9Lesson5Part2Completed = false;
  static bool arabic9Lesson5Part3Completed = false;
  static bool arabic9Lesson6Part1Completed = false;
  static bool arabic9Lesson6Part2Completed = false;
  static bool arabic9Lesson6Part3Completed = false;
  static bool arabic9Lesson7Part1Completed = false;
  static bool arabic9Lesson7Part2Completed = false;
  static bool arabic9Lesson7Part3Completed = false;
  static bool arabic9Lesson8Part1Completed = false;
  static bool arabic9Lesson8Part2Completed = false;
  static bool arabic9Lesson8Part3Completed = false;
  static bool arabic9Lesson9Part1Completed = false;
  static bool arabic9Lesson9Part2Completed = false;
  static bool arabic9Lesson9Part3Completed = false;
  static bool arabic9Lesson10Part1Completed = false;
  static bool arabic9Lesson10Part2Completed = false;
  static bool arabic9Lesson10Part3Completed = false;
  static bool quran7Lesson1Part1Completed = false;
  static bool quran7Lesson1Part2Completed = false;
  static bool quran7Lesson1Part3Completed = false;
  static bool quran7Lesson2Part1Completed = false;
  static bool quran7Lesson2Part2Completed = false;
  static bool quran7Lesson2Part3Completed = false;
  static bool quran7Lesson3Part1Completed = false;
  static bool quran7Lesson3Part2Completed = false;
  static bool quran7Lesson3Part3Completed = false;
  static bool quran7Lesson4Part1Completed = false;
  static bool quran7Lesson4Part2Completed = false;
  static bool quran7Lesson4Part3Completed = false;
  static bool quran7Lesson5Part1Completed = false;
  static bool quran7Lesson5Part2Completed = false;
  static bool quran7Lesson5Part3Completed = false;
  static bool quran7Lesson6Part1Completed = false;
  static bool quran7Lesson6Part2Completed = false;
  static bool quran7Lesson6Part3Completed = false;
  static bool quran7Lesson7Part1Completed = false;
  static bool quran7Lesson7Part2Completed = false;
  static bool quran7Lesson7Part3Completed = false;
  static bool quran7Lesson8Part1Completed = false;
  static bool quran7Lesson8Part2Completed = false;
  static bool quran7Lesson8Part3Completed = false;
  static bool quran7Lesson9Part1Completed = false;
  static bool quran7Lesson9Part2Completed = false;
  static bool quran7Lesson9Part3Completed = false;
  static bool quran7Lesson10Part1Completed = false;
  static bool quran7Lesson10Part2Completed = false;
  static bool quran7Lesson10Part3Completed = false;
  static bool quran7Lesson11Part1Completed = false;
  static bool quran7Lesson11Part2Completed = false;
  static bool quran7Lesson11Part3Completed = false;
  static bool quran7Lesson12Part1Completed = false;
  static bool quran7Lesson12Part2Completed = false;
  static bool quran7Lesson12Part3Completed = false;
  static bool quran8Lesson1Part1Completed = false;
  static bool quran8Lesson1Part2Completed = false;
  static bool quran8Lesson1Part3Completed = false;
  static bool quran8Lesson2Part1Completed = false;
  static bool quran8Lesson2Part2Completed = false;
  static bool quran8Lesson2Part3Completed = false;
  static bool quran8Lesson3Part1Completed = false;
  static bool quran8Lesson3Part2Completed = false;
  static bool quran8Lesson3Part3Completed = false;
  static bool quran8Lesson4Part1Completed = false;
  static bool quran8Lesson4Part2Completed = false;
  static bool quran8Lesson4Part3Completed = false;
  static bool quran8Lesson5Part1Completed = false;
  static bool quran8Lesson5Part2Completed = false;
  static bool quran8Lesson5Part3Completed = false;
  static bool quran8Lesson6Part1Completed = false;
  static bool quran8Lesson6Part2Completed = false;
  static bool quran8Lesson6Part3Completed = false;
  static bool quran8Lesson7Part1Completed = false;
  static bool quran8Lesson7Part2Completed = false;
  static bool quran8Lesson7Part3Completed = false;
  static bool quran8Lesson8Part1Completed = false;
  static bool quran8Lesson8Part2Completed = false;
  static bool quran8Lesson8Part3Completed = false;
  static bool quran8Lesson9Part1Completed = false;
  static bool quran8Lesson9Part2Completed = false;
  static bool quran8Lesson9Part3Completed = false;
  static bool quran8Lesson10Part1Completed = false;
  static bool quran8Lesson10Part2Completed = false;
  static bool quran8Lesson10Part3Completed = false;
  static bool quran8Lesson11Part1Completed = false;
  static bool quran8Lesson11Part2Completed = false;
  static bool quran8Lesson11Part3Completed = false;
  static bool quran8Lesson12Part1Completed = false;
  static bool quran8Lesson12Part2Completed = false;
  static bool quran8Lesson12Part3Completed = false;
  static bool quran9Lesson1Part2Completed = false;
  static bool quran9Lesson1Part3Completed = false;
  static bool quran9Lesson2Part1Completed = false;
  static bool quran9Lesson2Part2Completed = false;
  static bool quran9Lesson2Part3Completed = false;
  static bool quran9Lesson3Part1Completed = false;
  static bool quran9Lesson3Part2Completed = false;
  static bool quran9Lesson3Part3Completed = false;
  static bool quran9Lesson4Part1Completed = false;
  static bool quran9Lesson4Part2Completed = false;
  static bool quran9Lesson4Part3Completed = false;
  static bool quran9Lesson5Part1Completed = false;
  static bool quran9Lesson5Part2Completed = false;
  static bool quran9Lesson5Part3Completed = false;
  static bool quran9Lesson6Part1Completed = false;
  static bool quran9Lesson6Part2Completed = false;
  static bool quran9Lesson6Part3Completed = false;
  static bool quran9Lesson7Part1Completed = false;
  static bool quran9Lesson7Part2Completed = false;
  static bool quran9Lesson7Part3Completed = false;
  static bool quran9Lesson8Part1Completed = false;
  static bool quran9Lesson8Part2Completed = false;
  static bool quran9Lesson8Part3Completed = false;
  static bool quran9Lesson9Part1Completed = false;
  static bool quran9Lesson9Part2Completed = false;
  static bool quran9Lesson9Part3Completed = false;
  static bool quran9Lesson10Part1Completed = false;
  static bool quran9Lesson10Part2Completed = false;
  static bool quran9Lesson10Part3Completed = false;
  static bool quran9Lesson11Part1Completed = false;
  static bool quran9Lesson11Part2Completed = false;
  static bool quran9Lesson11Part3Completed = false;
  static bool zaban7Lesson1Part1Completed = false;
  static bool zaban7Lesson1Part2Completed = false;
  static bool zaban7Lesson1Part3Completed = false;
  static bool zaban7WelcomePart1Completed = false;
  static bool zaban7WelcomePart2Completed = false;
  static bool zaban7WelcomePart3Completed = false;
  static bool zaban7Lesson3Part1Completed = false;
  static bool zaban7Lesson3Part2Completed = false;
  static bool zaban7Lesson3Part3Completed = false;
  static bool zaban7Lesson4Part1Completed = false;
  static bool zaban7Lesson4Part2Completed = false;
  static bool zaban7Lesson4Part3Completed = false;
  static bool zaban7Lesson5Part1Completed = false;
  static bool zaban7Lesson5Part2Completed = false;
  static bool zaban7Lesson5Part3Completed = false;
  static bool zaban7Lesson6Part1Completed = false;
  static bool zaban7Lesson6Part2Completed = false;
  static bool zaban7Lesson6Part3Completed = false;
  static bool zaban7Lesson7Part1Completed = false;
  static bool zaban7Lesson7Part2Completed = false;
  static bool zaban7Lesson7Part3Completed = false;
  static bool zaban7Lesson8Part1Completed = false;
  static bool zaban7Lesson8Part2Completed = false;
  static bool zaban7Lesson8Part3Completed = false;
  static bool zaban8Lesson1Part1Completed = false;
  static bool zaban8Lesson1Part2Completed = false;
  static bool zaban8Lesson1Part3Completed = false;
  static bool zaban8Lesson2Part1Completed = false;
  static bool zaban8Lesson2Part2Completed = false;
  static bool zaban8Lesson2Part3Completed = false;
  static bool zaban8Lesson3Part1Completed = false;
  static bool zaban8Lesson3Part2Completed = false;
  static bool zaban8Lesson3Part3Completed = false;
  static bool zaban8Lesson4Part1Completed = false;
  static bool zaban8Lesson4Part2Completed = false;
  static bool zaban8Lesson4Part3Completed = false;
  static bool zaban8Lesson5Part1Completed = false;
  static bool zaban8Lesson5Part2Completed = false;
  static bool zaban8Lesson5Part3Completed = false;
  static bool zaban8Lesson6Part1Completed = false;
  static bool zaban8Lesson6Part2Completed = false;
  static bool zaban8Lesson6Part3Completed = false;
  static bool zaban8Lesson7Part1Completed = false;
  static bool zaban8Lesson7Part2Completed = false;
  static bool zaban8Lesson7Part3Completed = false;
  static bool zaban9Lesson1Part1Completed = false;
  static bool zaban9Lesson1Part2Completed = false;
  static bool zaban9Lesson1Part3Completed = false;
  static bool zaban9Lesson2Part1Completed = false;
  static bool zaban9Lesson2Part2Completed = false;
  static bool zaban9Lesson2Part3Completed = false;
  static bool zaban9Lesson3Part1Completed = false;
  static bool zaban9Lesson3Part2Completed = false;
  static bool zaban9Lesson3Part3Completed = false;
  static bool zaban9Lesson4Part1Completed = false;
  static bool zaban9Lesson4Part2Completed = false;
  static bool zaban9Lesson4Part3Completed = false;
  static bool zaban9Lesson5Part1Completed = false;
  static bool zaban9Lesson5Part2Completed = false;
  static bool zaban9Lesson5Part3Completed = false;
  static bool zaban9Lesson6Part1Completed = false;
  static bool zaban9Lesson6Part2Completed = false;
  static bool zaban9Lesson6Part3Completed = false;
  static bool farsi7Lesson1Part1Completed = false;
  static bool farsi7Lesson1Part2Completed = false;
  static bool farsi7Lesson1Part3Completed = false;
  static bool farsi7Lesson2Part1Completed = false;
  static bool farsi7Lesson2Part2Completed = false;
  static bool farsi7Lesson2Part3Completed = false;
  static bool farsi7Lesson3Part1Completed = false;
  static bool farsi7Lesson3Part2Completed = false;
  static bool farsi7Lesson3Part3Completed = false;
  static bool farsi7Lesson4Part1Completed = false;
  static bool farsi7Lesson4Part2Completed = false;
  static bool farsi7Lesson4Part3Completed = false;
  static bool farsi7Lesson5Part1Completed = false;
  static bool farsi7Lesson5Part2Completed = false;
  static bool farsi7Lesson5Part3Completed = false;
  static bool farsi7Lesson6Part1Completed = false;
  static bool farsi7Lesson6Part2Completed = false;
  static bool farsi7Lesson6Part3Completed = false;
  static bool farsi8Lesson1Part1Completed = false;
  static bool farsi8Lesson1Part2Completed = false;
  static bool farsi8Lesson1Part3Completed = false;
  static bool farsi8Lesson2Part1Completed = false;
  static bool farsi8Lesson2Part2Completed = false;
  static bool farsi8Lesson2Part3Completed = false;
  static bool farsi8Lesson3Part1Completed = false;
  static bool farsi8Lesson3Part2Completed = false;
  static bool farsi8Lesson3Part3Completed = false;
  static bool farsi8Lesson4Part1Completed = false;
  static bool farsi8Lesson4Part2Completed = false;
  static bool farsi8Lesson4Part3Completed = false;
  static bool farsi8Lesson5Part1Completed = false;
  static bool farsi8Lesson5Part2Completed = false;
  static bool farsi8Lesson5Part3Completed = false;
  static bool farsi8Lesson6Part1Completed = false;
  static bool farsi8Lesson6Part2Completed = false;
  static bool farsi8Lesson6Part3Completed = false;
  static bool farsi9Lesson1Part1Completed = false;
  static bool farsi9Lesson1Part2Completed = false;
  static bool farsi9Lesson1Part3Completed = false;
  static bool farsi9Lesson2Part1Completed = false;
  static bool farsi9Lesson2Part2Completed = false;
  static bool farsi9Lesson2Part3Completed = false;
  static bool farsi9Lesson3Part1Completed = false;
  static bool farsi9Lesson3Part2Completed = false;
  static bool farsi9Lesson3Part3Completed = false;
  static bool farsi9Lesson4Part1Completed = false;
  static bool farsi9Lesson4Part2Completed = false;
  static bool farsi9Lesson4Part3Completed = false;
  static bool farsi9Lesson5Part1Completed = false;
  static bool farsi9Lesson5Part2Completed = false;
  static bool farsi9Lesson5Part3Completed = false;
  static bool farsi9Lesson6Part1Completed = false;
  static bool farsi9Lesson6Part2Completed = false;
  static bool farsi9Lesson6Part3Completed = false;
  static bool payam7Lesson1Part1Completed = false;
  static bool payam7Lesson1Part2Completed = false;
  static bool payam7Lesson1Part3Completed = false;
  static bool payam7Lesson2Part1Completed = false;
  static bool payam7Lesson2Part2Completed = false;
  static bool payam7Lesson2Part3Completed = false;
  static bool payam7Lesson3Part1Completed = false;
  static bool payam7Lesson3Part2Completed = false;
  static bool payam7Lesson3Part3Completed = false;
  static bool payam7Lesson4Part1Completed = false;
  static bool payam7Lesson4Part2Completed = false;
  static bool payam7Lesson4Part3Completed = false;
  static bool payam7Lesson5Part1Completed = false;
  static bool payam7Lesson5Part2Completed = false;
  static bool payam7Lesson5Part3Completed = false;
  static bool payam8Lesson1Part1Completed = false;
  static bool payam8Lesson1Part2Completed = false;
  static bool payam8Lesson1Part3Completed = false;
  static bool payam8Lesson2Part1Completed = false;
  static bool payam8Lesson2Part2Completed = false;
  static bool payam8Lesson2Part3Completed = false;
  static bool payam8Lesson3Part1Completed = false;
  static bool payam8Lesson3Part2Completed = false;
  static bool payam8Lesson3Part3Completed = false;
  static bool payam8Lesson4Part1Completed = false;
  static bool payam8Lesson4Part2Completed = false;
  static bool payam8Lesson4Part3Completed = false;
  static bool payam8Lesson5Part1Completed = false;
  static bool payam8Lesson5Part2Completed = false;
  static bool payam8Lesson5Part3Completed = false;
  static bool payam8Lesson6Part1Completed = false;
  static bool payam8Lesson6Part2Completed = false;
  static bool payam8Lesson6Part3Completed = false;
  static bool payam9Lesson1Part1Completed = false;
  static bool payam9Lesson1Part2Completed = false;
  static bool payam9Lesson1Part3Completed = false;
  static bool payam9Lesson2Part1Completed = false;
  static bool payam9Lesson2Part2Completed = false;
  static bool payam9Lesson2Part3Completed = false;
  static bool payam9Lesson3Part1Completed = false;
  static bool payam9Lesson3Part2Completed = false;
  static bool payam9Lesson3Part3Completed = false;
  static bool payam9Lesson4Part1Completed = false;
  static bool payam9Lesson4Part2Completed = false;
  static bool payam9Lesson4Part3Completed = false;
  static bool payam9Lesson5Part1Completed = false;
  static bool payam9Lesson5Part2Completed = false;
  static bool payam9Lesson5Part3Completed = false;
  static bool motaleat7Lesson1Part1Completed = false;
  static bool motaleat7Lesson1Part2Completed = false;
  static bool motaleat7Lesson1Part3Completed = false;
  static bool motaleat7Lesson2Part1Completed = false;
  static bool motaleat7Lesson2Part2Completed = false;
  static bool motaleat7Lesson2Part3Completed = false;
  static bool motaleat7Lesson3Part1Completed = false;
  static bool motaleat7Lesson3Part2Completed = false;
  static bool motaleat7Lesson3Part3Completed = false;
  static bool motaleat7Lesson4Part1Completed = false;
  static bool motaleat7Lesson4Part2Completed = false;
  static bool motaleat7Lesson4Part3Completed = false;
  static bool motaleat7Lesson5Part1Completed = false;
  static bool motaleat7Lesson5Part2Completed = false;
  static bool motaleat7Lesson5Part3Completed = false;
  static bool motaleat7Lesson6Part1Completed = false;
  static bool motaleat7Lesson6Part2Completed = false;
  static bool motaleat7Lesson6Part3Completed = false;
  static bool motaleat7Lesson7Part1Completed = false;
  static bool motaleat7Lesson7Part2Completed = false;
  static bool motaleat7Lesson7Part3Completed = false;
  static bool motaleat7Lesson8Part1Completed = false;
  static bool motaleat7Lesson8Part2Completed = false;
  static bool motaleat7Lesson8Part3Completed = false;
  static bool motaleat7Lesson9Part1Completed = false;
  static bool motaleat7Lesson9Part2Completed = false;
  static bool motaleat7Lesson9Part3Completed = false;
  static bool motaleat7Lesson10Part1Completed = false;
  static bool motaleat7Lesson10Part2Completed = false;
  static bool motaleat7Lesson10Part3Completed = false;
  static bool motaleat7Lesson11Part1Completed = false;
  static bool motaleat7Lesson11Part2Completed = false;
  static bool motaleat7Lesson11Part3Completed = false;
  static bool motaleat7Lesson12Part1Completed = false;
  static bool motaleat7Lesson12Part2Completed = false;
  static bool motaleat7Lesson12Part3Completed = false;
  static bool motaleat8Lesson1Part1Completed = false;
  static bool motaleat8Lesson1Part2Completed = false;
  static bool motaleat8Lesson1Part3Completed = false;
  static bool motaleat8Lesson2Part1Completed = false;
  static bool motaleat8Lesson2Part2Completed = false;
  static bool motaleat8Lesson2Part3Completed = false;
  static bool motaleat8Lesson3Part1Completed = false;
  static bool motaleat8Lesson3Part2Completed = false;
  static bool motaleat8Lesson3Part3Completed = false;
  static bool motaleat8Lesson4Part1Completed = false;
  static bool motaleat8Lesson4Part2Completed = false;
  static bool motaleat8Lesson4Part3Completed = false;
  static bool motaleat8Lesson5Part1Completed = false;
  static bool motaleat8Lesson5Part2Completed = false;
  static bool motaleat8Lesson5Part3Completed = false;
  static bool motaleat8Lesson6Part1Completed = false;
  static bool motaleat8Lesson6Part2Completed = false;
  static bool motaleat8Lesson6Part3Completed = false;
  static bool motaleat8Lesson7Part1Completed = false;
  static bool motaleat8Lesson7Part2Completed = false;
  static bool motaleat8Lesson7Part3Completed = false;
  static bool motaleat8Lesson8Part1Completed = false;
  static bool motaleat8Lesson8Part2Completed = false;
  static bool motaleat8Lesson8Part3Completed = false;
  static bool motaleat8Lesson9Part1Completed = false;
  static bool motaleat8Lesson9Part2Completed = false;
  static bool motaleat8Lesson9Part3Completed = false;
  static bool motaleat8Lesson10Part1Completed = false;
  static bool motaleat8Lesson10Part2Completed = false;
  static bool motaleat8Lesson10Part3Completed = false;
  static bool motaleat8Lesson11Part1Completed = false;
  static bool motaleat8Lesson11Part2Completed = false;
  static bool motaleat8Lesson11Part3Completed = false;
  static bool motaleat8Lesson12Part1Completed = false;
  static bool motaleat8Lesson12Part2Completed = false;
  static bool motaleat8Lesson12Part3Completed = false;

  static bool motaleat9Lesson1Part1Completed = false;
  static bool motaleat9Lesson1Part2Completed = false;
  static bool motaleat9Lesson1Part3Completed = false;
  static bool motaleat9Lesson2Part1Completed = false;
  static bool motaleat9Lesson2Part2Completed = false;
  static bool motaleat9Lesson2Part3Completed = false;
  static bool motaleat9Lesson3Part1Completed = false;
  static bool motaleat9Lesson3Part2Completed = false;
  static bool motaleat9Lesson3Part3Completed = false;
  static bool motaleat9Lesson4Part1Completed = false;
  static bool motaleat9Lesson4Part2Completed = false;
  static bool motaleat9Lesson4Part3Completed = false;
  static bool motaleat9Lesson5Part1Completed = false;
  static bool motaleat9Lesson5Part2Completed = false;
  static bool motaleat9Lesson5Part3Completed = false;
  static bool motaleat9Lesson6Part1Completed = false;
  static bool motaleat9Lesson6Part2Completed = false;
  static bool motaleat9Lesson6Part3Completed = false;
  static bool motaleat9Lesson7Part1Completed = false;
  static bool motaleat9Lesson7Part2Completed = false;
  static bool motaleat9Lesson7Part3Completed = false;
  static bool motaleat9Lesson8Part1Completed = false;
  static bool motaleat9Lesson8Part2Completed = false;
  static bool motaleat9Lesson8Part3Completed = false;
  static bool motaleat9Lesson9Part1Completed = false;
  static bool motaleat9Lesson9Part2Completed = false;
  static bool motaleat9Lesson9Part3Completed = false;
  static bool motaleat9Lesson10Part1Completed = false;
  static bool motaleat9Lesson10Part2Completed = false;
  static bool motaleat9Lesson10Part3Completed = false;
  static bool motaleat9Lesson11Part1Completed = false;
  static bool motaleat9Lesson11Part2Completed = false;
  static bool motaleat9Lesson11Part3Completed = false;
  static bool motaleat9Lesson12Part1Completed = false;
  static bool motaleat9Lesson12Part2Completed = false;
  static bool motaleat9Lesson12Part3Completed = false;

  static bool olom7Lesson1Part1Completed = false;
  static bool olom7Lesson1Part2Completed = false;
  static bool olom7Lesson1Part3Completed = false;
  static bool olom7Lesson2Part1Completed = false;
  static bool olom7Lesson2Part2Completed = false;
  static bool olom7Lesson2Part3Completed = false;
  static bool olom7Lesson3Part1Completed = false;
  static bool olom7Lesson3Part2Completed = false;
  static bool olom7Lesson3Part3Completed = false;
  static bool olom7Lesson4Part1Completed = false;
  static bool olom7Lesson4Part2Completed = false;
  static bool olom7Lesson4Part3Completed = false;
  static bool olom7Lesson5Part1Completed = false;
  static bool olom7Lesson5Part2Completed = false;
  static bool olom7Lesson5Part3Completed = false;
  static bool olom7Lesson6Part1Completed = false;
  static bool olom7Lesson6Part2Completed = false;
  static bool olom7Lesson6Part3Completed = false;
  static bool olom7Lesson7Part1Completed = false;
  static bool olom7Lesson7Part2Completed = false;
  static bool olom7Lesson7Part3Completed = false;
  static bool olom7Lesson8Part1Completed = false;
  static bool olom7Lesson8Part2Completed = false;
  static bool olom7Lesson8Part3Completed = false;
  static bool olom7Lesson9Part1Completed = false;
  static bool olom7Lesson9Part2Completed = false;
  static bool olom7Lesson9Part3Completed = false;
  static bool olom7Lesson10Part1Completed = false;
  static bool olom7Lesson10Part2Completed = false;
  static bool olom7Lesson10Part3Completed = false;
  static bool olom7Lesson11Part1Completed = false;
  static bool olom7Lesson11Part2Completed = false;
  static bool olom7Lesson11Part3Completed = false;
  static bool olom7Lesson12Part1Completed = false;
  static bool olom7Lesson12Part2Completed = false;
  static bool olom7Lesson12Part3Completed = false;
  static bool olom7Lesson13Part1Completed = false;
  static bool olom7Lesson13Part2Completed = false;
  static bool olom7Lesson13Part3Completed = false;
  static bool olom7Lesson14Part1Completed = false;
  static bool olom7Lesson14Part2Completed = false;
  static bool olom7Lesson14Part3Completed = false;
  static bool olom7Lesson15Part1Completed = false;
  static bool olom7Lesson15Part2Completed = false;
  static bool olom7Lesson15Part3Completed = false;
  static bool olom8Lesson1Part1Completed = false;
  static bool olom8Lesson1Part2Completed = false;
  static bool olom8Lesson1Part3Completed = false;
  static bool olom8Lesson2Part1Completed = false;
  static bool olom8Lesson2Part2Completed = false;
  static bool olom8Lesson2Part3Completed = false;
  static bool olom8Lesson3Part1Completed = false;
  static bool olom8Lesson3Part2Completed = false;
  static bool olom8Lesson3Part3Completed = false;
  static bool olom8Lesson4Part1Completed = false;
  static bool olom8Lesson4Part2Completed = false;
  static bool olom8Lesson4Part3Completed = false;
  static bool olom8Lesson5Part1Completed = false;
  static bool olom8Lesson5Part2Completed = false;
  static bool olom8Lesson5Part3Completed = false;
  static bool olom8Lesson6Part1Completed = false;
  static bool olom8Lesson6Part2Completed = false;
  static bool olom8Lesson6Part3Completed = false;
  static bool olom8Lesson7Part1Completed = false;
  static bool olom8Lesson7Part2Completed = false;
  static bool olom8Lesson7Part3Completed = false;
  static bool olom8Lesson8Part1Completed = false;
  static bool olom8Lesson8Part2Completed = false;
  static bool olom8Lesson8Part3Completed = false;
  static bool olom8Lesson9Part1Completed = false;
  static bool olom8Lesson9Part2Completed = false;
  static bool olom8Lesson9Part3Completed = false;
  static bool olom8Lesson10Part1Completed = false;
  static bool olom8Lesson10Part2Completed = false;
  static bool olom8Lesson10Part3Completed = false;
  static bool olom8Lesson11Part1Completed = false;
  static bool olom8Lesson11Part2Completed = false;
  static bool olom8Lesson11Part3Completed = false;
  static bool olom8Lesson12Part1Completed = false;
  static bool olom8Lesson12Part2Completed = false;
  static bool olom8Lesson12Part3Completed = false;
  static bool olom8Lesson13Part1Completed = false;
  static bool olom8Lesson13Part2Completed = false;
  static bool olom8Lesson13Part3Completed = false;
  static bool olom8Lesson14Part1Completed = false;
  static bool olom8Lesson14Part2Completed = false;
  static bool olom8Lesson14Part3Completed = false;
  static bool olom8Lesson15Part1Completed = false;
  static bool olom8Lesson15Part2Completed = false;
  static bool olom8Lesson15Part3Completed = false;
  static bool olom9Lesson1Part1Completed = false;
  static bool olom9Lesson1Part2Completed = false;
  static bool olom9Lesson1Part3Completed = false;
  static bool olom9Lesson2Part1Completed = false;
  static bool olom9Lesson2Part2Completed = false;
  static bool olom9Lesson2Part3Completed = false;
  static bool olom9Lesson3Part1Completed = false;
  static bool olom9Lesson3Part2Completed = false;
  static bool olom9Lesson3Part3Completed = false;
  static bool olom9Lesson4Part1Completed = false;
  static bool olom9Lesson4Part2Completed = false;
  static bool olom9Lesson4Part3Completed = false;
  static bool olom9Lesson5Part1Completed = false;
  static bool olom9Lesson5Part2Completed = false;
  static bool olom9Lesson5Part3Completed = false;
  static bool olom9Lesson6Part1Completed = false;
  static bool olom9Lesson6Part2Completed = false;
  static bool olom9Lesson6Part3Completed = false;
  static bool olom9Lesson7Part1Completed = false;
  static bool olom9Lesson7Part2Completed = false;
  static bool olom9Lesson7Part3Completed = false;
  static bool olom9Lesson8Part1Completed = false;
  static bool olom9Lesson8Part2Completed = false;
  static bool olom9Lesson8Part3Completed = false;
  static bool olom9Lesson9Part1Completed = false;
  static bool olom9Lesson9Part2Completed = false;
  static bool olom9Lesson9Part3Completed = false;
  static bool olom9Lesson10Part1Completed = false;
  static bool olom9Lesson10Part2Completed = false;
  static bool olom9Lesson10Part3Completed = false;
  static bool olom9Lesson11Part1Completed = false;
  static bool olom9Lesson11Part2Completed = false;
  static bool olom9Lesson11Part3Completed = false;
  static bool olom9Lesson12Part1Completed = false;
  static bool olom9Lesson12Part2Completed = false;
  static bool olom9Lesson12Part3Completed = false;
  static bool olom9Lesson13Part1Completed = false;
  static bool olom9Lesson13Part2Completed = false;
  static bool olom9Lesson13Part3Completed = false;
  static bool olom9Lesson14Part1Completed = false;
  static bool olom9Lesson14Part2Completed = false;
  static bool olom9Lesson14Part3Completed = false;
  static bool olom9Lesson15Part1Completed = false;
  static bool olom9Lesson15Part2Completed = false;
  static bool olom9Lesson15Part3Completed = false;



  // گترهای واژگان عربی هشتم درس اول
  static List<Map<String, String>> get arabic8Lesson1Part1Vocab => [
    {'word': 'بَسيط', 'emoji': '🔹', 'translation': 'ساده'},
    {'word': 'اَلثَّامِن', 'emoji': '8️⃣', 'translation': 'هشتم'},
    {'word': 'حَافِلَة', 'emoji': '🚌', 'translation': 'اتوبوس'},
    {'word': 'حَلْوَانِيّ', 'emoji': '🧁', 'translation': 'شیرینی‌پروش'},
    {'word': 'رُزّ', 'emoji': '🍚', 'translation': 'برنج'},
    {'word': 'مَوْقِف', 'emoji': '🚏', 'translation': 'ایستگاه'},
    {'word': 'مُوَظَّف', 'emoji': '👨‍💼', 'translation': 'کارمند'},
    {'word': 'نَجَحَ', 'emoji': '🏆', 'translation': 'موفق شد'},
  ];

  static List<Map<String, String>> get arabic8Lesson1Part2Vocab => [
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

  static List<Map<String, String>> get arabic8Lesson1Part3Vocab => [
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

  // گترهای واژگان عربی هشتم درس دوم
  static List<Map<String, String>> get arabic8Lesson2Part1Vocab => [
    {'word': 'تَعَلُّم', 'emoji': '🧠', 'translation': 'یاد گرفتن'},
    {'word': 'قَدَرَ', 'emoji': '💪', 'translation': 'توانست'},
    {'word': 'جَعَلَ', 'emoji': '📌', 'translation': 'قرار داد'},
    {'word': 'كَأَنَّ', 'emoji': '💭', 'translation': 'گویا، انگار'},
    {'word': 'حَدَّاد', 'emoji': '⚒️', 'translation': 'آهنگر'},
    {'word': 'كَتَمَ', 'emoji': '🥷', 'translation': 'پنهان کرد'},
    {'word': 'اَلْخَامِس', 'emoji': '5️⃣', 'translation': 'پنجم'},
    {'word': 'سَهْل', 'emoji': '🪶', 'translation': 'آسان'},
  ];

  static List<Map<String, String>> get arabic8Lesson2Part2Vocab => [
    {'word': 'تعلم', 'emoji': '🧠', 'translation': 'یاد گرفتن'},
    {'word': 'قدر', 'emoji': '💪', 'translation': 'توانست'},
    {'word': 'جعل', 'emoji': '📌', 'translation': 'قرار داد'},
    {'word': 'كأن', 'emoji': '💭', 'translation': 'گویا، انگار'},
    {'word': 'حداد', 'emoji': '⚒️', 'translation': 'آهنگر'},
    {'word': 'کتم', 'emoji': '🥷', 'translation': 'پنهان کرد'},
    {'word': 'الخامس', 'emoji': '5️⃣', 'translation': 'پنجم'},
    {'word': 'کل', 'emoji': '👥', 'translation': 'همه، هر'},
    {'word': 'خباز', 'emoji': '🥖', 'translation': 'نانوا'},
    {'word': 'سهل', 'emoji': '🪶', 'translation': 'آسان'},
    {'word': 'مبین', 'emoji': '🔍', 'translation': 'آشکار، آشکارکننده'},
    {'word': 'طعام', 'emoji': '🍲', 'translation': 'غذا'},
    {'word': 'عالم', 'emoji': '🌍', 'translation': 'جهان'},
    {'word': 'منظمة', 'emoji': '🏛️', 'translation': 'سازمان'},
  ];

  static List<Map<String, String>> get arabic8Lesson2Part3Vocab => [
    {'ar': 'كُلُّ الرِّجَالِ', 'fa': 'همۀ مردان', 'emoji': '👨‍👨‍👦'},
    {'ar': 'خَبَّاز', 'fa': 'نانوا', 'emoji': '🥖'},
    {'ar': 'كُلُّ رَجُلٍ', 'fa': 'هر مردی', 'emoji': '👤'},
    {'ar': 'مُبِين', 'fa': 'آشکار، آشکارکننده', 'emoji': '🔍'},
    {'ar': 'مَمْزُوج', 'fa': 'آمیخته', 'emoji': '🧪'},
    {'ar': 'طَعَام', 'fa': 'غذا (جمع: أَطْعِمَة)', 'emoji': '🍲'},
    {'ar': 'أَطْعِمَة', 'fa': 'غذاها (مفرد: طَعَام)', 'emoji': '🍽️'},
    {'ar': 'عَالَم', 'fa': 'جهان', 'emoji': '🌍'},
    {'ar': 'مُنَظَّمَة', 'fa': 'سازمان', 'emoji': '🏛️'},
    {'ar': 'مُنَظَّمَةُ الْأُمَمِ الْمُتَّحِدَةِ', 'fa': 'سازمان ملل متّحد', 'emoji': '🇺🇳'},
  ];

  // گترهای واژگان عربی هشتم درس سوم
  static List<Map<String, String>> get arabic8Lesson3Part1Vocab => [
    {'word': 'رِيَاضِيّ', 'emoji': '🏋️‍♂️', 'translation': 'ورزشکار'},
    {'word': 'صَارَ', 'emoji': '☑', 'translation': 'شد'},
    {'word': 'عَيْن', 'emoji': '👁️', 'translation': 'چشم'},
    {'word': 'فَحَصَ', 'emoji': '🩺', 'translation': 'معاینه کرد'},
    {'word': 'مَرْضَى', 'emoji': '🏥', 'translation': 'بیماران'},
    {'word': 'تَقَدُّم', 'emoji': '📈', 'translation': 'پیشرفت'},
    {'word': 'مُسْتَقْبَل', 'emoji': '🔮', 'translation': 'آینده'},
    {'word': 'الآخرين', 'emoji': '👥', 'translation': 'دیگران'},
  ];

  static List<Map<String, String>> get arabic8Lesson3Part2Vocab => [
    {'word': 'رياضة', 'emoji': '⚽', 'translation': 'ورزش'},
    {'word': 'احب', 'emoji': '❤️', 'translation': 'دوست داشت'},
    {'word': 'طب العيون', 'emoji': '👁️‍🗨️', 'translation': 'چشم‌پزشکی'},
    {'word': 'اصحاب المهن', 'emoji': '🧑‍💼', 'translation': 'صاحبان شغل‌ها'},
    {'word': 'عن', 'emoji': '🗨️', 'translation': 'درباره، از'},
    {'word': 'انصحك ان تذهب', 'emoji': '🗣️', 'translation': 'تو را نصیحت می‌کنم که بروی'},
  ];

  static List<Map<String, String>> get arabic8Lesson3Part3Vocab => [
    {'ar': 'بِلَاد', 'fa': 'کشور، شهرها', 'emoji': '🌍'},
    {'ar': 'بَيْع', 'fa': 'فروش', 'emoji': '🛒'},
    {'ar': 'مِهْنَة', 'fa': 'شغل', 'emoji': '💼'},
    {'ar': 'خُبْز', 'fa': 'نان', 'emoji': '🍞'},
    {'ar': 'يَحْتَاجُ', 'fa': 'نیاز دارد', 'emoji': '🤲'},
  ];

  // گترهای واژگان عربی هشتم درس چهارم
  static List<Map<String, String>> get arabic8Lesson4Part1Vocab => [
    {'word': 'فِضَّة', 'emoji': '🥈', 'translation': 'نقره'},
    {'word': 'اِبن', 'emoji': '👦', 'translation': 'پسر، فرزند'},
    {'word': 'إنَّما', 'emoji': '❗', 'translation': 'فقط، جز این نیست که'},
    {'word': 'فِعْل', 'emoji': '⚙️', 'translation': 'کار، انجام دادن'},
    {'word': 'جَدَل', 'emoji': '🗣️', 'translation': 'جرّ و بحث'},
    {'word': 'قَادِم', 'emoji': '🔮', 'translation': 'آینده'},
    {'word': 'خَطَايَا', 'emoji': '😈', 'translation': 'گناهان، خطاها'},
    {'word': 'قَوْل', 'emoji': '💬', 'translation': 'گفتار'},
  ];

  static List<Map<String, String>> get arabic8Lesson4Part2Vocab => [
    {'word': 'ابن آدم', 'emoji': '👤', 'translation': 'آدمیزاد'},
    {'word': 'شاهد', 'emoji': '👀', 'translation': 'دید'},
    {'word': 'يشاهد', 'emoji': '👀', 'translation': 'می‌بیند'},
    {'word': 'كذب', 'emoji': '🤥', 'translation': 'دروغ گفت'},
    {'word': 'شكر', 'emoji': '🙏', 'translation': 'تشکّر کرد'},
    {'word': 'صدق', 'emoji': '👼', 'translation': 'راست گفت'},
    {'word': 'عاش', 'emoji': '🏡', 'translation': 'زندگی کرد'},
  ];

  static List<Map<String, String>> get arabic8Lesson4Part3Vocab => [
    {'ar': 'نَفْع', 'fa': 'سود رساند', 'emoji': '🤌'},
    {'ar': 'غَرِقَ', 'fa': 'غرق شد', 'emoji': '🌊'},
    {'ar': 'فَرَس', 'fa': 'اسب', 'emoji': '🐎'},
    {'ar': 'مُخْتَبَر', 'fa': 'آزمایشگاه', 'emoji': '🧪'},
  ];

  // گترهای واژگان عربی هشتم درس پنجم
  static List<Map<String, String>> get arabic8Lesson5Part1Vocab => [
    {'word': 'جاءَ', 'emoji': '🚶‍♂️', 'translation': 'آمد'},
    {'word': 'بَصَر', 'emoji': '👁️', 'translation': 'دیدگان'},
    {'word': 'حَبِيب', 'emoji': '❤️', 'translation': 'دوست'},
    {'word': 'أَتَىٰ', 'emoji': '🏃‍♂️', 'translation': 'می‌آید'},
    {'word': 'إِحْدَىٰ', 'emoji': '👤', 'translation': 'یکی از'},
    {'word': 'حَرَسَ | يَحْرُسُ', 'emoji': '🛡️', 'translation': 'نگه‌داری کرد | نگه‌داری می‌کند'},
    {'word': 'أَعْلَم', 'emoji': '🧠', 'translation': 'داناترین، داناتر'},
    {'word': 'دمع', 'emoji': '💧', 'translation': 'اشک'},
  ];

  static List<Map<String, String>> get arabic8Lesson5Part2Vocab => [
    {'word': 'نفس المكان', 'emoji': '📍', 'translation': 'همان جا'},
    {'word': 'نفسي', 'emoji': '🙋‍♂️', 'translation': 'خودم'},
    {'word': 'خزائن', 'emoji': '💎', 'translation': 'گنجینه‌ها'},
    {'word': 'دمع', 'emoji': '💧', 'translation': 'اشک'},
    {'word': 'بالتأكيد', 'emoji': '✔️', 'translation': 'البته'},
    {'word': 'ساحة', 'emoji': '🏟️', 'translation': 'حیاط، میدان'},
  ];

  static List<Map<String, String>> get arabic8Lesson5Part3Vocab => [
    {'ar': 'بَعْدَمَا', 'fa': 'پس از این که', 'emoji': '⏱️'},
    {'ar': 'شَرِبَ', 'fa': 'نوشید', 'emoji': '🥤'},
    {'ar': 'عُصْفُور', 'fa': 'گنجشک', 'emoji': '🐦'},
    {'ar': 'بِكُلِّ سُرُور', 'fa': 'با کمال میل', 'emoji': '🤝'},
    {'ar': 'مِصْبَاح', 'fa': 'چراغ', 'emoji': '🔦'},
    {'ar': 'اَلثَّالِث', 'fa': 'سوم، سومین', 'emoji': '🥉'},
    {'ar': 'جَار', 'fa': 'همسايه', 'emoji': '🏠'},
  ];

  // گترهای واژگان عربی هشتم درس ششم
  static List<Map<String, String>> get arabic8Lesson6Part1Vocab => [
    {'word': 'أَرْبَعُونَ، أَرْبَعِينَ', 'emoji': '4️⃣0️⃣', 'translation': 'چهل'},
    {'word': 'كُرَةُ الْمِنْضَدَةِ', 'emoji': '🏓', 'translation': 'تنیس روی میز'},
    {'word': 'أَمَرَ', 'emoji': '🫵', 'translation': 'فرمان داد'},
    {'word': 'لِهٰذِهِ الْأُسْرَةِ', 'emoji': '👨‍👩‍👧‍👦', 'translation': 'دارد، برای (این خانواده دارد)'},
    {'word': 'اَلْأُولَىٰ', 'emoji': '🥇', 'translation': 'یکم، نخستین (مؤنث اول)'},
    {'word': 'حُبُوب مُسَکِّنَة', 'emoji': '💊', 'translation': 'قرص‌های مسکن'},
    {'word': 'لَا', 'emoji': '🚫', 'translation': 'حرف نفی مضارع'},
    {'word': 'خَاتَم', 'emoji': '💍', 'translation': 'انگشتر'},
  ];

  static List<Map<String, String>> get arabic8Lesson6Part2Vocab => [
    {'word': 'ما بك', 'emoji': '🤔', 'translation': 'تو را چه می‌شود؟'},
    {'word': 'سافر', 'emoji': '✈️', 'translation': 'سفر کرد'},
    {'word': 'يسافر', 'emoji': '✈️', 'translation': 'سفر می‌کند'},
    {'word': 'شراب', 'emoji': '🧃', 'translation': 'شربت، نوشیدنی'},
    {'word': 'صداع', 'emoji': '🤕', 'translation': 'سردرد'},
    {'word': 'مستوصف', 'emoji': '🏥', 'translation': 'درمانگاه'},
    {'word': 'طائرة', 'emoji': '✈️', 'translation': 'هواپیما'},
    {'word': 'قافلة', 'emoji': '🐪', 'translation': 'کاروان'},
  ];

  static List<Map<String, String>> get arabic8Lesson6Part3Vocab => [
    {'ar': 'مَرَضُ السُّكَّرِ', 'fa': 'بیماری قند', 'emoji': '🩸🍬'},
    {'ar': 'مَسَاء', 'fa': 'شب، بعد از ظهر', 'emoji': '🌆'},
    {'ar': 'ضَغْطُ الدَّمِ', 'fa': 'فشار خون', 'emoji': '🩸📈'},
    {'ar': 'مَعاً', 'fa': 'با هم', 'emoji': '👥'},
    {'ar': 'وَصْفَة', 'fa': 'نسخه', 'emoji': '📝'},
    {'ar': 'يَخْفَىٰ', 'fa': 'پنهان می‌ماند', 'emoji': '🥷'},
  ];

  // گترهای واژگان عربی هشتم درس هفتم
  static List<Map<String, String>> get arabic8Lesson7Part1Vocab => [
    {'word': 'عِنْدَمَا', 'emoji': '⏳', 'translation': 'وقتی که'},
    {'word': 'آبَاء', 'emoji': '👨‍👧‍👦', 'translation': 'پدران'},
    {'word': 'إِضَاعَة', 'emoji': '📉', 'translation': 'تباه کردن'},
    {'word': 'غَابَة', 'emoji': '🌲', 'translation': 'جنگل'},
    {'word': 'أَلَا', 'emoji': '🗣️', 'translation': 'هان، آگاه باش'},
    {'word': 'جَلَبَ', 'emoji': '🫴', 'translation': 'می‌آورد'},
    {'word': 'فَرْخ', 'emoji': '🐣', 'translation': 'جوجه'},
    {'word': 'حَطَب', 'emoji': '🪵', 'translation': 'هیزم'},
  ];

  static List<Map<String, String>> get arabic8Lesson7Part2Vocab => [
    {'word': 'كما', 'emoji': '🟰', 'translation': 'همان طور که'},
    {'word': 'غزال', 'emoji': '🦌', 'translation': 'آهو'},
    {'word': 'حوائج', 'emoji': '🤲', 'translation': 'نیازها'},
    {'word': 'فرح', 'emoji': '😀', 'translation': 'شادی'},
    {'word': 'متى', 'emoji': '⏰', 'translation': 'کی؟'},
    {'word': 'نصر', 'emoji': '🤝', 'translation': 'یاری'},
    {'word': 'ذئاب', 'emoji': '🐺', 'translation': 'گرگ‌ها'},
    {'word': 'الرابع', 'emoji': '4️⃣', 'translation': 'چهارم'},
    {'word': 'هجم', 'emoji': '⚔️', 'translation': 'حمله کرد'},
  ];

  static List<Map<String, String>> get arabic8Lesson7Part3Vocab => [
    {'ar': 'حَمَامَة', 'fa': 'کبوتر', 'emoji': '🕊️'},
    {'ar': 'ضَحِكَ', 'fa': 'خندید', 'emoji': '😂'},
    {'ar': 'حَطَب', 'fa': 'هیزم', 'emoji': '🪵'},
    {'ar': 'غَابَة', 'fa': 'جنگل', 'emoji': '🌲'},
    {'ar': 'يَئِسَ', 'fa': 'ناامید شد', 'emoji': '😞'},
    {'ar': 'ذِئْب', 'fa': 'گرگ', 'emoji': '🐺'},
    {'ar': 'طَائِر', 'fa': 'پرنده', 'emoji': '🦜'},
  ];

  // گترهای واژگان عربی هشتم درس هشتم
  static List<Map<String, String>> get arabic8Lesson8Part1Vocab => [
    {'word': 'عُشّ', 'emoji': '🪺', 'translation': 'لانه'},
    {'word': 'أَقْرِبَاء', 'emoji': '👨‍👩‍👧‍👦', 'translation': 'خویشاوندان'},
    {'word': 'تَسْأَلُ فِرَاخَهَا', 'emoji': '❓', 'translation': 'از جوجه‌هایش می‌پرسد'},
    {'word': 'قَمْح', 'emoji': '🌾', 'translation': 'گندم'},
    {'word': 'حَدَثَ', 'emoji': '💥', 'translation': 'اتفاق افتاد'},
    {'word': 'كَوْكَب', 'emoji': '⭐', 'translation': 'ستاره'},
    {'word': 'حَضَرَ', 'emoji': '🙋‍♂️', 'translation': 'حاضر شد'},
    {'word': 'مَائِدَة', 'emoji': '🍽️', 'translation': 'سفره‌ی غذا'},
  ];

  static List<Map<String, String>> get arabic8Lesson8Part2Vocab => [
    {'word': 'ساجد', 'emoji': '🙇‍♂️', 'translation': 'سجده‌کننده'},
    {'word': 'يعتمد', 'emoji': '🧠', 'translation': 'اعتماد می‌کند'},
    {'word': 'عش', 'emoji': '🪺', 'translation': 'لانه'},
    {'word': 'قمح', 'emoji': '🌾', 'translation': 'گندم'},
    {'word': 'حدث', 'emoji': '💥', 'translation': 'اتفاق افتاد'},
    {'word': 'كوكب', 'emoji': '⭐', 'translation': 'ستاره'},
    {'word': 'مائدة', 'emoji': '🍽️', 'translation': 'سفره‌ی غذا'},
    {'word': 'عزة', 'emoji': '✨', 'translation': 'ارجمندی'},
  ];

  static List<Map<String, String>> get arabic8Lesson8Part3Vocab => [
    {'ar': 'سَاجِد', 'fa': 'سجده‌کننده', 'emoji': '🧎‍♂️'},
    {'ar': 'يَعْتَمِدُ', 'fa': 'اعتماد می‌کند، تکیه می‌کند', 'emoji': '🤝'},
    {'ar': 'عُشّ', 'fa': 'لانه', 'emoji': '🪺'},
    {'ar': 'قَمْح', 'fa': 'گندم', 'emoji': '🌾'},
    {'ar': 'حَدَثَ', 'fa': 'اتفاق افتاد', 'emoji': '💥'},
    {'ar': 'كَوْكَب', 'fa': 'ستاره', 'emoji': '⭐'},
    {'ar': 'مَائِدَة', 'fa': 'سفره‌ی غذا', 'emoji': '🍽️'},
  ];

  // گترهای واژگان عربی هشتم درس نهم
  static List<Map<String, String>> get arabic8Lesson9Part1Vocab => [
    {'word': 'أَزْهَار', 'emoji': '🌸', 'translation': 'گل‌ها'},
    {'word': 'عَشَاء', 'emoji': '🌙', 'translation': 'شام'},
    {'word': 'غَدَاء', 'emoji': '☀️', 'translation': 'ناهار'},
    {'word': 'غَفَرَ', 'emoji': '🤲', 'translation': 'آمرزید'},
    {'word': 'أَسْنَان', 'emoji': '🦷', 'translation': 'دندان‌ها'},
    {'word': 'الَّذِينَ', 'emoji': '👥', 'translation': 'کسانی که'},
    {'word': 'فُرْشَاة', 'emoji': '🪥', 'translation': 'مسواک'},
    {'word': 'فِضِّي', 'emoji': '🥈', 'translation': 'نقره‌ای'},
  ];

  static List<Map<String, String>> get arabic8Lesson9Part2Vocab => [
    {'word': 'أولياء', 'emoji': '🤝', 'translation': 'یاران، اولیاء'},
    {'word': 'بما', 'emoji': '❓', 'translation': 'با چه چیزی؟'},
    {'word': 'حسنى', 'emoji': '✨', 'translation': 'نیکوتر'},
    {'word': 'محافظة', 'emoji': '🗺️', 'translation': 'استان'},
    {'word': 'خوف', 'emoji': '😨', 'translation': 'ترس، ترسیدن'},
    {'word': 'مسموح', 'emoji': '✅', 'translation': 'مجاز'},
    {'word': 'مطعم', 'emoji': '🍽️', 'translation': 'غذاخوری، رستوران'},
    {'word': 'ذنب', 'emoji': '👹', 'translation': 'گناه'},
  ];

  static List<Map<String, String>> get arabic8Lesson9Part3Vocab => [
    {'ar': 'السَّابع، السَّابِعَة', 'fa': 'هفتم', 'emoji': '7️⃣'},
    {'ar': 'السَّادس، السَّادِسَة', 'fa': 'ششم', 'emoji': '6️⃣'},
    {'ar': 'مَعْجُونُ أَسْنَان', 'fa': 'خمیر دندان', 'emoji': '🧴'},
    {'ar': 'مَلْعَب', 'fa': 'زمین بازی، ورزشگاه', 'emoji': '🏟️'},
    {'ar': 'شَاي', 'fa': 'چای', 'emoji': '🍵'},
    {'ar': 'مِنْشَفَة', 'fa': 'حوله', 'emoji': '🧻'},
    {'ar': 'شَلَّال', 'fa': 'آبشار', 'emoji': '🌊'},
    {'ar': 'زَهْر', 'fa': 'گل', 'emoji': '🌸'},
    {'ar': 'سِنّ', 'fa': 'دندان', 'emoji': '🦷'},
  ];

  // گترهای واژگان عربی هشتم درس دهم
  static List<Map<String, String>> get arabic8Lesson10Part1Vocab => [];

  static List<Map<String, String>> get arabic8Lesson10Part2Vocab => [
    {'word': 'التاسع', 'emoji': '9️⃣', 'translation': 'نهم'},
    {'word': 'الحادي عشر', 'emoji': '1️⃣1️⃣', 'translation': 'یازدهم'},
    {'word': 'الثاني عشر', 'emoji': '1️⃣2️⃣', 'translation': 'دوازدهم'},
    {'word': 'العاشر', 'emoji': '🔟', 'translation': 'دهم'},
    {'word': 'تمر', 'emoji': '🌴', 'translation': 'خرما'},
  ];

  static List<Map<String, String>> get arabic8Lesson10Part3Vocab => [
    {'ar': 'التَّاسِع، التَّاسِعَة', 'fa': 'نهم', 'emoji': '9️⃣'},
    {'ar': 'الحَادِي عَشَرَ، الحَادِيَة عَشْرَة', 'fa': 'یازدهم', 'emoji': '1️⃣1️⃣'},
    {'ar': 'الثَّانِي عَشَرَ، الثَّانِيَة عَشْرَة', 'fa': 'دوازدهم', 'emoji': '1️⃣2️⃣'},
    {'ar': 'العَاشِر، العَاشِرَة', 'fa': 'دهم', 'emoji': '🔟'},
    {'ar': 'تَمْر', 'fa': 'خرما', 'emoji': '🌴'},
  ];

  // گترهای واژگان عربی نهم درس اول
  static List<Map<String, String>> get arabic9Lesson1Part1Vocab => [
    {'word': 'آمِن', 'emoji': '🛡️', 'translation': 'ایمن'},
    {'word': 'اَلْعُبورُ الْآمِنُ', 'emoji': '🚸', 'translation': 'عبور و مرور ایمن'},
    {'word': 'سَأَلَ', 'emoji': '❓', 'translation': 'پرسید'},
    {'word': 'ابْتَدَأَ', 'emoji': '🎬', 'translation': 'آغاز کرد، شروع کرد'},
    {'word': 'صَعْب', 'emoji': '🧗‍♂️', 'translation': 'سخت'},
    {'word': 'عَام', 'emoji': '📅', 'translation': 'سال'},
    {'word': 'دَرَّسَ', 'emoji': '👨‍🏫', 'translation': 'درس داد'},
    {'word': 'تَخَرَّجَ', 'emoji': '🎓', 'translation': 'فارغ‌التحصیل شد'},
  ];

  static List<Map<String, String>> get arabic9Lesson1Part2Vocab => [
    {'word': 'ممرالمشاة', 'emoji': '🚶‍♂️', 'translation': 'گذرگاه پیاده'},
    {'word': 'تلمیذ', 'emoji': '🧑‍🎓', 'translation': 'دانش‌آموز'},
    {'word': 'دراسة', 'emoji': '📚', 'translation': 'تحصیل، درس خواندن'},
    {'word': 'رصيف', 'emoji': '🛣️', 'translation': 'پیاده‌رو'},
  ];

  static List<Map<String, String>> get arabic9Lesson1Part3Vocab => [
    {'ar': 'زَادَ', 'fa': 'افزایش یافت، زیاد شد', 'emoji': '📈'},
    {'ar': 'منطقة تعليم المرور', 'fa': 'پارک آموزش ترافیک', 'emoji': '🚦'},
    {'ar': 'يَمْشُونَ', 'fa': 'راه می‌روند', 'emoji': '🚶‍♀️'},
    {'ar': 'بَنِين', 'fa': 'پسران', 'emoji': '👦'},
    {'ar': 'قِيَام', 'fa': 'برخاستن، قیام', 'emoji': '🧍‍♂️'},
    {'ar': 'حَذَّرَ', 'fa': 'هشدار داد', 'emoji': '⚠️'},
    {'ar': 'ها هان', 'fa': 'هان هان', 'emoji': '🗣️'},
  ];

  // گترهای واژگان عربی نهم درس دوم
  static List<Map<String, String>> get arabic9Lesson2Part1Vocab => [
    {'word': 'آمَنَ', 'emoji': '🤲', 'translation': 'ایمان آورد'},
    {'word': 'أَحَبُّ', 'emoji': '❤️', 'translation': 'دوست‌داشتنی‌تر، محبوب‌تر'},
    {'word': 'صَحِيفَة', 'emoji': '📰', 'translation': 'روزنامه'},
    {'word': 'إِشَارَاتُ الْمُرُورِ', 'emoji': '🚦', 'translation': 'علائم راهنمایی و رانندگی'},
    {'word': 'إِدَارَةُ الْمُرُورِ', 'emoji': '🏢', 'translation': 'اداره راهنمایی و رانندگی'},
    {'word': 'قبح', 'emoji': '👹', 'translation': 'شتی'},
    {'word': 'مُرُور', 'emoji': '🚶‍♂️', 'translation': 'گذر کردن'},
    {'word': 'صَدَمَ', 'emoji': '💥', 'translation': 'تصادف کرد، کوبید'},
  ];

  static List<Map<String, String>> get arabic9Lesson2Part2Vocab => [
    {'word': 'شقاوت', 'emoji': '⛓️', 'translation': 'بدبختی'},
    {'word': 'صحف', 'emoji': '📰', 'translation': 'روزنامه‌ها'},
    {'word': 'فجأة', 'emoji': '⚡', 'translation': 'ناگهان'},
    {'word': 'أنصح', 'emoji': '💡', 'translation': 'اندرزگوترین'},
    {'word': 'بكاء', 'emoji': '😭', 'translation': 'گریه کردن، گریه'},
    {'word': 'لقد', 'emoji': '✔️', 'translation': 'قطعاً'},
    {'word': 'تالي', 'emoji': '⏭️', 'translation': 'بعدی'},
    {'word': 'لم', 'emoji': '❓', 'translation': 'برای چه'},
  ];

  static List<Map<String, String>> get arabic9Lesson2Part3Vocab => [
    {'ar': 'تَكَلَّمَ', 'fa': 'سخن گفت', 'emoji': '🗣️'},
    {'ar': 'ذَكِيّ', 'fa': 'باهوش', 'emoji': '🧠'},
    {'ar': 'مُسْتَشْفَىً', 'fa': 'بیمارستان', 'emoji': '🏥'},
    {'ar': 'رَقَدَ', 'fa': 'بستری شد، خوابید', 'emoji': '🛏️'},
    {'ar': 'نَادَى', 'fa': 'صدا زد', 'emoji': '🗣️'},
    {'ar': 'هَادِئ', 'fa': 'آرام', 'emoji': '😌'},
    {'ar': 'سَتَرَ', 'fa': 'پوشاند، پنهان کرد', 'emoji': '🥷'},
  ];

  // گترهای واژگان عربی نهم درس سوم
  static List<Map<String, String>> get arabic9Lesson3Part1Vocab => [
    {'word': 'عَدُوّ', 'emoji': '👿', 'translation': 'دشمن'},
    {'word': 'إِخْوَان', 'emoji': '😇', 'translation': 'برادران'},
    {'word': 'اِعْتَذَرَ', 'emoji': '🙇‍♂️', 'translation': 'عذرخواهی کرد'},
    {'word': 'غَضِبَ', 'emoji': '😡', 'translation': 'خشمگین شد'},
    {'word': 'جِسْر', 'emoji': '🌉', 'translation': 'پل (جمع: جُسُور)'},
    {'word': 'حَسِبَ', 'emoji': '💭', 'translation': 'پنداشت، گمان کرد'},
    {'word': 'قَبَّلَ', 'emoji': '😘', 'translation': 'بوسید'},
    {'word': 'رَجَاءً', 'emoji': '🙏', 'translation': 'لطفاً، خواهشاً'},
  ];

  static List<Map<String, String>> get arabic9Lesson3Part2Vocab => [
    {'word': 'غضبان', 'emoji': '😡', 'translation': 'خشمگین'},
    {'word': 'قسم', 'emoji': '➗', 'translation': 'تقسیم کرد'},
    {'word': 'کشف', 'emoji': '🔍', 'translation': 'آشکار کرد'},
    {'word': 'جسر', 'emoji': '🌉', 'translation': 'پل (جمع: جُسُور)'},
  ];

  static List<Map<String, String>> get arabic9Lesson3Part3Vocab => [
    {'ar': 'حَسِبَ', 'fa': 'پنداشت، گمان کرد', 'emoji': '💭'},
    {'ar': 'قَبَّلَ', 'fa': 'بوسید', 'emoji': '😘'},
    {'ar': 'رَجَاءً', 'fa': 'لطفاً، خواهشاً', 'emoji': '🙏'},
    {'ar': 'رَجِيم', 'fa': 'رانده شده', 'emoji': '🚫'},
    {'ar': 'مَخْزَن', 'fa': 'انبار (جمع: مَخَازِن)', 'emoji': '🏭'},
  ];

  // گترهای واژگان عربی نهم درس چهارم
  static List<Map<String, String>> get arabic9Lesson4Part1Vocab => [
    {'word': 'شَبَاب', 'emoji': '🧑‍🦱', 'translation': 'جوانان، جوانی'},
    {'word': 'أَبْحَاث', 'emoji': '🔍', 'translation': 'پژوهش‌ها، تحقیقات'},
    {'word': 'اِحْتَرَقَ', 'emoji': '🔥', 'translation': 'آتش گرفت، سوخت'},
    {'word': 'صَرَخَ', 'emoji': '🗣️', 'translation': 'فریاد زد'},
    {'word': 'أَداء', 'emoji': '✅', 'translation': 'انجام دادن، ادا کردن'},
    {'word': 'أَصَابَ', 'emoji': '💥', 'translation': 'آسیب رساند، اصابت کرد'},
    {'word': 'فَرَج', 'emoji': '🕊️', 'translation': 'گشایش، رهایی'},
    {'word': 'فَقَدَ', 'emoji': '📉', 'translation': 'از دست داد'},
  ];

  static List<Map<String, String>> get arabic9Lesson4Part2Vocab => [
    {'word': 'الصين', 'emoji': '🇨🇳', 'translation': 'چین'},
    {'word': 'إذ', 'emoji': '⏳', 'translation': 'آن‌گاه'},
    {'word': 'عصف', 'emoji': '💨', 'translation': 'وزید'},
    {'word': 'أفرقة', 'emoji': '👥', 'translation': 'تیم‌ها، گروه‌ها'},
    {'word': 'محاولة', 'emoji': '🧗‍♂️', 'translation': 'تلاش کردن'},
    {'word': 'مضی', 'emoji': '⏳', 'translation': 'گذشت'},
    {'word': 'مطر', 'emoji': '🌧️', 'translation': 'باران'},
    {'word': 'مواصلة', 'emoji': '➡️', 'translation': 'ادامه دادن'},
    {'word': 'حرب', 'emoji': '⚔️', 'translation': 'جنگ'},
    {'word': 'دخان', 'emoji': '🚬', 'translation': 'دود'},
    {'word': 'نباتات', 'emoji': '🌱', 'translation': 'گیاهان'},
    {'word': 'رياح', 'emoji': '🌬️', 'translation': 'بادها'},
    {'word': 'جامعة', 'emoji': '🎓', 'translation': 'دانشگاه'},
  ];

  static List<Map<String, String>> get arabic9Lesson4Part3Vocab => [
    {'ar': 'اِنْكَسَرَ', 'fa': 'شکسته شد', 'emoji': '💔'},
    {'ar': 'بَغْتَةً', 'fa': 'ناگهان', 'emoji': '⚡'},
    {'ar': 'مِيَاه', 'fa': 'آب‌ها', 'emoji': '💧'},
    {'ar': 'صِين', 'fa': 'چین', 'emoji': '🇨🇳'},
    {'ar': 'شَابّ', 'fa': 'جوان', 'emoji': '🧑‍🦱'},
    {'ar': 'عََصَفَ', 'fa': 'وزید', 'emoji': '💨'},
  ];

  // گترهای واژگان عربی نهم درس پنجم
  static List<Map<String, String>> get arabic9Lesson5Part1Vocab => [
    {'word': 'أسَد', 'emoji': '🦁', 'translation': 'شیر'},
    {'word': 'ظَنَّ', 'emoji': '💭', 'translation': 'گمان کرد'},
    {'word': 'ثَعْلَب', 'emoji': '🦊', 'translation': 'روباه'},
    {'word': 'ثَقِيلُ السَّمْعِ', 'emoji': '🦻', 'translation': 'کم‌شنوا'},
    {'word': 'جَدَّ', 'emoji': '🏋️‍♂️', 'translation': 'تلاش کرد'},
    {'word': 'جَرَّحَ | يُجَرِّحُ', 'emoji': '🩹', 'translation': 'زخمی کرد | زخمی می‌کند'},
    {'word': 'حَاوَلَ', 'emoji': '🧗‍♂️', 'translation': 'تلاش کرد'},
    {'word': 'نَجَاح', 'emoji': '🏆', 'translation': 'موفقیت'},
  ];

  static List<Map<String, String>> get arabic9Lesson5Part2Vocab => [
    {'word': 'قرع', 'emoji': '🔨', 'translation': 'کوبید'},
    {'word': 'طرق', 'emoji': '🔨', 'translation': 'کوبید'},
    {'word': 'كلب', 'emoji': '🐕', 'translation': 'سگ'},
    {'word': 'لج', 'emoji': '💢', 'translation': 'پافشاری کرد'},
    {'word': 'مات', 'emoji': '⚰️', 'translation': 'مرد'},
    {'word': 'مصير', 'emoji': '🛤️', 'translation': 'سرنوشت'},
    {'word': 'نجاح', 'emoji': '🏆', 'translation': 'موفقیت'},
  ];

  static List<Map<String, String>> get arabic9Lesson5Part3Vocab => [
    {'ar': 'حَدِيقَةُ الْحَيَوَانَاتِ', 'fa': 'باغ وحش', 'emoji': '🦁'},
    {'ar': 'رَائِد', 'fa': 'جلودار، پیشگام', 'emoji': '🚩'},
    {'ar': 'سَکَتَ\nيَسْکُتُ', 'fa': 'ساکت شد | ساکت می‌شود', 'emoji': '🤫'},
    {'ar': 'شَجَّعَ عَلَیٰ\nيُشَجِّعُ', 'fa': 'تشویق کرد | تشویق می‌کند', 'emoji': '👏'},
    {'ar': 'نَقَصَ\nيَنْقُصُ', 'fa': 'کم شد | کم می‌شود', 'emoji': '📉'},
    {'ar': 'وَلَجَ\nيَلِجُ', 'fa': 'وارد شد | وارد می‌شود', 'emoji': '🚪'},
  ];

  // گترهای واژگان عربی نهم درس ششم
  static List<Map<String, String>> get arabic9Lesson6Part1Vocab => [
    {'word': 'اِسْتَلَمَ', 'emoji': '📥', 'translation': 'دریافت کرد'},
    {'word': 'تَعَلَّمَ', 'emoji': '🧠', 'translation': 'یاد گرفت'},
    {'word': 'حَفْلَةُ زَوَاج', 'emoji': '💒', 'translation': 'جشن ازدواج'},
    {'word': 'عَطَّرَ', 'emoji': '🧴', 'translation': 'خوشبو کرد'},
    {'word': 'غَيَّرَ', 'emoji': '🔄', 'translation': 'عوض کرد، تغییر داد'},
    {'word': 'دَفَعَ', 'emoji': '✋', 'translation': 'پرداخت کرد'},
    {'word': 'رَاسِب', 'emoji': '❌', 'translation': 'مردود'},
    {'word': 'رَاقِد', 'emoji': '🛌', 'translation': 'بستری'},
  ];

  static List<Map<String, String>> get arabic9Lesson6Part2Vocab => [
    {'word': 'زجاجة', 'emoji': '🫙', 'translation': 'شیشه'},
    {'word': 'صوم', 'emoji': '🌙', 'translation': 'روزه'},
    {'word': 'لام', 'emoji': '🛑', 'translation': 'سرزنش کرد'},
    {'word': 'مثالی', 'emoji': '⭐', 'translation': 'نمونه'},
    {'word': 'مزدحم', 'emoji': '🚗🚙', 'translation': 'شلوغ'},
    {'word': 'ملفّ', 'emoji': '📁', 'translation': 'پرونده'},
    {'word': 'نام', 'emoji': '😴', 'translation': 'خوابید'},
  ];

  static List<Map<String, String>> get arabic9Lesson6Part3Vocab => [
    {'ar': 'رائِحَة', 'fa': 'بو', 'emoji': '👃'},
    {'ar': 'رَسَبَ', 'fa': 'مردود شد', 'emoji': '❌'},
    {'ar': 'رَوْح', 'fa': 'رحمت', 'emoji': '🕊️'},
    {'ar': 'رَاقِد', 'fa': 'بستری', 'emoji': '🛌'},
    {'ar': 'ملفّ', 'fa': 'پرونده', 'emoji': '📁'},
    {'ar': 'نَشيط', 'fa': 'فعّال، با نشاط', 'emoji': '⚡'},
  ];

  // گترهای واژگان عربی نهم درس هفتم
  static List<Map<String, String>> get arabic9Lesson7Part1Vocab => [
    {'word': 'آلَة', 'emoji': '⚙️', 'translation': 'دستگاه'},
    {'word': 'آلَةُ طِبَاعَة', 'emoji': '🖨️', 'translation': 'دستگاه چاپ'},
    {'word': 'أَحْسَنَ عَمَلاً', 'emoji': '⭐', 'translation': 'کاری را نیکو انجام داد'},
    {'word': 'طَرَدَ', 'emoji': '🏃‍♂️', 'translation': 'با تندی راند'},
    {'word': 'طُفُولَة', 'emoji': '👶', 'translation': 'کودکی'},
    {'word': 'أَدَوَات', 'emoji': '🛠️', 'translation': 'ابزارها'},
    {'word': 'كِيمْيَاوِيّ', 'emoji': '🧪', 'translation': 'شیمیایی'},
    {'word': 'بِطَارِيَّة', 'emoji': '🔋', 'translation': 'باتری'},
  ];

  static List<Map<String, String>> get arabic9Lesson7Part2Vocab => [
    {'word': 'عربة', 'emoji': '🚂', 'translation': 'واگن، گاری'},
    {'word': 'کمل', 'emoji': '🧩', 'translation': 'کامل کرد'},
    {'word': 'بضائع', 'emoji': '📦', 'translation': 'کالاها'},
    {'word': 'أضاع', 'emoji': '🗑️', 'translation': 'تباه کرد'},
    {'word': 'مسجل', 'emoji': '🎙️', 'translation': 'دستگاه ضبط'},
    {'word': 'تمثال', 'emoji': '🗿', 'translation': 'تندیس'},
    {'word': 'وضع', 'emoji': '🫳', 'translation': 'گذاشت'},
  ];

  static List<Map<String, String>> get arabic9Lesson7Part3Vocab => [
    {'ar': 'أَنْقَذَ', 'fa': 'نجات داد', 'emoji': '🏊‍♂️'},
    {'ar': 'نَفَقَات', 'fa': 'هزینه‌ها', 'emoji': '💰'},
    {'ar': 'شَرِكَة', 'fa': 'شرکت', 'emoji': '🏢'},
    {'ar': 'نَوْم', 'fa': 'خواب', 'emoji': '😴'},
    {'ar': 'صِنَاعَة', 'fa': 'صنعت', 'emoji': '🏭'},
    {'ar': 'طَاقَة كَهْرَبَائِيَّة', 'fa': 'نیروی برق', 'emoji': '⚡'},
    {'ar': 'طَبَعَ', 'fa': 'چاپ کرد', 'emoji': '🖨️'},
  ];

  static List<Map<String, String>> get arabic9Lesson8Part1Vocab => [
    {'word': 'اِسْتَخْرَجَ', 'emoji': '⛏️', 'translation': 'بیرون آورد (مضارع: يَسْتَخْرِجُ)'},
    {'word': 'عُمَّال', 'emoji': '👷‍♂️', 'translation': 'کارگران (مفرد: عَامِل)'},
    {'word': 'نُقُود', 'emoji': '💵', 'translation': 'پول، پول'},
    {'word': 'اِشْتَغَلَ', 'emoji': '💼', 'translation': 'کار کرد (مضارع: يَشْتَغِلُ)'},
    {'word': 'سَلَامَةً', 'emoji': '💚', 'translation': 'سلامتی / اشکالی ندارد'},
    {'word': 'مَتْحَف', 'emoji': '🏛️', 'translation': 'موزه'},
    {'word': 'بِئْر', 'emoji': '🕳️', 'translation': 'چاه'},
    {'word': 'لَا شُكْرَ عَلَى الْوَاجِبِ', 'emoji': '🙏', 'translation': 'وظیفه بود؛ تشکّر لازم نیست'},
  ];

  static List<Map<String, String>> get arabic9Lesson8Part2Vocab => [
    {'word': 'ما کانت عندي', 'emoji': '❌', 'translation': 'نداشتم'},
    {'word': 'تفضل', 'emoji': '🤲', 'translation': 'بفرما'},
    {'word': 'لا باس', 'emoji': '🤷‍♂️', 'translation': 'اشکالی ندارد'},
    {'word': 'متحف', 'emoji': '🏛️', 'translation': 'موزه'},
    {'word': 'تعال', 'emoji': '🚶‍♂️', 'translation': 'بيا'},
    {'word': 'مکرم', 'emoji': '🕋', 'translation': 'گرامی داشته شده'},
    {'word': 'دلیل', 'emoji': '🧭', 'translation': 'راهنما'},
    {'word': 'نقود', 'emoji': '💵', 'translation': 'پول، پول'},
  ];

  static List<Map<String, String>> get arabic9Lesson8Part3Vocab => [
    {'ar': 'لَا بَأْس', 'fa': 'اشکالی ندارد', 'emoji': '🤷‍♂️'},
    {'ar': 'مَتْحَف', 'fa': 'موزه', 'emoji': '🏛️'},
    {'ar': 'تَعَالَ', 'fa': 'بیا', 'emoji': '🚶‍♂️'},
    {'ar': 'نُقُود', 'fa': 'پول، پول', 'emoji': '💵'},
    {'ar': 'بِئْر', 'fa': 'چاه', 'emoji': '🕳️'},
  ];

  static List<Map<String, String>> get arabic9Lesson9Part1Vocab => [
    {'word': 'أَحْسَنَ', 'emoji': '⭐', 'translation': 'بهتر، بهترین'},
    {'word': 'سَمَاوِيّ', 'emoji': '🌌', 'translation': 'آسمانی'},
    {'word': 'غَارَة', 'emoji': '⚔️', 'translation': 'حمله'},
    {'word': 'بَنَفْسَجِيّ', 'emoji': '🟣', 'translation': 'بنفش'},
    {'word': 'تلوين', 'emoji': '🎨', 'translation': 'رنگ‌آمیزی'},
    {'word': 'طَيَّار', 'emoji': '✈️', 'translation': 'خلبان'},
    {'word': 'ليمون', 'emoji': '🍋', 'translation': 'لیمو'},
    {'word': 'عَصِيرُ الْفَاكِهَةِ', 'emoji': '🧃', 'translation': 'آبمیوه'},
  ];

  static List<Map<String, String>> get arabic9Lesson9Part2Vocab => [
    {'word': 'تعب', 'emoji': '🥱', 'translation': 'خستگی'},
    {'word': 'قل', 'emoji': '📉', 'translation': 'کم شد'},
    {'word': 'تلوین', 'emoji': '🎨', 'translation': 'رنگ‌آمیزی'},
    {'word': 'انتباه', 'emoji': '🎯', 'translation': 'توجّه'},
    {'word': 'مهدی', 'emoji': '🧘', 'translation': 'آرام‌بخش'},
    {'word': 'تناول', 'emoji': '🍽️', 'translation': 'خورد (مضارع: يَتَنَاوَلُ)'},
  ];

  static List<Map<String, String>> get arabic9Lesson9Part3Vocab => [
    {'ar': 'مُجَفَّف', 'fa': 'خشک، خشک شده', 'emoji': '☀️'},
    {'ar': 'جَزَر', 'fa': 'هویج', 'emoji': '🥕'},
    {'ar': 'مِشْمِش', 'fa': 'زردآلو', 'emoji': '🍑'},
    {'ar': 'حَلِيب', 'fa': 'شیر', 'emoji': '🥛'},
    {'ar': 'خَطَأ', 'fa': 'اشتباه', 'emoji': '❌'},
  ];

  static List<Map<String, String>> get arabic9Lesson10Part1Vocab => [
    {'word': 'اِتِّصَال', 'emoji': '📞', 'translation': 'تماس گرفتن'},
    {'word': 'أَرْجُو', 'emoji': '🙏', 'translation': 'خواهش می‌کنم'},
    {'word': 'نَسِيرُ', 'emoji': '🚶‍♂️', 'translation': 'حرکت می‌کنیم'},
    {'word': 'حَاسُوب', 'emoji': '💻', 'translation': 'رایانه'},
    {'word': 'أَهْدَيْتُ', 'emoji': '🎁', 'translation': 'هدیه کردم'},
    {'word': 'تَحْرِیر', 'emoji': '🕊️', 'translation': 'آزادسازی'},
    {'word': 'عَائِلَة', 'emoji': '👨‍👩‍👧‍👦', 'translation': 'خانواده'},
    {'word': 'لَحِقَ بِبَيْتِكُمْ', 'emoji': '🏠', 'translation': 'به خانه‌تان رسید'},
  ];

  static List<Map<String, String>> get arabic9Lesson10Part2Vocab => [
    {'word': 'دون اذنکم', 'emoji': '🚫', 'translation': 'بدون اجازۀ شما'},
    {'word': 'عائلة', 'emoji': '👨‍👩‍👧‍👦', 'translation': 'خانواده = أسرَة'},
    {'word': 'أضرار', 'emoji': '⚠️', 'translation': 'زیان ها (مفرد: ضرر)'},
    {'word': 'مستعد', 'emoji': '🎒', 'translation': 'آماده'},
    {'word': 'سعر', 'emoji': '🤌', 'translation': 'قيمت'},
  ];

  static List<Map<String, String>> get arabic9Lesson10Part3Vocab => [
    {'ar': 'نسير', 'fa': 'حرکت می کنیم (سارَ: حرکت کرد)', 'emoji': '🚶‍♂️'},
    {'ar': 'يمكن القول', 'fa': 'می شود گفت', 'emoji': '🗣️'},
    {'ar': 'ثمن', 'fa': 'قیمت', 'emoji': '🤌'},
    {'ar': 'ينهض', 'fa': 'برمی خيزد (ماضی: نهض)', 'emoji': '🧍'},
    {'ar': 'حاسوب', 'fa': 'رايانه', 'emoji': '💻'},
  ];

  // وضعیت تکمیل بازی‌های درس اول تا ششم عربی هفتم
  static bool lesson1Part1Completed = false;
  static bool lesson1Part2Completed = false;
  static bool lesson1Part3Completed = false;
  static bool lesson2Part1Completed = false;
  static bool lesson2Part2Completed = false;
  static bool lesson2Part3Completed = false;
  static bool lesson3Part1Completed = false;
  static bool lesson3Part2Completed = false;
  static bool lesson3Part3Completed = false;
  static bool lesson4Part1Completed = false;
  static bool lesson4Part2Completed = false;
  static bool lesson4Part3Completed = false;
  static bool lesson5Part1Completed = false;
  static bool lesson5Part2Completed = false;
  static bool lesson5Part3Completed = false;
  static bool lesson6Part1Completed = false;
  static bool lesson6Part2Completed = false;
  static bool lesson6Part3Completed = false;
  static bool lesson7Part1Completed = false;
  static bool lesson7Part2Completed = false;
  static bool lesson7Part3Completed = false;
  static bool lesson8Part1Completed = false;
  static bool lesson8Part2Completed = false;
  static bool lesson8Part3Completed = false;
  static bool lesson9Part1Completed = false;
  static bool lesson9Part2Completed = false;
  static bool lesson9Part3Completed = false;
  static bool lesson10Part1Completed = false;
  static bool lesson10Part2Completed = false;
  static bool lesson10Part3Completed = false;
  static bool lesson11Part1Completed = false;
  static bool lesson11Part2Completed = false;
  static bool lesson11Part3Completed = false;
  static bool lesson12Part1Completed = false;
  static bool lesson12Part2Completed = false;
  static bool lesson12Part3Completed = false;
  static bool lesson13Part1Completed = false;
  static bool lesson13Part2Completed = false;
  static bool lesson13Part3Completed = false;
  static bool lesson14Part1Completed = false;
  static bool lesson14Part2Completed = false;
  static bool lesson14Part3Completed = false;
  static bool lesson15Part1Completed = false;
  static bool lesson15Part2Completed = false;
  static bool lesson15Part3Completed = false;
  static bool lesson16Part1Completed = false;
  static bool lesson16Part2Completed = false;
  static bool lesson16Part3Completed = false;
  static bool lesson17Part1Completed = false;
  static bool lesson17Part2Completed = false;
  static bool lesson17Part3Completed = false;
  static bool lesson18Part1Completed = false;
  static bool lesson18Part2Completed = false;
  static bool lesson18Part3Completed = false;
  static bool lesson19Part1Completed = false;
  static bool lesson19Part2Completed = false;
  static bool lesson19Part3Completed = false;
  static bool lesson20Part1Completed = false;
  static bool lesson20Part2Completed = false;
  static bool lesson20Part3Completed = false;
  static bool riyazi7Chapter1Completed = false;
  static bool riyazi7Chapter2Completed = false;
  static bool riyazi7Chapter3Completed = false;
  static bool riyazi7Chapter4Completed = false;
  static bool riyazi7Chapter5Completed = false;
  static bool riyazi7Chapter6Completed = false;
  static bool riyazi7Chapter7Completed = false;
  static bool riyazi7Chapter8Completed = false;
  static bool riyazi7Chapter9Completed = false;

  static bool riyazi8Chapter1Completed = false;
  static bool riyazi8Chapter2Completed = false;
  static bool riyazi8Chapter3Completed = false;
  static bool riyazi8Chapter4Completed = false;
  static bool riyazi8Chapter5Completed = false;
  static bool riyazi8Chapter6Completed = false;
  static bool riyazi8Chapter7Completed = false;
  static bool riyazi8Chapter8Completed = false;
  static bool riyazi8Chapter9Completed = false;

  static bool isRiyazi8ChapterCompleted(int chapter) {
    switch (chapter) {
      case 1: return riyazi8Chapter1Completed;
      case 2: return riyazi8Chapter2Completed;
      case 3: return riyazi8Chapter3Completed;
      case 4: return riyazi8Chapter4Completed;
      case 5: return riyazi8Chapter5Completed;
      case 6: return riyazi8Chapter6Completed;
      case 7: return riyazi8Chapter7Completed;
      case 8: return riyazi8Chapter8Completed;
      case 9: return riyazi8Chapter9Completed;
      default: return false;
    }
  }

  static void setRiyazi8ChapterCompleted(int chapter, bool value) {
    switch (chapter) {
      case 1: riyazi8Chapter1Completed = value; break;
      case 2: riyazi8Chapter2Completed = value; break;
      case 3: riyazi8Chapter3Completed = value; break;
      case 4: riyazi8Chapter4Completed = value; break;
      case 5: riyazi8Chapter5Completed = value; break;
      case 6: riyazi8Chapter6Completed = value; break;
      case 7: riyazi8Chapter7Completed = value; break;
      case 8: riyazi8Chapter8Completed = value; break;
      case 9: riyazi8Chapter9Completed = value; break;
    }
  }

  static bool riyazi9Chapter1Completed = false;
  static bool riyazi9Chapter2Completed = false;
  static bool riyazi9Chapter3Completed = false;
  static bool riyazi9Chapter4Completed = false;
  static bool riyazi9Chapter5Completed = false;
  static bool riyazi9Chapter6Completed = false;
  static bool riyazi9Chapter7Completed = false;
  static bool riyazi9Chapter8Completed = false;

  static bool isRiyazi9ChapterCompleted(int chapter) {
    switch (chapter) {
      case 1: return riyazi9Chapter1Completed;
      case 2: return riyazi9Chapter2Completed;
      case 3: return riyazi9Chapter3Completed;
      case 4: return riyazi9Chapter4Completed;
      case 5: return riyazi9Chapter5Completed;
      case 6: return riyazi9Chapter6Completed;
      case 7: return riyazi9Chapter7Completed;
      case 8: return riyazi9Chapter8Completed;
      default: return false;
    }
  }

  static void setRiyazi9ChapterCompleted(int chapter, bool value) {
    switch (chapter) {
      case 1: riyazi9Chapter1Completed = value; break;
      case 2: riyazi9Chapter2Completed = value; break;
      case 3: riyazi9Chapter3Completed = value; break;
      case 4: riyazi9Chapter4Completed = value; break;
      case 5: riyazi9Chapter5Completed = value; break;
      case 6: riyazi9Chapter6Completed = value; break;
      case 7: riyazi9Chapter7Completed = value; break;
      case 8: riyazi9Chapter8Completed = value; break;
    }
  }

  static bool isRiyazi7ChapterCompleted(int chapter) {
    switch (chapter) {
      case 1: return riyazi7Chapter1Completed;
      case 2: return riyazi7Chapter2Completed;
      case 3: return riyazi7Chapter3Completed;
      case 4: return riyazi7Chapter4Completed;
      case 5: return riyazi7Chapter5Completed;
      case 6: return riyazi7Chapter6Completed;
      case 7: return riyazi7Chapter7Completed;
      case 8: return riyazi7Chapter8Completed;
      case 9: return riyazi7Chapter9Completed;
      default: return false;
    }
  }

  static void setRiyazi7ChapterCompleted(int chapter, bool value) {
    switch (chapter) {
      case 1: riyazi7Chapter1Completed = value; break;
      case 2: riyazi7Chapter2Completed = value; break;
      case 3: riyazi7Chapter3Completed = value; break;
      case 4: riyazi7Chapter4Completed = value; break;
      case 5: riyazi7Chapter5Completed = value; break;
      case 6: riyazi7Chapter6Completed = value; break;
      case 7: riyazi7Chapter7Completed = value; break;
      case 8: riyazi7Chapter8Completed = value; break;
      case 9: riyazi7Chapter9Completed = value; break;
    }
  }

  // بارگذاری اطلاعات ذخیره شده هنگام شروع اپلیکیشن
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    phoneNumber = prefs.getString('phoneNumber') ?? '';
    selectedGrade = prefs.getInt('selectedGrade') ?? 1;
    userName = prefs.getString('userName') ?? '';
    userAvatar = prefs.getString('userAvatar') ?? '';
    pendingWelcomeGift = prefs.getBool('pendingWelcomeGift') ?? false;
    currentTheme = prefs.getString('currentTheme') ?? 'royal_purple';
    riyazi7Chapter1Completed = prefs.getBool('riyazi7Chapter1Completed') ?? false;
    riyazi7Chapter2Completed = prefs.getBool('riyazi7Chapter2Completed') ?? false;
    riyazi7Chapter3Completed = prefs.getBool('riyazi7Chapter3Completed') ?? false;
    riyazi7Chapter4Completed = prefs.getBool('riyazi7Chapter4Completed') ?? false;
    riyazi7Chapter5Completed = prefs.getBool('riyazi7Chapter5Completed') ?? false;
    riyazi7Chapter6Completed = prefs.getBool('riyazi7Chapter6Completed') ?? false;
    riyazi7Chapter7Completed = prefs.getBool('riyazi7Chapter7Completed') ?? false;
    riyazi7Chapter8Completed = prefs.getBool('riyazi7Chapter8Completed') ?? false;
    riyazi7Chapter9Completed = prefs.getBool('riyazi7Chapter9Completed') ?? false;
    riyazi8Chapter1Completed = prefs.getBool('riyazi8Chapter1Completed') ?? false;
    riyazi8Chapter2Completed = prefs.getBool('riyazi8Chapter2Completed') ?? false;
    riyazi8Chapter3Completed = prefs.getBool('riyazi8Chapter3Completed') ?? false;
    riyazi8Chapter4Completed = prefs.getBool('riyazi8Chapter4Completed') ?? false;
    riyazi8Chapter5Completed = prefs.getBool('riyazi8Chapter5Completed') ?? false;
    riyazi8Chapter6Completed = prefs.getBool('riyazi8Chapter6Completed') ?? false;
    riyazi8Chapter7Completed = prefs.getBool('riyazi8Chapter7Completed') ?? false;
    riyazi8Chapter8Completed = prefs.getBool('riyazi8Chapter8Completed') ?? false;
    riyazi8Chapter9Completed = prefs.getBool('riyazi8Chapter9Completed') ?? false;
    riyazi9Chapter1Completed = prefs.getBool('riyazi9Chapter1Completed') ?? false;
    riyazi9Chapter2Completed = prefs.getBool('riyazi9Chapter2Completed') ?? false;
    riyazi9Chapter3Completed = prefs.getBool('riyazi9Chapter3Completed') ?? false;
    riyazi9Chapter4Completed = prefs.getBool('riyazi9Chapter4Completed') ?? false;
    riyazi9Chapter5Completed = prefs.getBool('riyazi9Chapter5Completed') ?? false;
    riyazi9Chapter6Completed = prefs.getBool('riyazi9Chapter6Completed') ?? false;
    riyazi9Chapter7Completed = prefs.getBool('riyazi9Chapter7Completed') ?? false;
    riyazi9Chapter8Completed = prefs.getBool('riyazi9Chapter8Completed') ?? false;
    lesson1Part1Completed = prefs.getBool('lesson1Part1Completed') ?? false;
    lesson1Part2Completed = prefs.getBool('lesson1Part2Completed') ?? false;
    lesson1Part3Completed = prefs.getBool('lesson1Part3Completed') ?? false;
    lesson2Part1Completed = prefs.getBool('lesson2Part1Completed') ?? false;
    lesson2Part2Completed = prefs.getBool('lesson2Part2Completed') ?? false;
    lesson2Part3Completed = prefs.getBool('lesson2Part3Completed') ?? false;
    lesson3Part1Completed = prefs.getBool('lesson3Part1Completed') ?? false;
    lesson3Part2Completed = prefs.getBool('lesson3Part2Completed') ?? false;
    lesson3Part3Completed = prefs.getBool('lesson3Part3Completed') ?? false;
    lesson4Part1Completed = prefs.getBool('lesson4Part1Completed') ?? false;
    lesson4Part2Completed = prefs.getBool('lesson4Part2Completed') ?? false;
    lesson4Part3Completed = prefs.getBool('lesson4Part3Completed') ?? false;
    lesson5Part1Completed = prefs.getBool('lesson5Part1Completed') ?? false;
    lesson5Part2Completed = prefs.getBool('lesson5Part2Completed') ?? false;
    lesson5Part3Completed = prefs.getBool('lesson5Part3Completed') ?? false;
    lesson6Part1Completed = prefs.getBool('lesson6Part1Completed') ?? false;
    lesson6Part2Completed = prefs.getBool('lesson6Part2Completed') ?? false;
    lesson6Part3Completed = prefs.getBool('lesson6Part3Completed') ?? false;
    lesson7Part1Completed = prefs.getBool('lesson7Part1Completed') ?? false;
    lesson7Part2Completed = prefs.getBool('lesson7Part2Completed') ?? false;
    lesson7Part3Completed = prefs.getBool('lesson7Part3Completed') ?? false;
    lesson8Part1Completed = prefs.getBool('lesson8Part1Completed') ?? false;
    lesson8Part2Completed = prefs.getBool('lesson8Part2Completed') ?? false;
    lesson8Part3Completed = prefs.getBool('lesson8Part3Completed') ?? false;
    lesson9Part1Completed = prefs.getBool('lesson9Part1Completed') ?? false;
    lesson9Part2Completed = prefs.getBool('lesson9Part2Completed') ?? false;
    lesson9Part3Completed = prefs.getBool('lesson9Part3Completed') ?? false;
    lesson10Part1Completed = prefs.getBool('lesson10Part1Completed') ?? false;
    lesson10Part2Completed = prefs.getBool('lesson10Part2Completed') ?? false;
    lesson10Part3Completed = prefs.getBool('lesson10Part3Completed') ?? false;
    lesson11Part1Completed = prefs.getBool('lesson11Part1Completed') ?? false;
    lesson11Part2Completed = prefs.getBool('lesson11Part2Completed') ?? false;
    lesson11Part3Completed = prefs.getBool('lesson11Part3Completed') ?? false;
    lesson12Part1Completed = prefs.getBool('lesson12Part1Completed') ?? false;
    lesson12Part2Completed = prefs.getBool('lesson12Part2Completed') ?? false;
    lesson12Part3Completed = prefs.getBool('lesson12Part3Completed') ?? false;
    lesson13Part1Completed = prefs.getBool('lesson13Part1Completed') ?? false;
    lesson13Part2Completed = prefs.getBool('lesson13Part2Completed') ?? false;
    lesson13Part3Completed = prefs.getBool('lesson13Part3Completed') ?? false;
    lesson14Part1Completed = prefs.getBool('lesson14Part1Completed') ?? false;
    lesson14Part2Completed = prefs.getBool('lesson14Part2Completed') ?? false;
    lesson14Part3Completed = prefs.getBool('lesson14Part3Completed') ?? false;
    lesson15Part1Completed = prefs.getBool('lesson15Part1Completed') ?? false;
    lesson15Part2Completed = prefs.getBool('lesson15Part2Completed') ?? false;
    lesson15Part3Completed = prefs.getBool('lesson15Part3Completed') ?? false;
    lesson16Part1Completed = prefs.getBool('lesson16Part1Completed') ?? false;
    lesson16Part2Completed = prefs.getBool('lesson16Part2Completed') ?? false;
    lesson16Part3Completed = prefs.getBool('lesson16Part3Completed') ?? false;
    lesson17Part1Completed = prefs.getBool('lesson17Part1Completed') ?? false;
    lesson17Part2Completed = prefs.getBool('lesson17Part2Completed') ?? false;
    lesson17Part3Completed = prefs.getBool('lesson17Part3Completed') ?? false;
    lesson18Part1Completed = prefs.getBool('lesson18Part1Completed') ?? false;
    lesson18Part2Completed = prefs.getBool('lesson18Part2Completed') ?? false;
    lesson18Part3Completed = prefs.getBool('lesson18Part3Completed') ?? false;
    lesson19Part1Completed = prefs.getBool('lesson19Part1Completed') ?? false;
    lesson19Part2Completed = prefs.getBool('lesson19Part2Completed') ?? false;
    lesson19Part3Completed = prefs.getBool('lesson19Part3Completed') ?? false;
    lesson20Part1Completed = prefs.getBool('lesson20Part1Completed') ?? false;
    lesson20Part2Completed = prefs.getBool('lesson20Part2Completed') ?? false;
    lesson20Part3Completed = prefs.getBool('lesson20Part3Completed') ?? false;
    arabic8Lesson1Part1Completed = prefs.getBool('arabic8Lesson1Part1Completed') ?? false;
    arabic8Lesson1Part2Completed = prefs.getBool('arabic8Lesson1Part2Completed') ?? false;
    arabic8Lesson1Part3Completed = prefs.getBool('arabic8Lesson1Part3Completed') ?? false;
    arabic8Lesson2Part1Completed = prefs.getBool('arabic8Lesson2Part1Completed') ?? false;
    arabic8Lesson2Part2Completed = prefs.getBool('arabic8Lesson2Part2Completed') ?? false;
    arabic8Lesson2Part3Completed = prefs.getBool('arabic8Lesson2Part3Completed') ?? false;
    arabic8Lesson3Part1Completed = prefs.getBool('arabic8Lesson3Part1Completed') ?? false;
    arabic8Lesson3Part2Completed = prefs.getBool('arabic8Lesson3Part2Completed') ?? false;
    arabic8Lesson3Part3Completed = prefs.getBool('arabic8Lesson3Part3Completed') ?? false;
    arabic8Lesson4Part1Completed = prefs.getBool('arabic8Lesson4Part1Completed') ?? false;
    arabic8Lesson4Part2Completed = prefs.getBool('arabic8Lesson4Part2Completed') ?? false;
    arabic8Lesson4Part3Completed = prefs.getBool('arabic8Lesson4Part3Completed') ?? false;
    arabic8Lesson5Part1Completed = prefs.getBool('arabic8Lesson5Part1Completed') ?? false;
    arabic8Lesson5Part2Completed = prefs.getBool('arabic8Lesson5Part2Completed') ?? false;
    arabic8Lesson5Part3Completed = prefs.getBool('arabic8Lesson5Part3Completed') ?? false;
    arabic8Lesson6Part1Completed = prefs.getBool('arabic8Lesson6Part1Completed') ?? false;
    arabic8Lesson6Part2Completed = prefs.getBool('arabic8Lesson6Part2Completed') ?? false;
    arabic8Lesson6Part3Completed = prefs.getBool('arabic8Lesson6Part3Completed') ?? false;
    arabic8Lesson7Part1Completed = prefs.getBool('arabic8Lesson7Part1Completed') ?? false;
    arabic8Lesson7Part2Completed = prefs.getBool('arabic8Lesson7Part2Completed') ?? false;
    arabic8Lesson7Part3Completed = prefs.getBool('arabic8Lesson7Part3Completed') ?? false;
    arabic8Lesson8Part1Completed = prefs.getBool('arabic8Lesson8Part1Completed') ?? false;
    arabic8Lesson8Part2Completed = prefs.getBool('arabic8Lesson8Part2Completed') ?? false;
    arabic8Lesson8Part3Completed = prefs.getBool('arabic8Lesson8Part3Completed') ?? false;
    arabic8Lesson9Part1Completed = prefs.getBool('arabic8Lesson9Part1Completed') ?? false;
    arabic8Lesson9Part2Completed = prefs.getBool('arabic8Lesson9Part2Completed') ?? false;
    arabic8Lesson9Part3Completed = prefs.getBool('arabic8Lesson9Part3Completed') ?? false;
    arabic8Lesson10Part1Completed = prefs.getBool('arabic8Lesson10Part1Completed') ?? false;
    arabic8Lesson10Part2Completed = prefs.getBool('arabic8Lesson10Part2Completed') ?? false;
    arabic8Lesson10Part3Completed = prefs.getBool('arabic8Lesson10Part3Completed') ?? false;
    arabic9Lesson1Part1Completed = prefs.getBool('arabic9Lesson1Part1Completed') ?? false;
    arabic9Lesson1Part2Completed = prefs.getBool('arabic9Lesson1Part2Completed') ?? false;
    arabic9Lesson1Part3Completed = prefs.getBool('arabic9Lesson1Part3Completed') ?? false;
    arabic9Lesson2Part1Completed = prefs.getBool('arabic9Lesson2Part1Completed') ?? false;
    arabic9Lesson2Part2Completed = prefs.getBool('arabic9Lesson2Part2Completed') ?? false;
    arabic9Lesson2Part3Completed = prefs.getBool('arabic9Lesson2Part3Completed') ?? false;
    arabic9Lesson3Part1Completed = prefs.getBool('arabic9Lesson3Part1Completed') ?? false;
    arabic9Lesson3Part2Completed = prefs.getBool('arabic9Lesson3Part2Completed') ?? false;
    arabic9Lesson3Part3Completed = prefs.getBool('arabic9Lesson3Part3Completed') ?? false;
    arabic9Lesson4Part1Completed = prefs.getBool('arabic9Lesson4Part1Completed') ?? false;
    arabic9Lesson4Part2Completed = prefs.getBool('arabic9Lesson4Part2Completed') ?? false;
    arabic9Lesson4Part3Completed = prefs.getBool('arabic9Lesson4Part3Completed') ?? false;
    arabic9Lesson5Part1Completed = prefs.getBool('arabic9Lesson5Part1Completed') ?? false;
    arabic9Lesson5Part2Completed = prefs.getBool('arabic9Lesson5Part2Completed') ?? false;
    arabic9Lesson5Part3Completed = prefs.getBool('arabic9Lesson5Part3Completed') ?? false;
    arabic9Lesson6Part1Completed = prefs.getBool('arabic9Lesson6Part1Completed') ?? false;
    arabic9Lesson6Part2Completed = prefs.getBool('arabic9Lesson6Part2Completed') ?? false;
    arabic9Lesson6Part3Completed = prefs.getBool('arabic9Lesson6Part3Completed') ?? false;
    arabic9Lesson7Part1Completed = prefs.getBool('arabic9Lesson7Part1Completed') ?? false;
    arabic9Lesson7Part2Completed = prefs.getBool('arabic9Lesson7Part2Completed') ?? false;
    arabic9Lesson7Part3Completed = prefs.getBool('arabic9Lesson7Part3Completed') ?? false;
    arabic9Lesson8Part1Completed = prefs.getBool('arabic9Lesson8Part1Completed') ?? false;
    arabic9Lesson8Part2Completed = prefs.getBool('arabic9Lesson8Part2Completed') ?? false;
    arabic9Lesson8Part3Completed = prefs.getBool('arabic9Lesson8Part3Completed') ?? false;
    arabic9Lesson9Part1Completed = prefs.getBool('arabic9Lesson9Part1Completed') ?? false;
    arabic9Lesson9Part2Completed = prefs.getBool('arabic9Lesson9Part2Completed') ?? false;
    arabic9Lesson9Part3Completed = prefs.getBool('arabic9Lesson9Part3Completed') ?? false;
    arabic9Lesson10Part1Completed = prefs.getBool('arabic9Lesson10Part1Completed') ?? false;
    arabic9Lesson10Part2Completed = prefs.getBool('arabic9Lesson10Part2Completed') ?? false;
    arabic9Lesson10Part3Completed = prefs.getBool('arabic9Lesson10Part3Completed') ?? false;
    quran7Lesson1Part1Completed = prefs.getBool('quran7Lesson1Part1Completed') ?? false;
    quran7Lesson1Part2Completed = prefs.getBool('quran7Lesson1Part2Completed') ?? false;
    quran7Lesson1Part3Completed = prefs.getBool('quran7Lesson1Part3Completed') ?? false;
    quran7Lesson2Part1Completed = prefs.getBool('quran7Lesson2Part1Completed') ?? false;
    quran7Lesson2Part2Completed = prefs.getBool('quran7Lesson2Part2Completed') ?? false;
    quran7Lesson2Part3Completed = prefs.getBool('quran7Lesson2Part3Completed') ?? false;
    quran7Lesson3Part1Completed = prefs.getBool('quran7Lesson3Part1Completed') ?? false;
    quran7Lesson3Part2Completed = prefs.getBool('quran7Lesson3Part2Completed') ?? false;
    quran7Lesson3Part3Completed = prefs.getBool('quran7Lesson3Part3Completed') ?? false;
    quran7Lesson4Part1Completed = prefs.getBool('quran7Lesson4Part1Completed') ?? false;
    quran7Lesson4Part2Completed = prefs.getBool('quran7Lesson4Part2Completed') ?? false;
    quran7Lesson4Part3Completed = prefs.getBool('quran7Lesson4Part3Completed') ?? false;
    quran7Lesson5Part1Completed = prefs.getBool('quran7Lesson5Part1Completed') ?? false;
    quran7Lesson5Part2Completed = prefs.getBool('quran7Lesson5Part2Completed') ?? false;
    quran7Lesson5Part3Completed = prefs.getBool('quran7Lesson5Part3Completed') ?? false;
    quran7Lesson6Part1Completed = prefs.getBool('quran7Lesson6Part1Completed') ?? false;
    quran7Lesson6Part2Completed = prefs.getBool('quran7Lesson6Part2Completed') ?? false;
    quran7Lesson6Part3Completed = prefs.getBool('quran7Lesson6Part3Completed') ?? false;
    quran7Lesson7Part1Completed = prefs.getBool('quran7Lesson7Part1Completed') ?? false;
    quran7Lesson7Part2Completed = prefs.getBool('quran7Lesson7Part2Completed') ?? false;
    quran7Lesson7Part3Completed = prefs.getBool('quran7Lesson7Part3Completed') ?? false;
    quran7Lesson8Part1Completed = prefs.getBool('quran7Lesson8Part1Completed') ?? false;
    quran7Lesson8Part2Completed = prefs.getBool('quran7Lesson8Part2Completed') ?? false;
    quran7Lesson8Part3Completed = prefs.getBool('quran7Lesson8Part3Completed') ?? false;
    quran7Lesson9Part1Completed = prefs.getBool('quran7Lesson9Part1Completed') ?? false;
    quran7Lesson9Part2Completed = prefs.getBool('quran7Lesson9Part2Completed') ?? false;
    quran7Lesson9Part3Completed = prefs.getBool('quran7Lesson9Part3Completed') ?? false;
    quran7Lesson10Part1Completed = prefs.getBool('quran7Lesson10Part1Completed') ?? false;
    quran7Lesson10Part2Completed = prefs.getBool('quran7Lesson10Part2Completed') ?? false;
    quran7Lesson10Part3Completed = prefs.getBool('quran7Lesson10Part3Completed') ?? false;
    quran7Lesson11Part1Completed = prefs.getBool('quran7Lesson11Part1Completed') ?? false;
    quran7Lesson11Part2Completed = prefs.getBool('quran7Lesson11Part2Completed') ?? false;
    quran7Lesson11Part3Completed = prefs.getBool('quran7Lesson11Part3Completed') ?? false;
    quran7Lesson12Part1Completed = prefs.getBool('quran7Lesson12Part1Completed') ?? false;
    quran7Lesson12Part2Completed = prefs.getBool('quran7Lesson12Part2Completed') ?? false;
    quran7Lesson12Part3Completed = prefs.getBool('quran7Lesson12Part3Completed') ?? false;
    quran8Lesson1Part1Completed = prefs.getBool('quran8Lesson1Part1Completed') ?? false;
    quran8Lesson1Part2Completed = prefs.getBool('quran8Lesson1Part2Completed') ?? false;
    quran8Lesson1Part3Completed = prefs.getBool('quran8Lesson1Part3Completed') ?? false;
    quran8Lesson2Part1Completed = prefs.getBool('quran8Lesson2Part1Completed') ?? false;
    quran8Lesson2Part2Completed = prefs.getBool('quran8Lesson2Part2Completed') ?? false;
    quran8Lesson2Part3Completed = prefs.getBool('quran8Lesson2Part3Completed') ?? false;
    quran8Lesson3Part1Completed = prefs.getBool('quran8Lesson3Part1Completed') ?? false;
    quran8Lesson3Part2Completed = prefs.getBool('quran8Lesson3Part2Completed') ?? false;
    quran8Lesson3Part3Completed = prefs.getBool('quran8Lesson3Part3Completed') ?? false;
    quran8Lesson4Part1Completed = prefs.getBool('quran8Lesson4Part1Completed') ?? false;
    quran8Lesson4Part2Completed = prefs.getBool('quran8Lesson4Part2Completed') ?? false;
    quran8Lesson4Part3Completed = prefs.getBool('quran8Lesson4Part3Completed') ?? false;
    quran8Lesson5Part1Completed = prefs.getBool('quran8Lesson5Part1Completed') ?? false;
    quran8Lesson5Part2Completed = prefs.getBool('quran8Lesson5Part2Completed') ?? false;
    quran8Lesson5Part3Completed = prefs.getBool('quran8Lesson5Part3Completed') ?? false;
    quran8Lesson6Part1Completed = prefs.getBool('quran8Lesson6Part1Completed') ?? false;
    quran8Lesson6Part2Completed = prefs.getBool('quran8Lesson6Part2Completed') ?? false;
    quran8Lesson6Part3Completed = prefs.getBool('quran8Lesson6Part3Completed') ?? false;
    quran8Lesson7Part1Completed = prefs.getBool('quran8Lesson7Part1Completed') ?? false;
    quran8Lesson7Part2Completed = prefs.getBool('quran8Lesson7Part2Completed') ?? false;
    quran8Lesson7Part3Completed = prefs.getBool('quran8Lesson7Part3Completed') ?? false;
    quran8Lesson8Part1Completed = prefs.getBool('quran8Lesson8Part1Completed') ?? false;
    quran8Lesson8Part2Completed = prefs.getBool('quran8Lesson8Part2Completed') ?? false;
    quran8Lesson8Part3Completed = prefs.getBool('quran8Lesson8Part3Completed') ?? false;
    quran8Lesson9Part1Completed = prefs.getBool('quran8Lesson9Part1Completed') ?? false;
    quran8Lesson9Part2Completed = prefs.getBool('quran8Lesson9Part2Completed') ?? false;
    quran8Lesson9Part3Completed = prefs.getBool('quran8Lesson9Part3Completed') ?? false;
    quran8Lesson10Part1Completed = prefs.getBool('quran8Lesson10Part1Completed') ?? false;
    quran8Lesson10Part2Completed = prefs.getBool('quran8Lesson10Part2Completed') ?? false;
    quran8Lesson10Part3Completed = prefs.getBool('quran8Lesson10Part3Completed') ?? false;
    quran8Lesson11Part1Completed = prefs.getBool('quran8Lesson11Part1Completed') ?? false;
    quran8Lesson11Part2Completed = prefs.getBool('quran8Lesson11Part2Completed') ?? false;
    quran8Lesson11Part3Completed = prefs.getBool('quran8Lesson11Part3Completed') ?? false;
    quran8Lesson12Part1Completed = prefs.getBool('quran8Lesson12Part1Completed') ?? false;
    quran8Lesson12Part2Completed = prefs.getBool('quran8Lesson12Part2Completed') ?? false;
    quran8Lesson12Part3Completed = prefs.getBool('quran8Lesson12Part3Completed') ?? false;
    quran9Lesson1Part2Completed = prefs.getBool('quran9Lesson1Part2Completed') ?? false;
    quran9Lesson1Part3Completed = prefs.getBool('quran9Lesson1Part3Completed') ?? false;
    quran9Lesson2Part1Completed = prefs.getBool('quran9Lesson2Part1Completed') ?? false;
    quran9Lesson2Part2Completed = prefs.getBool('quran9Lesson2Part2Completed') ?? false;
    quran9Lesson2Part3Completed = prefs.getBool('quran9Lesson2Part3Completed') ?? false;
    quran9Lesson3Part1Completed = prefs.getBool('quran9Lesson3Part1Completed') ?? false;
    quran9Lesson3Part2Completed = prefs.getBool('quran9Lesson3Part2Completed') ?? false;
    quran9Lesson3Part3Completed = prefs.getBool('quran9Lesson3Part3Completed') ?? false;
    quran9Lesson4Part1Completed = prefs.getBool('quran9Lesson4Part1Completed') ?? false;
    quran9Lesson4Part2Completed = prefs.getBool('quran9Lesson4Part2Completed') ?? false;
    quran9Lesson4Part3Completed = prefs.getBool('quran9Lesson4Part3Completed') ?? false;
    quran9Lesson5Part1Completed = prefs.getBool('quran9Lesson5Part1Completed') ?? false;
    quran9Lesson5Part2Completed = prefs.getBool('quran9Lesson5Part2Completed') ?? false;
    quran9Lesson5Part3Completed = prefs.getBool('quran9Lesson5Part3Completed') ?? false;
    quran9Lesson6Part1Completed = prefs.getBool('quran9Lesson6Part1Completed') ?? false;
    quran9Lesson6Part2Completed = prefs.getBool('quran9Lesson6Part2Completed') ?? false;
    quran9Lesson6Part3Completed = prefs.getBool('quran9Lesson6Part3Completed') ?? false;
    quran9Lesson7Part1Completed = prefs.getBool('quran9Lesson7Part1Completed') ?? false;
    quran9Lesson7Part2Completed = prefs.getBool('quran9Lesson7Part2Completed') ?? false;
    quran9Lesson7Part3Completed = prefs.getBool('quran9Lesson7Part3Completed') ?? false;
    quran9Lesson8Part1Completed = prefs.getBool('quran9Lesson8Part1Completed') ?? false;
    quran9Lesson8Part2Completed = prefs.getBool('quran9Lesson8Part2Completed') ?? false;
    quran9Lesson8Part3Completed = prefs.getBool('quran9Lesson8Part3Completed') ?? false;
    quran9Lesson9Part1Completed = prefs.getBool('quran9Lesson9Part1Completed') ?? false;
    quran9Lesson9Part2Completed = prefs.getBool('quran9Lesson9Part2Completed') ?? false;
    quran9Lesson9Part3Completed = prefs.getBool('quran9Lesson9Part3Completed') ?? false;
    quran9Lesson10Part1Completed = prefs.getBool('quran9Lesson10Part1Completed') ?? false;
    quran9Lesson10Part2Completed = prefs.getBool('quran9Lesson10Part2Completed') ?? false;
    quran9Lesson10Part3Completed = prefs.getBool('quran9Lesson10Part3Completed') ?? false;
    quran9Lesson11Part1Completed = prefs.getBool('quran9Lesson11Part1Completed') ?? false;
    quran9Lesson11Part2Completed = prefs.getBool('quran9Lesson11Part2Completed') ?? false;
    quran9Lesson11Part3Completed = prefs.getBool('quran9Lesson11Part3Completed') ?? false;
    zaban7Lesson1Part1Completed = prefs.getBool('zaban7Lesson1Part1Completed') ?? false;
    zaban7Lesson1Part2Completed = prefs.getBool('zaban7Lesson1Part2Completed') ?? false;
    zaban7Lesson1Part3Completed = prefs.getBool('zaban7Lesson1Part3Completed') ?? false;
    zaban7WelcomePart1Completed = prefs.getBool('zaban7WelcomePart1Completed') ?? false;
    zaban7WelcomePart2Completed = prefs.getBool('zaban7WelcomePart2Completed') ?? false;
    zaban7WelcomePart3Completed = prefs.getBool('zaban7WelcomePart3Completed') ?? false;
    zaban7Lesson3Part1Completed = prefs.getBool('zaban7Lesson3Part1Completed') ?? false;
    zaban7Lesson3Part2Completed = prefs.getBool('zaban7Lesson3Part2Completed') ?? false;
    zaban7Lesson3Part3Completed = prefs.getBool('zaban7Lesson3Part3Completed') ?? false;
    zaban7Lesson4Part1Completed = prefs.getBool('zaban7Lesson4Part1Completed') ?? false;
    zaban7Lesson4Part2Completed = prefs.getBool('zaban7Lesson4Part2Completed') ?? false;
    zaban7Lesson4Part3Completed = prefs.getBool('zaban7Lesson4Part3Completed') ?? false;
    zaban7Lesson5Part1Completed = prefs.getBool('zaban7Lesson5Part1Completed') ?? false;
    zaban7Lesson5Part2Completed = prefs.getBool('zaban7Lesson5Part2Completed') ?? false;
    zaban7Lesson5Part3Completed = prefs.getBool('zaban7Lesson5Part3Completed') ?? false;
    zaban7Lesson6Part1Completed = prefs.getBool('zaban7Lesson6Part1Completed') ?? false;
    zaban7Lesson6Part2Completed = prefs.getBool('zaban7Lesson6Part2Completed') ?? false;
    zaban7Lesson6Part3Completed = prefs.getBool('zaban7Lesson6Part3Completed') ?? false;
    zaban7Lesson7Part1Completed = prefs.getBool('zaban7Lesson7Part1Completed') ?? false;
    zaban7Lesson7Part2Completed = prefs.getBool('zaban7Lesson7Part2Completed') ?? false;
    zaban7Lesson7Part3Completed = prefs.getBool('zaban7Lesson7Part3Completed') ?? false;
    zaban7Lesson8Part1Completed = prefs.getBool('zaban7Lesson8Part1Completed') ?? false;
    zaban7Lesson8Part2Completed = prefs.getBool('zaban7Lesson8Part2Completed') ?? false;
    zaban7Lesson8Part3Completed = prefs.getBool('zaban7Lesson8Part3Completed') ?? false;
    zaban8Lesson1Part1Completed = prefs.getBool('zaban8Lesson1Part1Completed') ?? false;
    zaban8Lesson1Part2Completed = prefs.getBool('zaban8Lesson1Part2Completed') ?? false;
    zaban8Lesson1Part3Completed = prefs.getBool('zaban8Lesson1Part3Completed') ?? false;
    zaban8Lesson2Part1Completed = prefs.getBool('zaban8Lesson2Part1Completed') ?? false;
    zaban8Lesson2Part2Completed = prefs.getBool('zaban8Lesson2Part2Completed') ?? false;
    zaban8Lesson2Part3Completed = prefs.getBool('zaban8Lesson2Part3Completed') ?? false;
    zaban8Lesson3Part1Completed = prefs.getBool('zaban8Lesson3Part1Completed') ?? false;
    zaban8Lesson3Part2Completed = prefs.getBool('zaban8Lesson3Part2Completed') ?? false;
    zaban8Lesson3Part3Completed = prefs.getBool('zaban8Lesson3Part3Completed') ?? false;
    zaban8Lesson4Part1Completed = prefs.getBool('zaban8Lesson4Part1Completed') ?? false;
    zaban8Lesson4Part2Completed = prefs.getBool('zaban8Lesson4Part2Completed') ?? false;
    zaban8Lesson4Part3Completed = prefs.getBool('zaban8Lesson4Part3Completed') ?? false;
    zaban8Lesson5Part1Completed = prefs.getBool('zaban8Lesson5Part1Completed') ?? false;
    zaban8Lesson5Part2Completed = prefs.getBool('zaban8Lesson5Part2Completed') ?? false;
    zaban8Lesson5Part3Completed = prefs.getBool('zaban8Lesson5Part3Completed') ?? false;
    zaban8Lesson6Part1Completed = prefs.getBool('zaban8Lesson6Part1Completed') ?? false;
    zaban8Lesson6Part2Completed = prefs.getBool('zaban8Lesson6Part2Completed') ?? false;
    zaban8Lesson6Part3Completed = prefs.getBool('zaban8Lesson6Part3Completed') ?? false;
    zaban8Lesson7Part1Completed = prefs.getBool('zaban8Lesson7Part1Completed') ?? false;
    zaban8Lesson7Part2Completed = prefs.getBool('zaban8Lesson7Part2Completed') ?? false;
    zaban8Lesson7Part3Completed = prefs.getBool('zaban8Lesson7Part3Completed') ?? false;
    zaban9Lesson1Part1Completed = prefs.getBool('zaban9Lesson1Part1Completed') ?? false;
    zaban9Lesson1Part2Completed = prefs.getBool('zaban9Lesson1Part2Completed') ?? false;
    zaban9Lesson1Part3Completed = prefs.getBool('zaban9Lesson1Part3Completed') ?? false;
    zaban9Lesson2Part1Completed = prefs.getBool('zaban9Lesson2Part1Completed') ?? false;
    zaban9Lesson2Part2Completed = prefs.getBool('zaban9Lesson2Part2Completed') ?? false;
    zaban9Lesson2Part3Completed = prefs.getBool('zaban9Lesson2Part3Completed') ?? false;
    zaban9Lesson3Part1Completed = prefs.getBool('zaban9Lesson3Part1Completed') ?? false;
    zaban9Lesson3Part2Completed = prefs.getBool('zaban9Lesson3Part2Completed') ?? false;
    zaban9Lesson3Part3Completed = prefs.getBool('zaban9Lesson3Part3Completed') ?? false;
    zaban9Lesson4Part1Completed = prefs.getBool('zaban9Lesson4Part1Completed') ?? false;
    zaban9Lesson4Part2Completed = prefs.getBool('zaban9Lesson4Part2Completed') ?? false;
    zaban9Lesson4Part3Completed = prefs.getBool('zaban9Lesson4Part3Completed') ?? false;
    zaban9Lesson5Part1Completed = prefs.getBool('zaban9Lesson5Part1Completed') ?? false;
    zaban9Lesson5Part2Completed = prefs.getBool('zaban9Lesson5Part2Completed') ?? false;
    zaban9Lesson5Part3Completed = prefs.getBool('zaban9Lesson5Part3Completed') ?? false;
    zaban9Lesson6Part1Completed = prefs.getBool('zaban9Lesson6Part1Completed') ?? false;
    zaban9Lesson6Part2Completed = prefs.getBool('zaban9Lesson6Part2Completed') ?? false;
    zaban9Lesson6Part3Completed = prefs.getBool('zaban9Lesson6Part3Completed') ?? false;
    farsi7Lesson1Part1Completed = prefs.getBool('farsi7Lesson1Part1Completed') ?? false;
    farsi7Lesson1Part2Completed = prefs.getBool('farsi7Lesson1Part2Completed') ?? false;
    farsi7Lesson1Part3Completed = prefs.getBool('farsi7Lesson1Part3Completed') ?? false;
    farsi7Lesson2Part1Completed = prefs.getBool('farsi7Lesson2Part1Completed') ?? false;
    farsi7Lesson2Part2Completed = prefs.getBool('farsi7Lesson2Part2Completed') ?? false;
    farsi7Lesson2Part3Completed = prefs.getBool('farsi7Lesson2Part3Completed') ?? false;
    farsi7Lesson3Part1Completed = prefs.getBool('farsi7Lesson3Part1Completed') ?? false;
    farsi7Lesson3Part2Completed = prefs.getBool('farsi7Lesson3Part2Completed') ?? false;
    farsi7Lesson3Part3Completed = prefs.getBool('farsi7Lesson3Part3Completed') ?? false;
    farsi7Lesson4Part1Completed = prefs.getBool('farsi7Lesson4Part1Completed') ?? false;
    farsi7Lesson4Part2Completed = prefs.getBool('farsi7Lesson4Part2Completed') ?? false;
    farsi7Lesson4Part3Completed = prefs.getBool('farsi7Lesson4Part3Completed') ?? false;
    farsi7Lesson5Part1Completed = prefs.getBool('farsi7Lesson5Part1Completed') ?? false;
    farsi7Lesson5Part2Completed = prefs.getBool('farsi7Lesson5Part2Completed') ?? false;
    farsi7Lesson5Part3Completed = prefs.getBool('farsi7Lesson5Part3Completed') ?? false;
    farsi7Lesson6Part1Completed = prefs.getBool('farsi7Lesson6Part1Completed') ?? false;
    farsi7Lesson6Part2Completed = prefs.getBool('farsi7Lesson6Part2Completed') ?? false;
    farsi7Lesson6Part3Completed = prefs.getBool('farsi7Lesson6Part3Completed') ?? false;
    farsi8Lesson1Part1Completed = prefs.getBool('farsi8Lesson1Part1Completed') ?? false;
    farsi8Lesson1Part2Completed = prefs.getBool('farsi8Lesson1Part2Completed') ?? false;
    farsi8Lesson1Part3Completed = prefs.getBool('farsi8Lesson1Part3Completed') ?? false;
    farsi8Lesson2Part1Completed = prefs.getBool('farsi8Lesson2Part1Completed') ?? false;
    farsi8Lesson2Part2Completed = prefs.getBool('farsi8Lesson2Part2Completed') ?? false;
    farsi8Lesson2Part3Completed = prefs.getBool('farsi8Lesson2Part3Completed') ?? false;
    farsi8Lesson3Part1Completed = prefs.getBool('farsi8Lesson3Part1Completed') ?? false;
    farsi8Lesson3Part2Completed = prefs.getBool('farsi8Lesson3Part2Completed') ?? false;
    farsi8Lesson3Part3Completed = prefs.getBool('farsi8Lesson3Part3Completed') ?? false;
    farsi8Lesson4Part1Completed = prefs.getBool('farsi8Lesson4Part1Completed') ?? false;
    farsi8Lesson4Part2Completed = prefs.getBool('farsi8Lesson4Part2Completed') ?? false;
    farsi8Lesson4Part3Completed = prefs.getBool('farsi8Lesson4Part3Completed') ?? false;
    farsi8Lesson5Part1Completed = prefs.getBool('farsi8Lesson5Part1Completed') ?? false;
    farsi8Lesson5Part2Completed = prefs.getBool('farsi8Lesson5Part2Completed') ?? false;
    farsi8Lesson5Part3Completed = prefs.getBool('farsi8Lesson5Part3Completed') ?? false;
    farsi8Lesson6Part1Completed = prefs.getBool('farsi8Lesson6Part1Completed') ?? false;
    farsi8Lesson6Part2Completed = prefs.getBool('farsi8Lesson6Part2Completed') ?? false;
    farsi8Lesson6Part3Completed = prefs.getBool('farsi8Lesson6Part3Completed') ?? false;
    farsi9Lesson1Part1Completed = prefs.getBool('farsi9Lesson1Part1Completed') ?? false;
    farsi9Lesson1Part2Completed = prefs.getBool('farsi9Lesson1Part2Completed') ?? false;
    farsi9Lesson1Part3Completed = prefs.getBool('farsi9Lesson1Part3Completed') ?? false;
    farsi9Lesson2Part1Completed = prefs.getBool('farsi9Lesson2Part1Completed') ?? false;
    farsi9Lesson2Part2Completed = prefs.getBool('farsi9Lesson2Part2Completed') ?? false;
    farsi9Lesson2Part3Completed = prefs.getBool('farsi9Lesson2Part3Completed') ?? false;
    farsi9Lesson3Part1Completed = prefs.getBool('farsi9Lesson3Part1Completed') ?? false;
    farsi9Lesson3Part2Completed = prefs.getBool('farsi9Lesson3Part2Completed') ?? false;
    farsi9Lesson3Part3Completed = prefs.getBool('farsi9Lesson3Part3Completed') ?? false;
    farsi9Lesson4Part1Completed = prefs.getBool('farsi9Lesson4Part1Completed') ?? false;
    farsi9Lesson4Part2Completed = prefs.getBool('farsi9Lesson4Part2Completed') ?? false;
    farsi9Lesson4Part3Completed = prefs.getBool('farsi9Lesson4Part3Completed') ?? false;
    farsi9Lesson5Part1Completed = prefs.getBool('farsi9Lesson5Part1Completed') ?? false;
    farsi9Lesson5Part2Completed = prefs.getBool('farsi9Lesson5Part2Completed') ?? false;
    farsi9Lesson5Part3Completed = prefs.getBool('farsi9Lesson5Part3Completed') ?? false;
    farsi9Lesson6Part1Completed = prefs.getBool('farsi9Lesson6Part1Completed') ?? false;
    farsi9Lesson6Part2Completed = prefs.getBool('farsi9Lesson6Part2Completed') ?? false;
    farsi9Lesson6Part3Completed = prefs.getBool('farsi9Lesson6Part3Completed') ?? false;
    payam7Lesson1Part1Completed = prefs.getBool('payam7Lesson1Part1Completed') ?? false;
    payam7Lesson1Part2Completed = prefs.getBool('payam7Lesson1Part2Completed') ?? false;
    payam7Lesson1Part3Completed = prefs.getBool('payam7Lesson1Part3Completed') ?? false;
    payam7Lesson2Part1Completed = prefs.getBool('payam7Lesson2Part1Completed') ?? false;
    payam7Lesson2Part2Completed = prefs.getBool('payam7Lesson2Part2Completed') ?? false;
    payam7Lesson2Part3Completed = prefs.getBool('payam7Lesson2Part3Completed') ?? false;
    payam7Lesson3Part1Completed = prefs.getBool('payam7Lesson3Part1Completed') ?? false;
    payam7Lesson3Part2Completed = prefs.getBool('payam7Lesson3Part2Completed') ?? false;
    payam7Lesson3Part3Completed = prefs.getBool('payam7Lesson3Part3Completed') ?? false;
    payam7Lesson4Part1Completed = prefs.getBool('payam7Lesson4Part1Completed') ?? false;
    payam7Lesson4Part2Completed = prefs.getBool('payam7Lesson4Part2Completed') ?? false;
    payam7Lesson4Part3Completed = prefs.getBool('payam7Lesson4Part3Completed') ?? false;
    payam7Lesson5Part1Completed = prefs.getBool('payam7Lesson5Part1Completed') ?? false;
    payam7Lesson5Part2Completed = prefs.getBool('payam7Lesson5Part2Completed') ?? false;
    payam7Lesson5Part3Completed = prefs.getBool('payam7Lesson5Part3Completed') ?? false;
    payam8Lesson1Part1Completed = prefs.getBool('payam8Lesson1Part1Completed') ?? false;
    payam8Lesson1Part2Completed = prefs.getBool('payam8Lesson1Part2Completed') ?? false;
    payam8Lesson1Part3Completed = prefs.getBool('payam8Lesson1Part3Completed') ?? false;
    payam8Lesson2Part1Completed = prefs.getBool('payam8Lesson2Part1Completed') ?? false;
    payam8Lesson2Part2Completed = prefs.getBool('payam8Lesson2Part2Completed') ?? false;
    payam8Lesson2Part3Completed = prefs.getBool('payam8Lesson2Part3Completed') ?? false;
    payam8Lesson3Part1Completed = prefs.getBool('payam8Lesson3Part1Completed') ?? false;
    payam8Lesson3Part2Completed = prefs.getBool('payam8Lesson3Part2Completed') ?? false;
    payam8Lesson3Part3Completed = prefs.getBool('payam8Lesson3Part3Completed') ?? false;
    payam8Lesson4Part1Completed = prefs.getBool('payam8Lesson4Part1Completed') ?? false;
    payam8Lesson4Part2Completed = prefs.getBool('payam8Lesson4Part2Completed') ?? false;
    payam8Lesson4Part3Completed = prefs.getBool('payam8Lesson4Part3Completed') ?? false;
    payam8Lesson5Part1Completed = prefs.getBool('payam8Lesson5Part1Completed') ?? false;
    payam8Lesson5Part2Completed = prefs.getBool('payam8Lesson5Part2Completed') ?? false;
    payam8Lesson5Part3Completed = prefs.getBool('payam8Lesson5Part3Completed') ?? false;
    payam8Lesson6Part1Completed = prefs.getBool('payam8Lesson6Part1Completed') ?? false;
    payam8Lesson6Part2Completed = prefs.getBool('payam8Lesson6Part2Completed') ?? false;
    payam8Lesson6Part3Completed = prefs.getBool('payam8Lesson6Part3Completed') ?? false;
    payam9Lesson1Part1Completed = prefs.getBool('payam9Lesson1Part1Completed') ?? false;
    payam9Lesson1Part2Completed = prefs.getBool('payam9Lesson1Part2Completed') ?? false;
    payam9Lesson1Part3Completed = prefs.getBool('payam9Lesson1Part3Completed') ?? false;
    payam9Lesson2Part1Completed = prefs.getBool('payam9Lesson2Part1Completed') ?? false;
    payam9Lesson2Part2Completed = prefs.getBool('payam9Lesson2Part2Completed') ?? false;
    payam9Lesson2Part3Completed = prefs.getBool('payam9Lesson2Part3Completed') ?? false;
    payam9Lesson3Part1Completed = prefs.getBool('payam9Lesson3Part1Completed') ?? false;
    payam9Lesson3Part2Completed = prefs.getBool('payam9Lesson3Part2Completed') ?? false;
    payam9Lesson3Part3Completed = prefs.getBool('payam9Lesson3Part3Completed') ?? false;
    payam9Lesson4Part1Completed = prefs.getBool('payam9Lesson4Part1Completed') ?? false;
    payam9Lesson4Part2Completed = prefs.getBool('payam9Lesson4Part2Completed') ?? false;
    payam9Lesson4Part3Completed = prefs.getBool('payam9Lesson4Part3Completed') ?? false;
    payam9Lesson5Part1Completed = prefs.getBool('payam9Lesson5Part1Completed') ?? false;
    payam9Lesson5Part2Completed = prefs.getBool('payam9Lesson5Part2Completed') ?? false;
    payam9Lesson5Part3Completed = prefs.getBool('payam9Lesson5Part3Completed') ?? false;
    motaleat7Lesson1Part1Completed = prefs.getBool('motaleat7Lesson1Part1Completed') ?? false;
    motaleat7Lesson1Part2Completed = prefs.getBool('motaleat7Lesson1Part2Completed') ?? false;
    motaleat7Lesson1Part3Completed = prefs.getBool('motaleat7Lesson1Part3Completed') ?? false;
    motaleat7Lesson2Part1Completed = prefs.getBool('motaleat7Lesson2Part1Completed') ?? false;
    motaleat7Lesson2Part2Completed = prefs.getBool('motaleat7Lesson2Part2Completed') ?? false;
    motaleat7Lesson2Part3Completed = prefs.getBool('motaleat7Lesson2Part3Completed') ?? false;
    motaleat7Lesson3Part1Completed = prefs.getBool('motaleat7Lesson3Part1Completed') ?? false;
    motaleat7Lesson3Part2Completed = prefs.getBool('motaleat7Lesson3Part2Completed') ?? false;
    motaleat7Lesson3Part3Completed = prefs.getBool('motaleat7Lesson3Part3Completed') ?? false;
    motaleat7Lesson4Part1Completed = prefs.getBool('motaleat7Lesson4Part1Completed') ?? false;
    motaleat7Lesson4Part2Completed = prefs.getBool('motaleat7Lesson4Part2Completed') ?? false;
    motaleat7Lesson4Part3Completed = prefs.getBool('motaleat7Lesson4Part3Completed') ?? false;
    motaleat7Lesson5Part1Completed = prefs.getBool('motaleat7Lesson5Part1Completed') ?? false;
    motaleat7Lesson5Part2Completed = prefs.getBool('motaleat7Lesson5Part2Completed') ?? false;
    motaleat7Lesson5Part3Completed = prefs.getBool('motaleat7Lesson5Part3Completed') ?? false;
    motaleat7Lesson6Part1Completed = prefs.getBool('motaleat7Lesson6Part1Completed') ?? false;
    motaleat7Lesson6Part2Completed = prefs.getBool('motaleat7Lesson6Part2Completed') ?? false;
    motaleat7Lesson6Part3Completed = prefs.getBool('motaleat7Lesson6Part3Completed') ?? false;
    motaleat7Lesson7Part1Completed = prefs.getBool('motaleat7Lesson7Part1Completed') ?? false;
    motaleat7Lesson7Part2Completed = prefs.getBool('motaleat7Lesson7Part2Completed') ?? false;
    motaleat7Lesson7Part3Completed = prefs.getBool('motaleat7Lesson7Part3Completed') ?? false;
    motaleat7Lesson8Part1Completed = prefs.getBool('motaleat7Lesson8Part1Completed') ?? false;
    motaleat7Lesson8Part2Completed = prefs.getBool('motaleat7Lesson8Part2Completed') ?? false;
    motaleat7Lesson8Part3Completed = prefs.getBool('motaleat7Lesson8Part3Completed') ?? false;
    motaleat7Lesson9Part1Completed = prefs.getBool('motaleat7Lesson9Part1Completed') ?? false;
    motaleat7Lesson9Part2Completed = prefs.getBool('motaleat7Lesson9Part2Completed') ?? false;
    motaleat7Lesson9Part3Completed = prefs.getBool('motaleat7Lesson9Part3Completed') ?? false;
    motaleat7Lesson10Part1Completed = prefs.getBool('motaleat7Lesson10Part1Completed') ?? false;
    motaleat7Lesson10Part2Completed = prefs.getBool('motaleat7Lesson10Part2Completed') ?? false;
    motaleat7Lesson10Part3Completed = prefs.getBool('motaleat7Lesson10Part3Completed') ?? false;
    motaleat7Lesson11Part1Completed = prefs.getBool('motaleat7Lesson11Part1Completed') ?? false;
    motaleat7Lesson11Part2Completed = prefs.getBool('motaleat7Lesson11Part2Completed') ?? false;
    motaleat7Lesson11Part3Completed = prefs.getBool('motaleat7Lesson11Part3Completed') ?? false;
    motaleat7Lesson12Part1Completed = prefs.getBool('motaleat7Lesson12Part1Completed') ?? false;
    motaleat7Lesson12Part2Completed = prefs.getBool('motaleat7Lesson12Part2Completed') ?? false;
    motaleat7Lesson12Part3Completed = prefs.getBool('motaleat7Lesson12Part3Completed') ?? false;
    motaleat8Lesson1Part1Completed = prefs.getBool('motaleat8Lesson1Part1Completed') ?? false;
    motaleat8Lesson1Part2Completed = prefs.getBool('motaleat8Lesson1Part2Completed') ?? false;
    motaleat8Lesson1Part3Completed = prefs.getBool('motaleat8Lesson1Part3Completed') ?? false;
    motaleat8Lesson2Part1Completed = prefs.getBool('motaleat8Lesson2Part1Completed') ?? false;
    motaleat8Lesson2Part2Completed = prefs.getBool('motaleat8Lesson2Part2Completed') ?? false;
    motaleat8Lesson2Part3Completed = prefs.getBool('motaleat8Lesson2Part3Completed') ?? false;
    motaleat8Lesson3Part1Completed = prefs.getBool('motaleat8Lesson3Part1Completed') ?? false;
    motaleat8Lesson3Part2Completed = prefs.getBool('motaleat8Lesson3Part2Completed') ?? false;
    motaleat8Lesson3Part3Completed = prefs.getBool('motaleat8Lesson3Part3Completed') ?? false;
    motaleat8Lesson4Part1Completed = prefs.getBool('motaleat8Lesson4Part1Completed') ?? false;
    motaleat8Lesson4Part2Completed = prefs.getBool('motaleat8Lesson4Part2Completed') ?? false;
    motaleat8Lesson4Part3Completed = prefs.getBool('motaleat8Lesson4Part3Completed') ?? false;
    motaleat8Lesson5Part1Completed = prefs.getBool('motaleat8Lesson5Part1Completed') ?? false;
    motaleat8Lesson5Part2Completed = prefs.getBool('motaleat8Lesson5Part2Completed') ?? false;
    motaleat8Lesson5Part3Completed = prefs.getBool('motaleat8Lesson5Part3Completed') ?? false;
    motaleat8Lesson6Part1Completed = prefs.getBool('motaleat8Lesson6Part1Completed') ?? false;
    motaleat8Lesson6Part2Completed = prefs.getBool('motaleat8Lesson6Part2Completed') ?? false;
    motaleat8Lesson6Part3Completed = prefs.getBool('motaleat8Lesson6Part3Completed') ?? false;
    motaleat8Lesson7Part1Completed = prefs.getBool('motaleat8Lesson7Part1Completed') ?? false;
    motaleat8Lesson7Part2Completed = prefs.getBool('motaleat8Lesson7Part2Completed') ?? false;
    motaleat8Lesson7Part3Completed = prefs.getBool('motaleat8Lesson7Part3Completed') ?? false;
    motaleat8Lesson8Part1Completed = prefs.getBool('motaleat8Lesson8Part1Completed') ?? false;
    motaleat8Lesson8Part2Completed = prefs.getBool('motaleat8Lesson8Part2Completed') ?? false;
    motaleat8Lesson8Part3Completed = prefs.getBool('motaleat8Lesson8Part3Completed') ?? false;
    motaleat8Lesson9Part1Completed = prefs.getBool('motaleat8Lesson9Part1Completed') ?? false;
    motaleat8Lesson9Part2Completed = prefs.getBool('motaleat8Lesson9Part2Completed') ?? false;
    motaleat8Lesson9Part3Completed = prefs.getBool('motaleat8Lesson9Part3Completed') ?? false;
    motaleat8Lesson10Part1Completed = prefs.getBool('motaleat8Lesson10Part1Completed') ?? false;
    motaleat8Lesson10Part2Completed = prefs.getBool('motaleat8Lesson10Part2Completed') ?? false;
    motaleat8Lesson10Part3Completed = prefs.getBool('motaleat8Lesson10Part3Completed') ?? false;
    motaleat8Lesson11Part1Completed = prefs.getBool('motaleat8Lesson11Part1Completed') ?? false;
    motaleat8Lesson11Part2Completed = prefs.getBool('motaleat8Lesson11Part2Completed') ?? false;
    motaleat8Lesson11Part3Completed = prefs.getBool('motaleat8Lesson11Part3Completed') ?? false;
    motaleat8Lesson12Part1Completed = prefs.getBool('motaleat8Lesson12Part1Completed') ?? false;
    motaleat8Lesson12Part2Completed = prefs.getBool('motaleat8Lesson12Part2Completed') ?? false;
    motaleat8Lesson12Part3Completed = prefs.getBool('motaleat8Lesson12Part3Completed') ?? false;

    motaleat9Lesson1Part1Completed = prefs.getBool('motaleat9Lesson1Part1Completed') ?? false;
    motaleat9Lesson1Part2Completed = prefs.getBool('motaleat9Lesson1Part2Completed') ?? false;
    motaleat9Lesson1Part3Completed = prefs.getBool('motaleat9Lesson1Part3Completed') ?? false;
    motaleat9Lesson2Part1Completed = prefs.getBool('motaleat9Lesson2Part1Completed') ?? false;
    motaleat9Lesson2Part2Completed = prefs.getBool('motaleat9Lesson2Part2Completed') ?? false;
    motaleat9Lesson2Part3Completed = prefs.getBool('motaleat9Lesson2Part3Completed') ?? false;
    motaleat9Lesson3Part1Completed = prefs.getBool('motaleat9Lesson3Part1Completed') ?? false;
    motaleat9Lesson3Part2Completed = prefs.getBool('motaleat9Lesson3Part2Completed') ?? false;
    motaleat9Lesson3Part3Completed = prefs.getBool('motaleat9Lesson3Part3Completed') ?? false;
    motaleat9Lesson4Part1Completed = prefs.getBool('motaleat9Lesson4Part1Completed') ?? false;
    motaleat9Lesson4Part2Completed = prefs.getBool('motaleat9Lesson4Part2Completed') ?? false;
    motaleat9Lesson4Part3Completed = prefs.getBool('motaleat9Lesson4Part3Completed') ?? false;
    motaleat9Lesson5Part1Completed = prefs.getBool('motaleat9Lesson5Part1Completed') ?? false;
    motaleat9Lesson5Part2Completed = prefs.getBool('motaleat9Lesson5Part2Completed') ?? false;
    motaleat9Lesson5Part3Completed = prefs.getBool('motaleat9Lesson5Part3Completed') ?? false;
    motaleat9Lesson6Part1Completed = prefs.getBool('motaleat9Lesson6Part1Completed') ?? false;
    motaleat9Lesson6Part2Completed = prefs.getBool('motaleat9Lesson6Part2Completed') ?? false;
    motaleat9Lesson6Part3Completed = prefs.getBool('motaleat9Lesson6Part3Completed') ?? false;
    motaleat9Lesson7Part1Completed = prefs.getBool('motaleat9Lesson7Part1Completed') ?? false;
    motaleat9Lesson7Part2Completed = prefs.getBool('motaleat9Lesson7Part2Completed') ?? false;
    motaleat9Lesson7Part3Completed = prefs.getBool('motaleat9Lesson7Part3Completed') ?? false;
    motaleat9Lesson8Part1Completed = prefs.getBool('motaleat9Lesson8Part1Completed') ?? false;
    motaleat9Lesson8Part2Completed = prefs.getBool('motaleat9Lesson8Part2Completed') ?? false;
    motaleat9Lesson8Part3Completed = prefs.getBool('motaleat9Lesson8Part3Completed') ?? false;
    motaleat9Lesson9Part1Completed = prefs.getBool('motaleat9Lesson9Part1Completed') ?? false;
    motaleat9Lesson9Part2Completed = prefs.getBool('motaleat9Lesson9Part2Completed') ?? false;
    motaleat9Lesson9Part3Completed = prefs.getBool('motaleat9Lesson9Part3Completed') ?? false;
    motaleat9Lesson10Part1Completed = prefs.getBool('motaleat9Lesson10Part1Completed') ?? false;
    motaleat9Lesson10Part2Completed = prefs.getBool('motaleat9Lesson10Part2Completed') ?? false;
    motaleat9Lesson10Part3Completed = prefs.getBool('motaleat9Lesson10Part3Completed') ?? false;
    motaleat9Lesson11Part1Completed = prefs.getBool('motaleat9Lesson11Part1Completed') ?? false;
    motaleat9Lesson11Part2Completed = prefs.getBool('motaleat9Lesson11Part2Completed') ?? false;
    motaleat9Lesson11Part3Completed = prefs.getBool('motaleat9Lesson11Part3Completed') ?? false;
    motaleat9Lesson12Part1Completed = prefs.getBool('motaleat9Lesson12Part1Completed') ?? false;
    motaleat9Lesson12Part2Completed = prefs.getBool('motaleat9Lesson12Part2Completed') ?? false;
    motaleat9Lesson12Part3Completed = prefs.getBool('motaleat9Lesson12Part3Completed') ?? false;
    zaban9Lesson5Part2Completed = prefs.getBool('zaban9Lesson5Part2Completed') ?? false;
    zaban9Lesson5Part3Completed = prefs.getBool('zaban9Lesson5Part3Completed') ?? false;
    zaban8Lesson2Part2Completed = prefs.getBool('zaban8Lesson2Part2Completed') ?? false;
    zaban8Lesson2Part3Completed = prefs.getBool('zaban8Lesson2Part3Completed') ?? false;

    if (isLoggedIn && phoneNumber.isNotEmpty) {
      await loadUserData(phoneNumber);
    } else {
      await logoutClean();
    }
  }

  // بارگذاری داده‌های اختصاصی یک شماره خاص (کیف پول، آواتارها، تم‌ها و خریدهای VIP)
  static Future<void> loadUserData(String phone) async {
    phoneNumber = phone;
    final prefs = await SharedPreferences.getInstance();
    coins = prefs.getInt('coins_$phone') ?? 0;
    currentTheme = prefs.getString('currentTheme_$phone') ?? 'royal_purple';
    unlockedAvatars = prefs.getStringList('unlockedAvatars_$phone') ?? [...defaultAvatars];
    unlockedThemes = prefs.getStringList('unlockedThemes_$phone') ?? ['royal_purple'];
    purchasedVipItems = prefs.getStringList('purchasedVipItems_$phone') ?? [];
    userName = prefs.getString('userName_$phone') ?? prefs.getString('userName') ?? '';
    userAvatar = prefs.getString('userAvatar_$phone') ?? prefs.getString('userAvatar') ?? '';
    selectedGrade = prefs.getInt('selectedGrade_$phone') ?? prefs.getInt('selectedGrade') ?? selectedGrade;
    lesson1Part1Completed = prefs.getBool('lesson1Part1Completed_$phone') ?? false;
    lesson1Part2Completed = prefs.getBool('lesson1Part2Completed_$phone') ?? false;
    lesson1Part3Completed = prefs.getBool('lesson1Part3Completed_$phone') ?? false;
    lesson2Part1Completed = prefs.getBool('lesson2Part1Completed_$phone') ?? false;
    lesson2Part2Completed = prefs.getBool('lesson2Part2Completed_$phone') ?? false;
    lesson2Part3Completed = prefs.getBool('lesson2Part3Completed_$phone') ?? false;
    lesson3Part1Completed = prefs.getBool('lesson3Part1Completed_$phone') ?? false;
    lesson3Part2Completed = prefs.getBool('lesson3Part2Completed_$phone') ?? false;
    lesson3Part3Completed = prefs.getBool('lesson3Part3Completed_$phone') ?? false;
    lesson4Part1Completed = prefs.getBool('lesson4Part1Completed_$phone') ?? false;
    lesson4Part2Completed = prefs.getBool('lesson4Part2Completed_$phone') ?? false;
    lesson4Part3Completed = prefs.getBool('lesson4Part3Completed_$phone') ?? false;
    lesson5Part1Completed = prefs.getBool('lesson5Part1Completed_$phone') ?? false;
    lesson5Part2Completed = prefs.getBool('lesson5Part2Completed_$phone') ?? false;
    lesson5Part3Completed = prefs.getBool('lesson5Part3Completed_$phone') ?? false;
    lesson6Part1Completed = prefs.getBool('lesson6Part1Completed_$phone') ?? false;
    lesson6Part2Completed = prefs.getBool('lesson6Part2Completed_$phone') ?? false;
    lesson6Part3Completed = prefs.getBool('lesson6Part3Completed_$phone') ?? false;
    lesson7Part1Completed = prefs.getBool('lesson7Part1Completed_$phone') ?? false;
    lesson7Part2Completed = prefs.getBool('lesson7Part2Completed_$phone') ?? false;
    lesson7Part3Completed = prefs.getBool('lesson7Part3Completed_$phone') ?? false;
    lesson8Part1Completed = prefs.getBool('lesson8Part1Completed_$phone') ?? false;
    lesson8Part2Completed = prefs.getBool('lesson8Part2Completed_$phone') ?? false;
    lesson8Part3Completed = prefs.getBool('lesson8Part3Completed_$phone') ?? false;
    lesson9Part1Completed = prefs.getBool('lesson9Part1Completed_$phone') ?? false;
    lesson9Part2Completed = prefs.getBool('lesson9Part2Completed_$phone') ?? false;
    lesson9Part3Completed = prefs.getBool('lesson9Part3Completed_$phone') ?? false;
    lesson10Part1Completed = prefs.getBool('lesson10Part1Completed_$phone') ?? false;
    lesson10Part2Completed = prefs.getBool('lesson10Part2Completed_$phone') ?? false;
    lesson10Part3Completed = prefs.getBool('lesson10Part3Completed_$phone') ?? false;
    lesson11Part1Completed = prefs.getBool('lesson11Part1Completed_$phone') ?? false;
    lesson11Part2Completed = prefs.getBool('lesson11Part2Completed_$phone') ?? false;
    lesson11Part3Completed = prefs.getBool('lesson11Part3Completed_$phone') ?? false;
    lesson12Part1Completed = prefs.getBool('lesson12Part1Completed_$phone') ?? false;
    lesson12Part2Completed = prefs.getBool('lesson12Part2Completed_$phone') ?? false;
    lesson12Part3Completed = prefs.getBool('lesson12Part3Completed_$phone') ?? false;
    lesson13Part1Completed = prefs.getBool('lesson13Part1Completed_$phone') ?? false;
    lesson13Part2Completed = prefs.getBool('lesson13Part2Completed_$phone') ?? false;
    lesson13Part3Completed = prefs.getBool('lesson13Part3Completed_$phone') ?? false;
    lesson14Part1Completed = prefs.getBool('lesson14Part1Completed_$phone') ?? false;
    lesson14Part2Completed = prefs.getBool('lesson14Part2Completed_$phone') ?? false;
    lesson14Part3Completed = prefs.getBool('lesson14Part3Completed_$phone') ?? false;
    lesson15Part1Completed = prefs.getBool('lesson15Part1Completed_$phone') ?? false;
    lesson15Part2Completed = prefs.getBool('lesson15Part2Completed_$phone') ?? false;
    lesson15Part3Completed = prefs.getBool('lesson15Part3Completed_$phone') ?? false;
    lesson16Part1Completed = prefs.getBool('lesson16Part1Completed_$phone') ?? false;
    lesson16Part2Completed = prefs.getBool('lesson16Part2Completed_$phone') ?? false;
    lesson16Part3Completed = prefs.getBool('lesson16Part3Completed_$phone') ?? false;
    lesson17Part1Completed = prefs.getBool('lesson17Part1Completed_$phone') ?? false;
    lesson17Part2Completed = prefs.getBool('lesson17Part2Completed_$phone') ?? false;
    lesson17Part3Completed = prefs.getBool('lesson17Part3Completed_$phone') ?? false;
    lesson18Part1Completed = prefs.getBool('lesson18Part1Completed_$phone') ?? false;
    lesson18Part2Completed = prefs.getBool('lesson18Part2Completed_$phone') ?? false;
    lesson18Part3Completed = prefs.getBool('lesson18Part3Completed_$phone') ?? false;
    lesson19Part1Completed = prefs.getBool('lesson19Part1Completed_$phone') ?? false;
    lesson19Part2Completed = prefs.getBool('lesson19Part2Completed_$phone') ?? false;
    lesson19Part3Completed = prefs.getBool('lesson19Part3Completed_$phone') ?? false;
    lesson20Part1Completed = prefs.getBool('lesson20Part1Completed_$phone') ?? false;
    lesson20Part2Completed = prefs.getBool('lesson20Part2Completed_$phone') ?? false;
    lesson20Part3Completed = prefs.getBool('lesson20Part3Completed_$phone') ?? false;
    arabic8Lesson1Part1Completed = prefs.getBool('arabic8Lesson1Part1Completed_$phone') ?? false;
    arabic8Lesson1Part2Completed = prefs.getBool('arabic8Lesson1Part2Completed_$phone') ?? false;
    arabic8Lesson1Part3Completed = prefs.getBool('arabic8Lesson1Part3Completed_$phone') ?? false;
    arabic8Lesson2Part1Completed = prefs.getBool('arabic8Lesson2Part1Completed_$phone') ?? false;
    arabic8Lesson2Part2Completed = prefs.getBool('arabic8Lesson2Part2Completed_$phone') ?? false;
    arabic8Lesson2Part3Completed = prefs.getBool('arabic8Lesson2Part3Completed_$phone') ?? false;
    arabic8Lesson3Part1Completed = prefs.getBool('arabic8Lesson3Part1Completed_$phone') ?? false;
    arabic8Lesson3Part2Completed = prefs.getBool('arabic8Lesson3Part2Completed_$phone') ?? false;
    arabic8Lesson3Part3Completed = prefs.getBool('arabic8Lesson3Part3Completed_$phone') ?? false;
    arabic8Lesson4Part1Completed = prefs.getBool('arabic8Lesson4Part1Completed_$phone') ?? false;
    arabic8Lesson4Part2Completed = prefs.getBool('arabic8Lesson4Part2Completed_$phone') ?? false;
    arabic8Lesson4Part3Completed = prefs.getBool('arabic8Lesson4Part3Completed_$phone') ?? false;
    arabic8Lesson5Part1Completed = prefs.getBool('arabic8Lesson5Part1Completed_$phone') ?? false;
    arabic8Lesson5Part2Completed = prefs.getBool('arabic8Lesson5Part2Completed_$phone') ?? false;
    arabic8Lesson5Part3Completed = prefs.getBool('arabic8Lesson5Part3Completed_$phone') ?? false;
    arabic8Lesson6Part1Completed = prefs.getBool('arabic8Lesson6Part1Completed_$phone') ?? false;
    arabic8Lesson6Part2Completed = prefs.getBool('arabic8Lesson6Part2Completed_$phone') ?? false;
    arabic8Lesson6Part3Completed = prefs.getBool('arabic8Lesson6Part3Completed_$phone') ?? false;
    arabic8Lesson7Part1Completed = prefs.getBool('arabic8Lesson7Part1Completed_$phone') ?? false;
    arabic8Lesson7Part2Completed = prefs.getBool('arabic8Lesson7Part2Completed_$phone') ?? false;
    arabic8Lesson7Part3Completed = prefs.getBool('arabic8Lesson7Part3Completed_$phone') ?? false;
    arabic8Lesson8Part1Completed = prefs.getBool('arabic8Lesson8Part1Completed_$phone') ?? false;
    arabic8Lesson8Part2Completed = prefs.getBool('arabic8Lesson8Part2Completed_$phone') ?? false;
    arabic8Lesson8Part3Completed = prefs.getBool('arabic8Lesson8Part3Completed_$phone') ?? false;
    arabic8Lesson9Part1Completed = prefs.getBool('arabic8Lesson9Part1Completed_$phone') ?? false;
    arabic8Lesson9Part2Completed = prefs.getBool('arabic8Lesson9Part2Completed_$phone') ?? false;
    arabic8Lesson9Part3Completed = prefs.getBool('arabic8Lesson9Part3Completed_$phone') ?? false;
    arabic8Lesson10Part1Completed = prefs.getBool('arabic8Lesson10Part1Completed_$phone') ?? false;
    arabic8Lesson10Part2Completed = prefs.getBool('arabic8Lesson10Part2Completed_$phone') ?? false;
    arabic8Lesson10Part3Completed = prefs.getBool('arabic8Lesson10Part3Completed_$phone') ?? false;
    arabic9Lesson1Part1Completed = prefs.getBool('arabic9Lesson1Part1Completed_$phone') ?? false;
    arabic9Lesson1Part2Completed = prefs.getBool('arabic9Lesson1Part2Completed_$phone') ?? false;
    arabic9Lesson1Part3Completed = prefs.getBool('arabic9Lesson1Part3Completed_$phone') ?? false;
    arabic9Lesson2Part1Completed = prefs.getBool('arabic9Lesson2Part1Completed_$phone') ?? false;
    arabic9Lesson2Part2Completed = prefs.getBool('arabic9Lesson2Part2Completed_$phone') ?? false;
    arabic9Lesson2Part3Completed = prefs.getBool('arabic9Lesson2Part3Completed_$phone') ?? false;
    arabic9Lesson3Part1Completed = prefs.getBool('arabic9Lesson3Part1Completed_$phone') ?? false;
    arabic9Lesson3Part2Completed = prefs.getBool('arabic9Lesson3Part2Completed_$phone') ?? false;
    arabic9Lesson3Part3Completed = prefs.getBool('arabic9Lesson3Part3Completed_$phone') ?? false;
    arabic9Lesson4Part1Completed = prefs.getBool('arabic9Lesson4Part1Completed_$phone') ?? false;
    arabic9Lesson4Part2Completed = prefs.getBool('arabic9Lesson4Part2Completed_$phone') ?? false;
    arabic9Lesson4Part3Completed = prefs.getBool('arabic9Lesson4Part3Completed_$phone') ?? false;
    arabic9Lesson5Part1Completed = prefs.getBool('arabic9Lesson5Part1Completed_$phone') ?? false;
    arabic9Lesson5Part2Completed = prefs.getBool('arabic9Lesson5Part2Completed_$phone') ?? false;
    arabic9Lesson5Part3Completed = prefs.getBool('arabic9Lesson5Part3Completed_$phone') ?? false;
    arabic9Lesson6Part1Completed = prefs.getBool('arabic9Lesson6Part1Completed_$phone') ?? false;
    arabic9Lesson6Part2Completed = prefs.getBool('arabic9Lesson6Part2Completed_$phone') ?? false;
    arabic9Lesson6Part3Completed = prefs.getBool('arabic9Lesson6Part3Completed_$phone') ?? false;
    arabic9Lesson7Part1Completed = prefs.getBool('arabic9Lesson7Part1Completed_$phone') ?? false;
    arabic9Lesson7Part2Completed = prefs.getBool('arabic9Lesson7Part2Completed_$phone') ?? false;
    arabic9Lesson7Part3Completed = prefs.getBool('arabic9Lesson7Part3Completed_$phone') ?? false;
    arabic9Lesson8Part1Completed = prefs.getBool('arabic9Lesson8Part1Completed_$phone') ?? false;
    arabic9Lesson8Part2Completed = prefs.getBool('arabic9Lesson8Part2Completed_$phone') ?? false;
    arabic9Lesson8Part3Completed = prefs.getBool('arabic9Lesson8Part3Completed_$phone') ?? false;
    arabic9Lesson9Part1Completed = prefs.getBool('arabic9Lesson9Part1Completed_$phone') ?? false;
    arabic9Lesson9Part2Completed = prefs.getBool('arabic9Lesson9Part2Completed_$phone') ?? false;
    arabic9Lesson9Part3Completed = prefs.getBool('arabic9Lesson9Part3Completed_$phone') ?? false;
    arabic9Lesson10Part1Completed = prefs.getBool('arabic9Lesson10Part1Completed_$phone') ?? false;
    arabic9Lesson10Part2Completed = prefs.getBool('arabic9Lesson10Part2Completed_$phone') ?? false;
    arabic9Lesson10Part3Completed = prefs.getBool('arabic9Lesson10Part3Completed_$phone') ?? false;
    quran7Lesson1Part1Completed = prefs.getBool('quran7Lesson1Part1Completed_$phone') ?? false;
    quran7Lesson1Part2Completed = prefs.getBool('quran7Lesson1Part2Completed_$phone') ?? false;
    quran7Lesson1Part3Completed = prefs.getBool('quran7Lesson1Part3Completed_$phone') ?? false;
    quran7Lesson2Part1Completed = prefs.getBool('quran7Lesson2Part1Completed_$phone') ?? false;
    quran7Lesson2Part2Completed = prefs.getBool('quran7Lesson2Part2Completed_$phone') ?? false;
    quran7Lesson2Part3Completed = prefs.getBool('quran7Lesson2Part3Completed_$phone') ?? false;
    quran7Lesson3Part1Completed = prefs.getBool('quran7Lesson3Part1Completed_$phone') ?? false;
    quran7Lesson3Part2Completed = prefs.getBool('quran7Lesson3Part2Completed_$phone') ?? false;
    quran7Lesson3Part3Completed = prefs.getBool('quran7Lesson3Part3Completed_$phone') ?? false;
    quran7Lesson4Part1Completed = prefs.getBool('quran7Lesson4Part1Completed_$phone') ?? false;
    quran7Lesson4Part2Completed = prefs.getBool('quran7Lesson4Part2Completed_$phone') ?? false;
    quran7Lesson4Part3Completed = prefs.getBool('quran7Lesson4Part3Completed_$phone') ?? false;
    quran7Lesson5Part1Completed = prefs.getBool('quran7Lesson5Part1Completed_$phone') ?? false;
    quran7Lesson5Part2Completed = prefs.getBool('quran7Lesson5Part2Completed_$phone') ?? false;
    quran7Lesson5Part3Completed = prefs.getBool('quran7Lesson5Part3Completed_$phone') ?? false;
    quran7Lesson6Part1Completed = prefs.getBool('quran7Lesson6Part1Completed_$phone') ?? false;
    quran7Lesson6Part2Completed = prefs.getBool('quran7Lesson6Part2Completed_$phone') ?? false;
    quran7Lesson6Part3Completed = prefs.getBool('quran7Lesson6Part3Completed_$phone') ?? false;
    quran7Lesson7Part1Completed = prefs.getBool('quran7Lesson7Part1Completed_$phone') ?? false;
    quran7Lesson7Part2Completed = prefs.getBool('quran7Lesson7Part2Completed_$phone') ?? false;
    quran7Lesson7Part3Completed = prefs.getBool('quran7Lesson7Part3Completed_$phone') ?? false;
    quran7Lesson8Part1Completed = prefs.getBool('quran7Lesson8Part1Completed_$phone') ?? false;
    quran7Lesson8Part2Completed = prefs.getBool('quran7Lesson8Part2Completed_$phone') ?? false;
    quran7Lesson8Part3Completed = prefs.getBool('quran7Lesson8Part3Completed_$phone') ?? false;
    quran7Lesson9Part1Completed = prefs.getBool('quran7Lesson9Part1Completed_$phone') ?? false;
    quran7Lesson9Part2Completed = prefs.getBool('quran7Lesson9Part2Completed_$phone') ?? false;
    quran7Lesson9Part3Completed = prefs.getBool('quran7Lesson9Part3Completed_$phone') ?? false;
    quran7Lesson10Part1Completed = prefs.getBool('quran7Lesson10Part1Completed_$phone') ?? false;
    quran7Lesson10Part2Completed = prefs.getBool('quran7Lesson10Part2Completed_$phone') ?? false;
    quran7Lesson10Part3Completed = prefs.getBool('quran7Lesson10Part3Completed_$phone') ?? false;
    quran7Lesson11Part1Completed = prefs.getBool('quran7Lesson11Part1Completed_$phone') ?? false;
    quran7Lesson11Part2Completed = prefs.getBool('quran7Lesson11Part2Completed_$phone') ?? false;
    quran7Lesson11Part3Completed = prefs.getBool('quran7Lesson11Part3Completed_$phone') ?? false;
    quran7Lesson12Part1Completed = prefs.getBool('quran7Lesson12Part1Completed_$phone') ?? false;
    quran7Lesson12Part2Completed = prefs.getBool('quran7Lesson12Part2Completed_$phone') ?? false;
    quran7Lesson12Part3Completed = prefs.getBool('quran7Lesson12Part3Completed_$phone') ?? false;
    quran8Lesson1Part1Completed = prefs.getBool('quran8Lesson1Part1Completed_$phone') ?? false;
    quran8Lesson1Part2Completed = prefs.getBool('quran8Lesson1Part2Completed_$phone') ?? false;
    quran8Lesson1Part3Completed = prefs.getBool('quran8Lesson1Part3Completed_$phone') ?? false;
    quran8Lesson2Part1Completed = prefs.getBool('quran8Lesson2Part1Completed_$phone') ?? false;
    quran8Lesson2Part2Completed = prefs.getBool('quran8Lesson2Part2Completed_$phone') ?? false;
    quran8Lesson2Part3Completed = prefs.getBool('quran8Lesson2Part3Completed_$phone') ?? false;
    quran8Lesson3Part1Completed = prefs.getBool('quran8Lesson3Part1Completed_$phone') ?? false;
    quran8Lesson3Part2Completed = prefs.getBool('quran8Lesson3Part2Completed_$phone') ?? false;
    quran8Lesson3Part3Completed = prefs.getBool('quran8Lesson3Part3Completed_$phone') ?? false;
    quran8Lesson4Part1Completed = prefs.getBool('quran8Lesson4Part1Completed_$phone') ?? false;
    quran8Lesson4Part2Completed = prefs.getBool('quran8Lesson4Part2Completed_$phone') ?? false;
    quran8Lesson4Part3Completed = prefs.getBool('quran8Lesson4Part3Completed_$phone') ?? false;
    quran8Lesson5Part1Completed = prefs.getBool('quran8Lesson5Part1Completed_$phone') ?? false;
    quran8Lesson5Part2Completed = prefs.getBool('quran8Lesson5Part2Completed_$phone') ?? false;
    quran8Lesson5Part3Completed = prefs.getBool('quran8Lesson5Part3Completed_$phone') ?? false;
    quran8Lesson6Part1Completed = prefs.getBool('quran8Lesson6Part1Completed_$phone') ?? false;
    quran8Lesson6Part2Completed = prefs.getBool('quran8Lesson6Part2Completed_$phone') ?? false;
    quran8Lesson6Part3Completed = prefs.getBool('quran8Lesson6Part3Completed_$phone') ?? false;
    quran8Lesson7Part1Completed = prefs.getBool('quran8Lesson7Part1Completed_$phone') ?? false;
    quran8Lesson7Part2Completed = prefs.getBool('quran8Lesson7Part2Completed_$phone') ?? false;
    quran8Lesson7Part3Completed = prefs.getBool('quran8Lesson7Part3Completed_$phone') ?? false;
    quran8Lesson8Part1Completed = prefs.getBool('quran8Lesson8Part1Completed_$phone') ?? false;
    quran8Lesson8Part2Completed = prefs.getBool('quran8Lesson8Part2Completed_$phone') ?? false;
    quran8Lesson8Part3Completed = prefs.getBool('quran8Lesson8Part3Completed_$phone') ?? false;
    quran8Lesson9Part1Completed = prefs.getBool('quran8Lesson9Part1Completed_$phone') ?? false;
    quran8Lesson9Part2Completed = prefs.getBool('quran8Lesson9Part2Completed_$phone') ?? false;
    quran8Lesson9Part3Completed = prefs.getBool('quran8Lesson9Part3Completed_$phone') ?? false;
    quran8Lesson10Part1Completed = prefs.getBool('quran8Lesson10Part1Completed_$phone') ?? false;
    quran8Lesson10Part2Completed = prefs.getBool('quran8Lesson10Part2Completed_$phone') ?? false;
    quran8Lesson10Part3Completed = prefs.getBool('quran8Lesson10Part3Completed_$phone') ?? false;
    quran8Lesson11Part1Completed = prefs.getBool('quran8Lesson11Part1Completed_$phone') ?? false;
    quran8Lesson11Part2Completed = prefs.getBool('quran8Lesson11Part2Completed_$phone') ?? false;
    quran8Lesson11Part3Completed = prefs.getBool('quran8Lesson11Part3Completed_$phone') ?? false;
    quran8Lesson12Part1Completed = prefs.getBool('quran8Lesson12Part1Completed_$phone') ?? false;
    quran8Lesson12Part2Completed = prefs.getBool('quran8Lesson12Part2Completed_$phone') ?? false;
    quran8Lesson12Part3Completed = prefs.getBool('quran8Lesson12Part3Completed_$phone') ?? false;
    quran9Lesson1Part2Completed = prefs.getBool('quran9Lesson1Part2Completed_$phone') ?? false;
    quran9Lesson1Part3Completed = prefs.getBool('quran9Lesson1Part3Completed_$phone') ?? false;
    quran9Lesson2Part1Completed = prefs.getBool('quran9Lesson2Part1Completed_$phone') ?? false;
    quran9Lesson2Part2Completed = prefs.getBool('quran9Lesson2Part2Completed_$phone') ?? false;
    quran9Lesson2Part3Completed = prefs.getBool('quran9Lesson2Part3Completed_$phone') ?? false;
    quran9Lesson3Part1Completed = prefs.getBool('quran9Lesson3Part1Completed_$phone') ?? false;
    quran9Lesson3Part2Completed = prefs.getBool('quran9Lesson3Part2Completed_$phone') ?? false;
    quran9Lesson3Part3Completed = prefs.getBool('quran9Lesson3Part3Completed_$phone') ?? false;
    quran9Lesson4Part1Completed = prefs.getBool('quran9Lesson4Part1Completed_$phone') ?? false;
    quran9Lesson4Part2Completed = prefs.getBool('quran9Lesson4Part2Completed_$phone') ?? false;
    quran9Lesson4Part3Completed = prefs.getBool('quran9Lesson4Part3Completed_$phone') ?? false;
    quran9Lesson5Part1Completed = prefs.getBool('quran9Lesson5Part1Completed_$phone') ?? false;
    quran9Lesson5Part2Completed = prefs.getBool('quran9Lesson5Part2Completed_$phone') ?? false;
    quran9Lesson5Part3Completed = prefs.getBool('quran9Lesson5Part3Completed_$phone') ?? false;
    quran9Lesson6Part1Completed = prefs.getBool('quran9Lesson6Part1Completed_$phone') ?? false;
    quran9Lesson6Part2Completed = prefs.getBool('quran9Lesson6Part2Completed_$phone') ?? false;
    quran9Lesson6Part3Completed = prefs.getBool('quran9Lesson6Part3Completed_$phone') ?? false;
    quran9Lesson7Part1Completed = prefs.getBool('quran9Lesson7Part1Completed_$phone') ?? false;
    quran9Lesson7Part2Completed = prefs.getBool('quran9Lesson7Part2Completed_$phone') ?? false;
    quran9Lesson7Part3Completed = prefs.getBool('quran9Lesson7Part3Completed_$phone') ?? false;
    quran9Lesson8Part1Completed = prefs.getBool('quran9Lesson8Part1Completed_$phone') ?? false;
    quran9Lesson8Part2Completed = prefs.getBool('quran9Lesson8Part2Completed_$phone') ?? false;
    quran9Lesson8Part3Completed = prefs.getBool('quran9Lesson8Part3Completed_$phone') ?? false;
    quran9Lesson9Part1Completed = prefs.getBool('quran9Lesson9Part1Completed_$phone') ?? false;
    quran9Lesson9Part2Completed = prefs.getBool('quran9Lesson9Part2Completed_$phone') ?? false;
    quran9Lesson9Part3Completed = prefs.getBool('quran9Lesson9Part3Completed_$phone') ?? false;
    quran9Lesson10Part1Completed = prefs.getBool('quran9Lesson10Part1Completed_$phone') ?? false;
    quran9Lesson10Part2Completed = prefs.getBool('quran9Lesson10Part2Completed_$phone') ?? false;
    quran9Lesson10Part3Completed = prefs.getBool('quran9Lesson10Part3Completed_$phone') ?? false;
    quran9Lesson11Part1Completed = prefs.getBool('quran9Lesson11Part1Completed_$phone') ?? false;
    quran9Lesson11Part2Completed = prefs.getBool('quran9Lesson11Part2Completed_$phone') ?? false;
    quran9Lesson11Part3Completed = prefs.getBool('quran9Lesson11Part3Completed_$phone') ?? false;
    zaban7Lesson1Part1Completed = prefs.getBool('zaban7Lesson1Part1Completed_$phone') ?? false;
    zaban7Lesson1Part2Completed = prefs.getBool('zaban7Lesson1Part2Completed_$phone') ?? false;
    zaban7Lesson1Part3Completed = prefs.getBool('zaban7Lesson1Part3Completed_$phone') ?? false;
    zaban7WelcomePart1Completed = prefs.getBool('zaban7WelcomePart1Completed_$phone') ?? false;
    zaban7WelcomePart2Completed = prefs.getBool('zaban7WelcomePart2Completed_$phone') ?? false;
    zaban7WelcomePart3Completed = prefs.getBool('zaban7WelcomePart3Completed_$phone') ?? false;
    zaban7Lesson3Part1Completed = prefs.getBool('zaban7Lesson3Part1Completed_$phone') ?? false;
    zaban7Lesson3Part2Completed = prefs.getBool('zaban7Lesson3Part2Completed_$phone') ?? false;
    zaban7Lesson3Part3Completed = prefs.getBool('zaban7Lesson3Part3Completed_$phone') ?? false;
    zaban7Lesson4Part1Completed = prefs.getBool('zaban7Lesson4Part1Completed_$phone') ?? false;
    zaban7Lesson4Part2Completed = prefs.getBool('zaban7Lesson4Part2Completed_$phone') ?? false;
    zaban7Lesson4Part3Completed = prefs.getBool('zaban7Lesson4Part3Completed_$phone') ?? false;
    zaban7Lesson5Part1Completed = prefs.getBool('zaban7Lesson5Part1Completed_$phone') ?? false;
    zaban7Lesson5Part2Completed = prefs.getBool('zaban7Lesson5Part2Completed_$phone') ?? false;
    zaban7Lesson5Part3Completed = prefs.getBool('zaban7Lesson5Part3Completed_$phone') ?? false;
    zaban7Lesson6Part1Completed = prefs.getBool('zaban7Lesson6Part1Completed_$phone') ?? false;
    zaban7Lesson6Part2Completed = prefs.getBool('zaban7Lesson6Part2Completed_$phone') ?? false;
    zaban7Lesson6Part3Completed = prefs.getBool('zaban7Lesson6Part3Completed_$phone') ?? false;
    zaban7Lesson7Part1Completed = prefs.getBool('zaban7Lesson7Part1Completed_$phone') ?? false;
    zaban7Lesson7Part2Completed = prefs.getBool('zaban7Lesson7Part2Completed_$phone') ?? false;
    zaban7Lesson7Part3Completed = prefs.getBool('zaban7Lesson7Part3Completed_$phone') ?? false;
    zaban8Lesson1Part1Completed = prefs.getBool('zaban8Lesson1Part1Completed_$phone') ?? false;
    zaban8Lesson1Part2Completed = prefs.getBool('zaban8Lesson1Part2Completed_$phone') ?? false;
    zaban8Lesson1Part3Completed = prefs.getBool('zaban8Lesson1Part3Completed_$phone') ?? false;
    zaban8Lesson2Part1Completed = prefs.getBool('zaban8Lesson2Part1Completed_$phone') ?? false;
    zaban8Lesson2Part2Completed = prefs.getBool('zaban8Lesson2Part2Completed_$phone') ?? false;
    zaban8Lesson2Part3Completed = prefs.getBool('zaban8Lesson2Part3Completed_$phone') ?? false;
    zaban8Lesson3Part1Completed = prefs.getBool('zaban8Lesson3Part1Completed_$phone') ?? false;
    zaban8Lesson3Part2Completed = prefs.getBool('zaban8Lesson3Part2Completed_$phone') ?? false;
    zaban8Lesson3Part3Completed = prefs.getBool('zaban8Lesson3Part3Completed_$phone') ?? false;
    zaban8Lesson4Part1Completed = prefs.getBool('zaban8Lesson4Part1Completed_$phone') ?? false;
    zaban8Lesson4Part2Completed = prefs.getBool('zaban8Lesson4Part2Completed_$phone') ?? false;
    zaban8Lesson4Part3Completed = prefs.getBool('zaban8Lesson4Part3Completed_$phone') ?? false;
    zaban8Lesson5Part1Completed = prefs.getBool('zaban8Lesson5Part1Completed_$phone') ?? false;
    zaban8Lesson5Part2Completed = prefs.getBool('zaban8Lesson5Part2Completed_$phone') ?? false;
    zaban8Lesson5Part3Completed = prefs.getBool('zaban8Lesson5Part3Completed_$phone') ?? false;
    zaban8Lesson6Part1Completed = prefs.getBool('zaban8Lesson6Part1Completed_$phone') ?? false;
    zaban8Lesson6Part2Completed = prefs.getBool('zaban8Lesson6Part2Completed_$phone') ?? false;
    zaban8Lesson6Part3Completed = prefs.getBool('zaban8Lesson6Part3Completed_$phone') ?? false;
    zaban8Lesson7Part1Completed = prefs.getBool('zaban8Lesson7Part1Completed_$phone') ?? false;
    zaban8Lesson7Part2Completed = prefs.getBool('zaban8Lesson7Part2Completed_$phone') ?? false;
    zaban8Lesson7Part3Completed = prefs.getBool('zaban8Lesson7Part3Completed_$phone') ?? false;
    zaban9Lesson1Part1Completed = prefs.getBool('zaban9Lesson1Part1Completed_$phone') ?? false;
    zaban9Lesson1Part2Completed = prefs.getBool('zaban9Lesson1Part2Completed_$phone') ?? false;
    zaban9Lesson1Part3Completed = prefs.getBool('zaban9Lesson1Part3Completed_$phone') ?? false;
    zaban9Lesson2Part1Completed = prefs.getBool('zaban9Lesson2Part1Completed_$phone') ?? false;
    zaban9Lesson2Part2Completed = prefs.getBool('zaban9Lesson2Part2Completed_$phone') ?? false;
    zaban9Lesson2Part3Completed = prefs.getBool('zaban9Lesson2Part3Completed_$phone') ?? false;
    zaban9Lesson3Part1Completed = prefs.getBool('zaban9Lesson3Part1Completed_$phone') ?? false;
    zaban9Lesson3Part2Completed = prefs.getBool('zaban9Lesson3Part2Completed_$phone') ?? false;
    zaban9Lesson3Part3Completed = prefs.getBool('zaban9Lesson3Part3Completed_$phone') ?? false;
    zaban9Lesson4Part1Completed = prefs.getBool('zaban9Lesson4Part1Completed_$phone') ?? false;
    zaban9Lesson4Part2Completed = prefs.getBool('zaban9Lesson4Part2Completed_$phone') ?? false;
    zaban9Lesson4Part3Completed = prefs.getBool('zaban9Lesson4Part3Completed_$phone') ?? false;
    zaban9Lesson5Part1Completed = prefs.getBool('zaban9Lesson5Part1Completed_$phone') ?? false;
    zaban9Lesson5Part2Completed = prefs.getBool('zaban9Lesson5Part2Completed_$phone') ?? false;
    zaban9Lesson5Part3Completed = prefs.getBool('zaban9Lesson5Part3Completed_$phone') ?? false;
    zaban9Lesson6Part1Completed = prefs.getBool('zaban9Lesson6Part1Completed_$phone') ?? false;
    zaban9Lesson6Part2Completed = prefs.getBool('zaban9Lesson6Part2Completed_$phone') ?? false;
    zaban9Lesson6Part3Completed = prefs.getBool('zaban9Lesson6Part3Completed_$phone') ?? false;
    farsi7Lesson1Part1Completed = prefs.getBool('farsi7Lesson1Part1Completed_$phone') ?? false;
    farsi7Lesson1Part2Completed = prefs.getBool('farsi7Lesson1Part2Completed_$phone') ?? false;
    farsi7Lesson1Part3Completed = prefs.getBool('farsi7Lesson1Part3Completed_$phone') ?? false;
    farsi7Lesson2Part1Completed = prefs.getBool('farsi7Lesson2Part1Completed_$phone') ?? false;
    farsi7Lesson2Part2Completed = prefs.getBool('farsi7Lesson2Part2Completed_$phone') ?? false;
    farsi7Lesson2Part3Completed = prefs.getBool('farsi7Lesson2Part3Completed_$phone') ?? false;
    farsi7Lesson3Part1Completed = prefs.getBool('farsi7Lesson3Part1Completed_$phone') ?? false;
    farsi7Lesson3Part2Completed = prefs.getBool('farsi7Lesson3Part2Completed_$phone') ?? false;
    farsi7Lesson3Part3Completed = prefs.getBool('farsi7Lesson3Part3Completed_$phone') ?? false;
    farsi7Lesson4Part1Completed = prefs.getBool('farsi7Lesson4Part1Completed_$phone') ?? false;
    farsi7Lesson4Part2Completed = prefs.getBool('farsi7Lesson4Part2Completed_$phone') ?? false;
    farsi7Lesson4Part3Completed = prefs.getBool('farsi7Lesson4Part3Completed_$phone') ?? false;
    farsi7Lesson5Part1Completed = prefs.getBool('farsi7Lesson5Part1Completed_$phone') ?? false;
    farsi7Lesson5Part2Completed = prefs.getBool('farsi7Lesson5Part2Completed_$phone') ?? false;
    farsi7Lesson5Part3Completed = prefs.getBool('farsi7Lesson5Part3Completed_$phone') ?? false;
    farsi7Lesson6Part1Completed = prefs.getBool('farsi7Lesson6Part1Completed_$phone') ?? false;
    farsi7Lesson6Part2Completed = prefs.getBool('farsi7Lesson6Part2Completed_$phone') ?? false;
    farsi7Lesson6Part3Completed = prefs.getBool('farsi7Lesson6Part3Completed_$phone') ?? false;
    farsi8Lesson1Part1Completed = prefs.getBool('farsi8Lesson1Part1Completed_$phone') ?? false;
    farsi8Lesson1Part2Completed = prefs.getBool('farsi8Lesson1Part2Completed_$phone') ?? false;
    farsi8Lesson1Part3Completed = prefs.getBool('farsi8Lesson1Part3Completed_$phone') ?? false;
    farsi8Lesson2Part1Completed = prefs.getBool('farsi8Lesson2Part1Completed_$phone') ?? false;
    farsi8Lesson2Part2Completed = prefs.getBool('farsi8Lesson2Part2Completed_$phone') ?? false;
    farsi8Lesson2Part3Completed = prefs.getBool('farsi8Lesson2Part3Completed_$phone') ?? false;
    farsi8Lesson3Part1Completed = prefs.getBool('farsi8Lesson3Part1Completed_$phone') ?? false;
    farsi8Lesson3Part2Completed = prefs.getBool('farsi8Lesson3Part2Completed_$phone') ?? false;
    farsi8Lesson3Part3Completed = prefs.getBool('farsi8Lesson3Part3Completed_$phone') ?? false;
    farsi8Lesson4Part1Completed = prefs.getBool('farsi8Lesson4Part1Completed_$phone') ?? false;
    farsi8Lesson4Part2Completed = prefs.getBool('farsi8Lesson4Part2Completed_$phone') ?? false;
    farsi8Lesson4Part3Completed = prefs.getBool('farsi8Lesson4Part3Completed_$phone') ?? false;
    farsi8Lesson5Part1Completed = prefs.getBool('farsi8Lesson5Part1Completed_$phone') ?? false;
    farsi8Lesson5Part2Completed = prefs.getBool('farsi8Lesson5Part2Completed_$phone') ?? false;
    farsi8Lesson5Part3Completed = prefs.getBool('farsi8Lesson5Part3Completed_$phone') ?? false;
    farsi8Lesson6Part1Completed = prefs.getBool('farsi8Lesson6Part1Completed_$phone') ?? false;
    farsi8Lesson6Part2Completed = prefs.getBool('farsi8Lesson6Part2Completed_$phone') ?? false;
    farsi8Lesson6Part3Completed = prefs.getBool('farsi8Lesson6Part3Completed_$phone') ?? false;
    farsi9Lesson1Part1Completed = prefs.getBool('farsi9Lesson1Part1Completed_$phone') ?? false;
    farsi9Lesson1Part2Completed = prefs.getBool('farsi9Lesson1Part2Completed_$phone') ?? false;
    farsi9Lesson1Part3Completed = prefs.getBool('farsi9Lesson1Part3Completed_$phone') ?? false;
    farsi9Lesson2Part1Completed = prefs.getBool('farsi9Lesson2Part1Completed_$phone') ?? false;
    farsi9Lesson2Part2Completed = prefs.getBool('farsi9Lesson2Part2Completed_$phone') ?? false;
    farsi9Lesson2Part3Completed = prefs.getBool('farsi9Lesson2Part3Completed_$phone') ?? false;
    farsi9Lesson3Part1Completed = prefs.getBool('farsi9Lesson3Part1Completed_$phone') ?? false;
    farsi9Lesson3Part2Completed = prefs.getBool('farsi9Lesson3Part2Completed_$phone') ?? false;
    farsi9Lesson3Part3Completed = prefs.getBool('farsi9Lesson3Part3Completed_$phone') ?? false;
    farsi9Lesson4Part1Completed = prefs.getBool('farsi9Lesson4Part1Completed_$phone') ?? false;
    farsi9Lesson4Part2Completed = prefs.getBool('farsi9Lesson4Part2Completed_$phone') ?? false;
    farsi9Lesson4Part3Completed = prefs.getBool('farsi9Lesson4Part3Completed_$phone') ?? false;
    farsi9Lesson5Part1Completed = prefs.getBool('farsi9Lesson5Part1Completed_$phone') ?? false;
    farsi9Lesson5Part2Completed = prefs.getBool('farsi9Lesson5Part2Completed_$phone') ?? false;
    farsi9Lesson5Part3Completed = prefs.getBool('farsi9Lesson5Part3Completed_$phone') ?? false;
    farsi9Lesson6Part1Completed = prefs.getBool('farsi9Lesson6Part1Completed_$phone') ?? false;
    farsi9Lesson6Part2Completed = prefs.getBool('farsi9Lesson6Part2Completed_$phone') ?? false;
    farsi9Lesson6Part3Completed = prefs.getBool('farsi9Lesson6Part3Completed_$phone') ?? false;
    payam7Lesson1Part1Completed = prefs.getBool('payam7Lesson1Part1Completed_$phone') ?? false;
    payam7Lesson1Part2Completed = prefs.getBool('payam7Lesson1Part2Completed_$phone') ?? false;
    payam7Lesson1Part3Completed = prefs.getBool('payam7Lesson1Part3Completed_$phone') ?? false;
    payam7Lesson2Part1Completed = prefs.getBool('payam7Lesson2Part1Completed_$phone') ?? false;
    payam7Lesson2Part2Completed = prefs.getBool('payam7Lesson2Part2Completed_$phone') ?? false;
    payam7Lesson2Part3Completed = prefs.getBool('payam7Lesson2Part3Completed_$phone') ?? false;
    payam7Lesson3Part1Completed = prefs.getBool('payam7Lesson3Part1Completed_$phone') ?? false;
    payam7Lesson3Part2Completed = prefs.getBool('payam7Lesson3Part2Completed_$phone') ?? false;
    payam7Lesson3Part3Completed = prefs.getBool('payam7Lesson3Part3Completed_$phone') ?? false;
    payam7Lesson4Part1Completed = prefs.getBool('payam7Lesson4Part1Completed_$phone') ?? false;
    payam7Lesson4Part2Completed = prefs.getBool('payam7Lesson4Part2Completed_$phone') ?? false;
    payam7Lesson4Part3Completed = prefs.getBool('payam7Lesson4Part3Completed_$phone') ?? false;
    payam7Lesson5Part1Completed = prefs.getBool('payam7Lesson5Part1Completed_$phone') ?? false;
    payam7Lesson5Part2Completed = prefs.getBool('payam7Lesson5Part2Completed_$phone') ?? false;
    payam7Lesson5Part3Completed = prefs.getBool('payam7Lesson5Part3Completed_$phone') ?? false;
    payam8Lesson1Part1Completed = prefs.getBool('payam8Lesson1Part1Completed_$phone') ?? false;
    payam8Lesson1Part2Completed = prefs.getBool('payam8Lesson1Part2Completed_$phone') ?? false;
    payam8Lesson1Part3Completed = prefs.getBool('payam8Lesson1Part3Completed_$phone') ?? false;
    payam8Lesson2Part1Completed = prefs.getBool('payam8Lesson2Part1Completed_$phone') ?? false;
    payam8Lesson2Part2Completed = prefs.getBool('payam8Lesson2Part2Completed_$phone') ?? false;
    payam8Lesson2Part3Completed = prefs.getBool('payam8Lesson2Part3Completed_$phone') ?? false;
    payam8Lesson3Part1Completed = prefs.getBool('payam8Lesson3Part1Completed_$phone') ?? false;
    payam8Lesson3Part2Completed = prefs.getBool('payam8Lesson3Part2Completed_$phone') ?? false;
    payam8Lesson3Part3Completed = prefs.getBool('payam8Lesson3Part3Completed_$phone') ?? false;
    payam8Lesson4Part1Completed = prefs.getBool('payam8Lesson4Part1Completed_$phone') ?? false;
    payam8Lesson4Part2Completed = prefs.getBool('payam8Lesson4Part2Completed_$phone') ?? false;
    payam8Lesson4Part3Completed = prefs.getBool('payam8Lesson4Part3Completed_$phone') ?? false;
    payam8Lesson5Part1Completed = prefs.getBool('payam8Lesson5Part1Completed_$phone') ?? false;
    payam8Lesson5Part2Completed = prefs.getBool('payam8Lesson5Part2Completed_$phone') ?? false;
    payam8Lesson5Part3Completed = prefs.getBool('payam8Lesson5Part3Completed_$phone') ?? false;
    payam8Lesson6Part1Completed = prefs.getBool('payam8Lesson6Part1Completed_$phone') ?? false;
    payam8Lesson6Part2Completed = prefs.getBool('payam8Lesson6Part2Completed_$phone') ?? false;
    payam8Lesson6Part3Completed = prefs.getBool('payam8Lesson6Part3Completed_$phone') ?? false;
    payam9Lesson1Part1Completed = prefs.getBool('payam9Lesson1Part1Completed_$phone') ?? false;
    payam9Lesson1Part2Completed = prefs.getBool('payam9Lesson1Part2Completed_$phone') ?? false;
    payam9Lesson1Part3Completed = prefs.getBool('payam9Lesson1Part3Completed_$phone') ?? false;
    payam9Lesson2Part1Completed = prefs.getBool('payam9Lesson2Part1Completed_$phone') ?? false;
    payam9Lesson2Part2Completed = prefs.getBool('payam9Lesson2Part2Completed_$phone') ?? false;
    payam9Lesson2Part3Completed = prefs.getBool('payam9Lesson2Part3Completed_$phone') ?? false;
    payam9Lesson3Part1Completed = prefs.getBool('payam9Lesson3Part1Completed_$phone') ?? false;
    payam9Lesson3Part2Completed = prefs.getBool('payam9Lesson3Part2Completed_$phone') ?? false;
    payam9Lesson3Part3Completed = prefs.getBool('payam9Lesson3Part3Completed_$phone') ?? false;
    payam9Lesson4Part1Completed = prefs.getBool('payam9Lesson4Part1Completed_$phone') ?? false;
    payam9Lesson4Part2Completed = prefs.getBool('payam9Lesson4Part2Completed_$phone') ?? false;
    payam9Lesson4Part3Completed = prefs.getBool('payam9Lesson4Part3Completed_$phone') ?? false;
    payam9Lesson5Part1Completed = prefs.getBool('payam9Lesson5Part1Completed_$phone') ?? false;
    payam9Lesson5Part2Completed = prefs.getBool('payam9Lesson5Part2Completed_$phone') ?? false;
    payam9Lesson5Part3Completed = prefs.getBool('payam9Lesson5Part3Completed_$phone') ?? false;
    motaleat7Lesson1Part1Completed = prefs.getBool('motaleat7Lesson1Part1Completed_$phone') ?? false;
    motaleat7Lesson1Part2Completed = prefs.getBool('motaleat7Lesson1Part2Completed_$phone') ?? false;
    motaleat7Lesson1Part3Completed = prefs.getBool('motaleat7Lesson1Part3Completed_$phone') ?? false;
    motaleat7Lesson2Part1Completed = prefs.getBool('motaleat7Lesson2Part1Completed_$phone') ?? false;
    motaleat7Lesson2Part2Completed = prefs.getBool('motaleat7Lesson2Part2Completed_$phone') ?? false;
    motaleat7Lesson2Part3Completed = prefs.getBool('motaleat7Lesson2Part3Completed_$phone') ?? false;
    motaleat7Lesson3Part1Completed = prefs.getBool('motaleat7Lesson3Part1Completed_$phone') ?? false;
    motaleat7Lesson3Part2Completed = prefs.getBool('motaleat7Lesson3Part2Completed_$phone') ?? false;
    motaleat7Lesson3Part3Completed = prefs.getBool('motaleat7Lesson3Part3Completed_$phone') ?? false;
    motaleat7Lesson4Part1Completed = prefs.getBool('motaleat7Lesson4Part1Completed_$phone') ?? false;
    motaleat7Lesson4Part2Completed = prefs.getBool('motaleat7Lesson4Part2Completed_$phone') ?? false;
    motaleat7Lesson4Part3Completed = prefs.getBool('motaleat7Lesson4Part3Completed_$phone') ?? false;
    motaleat7Lesson5Part1Completed = prefs.getBool('motaleat7Lesson5Part1Completed_$phone') ?? false;
    motaleat7Lesson5Part2Completed = prefs.getBool('motaleat7Lesson5Part2Completed_$phone') ?? false;
    motaleat7Lesson5Part3Completed = prefs.getBool('motaleat7Lesson5Part3Completed_$phone') ?? false;
    motaleat7Lesson6Part1Completed = prefs.getBool('motaleat7Lesson6Part1Completed_$phone') ?? false;
    motaleat7Lesson6Part2Completed = prefs.getBool('motaleat7Lesson6Part2Completed_$phone') ?? false;
    motaleat7Lesson6Part3Completed = prefs.getBool('motaleat7Lesson6Part3Completed_$phone') ?? false;
    motaleat7Lesson7Part1Completed = prefs.getBool('motaleat7Lesson7Part1Completed_$phone') ?? false;
    motaleat7Lesson7Part2Completed = prefs.getBool('motaleat7Lesson7Part2Completed_$phone') ?? false;
    motaleat7Lesson7Part3Completed = prefs.getBool('motaleat7Lesson7Part3Completed_$phone') ?? false;
    motaleat7Lesson8Part1Completed = prefs.getBool('motaleat7Lesson8Part1Completed_$phone') ?? false;
    motaleat7Lesson8Part2Completed = prefs.getBool('motaleat7Lesson8Part2Completed_$phone') ?? false;
    motaleat7Lesson8Part3Completed = prefs.getBool('motaleat7Lesson8Part3Completed_$phone') ?? false;
    motaleat7Lesson9Part1Completed = prefs.getBool('motaleat7Lesson9Part1Completed_$phone') ?? false;
    motaleat7Lesson9Part2Completed = prefs.getBool('motaleat7Lesson9Part2Completed_$phone') ?? false;
    motaleat7Lesson9Part3Completed = prefs.getBool('motaleat7Lesson9Part3Completed_$phone') ?? false;
    motaleat7Lesson10Part1Completed = prefs.getBool('motaleat7Lesson10Part1Completed_$phone') ?? false;
    motaleat7Lesson10Part2Completed = prefs.getBool('motaleat7Lesson10Part2Completed_$phone') ?? false;
    motaleat7Lesson10Part3Completed = prefs.getBool('motaleat7Lesson10Part3Completed_$phone') ?? false;
    motaleat7Lesson11Part1Completed = prefs.getBool('motaleat7Lesson11Part1Completed_$phone') ?? false;
    motaleat7Lesson11Part2Completed = prefs.getBool('motaleat7Lesson11Part2Completed_$phone') ?? false;
    motaleat7Lesson11Part3Completed = prefs.getBool('motaleat7Lesson11Part3Completed_$phone') ?? false;
    motaleat7Lesson12Part1Completed = prefs.getBool('motaleat7Lesson12Part1Completed_$phone') ?? false;
    motaleat7Lesson12Part2Completed = prefs.getBool('motaleat7Lesson12Part2Completed_$phone') ?? false;
    motaleat7Lesson12Part3Completed = prefs.getBool('motaleat7Lesson12Part3Completed_$phone') ?? false;
    motaleat8Lesson1Part1Completed = prefs.getBool('motaleat8Lesson1Part1Completed_$phone') ?? false;
    motaleat8Lesson1Part2Completed = prefs.getBool('motaleat8Lesson1Part2Completed_$phone') ?? false;
    motaleat8Lesson1Part3Completed = prefs.getBool('motaleat8Lesson1Part3Completed_$phone') ?? false;
    motaleat8Lesson2Part1Completed = prefs.getBool('motaleat8Lesson2Part1Completed_$phone') ?? false;
    motaleat8Lesson2Part2Completed = prefs.getBool('motaleat8Lesson2Part2Completed_$phone') ?? false;
    motaleat8Lesson2Part3Completed = prefs.getBool('motaleat8Lesson2Part3Completed_$phone') ?? false;
    motaleat8Lesson3Part1Completed = prefs.getBool('motaleat8Lesson3Part1Completed_$phone') ?? false;
    motaleat8Lesson3Part2Completed = prefs.getBool('motaleat8Lesson3Part2Completed_$phone') ?? false;
    motaleat8Lesson3Part3Completed = prefs.getBool('motaleat8Lesson3Part3Completed_$phone') ?? false;
    motaleat8Lesson4Part1Completed = prefs.getBool('motaleat8Lesson4Part1Completed_$phone') ?? false;
    motaleat8Lesson4Part2Completed = prefs.getBool('motaleat8Lesson4Part2Completed_$phone') ?? false;
    motaleat8Lesson4Part3Completed = prefs.getBool('motaleat8Lesson4Part3Completed_$phone') ?? false;
    motaleat8Lesson5Part1Completed = prefs.getBool('motaleat8Lesson5Part1Completed_$phone') ?? false;
    motaleat8Lesson5Part2Completed = prefs.getBool('motaleat8Lesson5Part2Completed_$phone') ?? false;
    motaleat8Lesson5Part3Completed = prefs.getBool('motaleat8Lesson5Part3Completed_$phone') ?? false;
    motaleat8Lesson6Part1Completed = prefs.getBool('motaleat8Lesson6Part1Completed_$phone') ?? false;
    motaleat8Lesson6Part2Completed = prefs.getBool('motaleat8Lesson6Part2Completed_$phone') ?? false;
    motaleat8Lesson6Part3Completed = prefs.getBool('motaleat8Lesson6Part3Completed_$phone') ?? false;
    motaleat8Lesson7Part1Completed = prefs.getBool('motaleat8Lesson7Part1Completed_$phone') ?? false;
    motaleat8Lesson7Part2Completed = prefs.getBool('motaleat8Lesson7Part2Completed_$phone') ?? false;
    motaleat8Lesson7Part3Completed = prefs.getBool('motaleat8Lesson7Part3Completed_$phone') ?? false;
    motaleat8Lesson8Part1Completed = prefs.getBool('motaleat8Lesson8Part1Completed_$phone') ?? false;
    motaleat8Lesson8Part2Completed = prefs.getBool('motaleat8Lesson8Part2Completed_$phone') ?? false;
    motaleat8Lesson8Part3Completed = prefs.getBool('motaleat8Lesson8Part3Completed_$phone') ?? false;
    motaleat8Lesson9Part1Completed = prefs.getBool('motaleat8Lesson9Part1Completed_$phone') ?? false;
    motaleat8Lesson9Part2Completed = prefs.getBool('motaleat8Lesson9Part2Completed_$phone') ?? false;
    motaleat8Lesson9Part3Completed = prefs.getBool('motaleat8Lesson9Part3Completed_$phone') ?? false;
    motaleat8Lesson10Part1Completed = prefs.getBool('motaleat8Lesson10Part1Completed_$phone') ?? false;
    motaleat8Lesson10Part2Completed = prefs.getBool('motaleat8Lesson10Part2Completed_$phone') ?? false;
    motaleat8Lesson10Part3Completed = prefs.getBool('motaleat8Lesson10Part3Completed_$phone') ?? false;
    motaleat8Lesson11Part1Completed = prefs.getBool('motaleat8Lesson11Part1Completed_$phone') ?? false;
    motaleat8Lesson11Part2Completed = prefs.getBool('motaleat8Lesson11Part2Completed_$phone') ?? false;
    motaleat8Lesson11Part3Completed = prefs.getBool('motaleat8Lesson11Part3Completed_$phone') ?? false;
    motaleat8Lesson12Part1Completed = prefs.getBool('motaleat8Lesson12Part1Completed_$phone') ?? false;
    motaleat8Lesson12Part2Completed = prefs.getBool('motaleat8Lesson12Part2Completed_$phone') ?? false;
    motaleat8Lesson12Part3Completed = prefs.getBool('motaleat8Lesson12Part3Completed_$phone') ?? false;

    motaleat9Lesson1Part1Completed = prefs.getBool('motaleat9Lesson1Part1Completed_$phone') ?? false;
    motaleat9Lesson1Part2Completed = prefs.getBool('motaleat9Lesson1Part2Completed_$phone') ?? false;
    motaleat9Lesson1Part3Completed = prefs.getBool('motaleat9Lesson1Part3Completed_$phone') ?? false;
    motaleat9Lesson2Part1Completed = prefs.getBool('motaleat9Lesson2Part1Completed_$phone') ?? false;
    motaleat9Lesson2Part2Completed = prefs.getBool('motaleat9Lesson2Part2Completed_$phone') ?? false;
    motaleat9Lesson2Part3Completed = prefs.getBool('motaleat9Lesson2Part3Completed_$phone') ?? false;
    motaleat9Lesson3Part1Completed = prefs.getBool('motaleat9Lesson3Part1Completed_$phone') ?? false;
    motaleat9Lesson3Part2Completed = prefs.getBool('motaleat9Lesson3Part2Completed_$phone') ?? false;
    motaleat9Lesson3Part3Completed = prefs.getBool('motaleat9Lesson3Part3Completed_$phone') ?? false;
    motaleat9Lesson4Part1Completed = prefs.getBool('motaleat9Lesson4Part1Completed_$phone') ?? false;
    motaleat9Lesson4Part2Completed = prefs.getBool('motaleat9Lesson4Part2Completed_$phone') ?? false;
    motaleat9Lesson4Part3Completed = prefs.getBool('motaleat9Lesson4Part3Completed_$phone') ?? false;
    motaleat9Lesson5Part1Completed = prefs.getBool('motaleat9Lesson5Part1Completed_$phone') ?? false;
    motaleat9Lesson5Part2Completed = prefs.getBool('motaleat9Lesson5Part2Completed_$phone') ?? false;
    motaleat9Lesson5Part3Completed = prefs.getBool('motaleat9Lesson5Part3Completed_$phone') ?? false;
    motaleat9Lesson6Part1Completed = prefs.getBool('motaleat9Lesson6Part1Completed_$phone') ?? false;
    motaleat9Lesson6Part2Completed = prefs.getBool('motaleat9Lesson6Part2Completed_$phone') ?? false;
    motaleat9Lesson6Part3Completed = prefs.getBool('motaleat9Lesson6Part3Completed_$phone') ?? false;
    motaleat9Lesson7Part1Completed = prefs.getBool('motaleat9Lesson7Part1Completed_$phone') ?? false;
    motaleat9Lesson7Part2Completed = prefs.getBool('motaleat9Lesson7Part2Completed_$phone') ?? false;
    motaleat9Lesson7Part3Completed = prefs.getBool('motaleat9Lesson7Part3Completed_$phone') ?? false;
    motaleat9Lesson8Part1Completed = prefs.getBool('motaleat9Lesson8Part1Completed_$phone') ?? false;
    motaleat9Lesson8Part2Completed = prefs.getBool('motaleat9Lesson8Part2Completed_$phone') ?? false;
    motaleat9Lesson8Part3Completed = prefs.getBool('motaleat9Lesson8Part3Completed_$phone') ?? false;
    motaleat9Lesson9Part1Completed = prefs.getBool('motaleat9Lesson9Part1Completed_$phone') ?? false;
    motaleat9Lesson9Part2Completed = prefs.getBool('motaleat9Lesson9Part2Completed_$phone') ?? false;
    motaleat9Lesson9Part3Completed = prefs.getBool('motaleat9Lesson9Part3Completed_$phone') ?? false;
    motaleat9Lesson10Part1Completed = prefs.getBool('motaleat9Lesson10Part1Completed_$phone') ?? false;
    motaleat9Lesson10Part2Completed = prefs.getBool('motaleat9Lesson10Part2Completed_$phone') ?? false;
    motaleat9Lesson10Part3Completed = prefs.getBool('motaleat9Lesson10Part3Completed_$phone') ?? false;
    motaleat9Lesson11Part1Completed = prefs.getBool('motaleat9Lesson11Part1Completed_$phone') ?? false;
    motaleat9Lesson11Part2Completed = prefs.getBool('motaleat9Lesson11Part2Completed_$phone') ?? false;
    motaleat9Lesson11Part3Completed = prefs.getBool('motaleat9Lesson11Part3Completed_$phone') ?? false;
    motaleat9Lesson12Part1Completed = prefs.getBool('motaleat9Lesson12Part1Completed_$phone') ?? false;
    motaleat9Lesson12Part2Completed = prefs.getBool('motaleat9Lesson12Part2Completed_$phone') ?? false;
    motaleat9Lesson12Part3Completed = prefs.getBool('motaleat9Lesson12Part3Completed_$phone') ?? false;
    zaban9Lesson5Part2Completed = prefs.getBool('zaban9Lesson5Part2Completed_$phone') ?? false;
    zaban9Lesson5Part3Completed = prefs.getBool('zaban9Lesson5Part3Completed_$phone') ?? false;
    zaban9Lesson4Part3Completed = prefs.getBool('zaban9Lesson4Part3Completed_$phone') ?? false;
    zaban7Lesson8Part1Completed = prefs.getBool('zaban7Lesson8Part1Completed_$phone') ?? false;
    zaban7Lesson8Part2Completed = prefs.getBool('zaban7Lesson8Part2Completed_$phone') ?? false;
    zaban7Lesson8Part3Completed = prefs.getBool('zaban7Lesson8Part3Completed_$phone') ?? false;
    olom7Lesson1Part1Completed = prefs.getBool('olom7Lesson1Part1Completed_$phone') ?? false;
    olom8Lesson1Part1Completed = prefs.getBool('olom8Lesson1Part1Completed_$phone') ?? false;
    olom7Lesson1Part2Completed = prefs.getBool('olom7Lesson1Part2Completed_$phone') ?? false;
    olom8Lesson1Part2Completed = prefs.getBool('olom8Lesson1Part2Completed_$phone') ?? false;
    olom7Lesson1Part3Completed = prefs.getBool('olom7Lesson1Part3Completed_$phone') ?? false;
    olom8Lesson1Part3Completed = prefs.getBool('olom8Lesson1Part3Completed_$phone') ?? false;
    olom7Lesson2Part1Completed = prefs.getBool('olom7Lesson2Part1Completed_$phone') ?? false;
    olom8Lesson2Part1Completed = prefs.getBool('olom8Lesson2Part1Completed_$phone') ?? false;
    olom7Lesson2Part2Completed = prefs.getBool('olom7Lesson2Part2Completed_$phone') ?? false;
    olom8Lesson2Part2Completed = prefs.getBool('olom8Lesson2Part2Completed_$phone') ?? false;
    olom7Lesson2Part3Completed = prefs.getBool('olom7Lesson2Part3Completed_$phone') ?? false;
    olom8Lesson2Part3Completed = prefs.getBool('olom8Lesson2Part3Completed_$phone') ?? false;
    olom7Lesson3Part1Completed = prefs.getBool('olom7Lesson3Part1Completed_$phone') ?? false;
    olom8Lesson3Part1Completed = prefs.getBool('olom8Lesson3Part1Completed_$phone') ?? false;
    olom7Lesson3Part2Completed = prefs.getBool('olom7Lesson3Part2Completed_$phone') ?? false;
    olom8Lesson3Part2Completed = prefs.getBool('olom8Lesson3Part2Completed_$phone') ?? false;
    olom7Lesson3Part3Completed = prefs.getBool('olom7Lesson3Part3Completed_$phone') ?? false;
    olom8Lesson3Part3Completed = prefs.getBool('olom8Lesson3Part3Completed_$phone') ?? false;
    olom7Lesson4Part1Completed = prefs.getBool('olom7Lesson4Part1Completed_$phone') ?? false;
    olom8Lesson4Part1Completed = prefs.getBool('olom8Lesson4Part1Completed_$phone') ?? false;
    olom7Lesson4Part2Completed = prefs.getBool('olom7Lesson4Part2Completed_$phone') ?? false;
    olom8Lesson4Part2Completed = prefs.getBool('olom8Lesson4Part2Completed_$phone') ?? false;
    olom7Lesson4Part3Completed = prefs.getBool('olom7Lesson4Part3Completed_$phone') ?? false;
    olom8Lesson4Part3Completed = prefs.getBool('olom8Lesson4Part3Completed_$phone') ?? false;
    olom7Lesson5Part1Completed = prefs.getBool('olom7Lesson5Part1Completed_$phone') ?? false;
    olom8Lesson5Part1Completed = prefs.getBool('olom8Lesson5Part1Completed_$phone') ?? false;
    olom7Lesson5Part2Completed = prefs.getBool('olom7Lesson5Part2Completed_$phone') ?? false;
    olom8Lesson5Part2Completed = prefs.getBool('olom8Lesson5Part2Completed_$phone') ?? false;
    olom7Lesson5Part3Completed = prefs.getBool('olom7Lesson5Part3Completed_$phone') ?? false;
    olom8Lesson5Part3Completed = prefs.getBool('olom8Lesson5Part3Completed_$phone') ?? false;
    olom7Lesson6Part1Completed = prefs.getBool('olom7Lesson6Part1Completed_$phone') ?? false;
    olom8Lesson6Part1Completed = prefs.getBool('olom8Lesson6Part1Completed_$phone') ?? false;
    olom7Lesson6Part2Completed = prefs.getBool('olom7Lesson6Part2Completed_$phone') ?? false;
    olom8Lesson6Part2Completed = prefs.getBool('olom8Lesson6Part2Completed_$phone') ?? false;
    olom7Lesson6Part3Completed = prefs.getBool('olom7Lesson6Part3Completed_$phone') ?? false;
    olom8Lesson6Part3Completed = prefs.getBool('olom8Lesson6Part3Completed_$phone') ?? false;
    olom7Lesson7Part1Completed = prefs.getBool('olom7Lesson7Part1Completed_$phone') ?? false;
    olom8Lesson7Part1Completed = prefs.getBool('olom8Lesson7Part1Completed_$phone') ?? false;
    olom7Lesson7Part2Completed = prefs.getBool('olom7Lesson7Part2Completed_$phone') ?? false;
    olom8Lesson7Part2Completed = prefs.getBool('olom8Lesson7Part2Completed_$phone') ?? false;
    olom7Lesson7Part3Completed = prefs.getBool('olom7Lesson7Part3Completed_$phone') ?? false;
    olom8Lesson7Part3Completed = prefs.getBool('olom8Lesson7Part3Completed_$phone') ?? false;
    olom7Lesson8Part1Completed = prefs.getBool('olom7Lesson8Part1Completed_$phone') ?? false;
    olom8Lesson8Part1Completed = prefs.getBool('olom8Lesson8Part1Completed_$phone') ?? false;
    olom7Lesson8Part2Completed = prefs.getBool('olom7Lesson8Part2Completed_$phone') ?? false;
    olom8Lesson8Part2Completed = prefs.getBool('olom8Lesson8Part2Completed_$phone') ?? false;
    olom7Lesson8Part3Completed = prefs.getBool('olom7Lesson8Part3Completed_$phone') ?? false;
    olom8Lesson8Part3Completed = prefs.getBool('olom8Lesson8Part3Completed_$phone') ?? false;
    olom7Lesson9Part1Completed = prefs.getBool('olom7Lesson9Part1Completed_$phone') ?? false;
    olom8Lesson9Part1Completed = prefs.getBool('olom8Lesson9Part1Completed_$phone') ?? false;
    olom7Lesson9Part2Completed = prefs.getBool('olom7Lesson9Part2Completed_$phone') ?? false;
    olom8Lesson9Part2Completed = prefs.getBool('olom8Lesson9Part2Completed_$phone') ?? false;
    olom7Lesson9Part3Completed = prefs.getBool('olom7Lesson9Part3Completed_$phone') ?? false;
    olom8Lesson9Part3Completed = prefs.getBool('olom8Lesson9Part3Completed_$phone') ?? false;
    olom7Lesson10Part1Completed = prefs.getBool('olom7Lesson10Part1Completed_$phone') ?? false;
    olom8Lesson10Part1Completed = prefs.getBool('olom8Lesson10Part1Completed_$phone') ?? false;
    olom7Lesson10Part2Completed = prefs.getBool('olom7Lesson10Part2Completed_$phone') ?? false;
    olom8Lesson10Part2Completed = prefs.getBool('olom8Lesson10Part2Completed_$phone') ?? false;
    olom7Lesson10Part3Completed = prefs.getBool('olom7Lesson10Part3Completed_$phone') ?? false;
    olom8Lesson10Part3Completed = prefs.getBool('olom8Lesson10Part3Completed_$phone') ?? false;
    olom7Lesson11Part1Completed = prefs.getBool('olom7Lesson11Part1Completed_$phone') ?? false;
    olom8Lesson11Part1Completed = prefs.getBool('olom8Lesson11Part1Completed_$phone') ?? false;
    olom7Lesson11Part2Completed = prefs.getBool('olom7Lesson11Part2Completed_$phone') ?? false;
    olom8Lesson11Part2Completed = prefs.getBool('olom8Lesson11Part2Completed_$phone') ?? false;
    olom7Lesson11Part3Completed = prefs.getBool('olom7Lesson11Part3Completed_$phone') ?? false;
    olom8Lesson11Part3Completed = prefs.getBool('olom8Lesson11Part3Completed_$phone') ?? false;
    olom7Lesson12Part1Completed = prefs.getBool('olom7Lesson12Part1Completed_$phone') ?? false;
    olom8Lesson12Part1Completed = prefs.getBool('olom8Lesson12Part1Completed_$phone') ?? false;
    olom7Lesson12Part2Completed = prefs.getBool('olom7Lesson12Part2Completed_$phone') ?? false;
    olom8Lesson12Part2Completed = prefs.getBool('olom8Lesson12Part2Completed_$phone') ?? false;
    olom7Lesson12Part3Completed = prefs.getBool('olom7Lesson12Part3Completed_$phone') ?? false;
    olom8Lesson12Part3Completed = prefs.getBool('olom8Lesson12Part3Completed_$phone') ?? false;
    olom7Lesson13Part1Completed = prefs.getBool('olom7Lesson13Part1Completed_$phone') ?? false;
    olom8Lesson13Part1Completed = prefs.getBool('olom8Lesson13Part1Completed_$phone') ?? false;
    olom7Lesson13Part2Completed = prefs.getBool('olom7Lesson13Part2Completed_$phone') ?? false;
    olom8Lesson13Part2Completed = prefs.getBool('olom8Lesson13Part2Completed_$phone') ?? false;
    olom7Lesson13Part3Completed = prefs.getBool('olom7Lesson13Part3Completed_$phone') ?? false;
    olom8Lesson13Part3Completed = prefs.getBool('olom8Lesson13Part3Completed_$phone') ?? false;
    olom7Lesson14Part1Completed = prefs.getBool('olom7Lesson14Part1Completed_$phone') ?? false;
    olom8Lesson14Part1Completed = prefs.getBool('olom8Lesson14Part1Completed_$phone') ?? false;
    olom7Lesson14Part2Completed = prefs.getBool('olom7Lesson14Part2Completed_$phone') ?? false;
    olom8Lesson14Part2Completed = prefs.getBool('olom8Lesson14Part2Completed_$phone') ?? false;
    olom7Lesson14Part3Completed = prefs.getBool('olom7Lesson14Part3Completed_$phone') ?? false;
    olom8Lesson14Part3Completed = prefs.getBool('olom8Lesson14Part3Completed_$phone') ?? false;
    olom7Lesson15Part1Completed = prefs.getBool('olom7Lesson15Part1Completed_$phone') ?? false;
    olom8Lesson15Part1Completed = prefs.getBool('olom8Lesson15Part1Completed_$phone') ?? false;
    olom7Lesson15Part2Completed = prefs.getBool('olom7Lesson15Part2Completed_$phone') ?? false;
    olom8Lesson15Part2Completed = prefs.getBool('olom8Lesson15Part2Completed_$phone') ?? false;
    olom7Lesson15Part3Completed = prefs.getBool('olom7Lesson15Part3Completed_$phone') ?? false;
    olom8Lesson15Part3Completed = prefs.getBool('olom8Lesson15Part3Completed_$phone') ?? false;
    olom9Lesson1Part1Completed = prefs.getBool('olom9Lesson1Part1Completed_$phone') ?? false;
    olom9Lesson1Part2Completed = prefs.getBool('olom9Lesson1Part2Completed_$phone') ?? false;
    olom9Lesson1Part3Completed = prefs.getBool('olom9Lesson1Part3Completed_$phone') ?? false;
    olom9Lesson2Part1Completed = prefs.getBool('olom9Lesson2Part1Completed_$phone') ?? false;
    olom9Lesson2Part2Completed = prefs.getBool('olom9Lesson2Part2Completed_$phone') ?? false;
    olom9Lesson2Part3Completed = prefs.getBool('olom9Lesson2Part3Completed_$phone') ?? false;
    olom9Lesson3Part1Completed = prefs.getBool('olom9Lesson3Part1Completed_$phone') ?? false;
    olom9Lesson3Part2Completed = prefs.getBool('olom9Lesson3Part2Completed_$phone') ?? false;
    olom9Lesson3Part3Completed = prefs.getBool('olom9Lesson3Part3Completed_$phone') ?? false;
    olom9Lesson4Part1Completed = prefs.getBool('olom9Lesson4Part1Completed_$phone') ?? false;
    olom9Lesson4Part2Completed = prefs.getBool('olom9Lesson4Part2Completed_$phone') ?? false;
    olom9Lesson4Part3Completed = prefs.getBool('olom9Lesson4Part3Completed_$phone') ?? false;
    olom9Lesson5Part1Completed = prefs.getBool('olom9Lesson5Part1Completed_$phone') ?? false;
    olom9Lesson5Part2Completed = prefs.getBool('olom9Lesson5Part2Completed_$phone') ?? false;
    olom9Lesson5Part3Completed = prefs.getBool('olom9Lesson5Part3Completed_$phone') ?? false;
    olom9Lesson6Part1Completed = prefs.getBool('olom9Lesson6Part1Completed_$phone') ?? false;
    olom9Lesson6Part2Completed = prefs.getBool('olom9Lesson6Part2Completed_$phone') ?? false;
    olom9Lesson6Part3Completed = prefs.getBool('olom9Lesson6Part3Completed_$phone') ?? false;
    olom9Lesson7Part1Completed = prefs.getBool('olom9Lesson7Part1Completed_$phone') ?? false;
    olom9Lesson7Part2Completed = prefs.getBool('olom9Lesson7Part2Completed_$phone') ?? false;
    olom9Lesson7Part3Completed = prefs.getBool('olom9Lesson7Part3Completed_$phone') ?? false;
    olom9Lesson8Part1Completed = prefs.getBool('olom9Lesson8Part1Completed_$phone') ?? false;
    olom9Lesson8Part2Completed = prefs.getBool('olom9Lesson8Part2Completed_$phone') ?? false;
    olom9Lesson8Part3Completed = prefs.getBool('olom9Lesson8Part3Completed_$phone') ?? false;
    olom9Lesson9Part1Completed = prefs.getBool('olom9Lesson9Part1Completed_$phone') ?? false;
    olom9Lesson9Part2Completed = prefs.getBool('olom9Lesson9Part2Completed_$phone') ?? false;
    olom9Lesson9Part3Completed = prefs.getBool('olom9Lesson9Part3Completed_$phone') ?? false;
    olom9Lesson10Part1Completed = prefs.getBool('olom9Lesson10Part1Completed_$phone') ?? false;
    olom9Lesson10Part2Completed = prefs.getBool('olom9Lesson10Part2Completed_$phone') ?? false;
    olom9Lesson10Part3Completed = prefs.getBool('olom9Lesson10Part3Completed_$phone') ?? false;
    olom9Lesson11Part1Completed = prefs.getBool('olom9Lesson11Part1Completed_$phone') ?? false;
    olom9Lesson11Part2Completed = prefs.getBool('olom9Lesson11Part2Completed_$phone') ?? false;
    olom9Lesson11Part3Completed = prefs.getBool('olom9Lesson11Part3Completed_$phone') ?? false;
    olom9Lesson12Part1Completed = prefs.getBool('olom9Lesson12Part1Completed_$phone') ?? false;
    olom9Lesson12Part2Completed = prefs.getBool('olom9Lesson12Part2Completed_$phone') ?? false;
    olom9Lesson12Part3Completed = prefs.getBool('olom9Lesson12Part3Completed_$phone') ?? false;
    olom9Lesson13Part1Completed = prefs.getBool('olom9Lesson13Part1Completed_$phone') ?? false;
    olom9Lesson13Part2Completed = prefs.getBool('olom9Lesson13Part2Completed_$phone') ?? false;
    olom9Lesson13Part3Completed = prefs.getBool('olom9Lesson13Part3Completed_$phone') ?? false;
    olom9Lesson14Part1Completed = prefs.getBool('olom9Lesson14Part1Completed_$phone') ?? false;
    olom9Lesson14Part2Completed = prefs.getBool('olom9Lesson14Part2Completed_$phone') ?? false;
    olom9Lesson14Part3Completed = prefs.getBool('olom9Lesson14Part3Completed_$phone') ?? false;
    olom9Lesson15Part1Completed = prefs.getBool('olom9Lesson15Part1Completed_$phone') ?? false;
    olom9Lesson15Part2Completed = prefs.getBool('olom9Lesson15Part2Completed_$phone') ?? false;
    olom9Lesson15Part3Completed = prefs.getBool('olom9Lesson15Part3Completed_$phone') ?? false;
    riyazi7Chapter1Completed = prefs.getBool('riyazi7Chapter1Completed_$phone') ?? false;
    riyazi7Chapter2Completed = prefs.getBool('riyazi7Chapter2Completed_$phone') ?? false;
    riyazi7Chapter3Completed = prefs.getBool('riyazi7Chapter3Completed_$phone') ?? false;
    riyazi7Chapter4Completed = prefs.getBool('riyazi7Chapter4Completed_$phone') ?? false;
    riyazi7Chapter5Completed = prefs.getBool('riyazi7Chapter5Completed_$phone') ?? false;
    riyazi7Chapter6Completed = prefs.getBool('riyazi7Chapter6Completed_$phone') ?? false;
    riyazi7Chapter7Completed = prefs.getBool('riyazi7Chapter7Completed_$phone') ?? false;
    riyazi7Chapter8Completed = prefs.getBool('riyazi7Chapter8Completed_$phone') ?? false;
    riyazi7Chapter9Completed = prefs.getBool('riyazi7Chapter9Completed_$phone') ?? false;
    riyazi8Chapter1Completed = prefs.getBool('riyazi8Chapter1Completed_$phone') ?? false;
    riyazi8Chapter2Completed = prefs.getBool('riyazi8Chapter2Completed_$phone') ?? false;
    riyazi8Chapter3Completed = prefs.getBool('riyazi8Chapter3Completed_$phone') ?? false;
    riyazi8Chapter4Completed = prefs.getBool('riyazi8Chapter4Completed_$phone') ?? false;
    riyazi8Chapter5Completed = prefs.getBool('riyazi8Chapter5Completed_$phone') ?? false;
    riyazi8Chapter6Completed = prefs.getBool('riyazi8Chapter6Completed_$phone') ?? false;
    riyazi8Chapter7Completed = prefs.getBool('riyazi8Chapter7Completed_$phone') ?? false;
    riyazi8Chapter8Completed = prefs.getBool('riyazi8Chapter8Completed_$phone') ?? false;
    riyazi8Chapter9Completed = prefs.getBool('riyazi8Chapter9Completed_$phone') ?? false;
    riyazi9Chapter1Completed = prefs.getBool('riyazi9Chapter1Completed_$phone') ?? false;
    riyazi9Chapter2Completed = prefs.getBool('riyazi9Chapter2Completed_$phone') ?? false;
    riyazi9Chapter3Completed = prefs.getBool('riyazi9Chapter3Completed_$phone') ?? false;
    riyazi9Chapter4Completed = prefs.getBool('riyazi9Chapter4Completed_$phone') ?? false;
    riyazi9Chapter5Completed = prefs.getBool('riyazi9Chapter5Completed_$phone') ?? false;
    riyazi9Chapter6Completed = prefs.getBool('riyazi9Chapter6Completed_$phone') ?? false;
    riyazi9Chapter7Completed = prefs.getBool('riyazi9Chapter7Completed_$phone') ?? false;
    riyazi9Chapter8Completed = prefs.getBool('riyazi9Chapter8Completed_$phone') ?? false;

    // همگام‌سازی خودکار کلیه سوابق دانش‌آموز به محض باز شدن برنامه
    if (phone.isNotEmpty) {
      int completedLessonsCount = 0;
      List<String> completedList = [];
      final suffix = '_$phone';
      for (String k in prefs.getKeys()) {
        if (k.contains('Completed') && k.endsWith(suffix) && prefs.getBool(k) == true) {
          completedLessonsCount++;
          completedList.add(k.replaceAll(suffix, ''));
        }
      }

      ApiService.syncStudentToAdmin(
        phoneNumber: phone,
        coins: coins,
        selectedGrade: selectedGrade,
        fullName: userName.isNotEmpty ? userName : 'دانش‌آموز دانا',
        currentAvatar: userAvatar.isNotEmpty ? userAvatar : 'image/avatar/1.webp',
        currentTheme: currentTheme,
        totalCompletedLessons: completedLessonsCount,
        completedLessons: completedList,
      );
    }
  }

  // پاکسازی کامل داده‌های حافظه موقت هنگام خروج از حساب
  static Future<void> logoutClean() async {
    if (phoneNumber.isNotEmpty) {
      await save();
    }
    isLoggedIn = false;
    phoneNumber = '';
    pendingWelcomeGift = false;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('pendingWelcomeGift', false);
    prefs.setBool('isLoggedIn', false);
    prefs.setString('phoneNumber', '');
    userName = '';
    userAvatar = '';
    coins = 0;
    currentTheme = 'royal_purple';
    unlockedAvatars = [...defaultAvatars];
    unlockedThemes = ['royal_purple'];
    purchasedVipItems = [];
    lesson1Part1Completed = false;
    lesson1Part2Completed = false;
    lesson1Part3Completed = false;
    lesson2Part1Completed = false;
    lesson2Part2Completed = false;
    lesson2Part3Completed = false;
    lesson3Part1Completed = false;
    lesson3Part2Completed = false;
    lesson3Part3Completed = false;
    lesson4Part1Completed = false;
    lesson4Part2Completed = false;
    lesson4Part3Completed = false;
    lesson5Part1Completed = false;
    lesson5Part2Completed = false;
    lesson5Part3Completed = false;
    lesson6Part1Completed = false;
    lesson6Part2Completed = false;
    lesson6Part3Completed = false;
    lesson7Part1Completed = false;
    lesson7Part2Completed = false;
    lesson7Part3Completed = false;
    lesson8Part1Completed = false;
    lesson8Part2Completed = false;
    lesson8Part3Completed = false;
    lesson9Part1Completed = false;
    lesson9Part2Completed = false;
    lesson9Part3Completed = false;
    lesson10Part1Completed = false;
    lesson10Part2Completed = false;
    lesson10Part3Completed = false;
    lesson11Part1Completed = false;
    lesson11Part2Completed = false;
    lesson11Part3Completed = false;
    lesson12Part1Completed = false;
    lesson12Part2Completed = false;
    lesson12Part3Completed = false;
    lesson13Part1Completed = false;
    lesson13Part2Completed = false;
    lesson13Part3Completed = false;
    lesson14Part1Completed = false;
    lesson14Part2Completed = false;
    lesson14Part3Completed = false;
    lesson15Part1Completed = false;
    lesson15Part2Completed = false;
    lesson15Part3Completed = false;
    lesson16Part1Completed = false;
    lesson16Part2Completed = false;
    lesson16Part3Completed = false;
    lesson17Part1Completed = false;
    lesson17Part2Completed = false;
    lesson17Part3Completed = false;
    lesson18Part1Completed = false;
    lesson18Part2Completed = false;
    lesson18Part3Completed = false;
    lesson19Part1Completed = false;
    lesson19Part2Completed = false;
    lesson19Part3Completed = false;
    lesson20Part1Completed = false;
    lesson20Part2Completed = false;
    lesson20Part3Completed = false;
    arabic8Lesson1Part1Completed = false;
    arabic8Lesson1Part2Completed = false;
    arabic8Lesson1Part3Completed = false;
    arabic8Lesson2Part1Completed = false;
    arabic8Lesson2Part2Completed = false;
    arabic8Lesson2Part3Completed = false;
    arabic8Lesson3Part1Completed = false;
    arabic8Lesson3Part2Completed = false;
    arabic8Lesson3Part3Completed = false;
    arabic8Lesson4Part1Completed = false;
    arabic8Lesson4Part2Completed = false;
    arabic8Lesson4Part3Completed = false;
    arabic8Lesson5Part1Completed = false;
    arabic8Lesson5Part2Completed = false;
    arabic8Lesson5Part3Completed = false;
    arabic8Lesson6Part1Completed = false;
    arabic8Lesson6Part2Completed = false;
    arabic8Lesson6Part3Completed = false;
    arabic8Lesson7Part1Completed = false;
    arabic8Lesson7Part2Completed = false;
    arabic8Lesson7Part3Completed = false;
    arabic8Lesson8Part1Completed = false;
    arabic8Lesson8Part2Completed = false;
    arabic8Lesson8Part3Completed = false;
    arabic8Lesson9Part1Completed = false;
    arabic8Lesson9Part2Completed = false;
    arabic8Lesson9Part3Completed = false;
    arabic8Lesson10Part1Completed = false;
    arabic8Lesson10Part2Completed = false;
    arabic8Lesson10Part3Completed = false;
    arabic9Lesson1Part1Completed = false;
    arabic9Lesson1Part2Completed = false;
    arabic9Lesson1Part3Completed = false;
    arabic9Lesson2Part1Completed = false;
    arabic9Lesson2Part2Completed = false;
    arabic9Lesson2Part3Completed = false;
    arabic9Lesson3Part1Completed = false;
    arabic9Lesson3Part2Completed = false;
    arabic9Lesson3Part3Completed = false;
    arabic9Lesson4Part1Completed = false;
    arabic9Lesson4Part2Completed = false;
    arabic9Lesson4Part3Completed = false;
    arabic9Lesson5Part1Completed = false;
    arabic9Lesson5Part2Completed = false;
    arabic9Lesson5Part3Completed = false;
    arabic9Lesson6Part1Completed = false;
    arabic9Lesson6Part2Completed = false;
    arabic9Lesson6Part3Completed = false;
    arabic9Lesson7Part1Completed = false;
    arabic9Lesson7Part2Completed = false;
    arabic9Lesson7Part3Completed = false;
    arabic9Lesson8Part1Completed = false;
    arabic9Lesson8Part2Completed = false;
    arabic9Lesson8Part3Completed = false;
    arabic9Lesson9Part1Completed = false;
    arabic9Lesson9Part2Completed = false;
    arabic9Lesson9Part3Completed = false;
    arabic9Lesson10Part1Completed = false;
    arabic9Lesson10Part2Completed = false;
    arabic9Lesson10Part3Completed = false;
    quran7Lesson1Part1Completed = false;
    quran7Lesson1Part2Completed = false;
    quran7Lesson1Part3Completed = false;
    quran7Lesson2Part1Completed = false;
    quran7Lesson2Part2Completed = false;
    quran7Lesson2Part3Completed = false;
    quran7Lesson3Part1Completed = false;
    quran7Lesson3Part2Completed = false;
    quran7Lesson3Part3Completed = false;
    quran7Lesson4Part1Completed = false;
    quran7Lesson4Part2Completed = false;
    quran7Lesson4Part3Completed = false;
    quran7Lesson5Part1Completed = false;
    quran7Lesson5Part2Completed = false;
    quran7Lesson5Part3Completed = false;
    quran7Lesson6Part1Completed = false;
    quran7Lesson6Part2Completed = false;
    quran7Lesson6Part3Completed = false;
    quran7Lesson7Part1Completed = false;
    quran7Lesson7Part2Completed = false;
    quran7Lesson7Part3Completed = false;
    quran7Lesson8Part1Completed = false;
    quran7Lesson8Part2Completed = false;
    quran7Lesson8Part3Completed = false;
    quran7Lesson9Part1Completed = false;
    quran7Lesson9Part2Completed = false;
    quran7Lesson9Part3Completed = false;
    quran7Lesson10Part1Completed = false;
    quran7Lesson10Part2Completed = false;
    quran7Lesson10Part3Completed = false;
    quran7Lesson11Part1Completed = false;
    quran7Lesson11Part2Completed = false;
    quran7Lesson11Part3Completed = false;
    quran7Lesson12Part1Completed = false;
    quran7Lesson12Part2Completed = false;
    quran7Lesson12Part3Completed = false;
    quran8Lesson1Part1Completed = false;
    quran8Lesson1Part2Completed = false;
    quran8Lesson1Part3Completed = false;
    quran8Lesson2Part1Completed = false;
    quran8Lesson2Part2Completed = false;
    quran8Lesson2Part3Completed = false;
    quran8Lesson3Part1Completed = false;
    quran8Lesson3Part2Completed = false;
    quran8Lesson3Part3Completed = false;
    quran8Lesson4Part1Completed = false;
    quran8Lesson4Part2Completed = false;
    quran8Lesson4Part3Completed = false;
    quran8Lesson5Part1Completed = false;
    quran8Lesson5Part2Completed = false;
    quran8Lesson5Part3Completed = false;
    quran8Lesson6Part1Completed = false;
    quran8Lesson6Part2Completed = false;
    quran8Lesson6Part3Completed = false;
    quran8Lesson7Part1Completed = false;
    quran8Lesson7Part2Completed = false;
    quran8Lesson7Part3Completed = false;
    quran8Lesson8Part1Completed = false;
    quran8Lesson8Part2Completed = false;
    quran8Lesson8Part3Completed = false;
    quran8Lesson9Part1Completed = false;
    quran8Lesson9Part2Completed = false;
    quran8Lesson9Part3Completed = false;
    quran8Lesson10Part1Completed = false;
    quran8Lesson10Part2Completed = false;
    quran8Lesson10Part3Completed = false;
    quran8Lesson11Part1Completed = false;
    quran8Lesson11Part2Completed = false;
    quran8Lesson11Part3Completed = false;
    quran8Lesson12Part1Completed = false;
    quran8Lesson12Part2Completed = false;
    quran8Lesson12Part3Completed = false;
    quran9Lesson1Part2Completed = false;
    quran9Lesson1Part3Completed = false;
    quran9Lesson2Part1Completed = false;
    quran9Lesson2Part2Completed = false;
    quran9Lesson2Part3Completed = false;
    quran9Lesson3Part1Completed = false;
    quran9Lesson3Part2Completed = false;
    quran9Lesson3Part3Completed = false;
    quran9Lesson4Part1Completed = false;
    quran9Lesson4Part2Completed = false;
    quran9Lesson4Part3Completed = false;
    quran9Lesson5Part1Completed = false;
    quran9Lesson5Part2Completed = false;
    quran9Lesson5Part3Completed = false;
    quran9Lesson6Part1Completed = false;
    quran9Lesson6Part2Completed = false;
    quran9Lesson6Part3Completed = false;
    quran9Lesson7Part1Completed = false;
    quran9Lesson7Part2Completed = false;
    quran9Lesson7Part3Completed = false;
    quran9Lesson8Part1Completed = false;
    quran9Lesson8Part2Completed = false;
    quran9Lesson8Part3Completed = false;
    quran9Lesson9Part1Completed = false;
    quran9Lesson9Part2Completed = false;
    quran9Lesson9Part3Completed = false;
    quran9Lesson10Part1Completed = false;
    quran9Lesson10Part2Completed = false;
    quran9Lesson10Part3Completed = false;
    quran9Lesson11Part1Completed = false;
    quran9Lesson11Part2Completed = false;
    quran9Lesson11Part3Completed = false;
    zaban7Lesson1Part1Completed = false;
    zaban7Lesson1Part2Completed = false;
    zaban7Lesson1Part3Completed = false;
    zaban7WelcomePart1Completed = false;
    zaban7WelcomePart2Completed = false;
    zaban7WelcomePart3Completed = false;
    zaban7Lesson3Part1Completed = false;
    zaban7Lesson3Part2Completed = false;
    zaban7Lesson3Part3Completed = false;
    zaban7Lesson4Part1Completed = false;
    zaban7Lesson4Part2Completed = false;
    zaban7Lesson4Part3Completed = false;
    zaban7Lesson5Part1Completed = false;
    zaban7Lesson5Part2Completed = false;
    zaban7Lesson5Part3Completed = false;
    zaban7Lesson7Part1Completed = false;
    zaban7Lesson7Part2Completed = false;
    zaban7Lesson7Part3Completed = false;
    zaban8Lesson1Part1Completed = false;
    zaban8Lesson1Part2Completed = false;
    zaban8Lesson1Part3Completed = false;
    zaban8Lesson2Part1Completed = false;
    zaban8Lesson2Part2Completed = false;
    zaban8Lesson2Part3Completed = false;
    zaban8Lesson3Part1Completed = false;
    zaban8Lesson3Part2Completed = false;
    zaban8Lesson3Part3Completed = false;
    zaban8Lesson4Part1Completed = false;
    zaban8Lesson4Part2Completed = false;
    zaban8Lesson4Part3Completed = false;
    zaban8Lesson5Part1Completed = false;
    zaban8Lesson5Part2Completed = false;
    zaban8Lesson5Part3Completed = false;
    zaban8Lesson6Part1Completed = false;
    zaban8Lesson6Part2Completed = false;
    zaban8Lesson6Part3Completed = false;
    zaban9Lesson1Part1Completed = false;
    zaban9Lesson1Part2Completed = false;
    zaban9Lesson1Part3Completed = false;
    zaban9Lesson2Part1Completed = false;
    zaban9Lesson2Part2Completed = false;
    zaban9Lesson2Part3Completed = false;
    zaban9Lesson3Part1Completed = false;
    zaban9Lesson3Part2Completed = false;
    zaban9Lesson3Part3Completed = false;
    zaban9Lesson4Part1Completed = false;
    zaban9Lesson4Part2Completed = false;
    zaban9Lesson4Part3Completed = false;
    farsi7Lesson1Part1Completed = false;
    farsi7Lesson1Part2Completed = false;
    farsi7Lesson1Part3Completed = false;
    farsi7Lesson2Part1Completed = false;
    farsi7Lesson2Part2Completed = false;
    farsi7Lesson2Part3Completed = false;
    farsi7Lesson3Part1Completed = false;
    farsi7Lesson3Part2Completed = false;
    farsi7Lesson3Part3Completed = false;
    farsi7Lesson4Part1Completed = false;
    farsi7Lesson4Part2Completed = false;
    farsi7Lesson4Part3Completed = false;
    farsi7Lesson5Part1Completed = false;
    farsi7Lesson5Part2Completed = false;
    farsi7Lesson5Part3Completed = false;
    farsi7Lesson6Part1Completed = false;
    farsi7Lesson6Part2Completed = false;
    farsi7Lesson6Part3Completed = false;
    farsi8Lesson1Part1Completed = false;
    farsi8Lesson1Part2Completed = false;
    farsi8Lesson1Part3Completed = false;
    farsi8Lesson2Part1Completed = false;
    farsi8Lesson2Part2Completed = false;
    farsi8Lesson2Part3Completed = false;
    farsi8Lesson3Part1Completed = false;
    farsi8Lesson3Part2Completed = false;
    farsi8Lesson3Part3Completed = false;
    farsi8Lesson4Part1Completed = false;
    farsi8Lesson4Part2Completed = false;
    farsi8Lesson4Part3Completed = false;
    farsi8Lesson5Part1Completed = false;
    farsi8Lesson5Part2Completed = false;
    farsi8Lesson5Part3Completed = false;
    farsi8Lesson6Part1Completed = false;
    farsi8Lesson6Part2Completed = false;
    farsi8Lesson6Part3Completed = false;
    farsi9Lesson1Part1Completed = false;
    farsi9Lesson1Part2Completed = false;
    farsi9Lesson1Part3Completed = false;
    farsi9Lesson2Part1Completed = false;
    farsi9Lesson2Part2Completed = false;
    farsi9Lesson2Part3Completed = false;
    farsi9Lesson3Part1Completed = false;
    farsi9Lesson3Part2Completed = false;
    farsi9Lesson3Part3Completed = false;
    farsi9Lesson4Part1Completed = false;
    farsi9Lesson4Part2Completed = false;
    farsi9Lesson4Part3Completed = false;
    farsi9Lesson5Part1Completed = false;
    farsi9Lesson5Part2Completed = false;
    farsi9Lesson5Part3Completed = false;
    farsi9Lesson6Part1Completed = false;
    farsi9Lesson6Part2Completed = false;
    farsi9Lesson6Part3Completed = false;
    payam7Lesson1Part1Completed = false;
    payam7Lesson1Part2Completed = false;
    payam7Lesson1Part3Completed = false;
    payam7Lesson2Part1Completed = false;
    payam7Lesson2Part2Completed = false;
    payam7Lesson2Part3Completed = false;
    payam7Lesson3Part1Completed = false;
    payam7Lesson3Part2Completed = false;
    payam7Lesson3Part3Completed = false;
    payam7Lesson4Part1Completed = false;
    payam7Lesson4Part2Completed = false;
    payam7Lesson4Part3Completed = false;
    payam7Lesson5Part1Completed = false;
    payam7Lesson5Part2Completed = false;
    payam7Lesson5Part3Completed = false;
    payam8Lesson1Part1Completed = false;
    payam8Lesson1Part2Completed = false;
    payam8Lesson1Part3Completed = false;
    payam8Lesson2Part1Completed = false;
    payam8Lesson2Part2Completed = false;
    payam8Lesson2Part3Completed = false;
    payam8Lesson3Part1Completed = false;
    payam8Lesson3Part2Completed = false;
    payam8Lesson3Part3Completed = false;
    payam8Lesson4Part1Completed = false;
    payam8Lesson4Part2Completed = false;
    payam8Lesson4Part3Completed = false;
    payam8Lesson5Part1Completed = false;
    payam8Lesson5Part2Completed = false;
    payam8Lesson5Part3Completed = false;
    payam8Lesson6Part1Completed = false;
    payam8Lesson6Part2Completed = false;
    payam8Lesson6Part3Completed = false;
    payam9Lesson1Part1Completed = false;
    payam9Lesson1Part2Completed = false;
    payam9Lesson1Part3Completed = false;
    payam9Lesson2Part1Completed = false;
    payam9Lesson2Part2Completed = false;
    payam9Lesson2Part3Completed = false;
    payam9Lesson3Part1Completed = false;
    payam9Lesson3Part2Completed = false;
    payam9Lesson3Part3Completed = false;
    payam9Lesson4Part1Completed = false;
    payam9Lesson4Part2Completed = false;
    payam9Lesson4Part3Completed = false;
    payam9Lesson5Part1Completed = false;
    payam9Lesson5Part2Completed = false;
    payam9Lesson5Part3Completed = false;
    motaleat7Lesson1Part1Completed = false;
    motaleat7Lesson1Part2Completed = false;
    motaleat7Lesson1Part3Completed = false;
    motaleat7Lesson2Part1Completed = false;
    motaleat7Lesson2Part2Completed = false;
    motaleat7Lesson2Part3Completed = false;
    motaleat7Lesson3Part1Completed = false;
    motaleat7Lesson3Part2Completed = false;
    motaleat7Lesson3Part3Completed = false;
    motaleat7Lesson4Part1Completed = false;
    motaleat7Lesson4Part2Completed = false;
    motaleat7Lesson4Part3Completed = false;
    motaleat7Lesson5Part1Completed = false;
    motaleat7Lesson5Part2Completed = false;
    motaleat7Lesson5Part3Completed = false;
    motaleat7Lesson6Part1Completed = false;
    motaleat7Lesson6Part2Completed = false;
    motaleat7Lesson6Part3Completed = false;
    motaleat7Lesson7Part1Completed = false;
    motaleat7Lesson7Part2Completed = false;
    motaleat7Lesson7Part3Completed = false;
    motaleat7Lesson8Part1Completed = false;
    motaleat7Lesson8Part2Completed = false;
    motaleat7Lesson8Part3Completed = false;
    motaleat7Lesson9Part1Completed = false;
    motaleat7Lesson9Part2Completed = false;
    motaleat7Lesson9Part3Completed = false;
    motaleat7Lesson10Part1Completed = false;
    motaleat7Lesson10Part2Completed = false;
    motaleat7Lesson10Part3Completed = false;
    motaleat7Lesson11Part1Completed = false;
    motaleat7Lesson11Part2Completed = false;
    motaleat7Lesson11Part3Completed = false;
    motaleat7Lesson12Part1Completed = false;
    motaleat7Lesson12Part2Completed = false;
    motaleat7Lesson12Part3Completed = false;
    motaleat8Lesson1Part1Completed = false;
    motaleat8Lesson1Part2Completed = false;
    motaleat8Lesson1Part3Completed = false;
    motaleat8Lesson2Part1Completed = false;
    motaleat8Lesson2Part2Completed = false;
    motaleat8Lesson2Part3Completed = false;
    motaleat8Lesson3Part1Completed = false;
    motaleat8Lesson3Part2Completed = false;
    motaleat8Lesson3Part3Completed = false;
    motaleat8Lesson4Part1Completed = false;
    motaleat8Lesson4Part2Completed = false;
    motaleat8Lesson4Part3Completed = false;
    motaleat8Lesson5Part1Completed = false;
    motaleat8Lesson5Part2Completed = false;
    motaleat8Lesson5Part3Completed = false;
    motaleat8Lesson6Part1Completed = false;
    motaleat8Lesson6Part2Completed = false;
    motaleat8Lesson6Part3Completed = false;
    motaleat8Lesson7Part1Completed = false;
    motaleat8Lesson7Part2Completed = false;
    motaleat8Lesson7Part3Completed = false;
    motaleat8Lesson8Part1Completed = false;
    motaleat8Lesson8Part2Completed = false;
    motaleat8Lesson8Part3Completed = false;
    motaleat8Lesson9Part1Completed = false;
    motaleat8Lesson9Part2Completed = false;
    motaleat8Lesson9Part3Completed = false;
    motaleat8Lesson10Part1Completed = false;
    motaleat8Lesson10Part2Completed = false;
    motaleat8Lesson10Part3Completed = false;
    motaleat8Lesson11Part1Completed = false;
    motaleat8Lesson11Part2Completed = false;
    motaleat8Lesson11Part3Completed = false;
    motaleat8Lesson12Part1Completed = false;
    motaleat8Lesson12Part2Completed = false;
    motaleat8Lesson12Part3Completed = false;

    motaleat9Lesson1Part1Completed = false;
    motaleat9Lesson1Part2Completed = false;
    motaleat9Lesson1Part3Completed = false;
    motaleat9Lesson2Part1Completed = false;
    motaleat9Lesson2Part2Completed = false;
    motaleat9Lesson2Part3Completed = false;
    motaleat9Lesson3Part1Completed = false;
    motaleat9Lesson3Part2Completed = false;
    motaleat9Lesson3Part3Completed = false;
    motaleat9Lesson4Part1Completed = false;
    motaleat9Lesson4Part2Completed = false;
    motaleat9Lesson4Part3Completed = false;
    motaleat9Lesson5Part1Completed = false;
    motaleat9Lesson5Part2Completed = false;
    motaleat9Lesson5Part3Completed = false;
    motaleat9Lesson6Part1Completed = false;
    motaleat9Lesson6Part2Completed = false;
    motaleat9Lesson6Part3Completed = false;
    motaleat9Lesson7Part1Completed = false;
    motaleat9Lesson7Part2Completed = false;
    motaleat9Lesson7Part3Completed = false;
    motaleat9Lesson8Part1Completed = false;
    motaleat9Lesson8Part2Completed = false;
    motaleat9Lesson8Part3Completed = false;
    motaleat9Lesson9Part1Completed = false;
    motaleat9Lesson9Part2Completed = false;
    motaleat9Lesson9Part3Completed = false;
    motaleat9Lesson10Part1Completed = false;
    motaleat9Lesson10Part2Completed = false;
    motaleat9Lesson10Part3Completed = false;
    motaleat9Lesson11Part1Completed = false;
    motaleat9Lesson11Part2Completed = false;
    motaleat9Lesson11Part3Completed = false;
    motaleat9Lesson12Part1Completed = false;
    motaleat9Lesson12Part2Completed = false;
    motaleat9Lesson12Part3Completed = false;
    zaban9Lesson5Part1Completed = false;
    zaban9Lesson5Part2Completed = false;
    zaban9Lesson5Part3Completed = false;
    zaban9Lesson6Part1Completed = false;
    zaban9Lesson6Part2Completed = false;
    zaban9Lesson6Part3Completed = false;
    zaban9Lesson3Part2Completed = false;
    zaban9Lesson3Part3Completed = false;
    zaban8Lesson6Part2Completed = false;
    zaban8Lesson6Part3Completed = false;
    zaban8Lesson7Part1Completed = false;
    zaban8Lesson7Part2Completed = false;
    zaban8Lesson7Part3Completed = false;
    zaban8Lesson4Part1Completed = false;
    zaban8Lesson4Part2Completed = false;
    zaban8Lesson4Part3Completed = false;
    zaban8Lesson3Part3Completed = false;
    zaban8Lesson2Part2Completed = false;
    zaban8Lesson2Part3Completed = false;
    zaban7Lesson7Part3Completed = false;
    zaban7Lesson8Part1Completed = false;
    zaban7Lesson8Part2Completed = false;
    zaban7Lesson8Part3Completed = false;
    zaban7Lesson7Part2Completed = false;
    zaban7Lesson7Part3Completed = false;
    zaban7Lesson6Part1Completed = false;
    zaban7Lesson6Part2Completed = false;
    zaban7Lesson6Part3Completed = false;
    zaban7Lesson5Part3Completed = false;
    zaban7Lesson3Part2Completed = false;
    zaban7Lesson3Part3Completed = false;
    quran9Lesson7Part3Completed = false;
    quran9Lesson6Part3Completed = false;
    riyazi7Chapter1Completed = false;
    riyazi7Chapter2Completed = false;
    riyazi7Chapter3Completed = false;
    riyazi7Chapter4Completed = false;
    riyazi7Chapter5Completed = false;
    riyazi7Chapter6Completed = false;
    riyazi7Chapter7Completed = false;
    riyazi7Chapter8Completed = false;
    riyazi7Chapter9Completed = false;
    riyazi8Chapter1Completed = false;
    riyazi8Chapter2Completed = false;
    riyazi8Chapter3Completed = false;
    riyazi8Chapter4Completed = false;
    riyazi8Chapter5Completed = false;
    riyazi8Chapter6Completed = false;
    riyazi8Chapter7Completed = false;
    riyazi8Chapter8Completed = false;
    riyazi8Chapter9Completed = false;
    riyazi9Chapter1Completed = false;
    riyazi9Chapter2Completed = false;
    riyazi9Chapter3Completed = false;
    riyazi9Chapter4Completed = false;
    riyazi9Chapter5Completed = false;
    riyazi9Chapter6Completed = false;
    riyazi9Chapter7Completed = false;
    riyazi9Chapter8Completed = false;
  }

  // ذخیره اطلاعات در حافظه ماندگار دستگاه (کاملاً به تفکیک شماره موبایل)


  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
    prefs.setString('phoneNumber', phoneNumber);
    prefs.setInt('selectedGrade', selectedGrade);
    prefs.setString('userName', userName);
    prefs.setString('userAvatar', userAvatar);
    prefs.setBool('pendingWelcomeGift', pendingWelcomeGift);
    prefs.setString('currentTheme', currentTheme);
    prefs.setBool('riyazi7Chapter1Completed', riyazi7Chapter1Completed);
    prefs.setBool('riyazi7Chapter2Completed', riyazi7Chapter2Completed);
    prefs.setBool('riyazi7Chapter3Completed', riyazi7Chapter3Completed);
    prefs.setBool('riyazi7Chapter4Completed', riyazi7Chapter4Completed);
    prefs.setBool('riyazi7Chapter5Completed', riyazi7Chapter5Completed);
    prefs.setBool('riyazi7Chapter6Completed', riyazi7Chapter6Completed);
    prefs.setBool('riyazi7Chapter7Completed', riyazi7Chapter7Completed);
    prefs.setBool('riyazi7Chapter8Completed', riyazi7Chapter8Completed);
    prefs.setBool('riyazi7Chapter9Completed', riyazi7Chapter9Completed);
    prefs.setBool('riyazi8Chapter1Completed', riyazi8Chapter1Completed);
    prefs.setBool('riyazi8Chapter2Completed', riyazi8Chapter2Completed);
    prefs.setBool('riyazi8Chapter3Completed', riyazi8Chapter3Completed);
    prefs.setBool('riyazi8Chapter4Completed', riyazi8Chapter4Completed);
    prefs.setBool('riyazi8Chapter5Completed', riyazi8Chapter5Completed);
    prefs.setBool('riyazi8Chapter6Completed', riyazi8Chapter6Completed);
    prefs.setBool('riyazi8Chapter7Completed', riyazi8Chapter7Completed);
    prefs.setBool('riyazi8Chapter8Completed', riyazi8Chapter8Completed);
    prefs.setBool('riyazi8Chapter9Completed', riyazi8Chapter9Completed);
    prefs.setBool('riyazi9Chapter1Completed', riyazi9Chapter1Completed);
    prefs.setBool('riyazi9Chapter2Completed', riyazi9Chapter2Completed);
    prefs.setBool('riyazi9Chapter3Completed', riyazi9Chapter3Completed);
    prefs.setBool('riyazi9Chapter4Completed', riyazi9Chapter4Completed);
    prefs.setBool('riyazi9Chapter5Completed', riyazi9Chapter5Completed);
    prefs.setBool('riyazi9Chapter6Completed', riyazi9Chapter6Completed);
    prefs.setBool('riyazi9Chapter7Completed', riyazi9Chapter7Completed);
    prefs.setBool('riyazi9Chapter8Completed', riyazi9Chapter8Completed);
    prefs.setBool('lesson1Part1Completed', lesson1Part1Completed);
    prefs.setBool('lesson1Part2Completed', lesson1Part2Completed);
    prefs.setBool('lesson1Part3Completed', lesson1Part3Completed);
    prefs.setBool('lesson2Part1Completed', lesson2Part1Completed);
    prefs.setBool('lesson2Part2Completed', lesson2Part2Completed);
    prefs.setBool('lesson2Part3Completed', lesson2Part3Completed);
    prefs.setBool('lesson3Part1Completed', lesson3Part1Completed);
    prefs.setBool('lesson3Part2Completed', lesson3Part2Completed);
    prefs.setBool('lesson3Part3Completed', lesson3Part3Completed);
    prefs.setBool('lesson4Part1Completed', lesson4Part1Completed);
    prefs.setBool('lesson4Part2Completed', lesson4Part2Completed);
    prefs.setBool('lesson4Part3Completed', lesson4Part3Completed);
    prefs.setBool('lesson5Part1Completed', lesson5Part1Completed);
    prefs.setBool('lesson5Part2Completed', lesson5Part2Completed);
    prefs.setBool('lesson5Part3Completed', lesson5Part3Completed);
    prefs.setBool('lesson6Part1Completed', lesson6Part1Completed);
    prefs.setBool('lesson6Part2Completed', lesson6Part2Completed);
    prefs.setBool('lesson6Part3Completed', lesson6Part3Completed);
    prefs.setBool('lesson7Part1Completed', lesson7Part1Completed);
    prefs.setBool('lesson7Part2Completed', lesson7Part2Completed);
    prefs.setBool('lesson7Part3Completed', lesson7Part3Completed);
    prefs.setBool('lesson8Part1Completed', lesson8Part1Completed);
    prefs.setBool('lesson8Part2Completed', lesson8Part2Completed);
    prefs.setBool('lesson8Part3Completed', lesson8Part3Completed);
    prefs.setBool('lesson9Part1Completed', lesson9Part1Completed);
    prefs.setBool('lesson9Part2Completed', lesson9Part2Completed);
    prefs.setBool('lesson9Part3Completed', lesson9Part3Completed);
    prefs.setBool('lesson10Part1Completed', lesson10Part1Completed);
    prefs.setBool('lesson10Part2Completed', lesson10Part2Completed);
    prefs.setBool('lesson10Part3Completed', lesson10Part3Completed);
    prefs.setBool('lesson11Part1Completed', lesson11Part1Completed);
    prefs.setBool('lesson11Part2Completed', lesson11Part2Completed);
    prefs.setBool('lesson11Part3Completed', lesson11Part3Completed);
    prefs.setBool('lesson12Part1Completed', lesson12Part1Completed);
    prefs.setBool('lesson12Part2Completed', lesson12Part2Completed);
    prefs.setBool('lesson12Part3Completed', lesson12Part3Completed);
    prefs.setBool('lesson13Part1Completed', lesson13Part1Completed);
    prefs.setBool('lesson13Part2Completed', lesson13Part2Completed);
    prefs.setBool('lesson13Part3Completed', lesson13Part3Completed);
    prefs.setBool('lesson14Part1Completed', lesson14Part1Completed);
    prefs.setBool('lesson14Part2Completed', lesson14Part2Completed);
    prefs.setBool('lesson14Part3Completed', lesson14Part3Completed);
    prefs.setBool('lesson15Part1Completed', lesson15Part1Completed);
    prefs.setBool('lesson15Part2Completed', lesson15Part2Completed);
    prefs.setBool('lesson15Part3Completed', lesson15Part3Completed);
    prefs.setBool('lesson16Part1Completed', lesson16Part1Completed);
    prefs.setBool('lesson16Part2Completed', lesson16Part2Completed);
    prefs.setBool('lesson16Part3Completed', lesson16Part3Completed);
    prefs.setBool('lesson17Part1Completed', lesson17Part1Completed);
    prefs.setBool('lesson17Part2Completed', lesson17Part2Completed);
    prefs.setBool('lesson17Part3Completed', lesson17Part3Completed);
    prefs.setBool('lesson18Part1Completed', lesson18Part1Completed);
    prefs.setBool('lesson18Part2Completed', lesson18Part2Completed);
    prefs.setBool('lesson18Part3Completed', lesson18Part3Completed);
    prefs.setBool('lesson19Part1Completed', lesson19Part1Completed);
    prefs.setBool('lesson19Part2Completed', lesson19Part2Completed);
    prefs.setBool('lesson19Part3Completed', lesson19Part3Completed);
    prefs.setBool('lesson20Part1Completed', lesson20Part1Completed);
    prefs.setBool('lesson20Part2Completed', lesson20Part2Completed);
    prefs.setBool('lesson20Part3Completed', lesson20Part3Completed);
    prefs.setBool('arabic8Lesson1Part1Completed', arabic8Lesson1Part1Completed);
    prefs.setBool('arabic8Lesson1Part2Completed', arabic8Lesson1Part2Completed);
    prefs.setBool('arabic8Lesson1Part3Completed', arabic8Lesson1Part3Completed);
    prefs.setBool('arabic8Lesson2Part1Completed', arabic8Lesson2Part1Completed);
    prefs.setBool('arabic8Lesson2Part2Completed', arabic8Lesson2Part2Completed);
    prefs.setBool('arabic8Lesson2Part3Completed', arabic8Lesson2Part3Completed);
    prefs.setBool('arabic8Lesson3Part1Completed', arabic8Lesson3Part1Completed);
    prefs.setBool('arabic8Lesson3Part2Completed', arabic8Lesson3Part2Completed);
    prefs.setBool('arabic8Lesson3Part3Completed', arabic8Lesson3Part3Completed);
    prefs.setBool('arabic8Lesson4Part1Completed', arabic8Lesson4Part1Completed);
    prefs.setBool('arabic8Lesson4Part2Completed', arabic8Lesson4Part2Completed);
    prefs.setBool('arabic8Lesson4Part3Completed', arabic8Lesson4Part3Completed);
    prefs.setBool('arabic8Lesson5Part1Completed', arabic8Lesson5Part1Completed);
    prefs.setBool('arabic8Lesson5Part2Completed', arabic8Lesson5Part2Completed);
    prefs.setBool('arabic8Lesson5Part3Completed', arabic8Lesson5Part3Completed);
    prefs.setBool('arabic8Lesson6Part1Completed', arabic8Lesson6Part1Completed);
    prefs.setBool('arabic8Lesson6Part2Completed', arabic8Lesson6Part2Completed);
    prefs.setBool('arabic8Lesson6Part3Completed', arabic8Lesson6Part3Completed);
    prefs.setBool('arabic8Lesson7Part1Completed', arabic8Lesson7Part1Completed);
    prefs.setBool('arabic8Lesson7Part2Completed', arabic8Lesson7Part2Completed);
    prefs.setBool('arabic8Lesson7Part3Completed', arabic8Lesson7Part3Completed);
    prefs.setBool('arabic8Lesson8Part1Completed', arabic8Lesson8Part1Completed);
    prefs.setBool('arabic8Lesson8Part2Completed', arabic8Lesson8Part2Completed);
    prefs.setBool('arabic8Lesson8Part3Completed', arabic8Lesson8Part3Completed);
    prefs.setBool('arabic8Lesson9Part1Completed', arabic8Lesson9Part1Completed);
    prefs.setBool('arabic8Lesson9Part2Completed', arabic8Lesson9Part2Completed);
    prefs.setBool('arabic8Lesson9Part3Completed', arabic8Lesson9Part3Completed);
    prefs.setBool('arabic8Lesson10Part1Completed', arabic8Lesson10Part1Completed);
    prefs.setBool('arabic8Lesson10Part2Completed', arabic8Lesson10Part2Completed);
    prefs.setBool('arabic8Lesson10Part3Completed', arabic8Lesson10Part3Completed);
    prefs.setBool('arabic9Lesson1Part1Completed', arabic9Lesson1Part1Completed);
    prefs.setBool('arabic9Lesson1Part2Completed', arabic9Lesson1Part2Completed);
    prefs.setBool('arabic9Lesson1Part3Completed', arabic9Lesson1Part3Completed);
    prefs.setBool('arabic9Lesson2Part1Completed', arabic9Lesson2Part1Completed);
    prefs.setBool('arabic9Lesson2Part2Completed', arabic9Lesson2Part2Completed);
    prefs.setBool('arabic9Lesson2Part3Completed', arabic9Lesson2Part3Completed);
    prefs.setBool('arabic9Lesson3Part1Completed', arabic9Lesson3Part1Completed);
    prefs.setBool('arabic9Lesson3Part2Completed', arabic9Lesson3Part2Completed);
    prefs.setBool('arabic9Lesson3Part3Completed', arabic9Lesson3Part3Completed);
    prefs.setBool('arabic9Lesson4Part1Completed', arabic9Lesson4Part1Completed);
    prefs.setBool('arabic9Lesson4Part2Completed', arabic9Lesson4Part2Completed);
    prefs.setBool('arabic9Lesson4Part3Completed', arabic9Lesson4Part3Completed);
    prefs.setBool('arabic9Lesson5Part1Completed', arabic9Lesson5Part1Completed);
    prefs.setBool('arabic9Lesson5Part2Completed', arabic9Lesson5Part2Completed);
    prefs.setBool('arabic9Lesson5Part3Completed', arabic9Lesson5Part3Completed);
    prefs.setBool('arabic9Lesson6Part1Completed', arabic9Lesson6Part1Completed);
    prefs.setBool('arabic9Lesson6Part2Completed', arabic9Lesson6Part2Completed);
    prefs.setBool('arabic9Lesson6Part3Completed', arabic9Lesson6Part3Completed);
    prefs.setBool('arabic9Lesson7Part1Completed', arabic9Lesson7Part1Completed);
    prefs.setBool('arabic9Lesson7Part2Completed', arabic9Lesson7Part2Completed);
    prefs.setBool('arabic9Lesson7Part3Completed', arabic9Lesson7Part3Completed);
    prefs.setBool('arabic9Lesson8Part1Completed', arabic9Lesson8Part1Completed);
    prefs.setBool('arabic9Lesson8Part2Completed', arabic9Lesson8Part2Completed);
    prefs.setBool('arabic9Lesson8Part3Completed', arabic9Lesson8Part3Completed);
    prefs.setBool('arabic9Lesson9Part1Completed', arabic9Lesson9Part1Completed);
    prefs.setBool('arabic9Lesson9Part2Completed', arabic9Lesson9Part2Completed);
    prefs.setBool('arabic9Lesson9Part3Completed', arabic9Lesson9Part3Completed);
    prefs.setBool('arabic9Lesson10Part1Completed', arabic9Lesson10Part1Completed);
    prefs.setBool('arabic9Lesson10Part2Completed', arabic9Lesson10Part2Completed);
    prefs.setBool('arabic9Lesson10Part3Completed', arabic9Lesson10Part3Completed);
    prefs.setBool('quran7Lesson1Part1Completed', quran7Lesson1Part1Completed);
    prefs.setBool('quran7Lesson1Part2Completed', quran7Lesson1Part2Completed);
    prefs.setBool('quran7Lesson1Part3Completed', quran7Lesson1Part3Completed);
    prefs.setBool('quran7Lesson2Part1Completed', quran7Lesson2Part1Completed);
    prefs.setBool('quran7Lesson2Part2Completed', quran7Lesson2Part2Completed);
    prefs.setBool('quran7Lesson2Part3Completed', quran7Lesson2Part3Completed);
    prefs.setBool('quran7Lesson3Part1Completed', quran7Lesson3Part1Completed);
    prefs.setBool('quran7Lesson3Part2Completed', quran7Lesson3Part2Completed);
    prefs.setBool('quran7Lesson3Part3Completed', quran7Lesson3Part3Completed);
    prefs.setBool('quran7Lesson4Part1Completed', quran7Lesson4Part1Completed);
    prefs.setBool('quran7Lesson4Part2Completed', quran7Lesson4Part2Completed);
    prefs.setBool('quran7Lesson4Part3Completed', quran7Lesson4Part3Completed);
    prefs.setBool('quran7Lesson5Part1Completed', quran7Lesson5Part1Completed);
    prefs.setBool('quran7Lesson5Part2Completed', quran7Lesson5Part2Completed);
    prefs.setBool('quran7Lesson5Part3Completed', quran7Lesson5Part3Completed);
    prefs.setBool('quran7Lesson6Part1Completed', quran7Lesson6Part1Completed);
    prefs.setBool('quran7Lesson6Part2Completed', quran7Lesson6Part2Completed);
    prefs.setBool('quran7Lesson6Part3Completed', quran7Lesson6Part3Completed);
    prefs.setBool('quran7Lesson7Part1Completed', quran7Lesson7Part1Completed);
    prefs.setBool('quran7Lesson7Part2Completed', quran7Lesson7Part2Completed);
    prefs.setBool('quran7Lesson7Part3Completed', quran7Lesson7Part3Completed);
    prefs.setBool('quran7Lesson8Part1Completed', quran7Lesson8Part1Completed);
    prefs.setBool('quran7Lesson8Part2Completed', quran7Lesson8Part2Completed);
    prefs.setBool('quran7Lesson8Part3Completed', quran7Lesson8Part3Completed);
    prefs.setBool('quran7Lesson9Part1Completed', quran7Lesson9Part1Completed);
    prefs.setBool('quran7Lesson9Part2Completed', quran7Lesson9Part2Completed);
    prefs.setBool('quran7Lesson9Part3Completed', quran7Lesson9Part3Completed);
    prefs.setBool('quran7Lesson10Part1Completed', quran7Lesson10Part1Completed);
    prefs.setBool('quran7Lesson10Part2Completed', quran7Lesson10Part2Completed);
    prefs.setBool('quran7Lesson10Part3Completed', quran7Lesson10Part3Completed);
    prefs.setBool('quran7Lesson11Part1Completed', quran7Lesson11Part1Completed);
    prefs.setBool('quran7Lesson11Part2Completed', quran7Lesson11Part2Completed);
    prefs.setBool('quran7Lesson11Part3Completed', quran7Lesson11Part3Completed);
    prefs.setBool('quran7Lesson12Part1Completed', quran7Lesson12Part1Completed);
    prefs.setBool('quran7Lesson12Part2Completed', quran7Lesson12Part2Completed);
    prefs.setBool('quran7Lesson12Part3Completed', quran7Lesson12Part3Completed);
    prefs.setBool('quran8Lesson1Part1Completed', quran8Lesson1Part1Completed);
    prefs.setBool('quran8Lesson1Part2Completed', quran8Lesson1Part2Completed);
    prefs.setBool('quran8Lesson1Part3Completed', quran8Lesson1Part3Completed);
    prefs.setBool('quran8Lesson2Part1Completed', quran8Lesson2Part1Completed);
    prefs.setBool('quran8Lesson2Part2Completed', quran8Lesson2Part2Completed);
    prefs.setBool('quran8Lesson2Part3Completed', quran8Lesson2Part3Completed);
    prefs.setBool('quran8Lesson3Part1Completed', quran8Lesson3Part1Completed);
    prefs.setBool('quran8Lesson3Part2Completed', quran8Lesson3Part2Completed);
    prefs.setBool('quran8Lesson3Part3Completed', quran8Lesson3Part3Completed);
    prefs.setBool('quran8Lesson4Part1Completed', quran8Lesson4Part1Completed);
    prefs.setBool('quran8Lesson4Part2Completed', quran8Lesson4Part2Completed);
    prefs.setBool('quran8Lesson4Part3Completed', quran8Lesson4Part3Completed);
    prefs.setBool('quran8Lesson5Part1Completed', quran8Lesson5Part1Completed);
    prefs.setBool('quran8Lesson5Part2Completed', quran8Lesson5Part2Completed);
    prefs.setBool('quran8Lesson5Part3Completed', quran8Lesson5Part3Completed);
    prefs.setBool('quran8Lesson6Part1Completed', quran8Lesson6Part1Completed);
    prefs.setBool('quran8Lesson6Part2Completed', quran8Lesson6Part2Completed);
    prefs.setBool('quran8Lesson6Part3Completed', quran8Lesson6Part3Completed);
    prefs.setBool('quran8Lesson7Part1Completed', quran8Lesson7Part1Completed);
    prefs.setBool('quran8Lesson7Part2Completed', quran8Lesson7Part2Completed);
    prefs.setBool('quran8Lesson7Part3Completed', quran8Lesson7Part3Completed);
    prefs.setBool('quran8Lesson8Part1Completed', quran8Lesson8Part1Completed);
    prefs.setBool('quran8Lesson8Part2Completed', quran8Lesson8Part2Completed);
    prefs.setBool('quran8Lesson8Part3Completed', quran8Lesson8Part3Completed);
    prefs.setBool('quran8Lesson9Part1Completed', quran8Lesson9Part1Completed);
    prefs.setBool('quran8Lesson9Part2Completed', quran8Lesson9Part2Completed);
    prefs.setBool('quran8Lesson9Part3Completed', quran8Lesson9Part3Completed);
    prefs.setBool('quran8Lesson10Part1Completed', quran8Lesson10Part1Completed);
    prefs.setBool('quran8Lesson10Part2Completed', quran8Lesson10Part2Completed);
    prefs.setBool('quran8Lesson10Part3Completed', quran8Lesson10Part3Completed);
    prefs.setBool('quran8Lesson11Part1Completed', quran8Lesson11Part1Completed);
    prefs.setBool('quran8Lesson11Part2Completed', quran8Lesson11Part2Completed);
    prefs.setBool('quran8Lesson11Part3Completed', quran8Lesson11Part3Completed);
    prefs.setBool('quran8Lesson12Part1Completed', quran8Lesson12Part1Completed);
    prefs.setBool('quran8Lesson12Part2Completed', quran8Lesson12Part2Completed);
    prefs.setBool('quran8Lesson12Part3Completed', quran8Lesson12Part3Completed);
    prefs.setBool('quran9Lesson1Part2Completed', quran9Lesson1Part2Completed);
    prefs.setBool('quran9Lesson1Part3Completed', quran9Lesson1Part3Completed);
    prefs.setBool('quran9Lesson2Part1Completed', quran9Lesson2Part1Completed);
    prefs.setBool('quran9Lesson2Part2Completed', quran9Lesson2Part2Completed);
    prefs.setBool('quran9Lesson2Part3Completed', quran9Lesson2Part3Completed);
    prefs.setBool('quran9Lesson3Part1Completed', quran9Lesson3Part1Completed);
    prefs.setBool('quran9Lesson3Part2Completed', quran9Lesson3Part2Completed);
    prefs.setBool('quran9Lesson3Part3Completed', quran9Lesson3Part3Completed);
    prefs.setBool('quran9Lesson4Part1Completed', quran9Lesson4Part1Completed);
    prefs.setBool('quran9Lesson4Part2Completed', quran9Lesson4Part2Completed);
    prefs.setBool('quran9Lesson4Part3Completed', quran9Lesson4Part3Completed);
    prefs.setBool('quran9Lesson5Part1Completed', quran9Lesson5Part1Completed);
    prefs.setBool('quran9Lesson5Part2Completed', quran9Lesson5Part2Completed);
    prefs.setBool('quran9Lesson5Part3Completed', quran9Lesson5Part3Completed);
    prefs.setBool('quran9Lesson6Part1Completed', quran9Lesson6Part1Completed);
    prefs.setBool('quran9Lesson6Part2Completed', quran9Lesson6Part2Completed);
    prefs.setBool('quran9Lesson6Part3Completed', quran9Lesson6Part3Completed);
    prefs.setBool('quran9Lesson7Part1Completed', quran9Lesson7Part1Completed);
    prefs.setBool('quran9Lesson7Part2Completed', quran9Lesson7Part2Completed);
    prefs.setBool('quran9Lesson7Part3Completed', quran9Lesson7Part3Completed);
    prefs.setBool('quran9Lesson8Part1Completed', quran9Lesson8Part1Completed);
    prefs.setBool('quran9Lesson8Part2Completed', quran9Lesson8Part2Completed);
    prefs.setBool('quran9Lesson8Part3Completed', quran9Lesson8Part3Completed);
    prefs.setBool('quran9Lesson9Part1Completed', quran9Lesson9Part1Completed);
    prefs.setBool('quran9Lesson9Part2Completed', quran9Lesson9Part2Completed);
    prefs.setBool('quran9Lesson9Part3Completed', quran9Lesson9Part3Completed);
    prefs.setBool('quran9Lesson10Part1Completed', quran9Lesson10Part1Completed);
    prefs.setBool('quran9Lesson10Part2Completed', quran9Lesson10Part2Completed);
    prefs.setBool('quran9Lesson10Part3Completed', quran9Lesson10Part3Completed);
    prefs.setBool('quran9Lesson11Part1Completed', quran9Lesson11Part1Completed);
    prefs.setBool('quran9Lesson11Part2Completed', quran9Lesson11Part2Completed);
    prefs.setBool('quran9Lesson11Part3Completed', quran9Lesson11Part3Completed);
    prefs.setBool('zaban7Lesson1Part1Completed', zaban7Lesson1Part1Completed);
    prefs.setBool('zaban7Lesson1Part2Completed', zaban7Lesson1Part2Completed);
    prefs.setBool('zaban7Lesson1Part3Completed', zaban7Lesson1Part3Completed);
    prefs.setBool('zaban7WelcomePart1Completed', zaban7WelcomePart1Completed);
    prefs.setBool('zaban7WelcomePart2Completed', zaban7WelcomePart2Completed);
    prefs.setBool('zaban7WelcomePart3Completed', zaban7WelcomePart3Completed);
    prefs.setBool('zaban7Lesson3Part1Completed', zaban7Lesson3Part1Completed);
    prefs.setBool('zaban7Lesson3Part2Completed', zaban7Lesson3Part2Completed);
    prefs.setBool('zaban7Lesson3Part3Completed', zaban7Lesson3Part3Completed);
    prefs.setBool('zaban7Lesson4Part1Completed', zaban7Lesson4Part1Completed);
    prefs.setBool('zaban7Lesson4Part2Completed', zaban7Lesson4Part2Completed);
    prefs.setBool('zaban7Lesson4Part3Completed', zaban7Lesson4Part3Completed);
    prefs.setBool('zaban7Lesson5Part1Completed', zaban7Lesson5Part1Completed);
    prefs.setBool('zaban7Lesson5Part2Completed', zaban7Lesson5Part2Completed);
    prefs.setBool('zaban7Lesson5Part3Completed', zaban7Lesson5Part3Completed);
    prefs.setBool('zaban7Lesson7Part1Completed', zaban7Lesson7Part1Completed);
    prefs.setBool('zaban7Lesson7Part2Completed', zaban7Lesson7Part2Completed);
    prefs.setBool('zaban7Lesson7Part3Completed', zaban7Lesson7Part3Completed);
    prefs.setBool('zaban8Lesson1Part1Completed', zaban8Lesson1Part1Completed);
    prefs.setBool('zaban8Lesson1Part2Completed', zaban8Lesson1Part2Completed);
    prefs.setBool('zaban8Lesson1Part3Completed', zaban8Lesson1Part3Completed);
    prefs.setBool('zaban8Lesson2Part1Completed', zaban8Lesson2Part1Completed);
    prefs.setBool('zaban8Lesson2Part2Completed', zaban8Lesson2Part2Completed);
    prefs.setBool('zaban8Lesson2Part3Completed', zaban8Lesson2Part3Completed);
    prefs.setBool('zaban8Lesson3Part1Completed', zaban8Lesson3Part1Completed);
    prefs.setBool('zaban8Lesson3Part2Completed', zaban8Lesson3Part2Completed);
    prefs.setBool('zaban8Lesson3Part3Completed', zaban8Lesson3Part3Completed);
    prefs.setBool('zaban8Lesson4Part1Completed', zaban8Lesson4Part1Completed);
    prefs.setBool('zaban8Lesson4Part2Completed', zaban8Lesson4Part2Completed);
    prefs.setBool('zaban8Lesson4Part3Completed', zaban8Lesson4Part3Completed);
    prefs.setBool('zaban8Lesson5Part1Completed', zaban8Lesson5Part1Completed);
    prefs.setBool('zaban8Lesson5Part2Completed', zaban8Lesson5Part2Completed);
    prefs.setBool('zaban8Lesson5Part3Completed', zaban8Lesson5Part3Completed);
    prefs.setBool('zaban9Lesson1Part1Completed', zaban9Lesson1Part1Completed);
    prefs.setBool('zaban9Lesson1Part2Completed', zaban9Lesson1Part2Completed);
    prefs.setBool('zaban9Lesson1Part3Completed', zaban9Lesson1Part3Completed);
    prefs.setBool('zaban9Lesson2Part1Completed', zaban9Lesson2Part1Completed);
    prefs.setBool('zaban9Lesson2Part2Completed', zaban9Lesson2Part2Completed);
    prefs.setBool('zaban9Lesson2Part3Completed', zaban9Lesson2Part3Completed);
    prefs.setBool('zaban9Lesson3Part1Completed', zaban9Lesson3Part1Completed);
    prefs.setBool('zaban9Lesson3Part2Completed', zaban9Lesson3Part2Completed);
    prefs.setBool('zaban9Lesson3Part3Completed', zaban9Lesson3Part3Completed);
    prefs.setBool('zaban9Lesson4Part1Completed', zaban9Lesson4Part1Completed);
    prefs.setBool('zaban9Lesson4Part2Completed', zaban9Lesson4Part2Completed);
    prefs.setBool('zaban9Lesson4Part3Completed', zaban9Lesson4Part3Completed);
    prefs.setBool('zaban9Lesson5Part1Completed', zaban9Lesson5Part1Completed);
    prefs.setBool('zaban9Lesson5Part2Completed', zaban9Lesson5Part2Completed);
    prefs.setBool('zaban9Lesson5Part3Completed', zaban9Lesson5Part3Completed);
    prefs.setBool('zaban9Lesson6Part1Completed', zaban9Lesson6Part1Completed);
    prefs.setBool('zaban9Lesson6Part2Completed', zaban9Lesson6Part2Completed);
    prefs.setBool('zaban9Lesson6Part3Completed', zaban9Lesson6Part3Completed);
    prefs.setBool('farsi7Lesson1Part1Completed', farsi7Lesson1Part1Completed);
    prefs.setBool('farsi7Lesson1Part2Completed', farsi7Lesson1Part2Completed);
    prefs.setBool('farsi7Lesson1Part3Completed', farsi7Lesson1Part3Completed);
    prefs.setBool('farsi7Lesson2Part1Completed', farsi7Lesson2Part1Completed);
    prefs.setBool('farsi7Lesson2Part2Completed', farsi7Lesson2Part2Completed);
    prefs.setBool('farsi7Lesson2Part3Completed', farsi7Lesson2Part3Completed);
    prefs.setBool('farsi7Lesson3Part1Completed', farsi7Lesson3Part1Completed);
    prefs.setBool('farsi7Lesson3Part2Completed', farsi7Lesson3Part2Completed);
    prefs.setBool('farsi7Lesson3Part3Completed', farsi7Lesson3Part3Completed);
    prefs.setBool('farsi7Lesson4Part1Completed', farsi7Lesson4Part1Completed);
    prefs.setBool('farsi7Lesson4Part2Completed', farsi7Lesson4Part2Completed);
    prefs.setBool('farsi7Lesson4Part3Completed', farsi7Lesson4Part3Completed);
    prefs.setBool('farsi7Lesson5Part1Completed', farsi7Lesson5Part1Completed);
    prefs.setBool('farsi7Lesson5Part2Completed', farsi7Lesson5Part2Completed);
    prefs.setBool('farsi7Lesson5Part3Completed', farsi7Lesson5Part3Completed);
    prefs.setBool('farsi7Lesson6Part1Completed', farsi7Lesson6Part1Completed);
    prefs.setBool('farsi7Lesson6Part2Completed', farsi7Lesson6Part2Completed);
    prefs.setBool('farsi7Lesson6Part3Completed', farsi7Lesson6Part3Completed);
    prefs.setBool('farsi8Lesson1Part1Completed', farsi8Lesson1Part1Completed);
    prefs.setBool('farsi8Lesson1Part2Completed', farsi8Lesson1Part2Completed);
    prefs.setBool('farsi8Lesson1Part3Completed', farsi8Lesson1Part3Completed);
    prefs.setBool('farsi8Lesson2Part1Completed', farsi8Lesson2Part1Completed);
    prefs.setBool('farsi8Lesson2Part2Completed', farsi8Lesson2Part2Completed);
    prefs.setBool('farsi8Lesson2Part3Completed', farsi8Lesson2Part3Completed);
    prefs.setBool('farsi8Lesson3Part1Completed', farsi8Lesson3Part1Completed);
    prefs.setBool('farsi8Lesson3Part2Completed', farsi8Lesson3Part2Completed);
    prefs.setBool('farsi8Lesson3Part3Completed', farsi8Lesson3Part3Completed);
    prefs.setBool('farsi8Lesson4Part1Completed', farsi8Lesson4Part1Completed);
    prefs.setBool('farsi8Lesson4Part2Completed', farsi8Lesson4Part2Completed);
    prefs.setBool('farsi8Lesson4Part3Completed', farsi8Lesson4Part3Completed);
    prefs.setBool('farsi8Lesson5Part1Completed', farsi8Lesson5Part1Completed);
    prefs.setBool('farsi8Lesson5Part2Completed', farsi8Lesson5Part2Completed);
    prefs.setBool('farsi8Lesson5Part3Completed', farsi8Lesson5Part3Completed);
    prefs.setBool('farsi8Lesson6Part1Completed', farsi8Lesson6Part1Completed);
    prefs.setBool('farsi8Lesson6Part2Completed', farsi8Lesson6Part2Completed);
    prefs.setBool('farsi8Lesson6Part3Completed', farsi8Lesson6Part3Completed);
    prefs.setBool('farsi9Lesson1Part1Completed', farsi9Lesson1Part1Completed);
    prefs.setBool('farsi9Lesson1Part2Completed', farsi9Lesson1Part2Completed);
    prefs.setBool('farsi9Lesson1Part3Completed', farsi9Lesson1Part3Completed);
    prefs.setBool('farsi9Lesson2Part1Completed', farsi9Lesson2Part1Completed);
    prefs.setBool('farsi9Lesson2Part2Completed', farsi9Lesson2Part2Completed);
    prefs.setBool('farsi9Lesson2Part3Completed', farsi9Lesson2Part3Completed);
    prefs.setBool('farsi9Lesson3Part1Completed', farsi9Lesson3Part1Completed);
    prefs.setBool('farsi9Lesson3Part2Completed', farsi9Lesson3Part2Completed);
    prefs.setBool('farsi9Lesson3Part3Completed', farsi9Lesson3Part3Completed);
    prefs.setBool('farsi9Lesson4Part1Completed', farsi9Lesson4Part1Completed);
    prefs.setBool('farsi9Lesson4Part2Completed', farsi9Lesson4Part2Completed);
    prefs.setBool('farsi9Lesson4Part3Completed', farsi9Lesson4Part3Completed);
    prefs.setBool('farsi9Lesson5Part1Completed', farsi9Lesson5Part1Completed);
    prefs.setBool('farsi9Lesson5Part2Completed', farsi9Lesson5Part2Completed);
    prefs.setBool('farsi9Lesson5Part3Completed', farsi9Lesson5Part3Completed);
    prefs.setBool('farsi9Lesson6Part1Completed', farsi9Lesson6Part1Completed);
    prefs.setBool('farsi9Lesson6Part2Completed', farsi9Lesson6Part2Completed);
    prefs.setBool('farsi9Lesson6Part3Completed', farsi9Lesson6Part3Completed);
    prefs.setBool('payam7Lesson1Part1Completed', payam7Lesson1Part1Completed);
    prefs.setBool('payam7Lesson1Part2Completed', payam7Lesson1Part2Completed);
    prefs.setBool('payam7Lesson1Part3Completed', payam7Lesson1Part3Completed);
    prefs.setBool('payam7Lesson2Part1Completed', payam7Lesson2Part1Completed);
    prefs.setBool('payam7Lesson2Part2Completed', payam7Lesson2Part2Completed);
    prefs.setBool('payam7Lesson2Part3Completed', payam7Lesson2Part3Completed);
    prefs.setBool('payam7Lesson3Part1Completed', payam7Lesson3Part1Completed);
    prefs.setBool('payam7Lesson3Part2Completed', payam7Lesson3Part2Completed);
    prefs.setBool('payam7Lesson3Part3Completed', payam7Lesson3Part3Completed);
    prefs.setBool('payam7Lesson4Part1Completed', payam7Lesson4Part1Completed);
    prefs.setBool('payam7Lesson4Part2Completed', payam7Lesson4Part2Completed);
    prefs.setBool('payam7Lesson4Part3Completed', payam7Lesson4Part3Completed);
    prefs.setBool('payam7Lesson5Part1Completed', payam7Lesson5Part1Completed);
    prefs.setBool('payam7Lesson5Part2Completed', payam7Lesson5Part2Completed);
    prefs.setBool('payam7Lesson5Part3Completed', payam7Lesson5Part3Completed);
    prefs.setBool('payam8Lesson1Part1Completed', payam8Lesson1Part1Completed);
    prefs.setBool('payam8Lesson1Part2Completed', payam8Lesson1Part2Completed);
    prefs.setBool('payam8Lesson1Part3Completed', payam8Lesson1Part3Completed);
    prefs.setBool('payam8Lesson2Part1Completed', payam8Lesson2Part1Completed);
    prefs.setBool('payam8Lesson2Part2Completed', payam8Lesson2Part2Completed);
    prefs.setBool('payam8Lesson2Part3Completed', payam8Lesson2Part3Completed);
    prefs.setBool('payam8Lesson3Part1Completed', payam8Lesson3Part1Completed);
    prefs.setBool('payam8Lesson3Part2Completed', payam8Lesson3Part2Completed);
    prefs.setBool('payam8Lesson3Part3Completed', payam8Lesson3Part3Completed);
    prefs.setBool('payam8Lesson4Part1Completed', payam8Lesson4Part1Completed);
    prefs.setBool('payam8Lesson4Part2Completed', payam8Lesson4Part2Completed);
    prefs.setBool('payam8Lesson4Part3Completed', payam8Lesson4Part3Completed);
    prefs.setBool('payam8Lesson5Part1Completed', payam8Lesson5Part1Completed);
    prefs.setBool('payam8Lesson5Part2Completed', payam8Lesson5Part2Completed);
    prefs.setBool('payam8Lesson5Part3Completed', payam8Lesson5Part3Completed);
    prefs.setBool('payam8Lesson6Part1Completed', payam8Lesson6Part1Completed);
    prefs.setBool('payam8Lesson6Part2Completed', payam8Lesson6Part2Completed);
    prefs.setBool('payam8Lesson6Part3Completed', payam8Lesson6Part3Completed);
    prefs.setBool('payam9Lesson1Part1Completed', payam9Lesson1Part1Completed);
    prefs.setBool('payam9Lesson1Part2Completed', payam9Lesson1Part2Completed);
    prefs.setBool('payam9Lesson1Part3Completed', payam9Lesson1Part3Completed);
    prefs.setBool('payam9Lesson2Part1Completed', payam9Lesson2Part1Completed);
    prefs.setBool('payam9Lesson2Part2Completed', payam9Lesson2Part2Completed);
    prefs.setBool('payam9Lesson2Part3Completed', payam9Lesson2Part3Completed);
    prefs.setBool('payam9Lesson3Part1Completed', payam9Lesson3Part1Completed);
    prefs.setBool('payam9Lesson3Part2Completed', payam9Lesson3Part2Completed);
    prefs.setBool('payam9Lesson3Part3Completed', payam9Lesson3Part3Completed);
    prefs.setBool('payam9Lesson4Part1Completed', payam9Lesson4Part1Completed);
    prefs.setBool('payam9Lesson4Part2Completed', payam9Lesson4Part2Completed);
    prefs.setBool('payam9Lesson4Part3Completed', payam9Lesson4Part3Completed);
    prefs.setBool('payam9Lesson5Part1Completed', payam9Lesson5Part1Completed);
    prefs.setBool('payam9Lesson5Part2Completed', payam9Lesson5Part2Completed);
    prefs.setBool('payam9Lesson5Part3Completed', payam9Lesson5Part3Completed);
    prefs.setBool('motaleat7Lesson1Part1Completed', motaleat7Lesson1Part1Completed);
    prefs.setBool('motaleat7Lesson1Part2Completed', motaleat7Lesson1Part2Completed);
    prefs.setBool('motaleat7Lesson1Part3Completed', motaleat7Lesson1Part3Completed);
    prefs.setBool('motaleat7Lesson2Part1Completed', motaleat7Lesson2Part1Completed);
    prefs.setBool('motaleat7Lesson2Part2Completed', motaleat7Lesson2Part2Completed);
    prefs.setBool('motaleat7Lesson2Part3Completed', motaleat7Lesson2Part3Completed);
    prefs.setBool('motaleat7Lesson3Part1Completed', motaleat7Lesson3Part1Completed);
    prefs.setBool('motaleat7Lesson3Part2Completed', motaleat7Lesson3Part2Completed);
    prefs.setBool('motaleat7Lesson3Part3Completed', motaleat7Lesson3Part3Completed);
    prefs.setBool('motaleat7Lesson4Part1Completed', motaleat7Lesson4Part1Completed);
    prefs.setBool('motaleat7Lesson4Part2Completed', motaleat7Lesson4Part2Completed);
    prefs.setBool('motaleat7Lesson4Part3Completed', motaleat7Lesson4Part3Completed);
    prefs.setBool('motaleat7Lesson5Part1Completed', motaleat7Lesson5Part1Completed);
    prefs.setBool('motaleat7Lesson5Part2Completed', motaleat7Lesson5Part2Completed);
    prefs.setBool('motaleat7Lesson5Part3Completed', motaleat7Lesson5Part3Completed);
    prefs.setBool('motaleat7Lesson6Part1Completed', motaleat7Lesson6Part1Completed);
    prefs.setBool('motaleat7Lesson6Part2Completed', motaleat7Lesson6Part2Completed);
    prefs.setBool('motaleat7Lesson6Part3Completed', motaleat7Lesson6Part3Completed);
    prefs.setBool('motaleat7Lesson7Part1Completed', motaleat7Lesson7Part1Completed);
    prefs.setBool('motaleat7Lesson7Part2Completed', motaleat7Lesson7Part2Completed);
    prefs.setBool('motaleat7Lesson7Part3Completed', motaleat7Lesson7Part3Completed);
    prefs.setBool('motaleat7Lesson8Part1Completed', motaleat7Lesson8Part1Completed);
    prefs.setBool('motaleat7Lesson8Part2Completed', motaleat7Lesson8Part2Completed);
    prefs.setBool('motaleat7Lesson8Part3Completed', motaleat7Lesson8Part3Completed);
    prefs.setBool('motaleat7Lesson9Part1Completed', motaleat7Lesson9Part1Completed);
    prefs.setBool('motaleat7Lesson9Part2Completed', motaleat7Lesson9Part2Completed);
    prefs.setBool('motaleat7Lesson9Part3Completed', motaleat7Lesson9Part3Completed);
    prefs.setBool('motaleat7Lesson10Part1Completed', motaleat7Lesson10Part1Completed);
    prefs.setBool('motaleat7Lesson10Part2Completed', motaleat7Lesson10Part2Completed);
    prefs.setBool('motaleat7Lesson10Part3Completed', motaleat7Lesson10Part3Completed);
    prefs.setBool('motaleat7Lesson11Part1Completed', motaleat7Lesson11Part1Completed);
    prefs.setBool('motaleat7Lesson11Part2Completed', motaleat7Lesson11Part2Completed);
    prefs.setBool('motaleat7Lesson11Part3Completed', motaleat7Lesson11Part3Completed);
    prefs.setBool('motaleat7Lesson12Part1Completed', motaleat7Lesson12Part1Completed);
    prefs.setBool('motaleat7Lesson12Part2Completed', motaleat7Lesson12Part2Completed);
    prefs.setBool('motaleat7Lesson12Part3Completed', motaleat7Lesson12Part3Completed);
    prefs.setBool('motaleat8Lesson1Part1Completed', motaleat8Lesson1Part1Completed);
    prefs.setBool('motaleat8Lesson1Part2Completed', motaleat8Lesson1Part2Completed);
    prefs.setBool('motaleat8Lesson1Part3Completed', motaleat8Lesson1Part3Completed);
    prefs.setBool('motaleat8Lesson2Part1Completed', motaleat8Lesson2Part1Completed);
    prefs.setBool('motaleat8Lesson2Part2Completed', motaleat8Lesson2Part2Completed);
    prefs.setBool('motaleat8Lesson2Part3Completed', motaleat8Lesson2Part3Completed);
    prefs.setBool('motaleat8Lesson3Part1Completed', motaleat8Lesson3Part1Completed);
    prefs.setBool('motaleat8Lesson3Part2Completed', motaleat8Lesson3Part2Completed);
    prefs.setBool('motaleat8Lesson3Part3Completed', motaleat8Lesson3Part3Completed);
    prefs.setBool('motaleat8Lesson4Part1Completed', motaleat8Lesson4Part1Completed);
    prefs.setBool('motaleat8Lesson4Part2Completed', motaleat8Lesson4Part2Completed);
    prefs.setBool('motaleat8Lesson4Part3Completed', motaleat8Lesson4Part3Completed);
    prefs.setBool('motaleat8Lesson5Part1Completed', motaleat8Lesson5Part1Completed);
    prefs.setBool('motaleat8Lesson5Part2Completed', motaleat8Lesson5Part2Completed);
    prefs.setBool('motaleat8Lesson5Part3Completed', motaleat8Lesson5Part3Completed);
    prefs.setBool('motaleat8Lesson6Part1Completed', motaleat8Lesson6Part1Completed);
    prefs.setBool('motaleat8Lesson6Part2Completed', motaleat8Lesson6Part2Completed);
    prefs.setBool('motaleat8Lesson6Part3Completed', motaleat8Lesson6Part3Completed);
    prefs.setBool('motaleat8Lesson7Part1Completed', motaleat8Lesson7Part1Completed);
    prefs.setBool('motaleat8Lesson7Part2Completed', motaleat8Lesson7Part2Completed);
    prefs.setBool('motaleat8Lesson7Part3Completed', motaleat8Lesson7Part3Completed);
    prefs.setBool('motaleat8Lesson8Part1Completed', motaleat8Lesson8Part1Completed);
    prefs.setBool('motaleat8Lesson8Part2Completed', motaleat8Lesson8Part2Completed);
    prefs.setBool('motaleat8Lesson8Part3Completed', motaleat8Lesson8Part3Completed);
    prefs.setBool('motaleat8Lesson9Part1Completed', motaleat8Lesson9Part1Completed);
    prefs.setBool('motaleat8Lesson9Part2Completed', motaleat8Lesson9Part2Completed);
    prefs.setBool('motaleat8Lesson9Part3Completed', motaleat8Lesson9Part3Completed);
    prefs.setBool('motaleat8Lesson10Part1Completed', motaleat8Lesson10Part1Completed);
    prefs.setBool('motaleat8Lesson10Part2Completed', motaleat8Lesson10Part2Completed);
    prefs.setBool('motaleat8Lesson10Part3Completed', motaleat8Lesson10Part3Completed);
    prefs.setBool('motaleat8Lesson11Part1Completed', motaleat8Lesson11Part1Completed);
    prefs.setBool('motaleat8Lesson11Part2Completed', motaleat8Lesson11Part2Completed);
    prefs.setBool('motaleat8Lesson11Part3Completed', motaleat8Lesson11Part3Completed);
    prefs.setBool('motaleat8Lesson12Part1Completed', motaleat8Lesson12Part1Completed);
    prefs.setBool('motaleat8Lesson12Part2Completed', motaleat8Lesson12Part2Completed);
    prefs.setBool('motaleat8Lesson12Part3Completed', motaleat8Lesson12Part3Completed);

    prefs.setBool('motaleat9Lesson1Part1Completed', motaleat9Lesson1Part1Completed);
    prefs.setBool('motaleat9Lesson1Part2Completed', motaleat9Lesson1Part2Completed);
    prefs.setBool('motaleat9Lesson1Part3Completed', motaleat9Lesson1Part3Completed);
    prefs.setBool('motaleat9Lesson2Part1Completed', motaleat9Lesson2Part1Completed);
    prefs.setBool('motaleat9Lesson2Part2Completed', motaleat9Lesson2Part2Completed);
    prefs.setBool('motaleat9Lesson2Part3Completed', motaleat9Lesson2Part3Completed);
    prefs.setBool('motaleat9Lesson3Part1Completed', motaleat9Lesson3Part1Completed);
    prefs.setBool('motaleat9Lesson3Part2Completed', motaleat9Lesson3Part2Completed);
    prefs.setBool('motaleat9Lesson3Part3Completed', motaleat9Lesson3Part3Completed);
    prefs.setBool('motaleat9Lesson4Part1Completed', motaleat9Lesson4Part1Completed);
    prefs.setBool('motaleat9Lesson4Part2Completed', motaleat9Lesson4Part2Completed);
    prefs.setBool('motaleat9Lesson4Part3Completed', motaleat9Lesson4Part3Completed);
    prefs.setBool('motaleat9Lesson5Part1Completed', motaleat9Lesson5Part1Completed);
    prefs.setBool('motaleat9Lesson5Part2Completed', motaleat9Lesson5Part2Completed);
    prefs.setBool('motaleat9Lesson5Part3Completed', motaleat9Lesson5Part3Completed);
    prefs.setBool('motaleat9Lesson6Part1Completed', motaleat9Lesson6Part1Completed);
    prefs.setBool('motaleat9Lesson6Part2Completed', motaleat9Lesson6Part2Completed);
    prefs.setBool('motaleat9Lesson6Part3Completed', motaleat9Lesson6Part3Completed);
    prefs.setBool('motaleat9Lesson7Part1Completed', motaleat9Lesson7Part1Completed);
    prefs.setBool('motaleat9Lesson7Part2Completed', motaleat9Lesson7Part2Completed);
    prefs.setBool('motaleat9Lesson7Part3Completed', motaleat9Lesson7Part3Completed);
    prefs.setBool('motaleat9Lesson8Part1Completed', motaleat9Lesson8Part1Completed);
    prefs.setBool('motaleat9Lesson8Part2Completed', motaleat9Lesson8Part2Completed);
    prefs.setBool('motaleat9Lesson8Part3Completed', motaleat9Lesson8Part3Completed);
    prefs.setBool('motaleat9Lesson9Part1Completed', motaleat9Lesson9Part1Completed);
    prefs.setBool('motaleat9Lesson9Part2Completed', motaleat9Lesson9Part2Completed);
    prefs.setBool('motaleat9Lesson9Part3Completed', motaleat9Lesson9Part3Completed);
    prefs.setBool('motaleat9Lesson10Part1Completed', motaleat9Lesson10Part1Completed);
    prefs.setBool('motaleat9Lesson10Part2Completed', motaleat9Lesson10Part2Completed);
    prefs.setBool('motaleat9Lesson10Part3Completed', motaleat9Lesson10Part3Completed);
    prefs.setBool('motaleat9Lesson11Part1Completed', motaleat9Lesson11Part1Completed);
    prefs.setBool('motaleat9Lesson11Part2Completed', motaleat9Lesson11Part2Completed);
    prefs.setBool('motaleat9Lesson11Part3Completed', motaleat9Lesson11Part3Completed);
    prefs.setBool('motaleat9Lesson12Part1Completed', motaleat9Lesson12Part1Completed);
    prefs.setBool('motaleat9Lesson12Part2Completed', motaleat9Lesson12Part2Completed);
    prefs.setBool('motaleat9Lesson12Part3Completed', motaleat9Lesson12Part3Completed);
    prefs.setBool('zaban9Lesson6Part3Completed', zaban9Lesson6Part3Completed);
    prefs.setBool('zaban8Lesson7Part1Completed', zaban8Lesson7Part1Completed);
    prefs.setBool('zaban8Lesson7Part2Completed', zaban8Lesson7Part2Completed);
    prefs.setBool('zaban8Lesson7Part3Completed', zaban8Lesson7Part3Completed);
    prefs.setBool('zaban8Lesson6Part1Completed', zaban8Lesson6Part1Completed);
    prefs.setBool('zaban8Lesson6Part2Completed', zaban8Lesson6Part2Completed);
    prefs.setBool('zaban8Lesson6Part3Completed', zaban8Lesson6Part3Completed);
    prefs.setBool('zaban8Lesson4Part1Completed', zaban8Lesson4Part1Completed);
    prefs.setBool('zaban8Lesson4Part2Completed', zaban8Lesson4Part2Completed);
    prefs.setBool('zaban8Lesson4Part3Completed', zaban8Lesson4Part3Completed);
    prefs.setBool('zaban8Lesson2Part2Completed', zaban8Lesson2Part2Completed);
    prefs.setBool('zaban8Lesson2Part3Completed', zaban8Lesson2Part3Completed);
    prefs.setBool('zaban8Lesson1Part2Completed', zaban8Lesson1Part2Completed);
    prefs.setBool('zaban8Lesson1Part3Completed', zaban8Lesson1Part3Completed);
    prefs.setBool('zaban7Lesson8Part1Completed', zaban7Lesson8Part1Completed);
    prefs.setBool('zaban7Lesson8Part2Completed', zaban7Lesson8Part2Completed);
    prefs.setBool('zaban7Lesson8Part3Completed', zaban7Lesson8Part3Completed);
    prefs.setBool('zaban7Lesson7Part2Completed', zaban7Lesson7Part2Completed);
    prefs.setBool('zaban7Lesson7Part3Completed', zaban7Lesson7Part3Completed);
    prefs.setBool('zaban7Lesson6Part1Completed', zaban7Lesson6Part1Completed);
    prefs.setBool('zaban7Lesson6Part2Completed', zaban7Lesson6Part2Completed);
    prefs.setBool('zaban7Lesson6Part3Completed', zaban7Lesson6Part3Completed);
    prefs.setBool('zaban7Lesson5Part2Completed', zaban7Lesson5Part2Completed);
    prefs.setBool('zaban7Lesson5Part3Completed', zaban7Lesson5Part3Completed);

    if (phoneNumber.isNotEmpty) {
      prefs.setString('userName_$phoneNumber', userName);
      prefs.setString('userAvatar_$phoneNumber', userAvatar);
      prefs.setInt('selectedGrade_$phoneNumber', selectedGrade);
      prefs.setInt('coins_$phoneNumber', coins);
      prefs.setString('currentTheme_$phoneNumber', currentTheme);
      prefs.setStringList('unlockedAvatars_$phoneNumber', unlockedAvatars);
      prefs.setStringList('unlockedThemes_$phoneNumber', unlockedThemes);
      prefs.setStringList('purchasedVipItems_$phoneNumber', purchasedVipItems);
      prefs.setBool('lesson1Part1Completed_$phoneNumber', lesson1Part1Completed);
      prefs.setBool('lesson1Part2Completed_$phoneNumber', lesson1Part2Completed);
      prefs.setBool('lesson1Part3Completed_$phoneNumber', lesson1Part3Completed);
      prefs.setBool('lesson2Part1Completed_$phoneNumber', lesson2Part1Completed);
      prefs.setBool('lesson2Part2Completed_$phoneNumber', lesson2Part2Completed);
      prefs.setBool('lesson2Part3Completed_$phoneNumber', lesson2Part3Completed);
      prefs.setBool('lesson3Part1Completed_$phoneNumber', lesson3Part1Completed);
      prefs.setBool('lesson3Part2Completed_$phoneNumber', lesson3Part2Completed);
      prefs.setBool('lesson3Part3Completed_$phoneNumber', lesson3Part3Completed);
      prefs.setBool('lesson4Part1Completed_$phoneNumber', lesson4Part1Completed);
      prefs.setBool('lesson4Part2Completed_$phoneNumber', lesson4Part2Completed);
      prefs.setBool('lesson4Part3Completed_$phoneNumber', lesson4Part3Completed);
      prefs.setBool('lesson5Part1Completed_$phoneNumber', lesson5Part1Completed);
      prefs.setBool('lesson5Part2Completed_$phoneNumber', lesson5Part2Completed);
      prefs.setBool('lesson5Part3Completed_$phoneNumber', lesson5Part3Completed);
      prefs.setBool('lesson6Part1Completed_$phoneNumber', lesson6Part1Completed);
      prefs.setBool('lesson6Part2Completed_$phoneNumber', lesson6Part2Completed);
      prefs.setBool('lesson6Part3Completed_$phoneNumber', lesson6Part3Completed);
      prefs.setBool('arabic8Lesson7Part1Completed_$phoneNumber', arabic8Lesson7Part1Completed);
      prefs.setBool('arabic8Lesson7Part2Completed_$phoneNumber', arabic8Lesson7Part2Completed);
      prefs.setBool('arabic8Lesson7Part3Completed_$phoneNumber', arabic8Lesson7Part3Completed);
      prefs.setBool('arabic8Lesson8Part1Completed_$phoneNumber', arabic8Lesson8Part1Completed);
      prefs.setBool('arabic8Lesson8Part2Completed_$phoneNumber', arabic8Lesson8Part2Completed);
      prefs.setBool('arabic8Lesson8Part3Completed_$phoneNumber', arabic8Lesson8Part3Completed);
      prefs.setBool('arabic8Lesson9Part1Completed_$phoneNumber', arabic8Lesson9Part1Completed);
      prefs.setBool('arabic8Lesson9Part2Completed_$phoneNumber', arabic8Lesson9Part2Completed);
      prefs.setBool('arabic8Lesson9Part3Completed_$phoneNumber', arabic8Lesson9Part3Completed);
      prefs.setBool('arabic8Lesson10Part1Completed_$phoneNumber', arabic8Lesson10Part1Completed);
      prefs.setBool('arabic8Lesson10Part2Completed_$phoneNumber', arabic8Lesson10Part2Completed);
      prefs.setBool('arabic8Lesson10Part3Completed_$phoneNumber', arabic8Lesson10Part3Completed);
      prefs.setBool('arabic9Lesson1Part1Completed_$phoneNumber', arabic9Lesson1Part1Completed);
      prefs.setBool('arabic9Lesson1Part2Completed_$phoneNumber', arabic9Lesson1Part2Completed);
      prefs.setBool('arabic9Lesson1Part3Completed_$phoneNumber', arabic9Lesson1Part3Completed);
      prefs.setBool('arabic9Lesson2Part1Completed_$phoneNumber', arabic9Lesson2Part1Completed);
      prefs.setBool('arabic9Lesson2Part2Completed_$phoneNumber', arabic9Lesson2Part2Completed);
      prefs.setBool('arabic9Lesson2Part3Completed_$phoneNumber', arabic9Lesson2Part3Completed);
      prefs.setBool('arabic9Lesson3Part1Completed_$phoneNumber', arabic9Lesson3Part1Completed);
      prefs.setBool('arabic9Lesson3Part2Completed_$phoneNumber', arabic9Lesson3Part2Completed);
      prefs.setBool('arabic9Lesson3Part3Completed_$phoneNumber', arabic9Lesson3Part3Completed);
      prefs.setBool('arabic9Lesson4Part1Completed_$phoneNumber', arabic9Lesson4Part1Completed);
      prefs.setBool('arabic9Lesson4Part2Completed_$phoneNumber', arabic9Lesson4Part2Completed);
      prefs.setBool('arabic9Lesson4Part3Completed_$phoneNumber', arabic9Lesson4Part3Completed);
      prefs.setBool('arabic9Lesson5Part1Completed_$phoneNumber', arabic9Lesson5Part1Completed);
      prefs.setBool('arabic9Lesson5Part2Completed_$phoneNumber', arabic9Lesson5Part2Completed);
      prefs.setBool('arabic9Lesson5Part3Completed_$phoneNumber', arabic9Lesson5Part3Completed);
      prefs.setBool('arabic9Lesson6Part1Completed_$phoneNumber', arabic9Lesson6Part1Completed);
      prefs.setBool('arabic9Lesson6Part2Completed_$phoneNumber', arabic9Lesson6Part2Completed);
      prefs.setBool('arabic9Lesson6Part3Completed_$phoneNumber', arabic9Lesson6Part3Completed);
      prefs.setBool('arabic9Lesson7Part1Completed_$phoneNumber', arabic9Lesson7Part1Completed);
      prefs.setBool('arabic9Lesson7Part2Completed_$phoneNumber', arabic9Lesson7Part2Completed);
      prefs.setBool('arabic9Lesson7Part3Completed_$phoneNumber', arabic9Lesson7Part3Completed);
      prefs.setBool('arabic9Lesson8Part1Completed_$phoneNumber', arabic9Lesson8Part1Completed);
      prefs.setBool('arabic9Lesson8Part2Completed_$phoneNumber', arabic9Lesson8Part2Completed);
      prefs.setBool('arabic9Lesson8Part3Completed_$phoneNumber', arabic9Lesson8Part3Completed);
      prefs.setBool('arabic9Lesson9Part1Completed_$phoneNumber', arabic9Lesson9Part1Completed);
      prefs.setBool('arabic9Lesson9Part2Completed_$phoneNumber', arabic9Lesson9Part2Completed);
      prefs.setBool('arabic9Lesson9Part3Completed_$phoneNumber', arabic9Lesson9Part3Completed);
      prefs.setBool('arabic9Lesson10Part1Completed_$phoneNumber', arabic9Lesson10Part1Completed);
      prefs.setBool('arabic9Lesson10Part2Completed_$phoneNumber', arabic9Lesson10Part2Completed);
      prefs.setBool('arabic9Lesson10Part3Completed_$phoneNumber', arabic9Lesson10Part3Completed);
      prefs.setBool('lesson7Part1Completed_$phoneNumber', lesson7Part1Completed);
      prefs.setBool('lesson7Part2Completed_$phoneNumber', lesson7Part2Completed);
      prefs.setBool('lesson7Part3Completed_$phoneNumber', lesson7Part3Completed);
      prefs.setBool('lesson8Part1Completed_$phoneNumber', lesson8Part1Completed);
      prefs.setBool('lesson8Part2Completed_$phoneNumber', lesson8Part2Completed);
      prefs.setBool('lesson8Part3Completed_$phoneNumber', lesson8Part3Completed);
      prefs.setBool('lesson9Part1Completed_$phoneNumber', lesson9Part1Completed);
      prefs.setBool('lesson9Part2Completed_$phoneNumber', lesson9Part2Completed);
      prefs.setBool('lesson9Part3Completed_$phoneNumber', lesson9Part3Completed);
      prefs.setBool('lesson10Part1Completed_$phoneNumber', lesson10Part1Completed);
      prefs.setBool('lesson10Part2Completed_$phoneNumber', lesson10Part2Completed);
      prefs.setBool('lesson10Part3Completed_$phoneNumber', lesson10Part3Completed);
      prefs.setBool('lesson11Part1Completed_$phoneNumber', lesson11Part1Completed);
      prefs.setBool('lesson11Part2Completed_$phoneNumber', lesson11Part2Completed);
      prefs.setBool('lesson11Part3Completed_$phoneNumber', lesson11Part3Completed);
      prefs.setBool('lesson12Part1Completed_$phoneNumber', lesson12Part1Completed);
      prefs.setBool('lesson12Part2Completed_$phoneNumber', lesson12Part2Completed);
      prefs.setBool('lesson12Part3Completed_$phoneNumber', lesson12Part3Completed);
      prefs.setBool('lesson13Part1Completed_$phoneNumber', lesson13Part1Completed);
      prefs.setBool('lesson13Part2Completed_$phoneNumber', lesson13Part2Completed);
      prefs.setBool('lesson13Part3Completed_$phoneNumber', lesson13Part3Completed);
      prefs.setBool('lesson14Part1Completed_$phoneNumber', lesson14Part1Completed);
      prefs.setBool('lesson14Part2Completed_$phoneNumber', lesson14Part2Completed);
      prefs.setBool('lesson14Part3Completed_$phoneNumber', lesson14Part3Completed);
      prefs.setBool('lesson15Part1Completed_$phoneNumber', lesson15Part1Completed);
      prefs.setBool('lesson15Part2Completed_$phoneNumber', lesson15Part2Completed);
      prefs.setBool('lesson15Part3Completed_$phoneNumber', lesson15Part3Completed);
      prefs.setBool('lesson16Part1Completed_$phoneNumber', lesson16Part1Completed);
      prefs.setBool('lesson16Part2Completed_$phoneNumber', lesson16Part2Completed);
      prefs.setBool('lesson16Part3Completed_$phoneNumber', lesson16Part3Completed);
      prefs.setBool('lesson17Part1Completed_$phoneNumber', lesson17Part1Completed);
      prefs.setBool('lesson17Part2Completed_$phoneNumber', lesson17Part2Completed);
      prefs.setBool('lesson17Part3Completed_$phoneNumber', lesson17Part3Completed);
      prefs.setBool('lesson18Part1Completed_$phoneNumber', lesson18Part1Completed);
      prefs.setBool('lesson18Part2Completed_$phoneNumber', lesson18Part2Completed);
      prefs.setBool('lesson18Part3Completed_$phoneNumber', lesson18Part3Completed);
      prefs.setBool('lesson19Part1Completed_$phoneNumber', lesson19Part1Completed);
      prefs.setBool('lesson19Part2Completed_$phoneNumber', lesson19Part2Completed);
      prefs.setBool('lesson19Part3Completed_$phoneNumber', lesson19Part3Completed);
      prefs.setBool('lesson20Part1Completed_$phoneNumber', lesson20Part1Completed);
      prefs.setBool('lesson20Part2Completed_$phoneNumber', lesson20Part2Completed);
      prefs.setBool('lesson20Part3Completed_$phoneNumber', lesson20Part3Completed);
      prefs.setBool('arabic8Lesson1Part1Completed_$phoneNumber', arabic8Lesson1Part1Completed);
      prefs.setBool('arabic8Lesson1Part2Completed_$phoneNumber', arabic8Lesson1Part2Completed);
      prefs.setBool('arabic8Lesson1Part3Completed_$phoneNumber', arabic8Lesson1Part3Completed);
      prefs.setBool('arabic8Lesson2Part1Completed_$phoneNumber', arabic8Lesson2Part1Completed);
      prefs.setBool('arabic8Lesson2Part2Completed_$phoneNumber', arabic8Lesson2Part2Completed);
      prefs.setBool('arabic8Lesson2Part3Completed_$phoneNumber', arabic8Lesson2Part3Completed);
      prefs.setBool('arabic8Lesson3Part1Completed_$phoneNumber', arabic8Lesson3Part1Completed);
      prefs.setBool('arabic8Lesson3Part2Completed_$phoneNumber', arabic8Lesson3Part2Completed);
      prefs.setBool('arabic8Lesson3Part3Completed_$phoneNumber', arabic8Lesson3Part3Completed);
      prefs.setBool('arabic8Lesson4Part1Completed_$phoneNumber', arabic8Lesson4Part1Completed);
      prefs.setBool('arabic8Lesson4Part2Completed_$phoneNumber', arabic8Lesson4Part2Completed);
      prefs.setBool('arabic8Lesson4Part3Completed_$phoneNumber', arabic8Lesson4Part3Completed);
      prefs.setBool('arabic8Lesson5Part1Completed_$phoneNumber', arabic8Lesson5Part1Completed);
      prefs.setBool('arabic8Lesson5Part2Completed_$phoneNumber', arabic8Lesson5Part2Completed);
      prefs.setBool('arabic8Lesson5Part3Completed_$phoneNumber', arabic8Lesson5Part3Completed);
      prefs.setBool('arabic8Lesson6Part1Completed_$phoneNumber', arabic8Lesson6Part1Completed);
      prefs.setBool('arabic8Lesson6Part2Completed_$phoneNumber', arabic8Lesson6Part2Completed);
      prefs.setBool('arabic8Lesson6Part3Completed_$phoneNumber', arabic8Lesson6Part3Completed);
      prefs.setBool('quran7Lesson1Part1Completed_$phoneNumber', quran7Lesson1Part1Completed);
      prefs.setBool('quran7Lesson1Part2Completed_$phoneNumber', quran7Lesson1Part2Completed);
      prefs.setBool('quran7Lesson1Part3Completed_$phoneNumber', quran7Lesson1Part3Completed);
      prefs.setBool('quran7Lesson2Part1Completed_$phoneNumber', quran7Lesson2Part1Completed);
      prefs.setBool('quran7Lesson2Part2Completed_$phoneNumber', quran7Lesson2Part2Completed);
      prefs.setBool('quran7Lesson2Part3Completed_$phoneNumber', quran7Lesson2Part3Completed);
      prefs.setBool('quran7Lesson3Part1Completed_$phoneNumber', quran7Lesson3Part1Completed);
      prefs.setBool('quran7Lesson3Part2Completed_$phoneNumber', quran7Lesson3Part2Completed);
      prefs.setBool('quran7Lesson3Part3Completed_$phoneNumber', quran7Lesson3Part3Completed);
      prefs.setBool('quran7Lesson4Part1Completed_$phoneNumber', quran7Lesson4Part1Completed);
      prefs.setBool('quran7Lesson4Part2Completed_$phoneNumber', quran7Lesson4Part2Completed);
      prefs.setBool('quran7Lesson4Part3Completed_$phoneNumber', quran7Lesson4Part3Completed);
      prefs.setBool('quran7Lesson5Part1Completed_$phoneNumber', quran7Lesson5Part1Completed);
      prefs.setBool('quran7Lesson5Part2Completed_$phoneNumber', quran7Lesson5Part2Completed);
      prefs.setBool('quran7Lesson5Part3Completed_$phoneNumber', quran7Lesson5Part3Completed);
      prefs.setBool('quran7Lesson6Part1Completed_$phoneNumber', quran7Lesson6Part1Completed);
      prefs.setBool('quran7Lesson6Part2Completed_$phoneNumber', quran7Lesson6Part2Completed);
      prefs.setBool('quran7Lesson6Part3Completed_$phoneNumber', quran7Lesson6Part3Completed);
      prefs.setBool('quran7Lesson7Part1Completed_$phoneNumber', quran7Lesson7Part1Completed);
      prefs.setBool('quran7Lesson7Part2Completed_$phoneNumber', quran7Lesson7Part2Completed);
      prefs.setBool('quran7Lesson7Part3Completed_$phoneNumber', quran7Lesson7Part3Completed);
      prefs.setBool('quran7Lesson8Part1Completed_$phoneNumber', quran7Lesson8Part1Completed);
      prefs.setBool('quran7Lesson8Part2Completed_$phoneNumber', quran7Lesson8Part2Completed);
      prefs.setBool('quran7Lesson8Part3Completed_$phoneNumber', quran7Lesson8Part3Completed);
      prefs.setBool('quran7Lesson9Part1Completed_$phoneNumber', quran7Lesson9Part1Completed);
      prefs.setBool('quran7Lesson9Part2Completed_$phoneNumber', quran7Lesson9Part2Completed);
      prefs.setBool('quran7Lesson9Part3Completed_$phoneNumber', quran7Lesson9Part3Completed);
      prefs.setBool('quran7Lesson10Part1Completed_$phoneNumber', quran7Lesson10Part1Completed);
      prefs.setBool('quran7Lesson10Part2Completed_$phoneNumber', quran7Lesson10Part2Completed);
      prefs.setBool('quran7Lesson10Part3Completed_$phoneNumber', quran7Lesson10Part3Completed);
      prefs.setBool('quran7Lesson11Part1Completed_$phoneNumber', quran7Lesson11Part1Completed);
      prefs.setBool('quran7Lesson11Part2Completed_$phoneNumber', quran7Lesson11Part2Completed);
      prefs.setBool('quran7Lesson11Part3Completed_$phoneNumber', quran7Lesson11Part3Completed);
      prefs.setBool('quran7Lesson12Part1Completed_$phoneNumber', quran7Lesson12Part1Completed);
      prefs.setBool('quran7Lesson12Part2Completed_$phoneNumber', quran7Lesson12Part2Completed);
      prefs.setBool('quran7Lesson12Part3Completed_$phoneNumber', quran7Lesson12Part3Completed);
      prefs.setBool('quran8Lesson1Part1Completed_$phoneNumber', quran8Lesson1Part1Completed);
      prefs.setBool('quran8Lesson1Part2Completed_$phoneNumber', quran8Lesson1Part2Completed);
      prefs.setBool('quran8Lesson1Part3Completed_$phoneNumber', quran8Lesson1Part3Completed);
      prefs.setBool('quran8Lesson2Part1Completed_$phoneNumber', quran8Lesson2Part1Completed);
      prefs.setBool('quran8Lesson2Part2Completed_$phoneNumber', quran8Lesson2Part2Completed);
      prefs.setBool('quran8Lesson2Part3Completed_$phoneNumber', quran8Lesson2Part3Completed);
      prefs.setBool('quran8Lesson3Part1Completed_$phoneNumber', quran8Lesson3Part1Completed);
      prefs.setBool('quran8Lesson3Part2Completed_$phoneNumber', quran8Lesson3Part2Completed);
      prefs.setBool('quran8Lesson3Part3Completed_$phoneNumber', quran8Lesson3Part3Completed);
      prefs.setBool('quran8Lesson4Part1Completed_$phoneNumber', quran8Lesson4Part1Completed);
      prefs.setBool('quran8Lesson4Part2Completed_$phoneNumber', quran8Lesson4Part2Completed);
      prefs.setBool('quran8Lesson4Part3Completed_$phoneNumber', quran8Lesson4Part3Completed);
      prefs.setBool('quran8Lesson5Part1Completed_$phoneNumber', quran8Lesson5Part1Completed);
      prefs.setBool('quran8Lesson5Part2Completed_$phoneNumber', quran8Lesson5Part2Completed);
      prefs.setBool('quran8Lesson5Part3Completed_$phoneNumber', quran8Lesson5Part3Completed);
      prefs.setBool('quran8Lesson6Part1Completed_$phoneNumber', quran8Lesson6Part1Completed);
      prefs.setBool('quran8Lesson6Part2Completed_$phoneNumber', quran8Lesson6Part2Completed);
      prefs.setBool('quran8Lesson6Part3Completed_$phoneNumber', quran8Lesson6Part3Completed);
      prefs.setBool('quran8Lesson7Part1Completed_$phoneNumber', quran8Lesson7Part1Completed);
      prefs.setBool('quran8Lesson7Part2Completed_$phoneNumber', quran8Lesson7Part2Completed);
      prefs.setBool('quran8Lesson7Part3Completed_$phoneNumber', quran8Lesson7Part3Completed);
      prefs.setBool('quran8Lesson8Part1Completed_$phoneNumber', quran8Lesson8Part1Completed);
      prefs.setBool('quran8Lesson8Part2Completed_$phoneNumber', quran8Lesson8Part2Completed);
      prefs.setBool('quran8Lesson8Part3Completed_$phoneNumber', quran8Lesson8Part3Completed);
      prefs.setBool('quran8Lesson9Part1Completed_$phoneNumber', quran8Lesson9Part1Completed);
      prefs.setBool('quran8Lesson9Part2Completed_$phoneNumber', quran8Lesson9Part2Completed);
      prefs.setBool('quran8Lesson9Part3Completed_$phoneNumber', quran8Lesson9Part3Completed);
      prefs.setBool('quran8Lesson10Part1Completed_$phoneNumber', quran8Lesson10Part1Completed);
      prefs.setBool('quran8Lesson10Part2Completed_$phoneNumber', quran8Lesson10Part2Completed);
      prefs.setBool('quran8Lesson10Part3Completed_$phoneNumber', quran8Lesson10Part3Completed);
      prefs.setBool('quran8Lesson11Part1Completed_$phoneNumber', quran8Lesson11Part1Completed);
      prefs.setBool('quran8Lesson11Part2Completed_$phoneNumber', quran8Lesson11Part2Completed);
      prefs.setBool('quran8Lesson11Part3Completed_$phoneNumber', quran8Lesson11Part3Completed);
      prefs.setBool('quran8Lesson12Part1Completed_$phoneNumber', quran8Lesson12Part1Completed);
      prefs.setBool('quran8Lesson12Part2Completed_$phoneNumber', quran8Lesson12Part2Completed);
      prefs.setBool('quran8Lesson12Part3Completed_$phoneNumber', quran8Lesson12Part3Completed);
      prefs.setBool('quran9Lesson1Part2Completed_$phoneNumber', quran9Lesson1Part2Completed);
      prefs.setBool('quran9Lesson1Part3Completed_$phoneNumber', quran9Lesson1Part3Completed);
      prefs.setBool('quran9Lesson2Part1Completed_$phoneNumber', quran9Lesson2Part1Completed);
      prefs.setBool('quran9Lesson2Part2Completed_$phoneNumber', quran9Lesson2Part2Completed);
      prefs.setBool('quran9Lesson2Part3Completed_$phoneNumber', quran9Lesson2Part3Completed);
      prefs.setBool('quran9Lesson3Part1Completed_$phoneNumber', quran9Lesson3Part1Completed);
      prefs.setBool('quran9Lesson3Part2Completed_$phoneNumber', quran9Lesson3Part2Completed);
      prefs.setBool('quran9Lesson3Part3Completed_$phoneNumber', quran9Lesson3Part3Completed);
      prefs.setBool('quran9Lesson4Part1Completed_$phoneNumber', quran9Lesson4Part1Completed);
      prefs.setBool('quran9Lesson4Part2Completed_$phoneNumber', quran9Lesson4Part2Completed);
      prefs.setBool('quran9Lesson4Part3Completed_$phoneNumber', quran9Lesson4Part3Completed);
      prefs.setBool('quran9Lesson5Part1Completed_$phoneNumber', quran9Lesson5Part1Completed);
      prefs.setBool('quran9Lesson5Part2Completed_$phoneNumber', quran9Lesson5Part2Completed);
      prefs.setBool('quran9Lesson5Part3Completed_$phoneNumber', quran9Lesson5Part3Completed);
      prefs.setBool('quran9Lesson6Part1Completed_$phoneNumber', quran9Lesson6Part1Completed);
      prefs.setBool('quran9Lesson6Part2Completed_$phoneNumber', quran9Lesson6Part2Completed);
      prefs.setBool('quran9Lesson6Part3Completed_$phoneNumber', quran9Lesson6Part3Completed);
      prefs.setBool('quran9Lesson7Part1Completed_$phoneNumber', quran9Lesson7Part1Completed);
      prefs.setBool('quran9Lesson7Part2Completed_$phoneNumber', quran9Lesson7Part2Completed);
      prefs.setBool('quran9Lesson7Part3Completed_$phoneNumber', quran9Lesson7Part3Completed);
      prefs.setBool('olom7Lesson1Part1Completed_$phoneNumber', olom7Lesson1Part1Completed);
      prefs.setBool('olom8Lesson1Part1Completed_$phoneNumber', olom8Lesson1Part1Completed);
      prefs.setBool('olom7Lesson1Part2Completed_$phoneNumber', olom7Lesson1Part2Completed);
      prefs.setBool('olom8Lesson1Part2Completed_$phoneNumber', olom8Lesson1Part2Completed);
      prefs.setBool('olom7Lesson1Part3Completed_$phoneNumber', olom7Lesson1Part3Completed);
      prefs.setBool('olom8Lesson1Part3Completed_$phoneNumber', olom8Lesson1Part3Completed);
      prefs.setBool('olom7Lesson2Part1Completed_$phoneNumber', olom7Lesson2Part1Completed);
      prefs.setBool('olom8Lesson2Part1Completed_$phoneNumber', olom8Lesson2Part1Completed);
      prefs.setBool('olom7Lesson2Part2Completed_$phoneNumber', olom7Lesson2Part2Completed);
      prefs.setBool('olom8Lesson2Part2Completed_$phoneNumber', olom8Lesson2Part2Completed);
      prefs.setBool('olom7Lesson2Part3Completed_$phoneNumber', olom7Lesson2Part3Completed);
      prefs.setBool('olom8Lesson2Part3Completed_$phoneNumber', olom8Lesson2Part3Completed);
      prefs.setBool('olom7Lesson3Part1Completed_$phoneNumber', olom7Lesson3Part1Completed);
      prefs.setBool('olom8Lesson3Part1Completed_$phoneNumber', olom8Lesson3Part1Completed);
      prefs.setBool('olom7Lesson3Part2Completed_$phoneNumber', olom7Lesson3Part2Completed);
      prefs.setBool('olom8Lesson3Part2Completed_$phoneNumber', olom8Lesson3Part2Completed);
      prefs.setBool('olom7Lesson3Part3Completed_$phoneNumber', olom7Lesson3Part3Completed);
      prefs.setBool('olom8Lesson3Part3Completed_$phoneNumber', olom8Lesson3Part3Completed);
      prefs.setBool('olom7Lesson4Part1Completed_$phoneNumber', olom7Lesson4Part1Completed);
      prefs.setBool('olom8Lesson4Part1Completed_$phoneNumber', olom8Lesson4Part1Completed);
      prefs.setBool('olom7Lesson4Part2Completed_$phoneNumber', olom7Lesson4Part2Completed);
      prefs.setBool('olom8Lesson4Part2Completed_$phoneNumber', olom8Lesson4Part2Completed);
      prefs.setBool('olom7Lesson4Part3Completed_$phoneNumber', olom7Lesson4Part3Completed);
      prefs.setBool('olom8Lesson4Part3Completed_$phoneNumber', olom8Lesson4Part3Completed);
      prefs.setBool('olom7Lesson5Part1Completed_$phoneNumber', olom7Lesson5Part1Completed);
      prefs.setBool('olom8Lesson5Part1Completed_$phoneNumber', olom8Lesson5Part1Completed);
      prefs.setBool('olom7Lesson5Part2Completed_$phoneNumber', olom7Lesson5Part2Completed);
      prefs.setBool('olom8Lesson5Part2Completed_$phoneNumber', olom8Lesson5Part2Completed);
      prefs.setBool('olom7Lesson5Part3Completed_$phoneNumber', olom7Lesson5Part3Completed);
      prefs.setBool('olom8Lesson5Part3Completed_$phoneNumber', olom8Lesson5Part3Completed);
      prefs.setBool('olom7Lesson6Part1Completed_$phoneNumber', olom7Lesson6Part1Completed);
      prefs.setBool('olom8Lesson6Part1Completed_$phoneNumber', olom8Lesson6Part1Completed);
      prefs.setBool('olom7Lesson6Part2Completed_$phoneNumber', olom7Lesson6Part2Completed);
      prefs.setBool('olom8Lesson6Part2Completed_$phoneNumber', olom8Lesson6Part2Completed);
      prefs.setBool('olom7Lesson6Part3Completed_$phoneNumber', olom7Lesson6Part3Completed);
      prefs.setBool('olom8Lesson6Part3Completed_$phoneNumber', olom8Lesson6Part3Completed);
      prefs.setBool('olom7Lesson7Part1Completed_$phoneNumber', olom7Lesson7Part1Completed);
      prefs.setBool('olom8Lesson7Part1Completed_$phoneNumber', olom8Lesson7Part1Completed);
      prefs.setBool('olom7Lesson7Part2Completed_$phoneNumber', olom7Lesson7Part2Completed);
      prefs.setBool('olom8Lesson7Part2Completed_$phoneNumber', olom8Lesson7Part2Completed);
      prefs.setBool('olom7Lesson7Part3Completed_$phoneNumber', olom7Lesson7Part3Completed);
      prefs.setBool('olom8Lesson7Part3Completed_$phoneNumber', olom8Lesson7Part3Completed);
      prefs.setBool('olom7Lesson8Part1Completed_$phoneNumber', olom7Lesson8Part1Completed);
      prefs.setBool('olom8Lesson8Part1Completed_$phoneNumber', olom8Lesson8Part1Completed);
      prefs.setBool('olom7Lesson8Part2Completed_$phoneNumber', olom7Lesson8Part2Completed);
      prefs.setBool('olom8Lesson8Part2Completed_$phoneNumber', olom8Lesson8Part2Completed);
      prefs.setBool('olom7Lesson8Part3Completed_$phoneNumber', olom7Lesson8Part3Completed);
      prefs.setBool('olom8Lesson8Part3Completed_$phoneNumber', olom8Lesson8Part3Completed);
      prefs.setBool('olom7Lesson9Part1Completed_$phoneNumber', olom7Lesson9Part1Completed);
      prefs.setBool('olom8Lesson9Part1Completed_$phoneNumber', olom8Lesson9Part1Completed);
      prefs.setBool('olom7Lesson9Part2Completed_$phoneNumber', olom7Lesson9Part2Completed);
      prefs.setBool('olom8Lesson9Part2Completed_$phoneNumber', olom8Lesson9Part2Completed);
      prefs.setBool('olom7Lesson9Part3Completed_$phoneNumber', olom7Lesson9Part3Completed);
      prefs.setBool('olom8Lesson9Part3Completed_$phoneNumber', olom8Lesson9Part3Completed);
      prefs.setBool('olom7Lesson10Part1Completed_$phoneNumber', olom7Lesson10Part1Completed);
      prefs.setBool('olom8Lesson10Part1Completed_$phoneNumber', olom8Lesson10Part1Completed);
      prefs.setBool('olom7Lesson10Part2Completed_$phoneNumber', olom7Lesson10Part2Completed);
      prefs.setBool('olom8Lesson10Part2Completed_$phoneNumber', olom8Lesson10Part2Completed);
      prefs.setBool('olom7Lesson10Part3Completed_$phoneNumber', olom7Lesson10Part3Completed);
      prefs.setBool('olom8Lesson10Part3Completed_$phoneNumber', olom8Lesson10Part3Completed);
      prefs.setBool('olom7Lesson11Part1Completed_$phoneNumber', olom7Lesson11Part1Completed);
      prefs.setBool('olom8Lesson11Part1Completed_$phoneNumber', olom8Lesson11Part1Completed);
      prefs.setBool('olom7Lesson11Part2Completed_$phoneNumber', olom7Lesson11Part2Completed);
      prefs.setBool('olom8Lesson11Part2Completed_$phoneNumber', olom8Lesson11Part2Completed);
      prefs.setBool('olom7Lesson11Part3Completed_$phoneNumber', olom7Lesson11Part3Completed);
      prefs.setBool('olom8Lesson11Part3Completed_$phoneNumber', olom8Lesson11Part3Completed);
      prefs.setBool('olom7Lesson12Part1Completed_$phoneNumber', olom7Lesson12Part1Completed);
      prefs.setBool('olom8Lesson12Part1Completed_$phoneNumber', olom8Lesson12Part1Completed);
      prefs.setBool('olom7Lesson12Part2Completed_$phoneNumber', olom7Lesson12Part2Completed);
      prefs.setBool('olom8Lesson12Part2Completed_$phoneNumber', olom8Lesson12Part2Completed);
      prefs.setBool('olom7Lesson12Part3Completed_$phoneNumber', olom7Lesson12Part3Completed);
      prefs.setBool('olom8Lesson12Part3Completed_$phoneNumber', olom8Lesson12Part3Completed);
      prefs.setBool('olom7Lesson13Part1Completed_$phoneNumber', olom7Lesson13Part1Completed);
      prefs.setBool('olom8Lesson13Part1Completed_$phoneNumber', olom8Lesson13Part1Completed);
      prefs.setBool('olom7Lesson13Part2Completed_$phoneNumber', olom7Lesson13Part2Completed);
      prefs.setBool('olom8Lesson13Part2Completed_$phoneNumber', olom8Lesson13Part2Completed);
      prefs.setBool('olom7Lesson13Part3Completed_$phoneNumber', olom7Lesson13Part3Completed);
      prefs.setBool('olom8Lesson13Part3Completed_$phoneNumber', olom8Lesson13Part3Completed);
      prefs.setBool('olom7Lesson14Part1Completed_$phoneNumber', olom7Lesson14Part1Completed);
      prefs.setBool('olom8Lesson14Part1Completed_$phoneNumber', olom8Lesson14Part1Completed);
      prefs.setBool('olom7Lesson14Part2Completed_$phoneNumber', olom7Lesson14Part2Completed);
      prefs.setBool('olom8Lesson14Part2Completed_$phoneNumber', olom8Lesson14Part2Completed);
      prefs.setBool('olom7Lesson14Part3Completed_$phoneNumber', olom7Lesson14Part3Completed);
      prefs.setBool('olom8Lesson14Part3Completed_$phoneNumber', olom8Lesson14Part3Completed);
      prefs.setBool('olom7Lesson15Part1Completed_$phoneNumber', olom7Lesson15Part1Completed);
      prefs.setBool('olom8Lesson15Part1Completed_$phoneNumber', olom8Lesson15Part1Completed);
      prefs.setBool('olom7Lesson15Part2Completed_$phoneNumber', olom7Lesson15Part2Completed);
      prefs.setBool('olom8Lesson15Part2Completed_$phoneNumber', olom8Lesson15Part2Completed);
      prefs.setBool('olom7Lesson15Part3Completed_$phoneNumber', olom7Lesson15Part3Completed);
      prefs.setBool('olom8Lesson15Part3Completed_$phoneNumber', olom8Lesson15Part3Completed);
      prefs.setBool('olom9Lesson1Part1Completed_$phoneNumber', olom9Lesson1Part1Completed);
      prefs.setBool('olom9Lesson1Part2Completed_$phoneNumber', olom9Lesson1Part2Completed);
      prefs.setBool('olom9Lesson1Part3Completed_$phoneNumber', olom9Lesson1Part3Completed);
      prefs.setBool('olom9Lesson2Part1Completed_$phoneNumber', olom9Lesson2Part1Completed);
      prefs.setBool('olom9Lesson2Part2Completed_$phoneNumber', olom9Lesson2Part2Completed);
      prefs.setBool('olom9Lesson2Part3Completed_$phoneNumber', olom9Lesson2Part3Completed);
      prefs.setBool('olom9Lesson3Part1Completed_$phoneNumber', olom9Lesson3Part1Completed);
      prefs.setBool('olom9Lesson3Part2Completed_$phoneNumber', olom9Lesson3Part2Completed);
      prefs.setBool('olom9Lesson3Part3Completed_$phoneNumber', olom9Lesson3Part3Completed);
      prefs.setBool('olom9Lesson4Part1Completed_$phoneNumber', olom9Lesson4Part1Completed);
      prefs.setBool('olom9Lesson4Part2Completed_$phoneNumber', olom9Lesson4Part2Completed);
      prefs.setBool('olom9Lesson4Part3Completed_$phoneNumber', olom9Lesson4Part3Completed);
      prefs.setBool('olom9Lesson5Part1Completed_$phoneNumber', olom9Lesson5Part1Completed);
      prefs.setBool('olom9Lesson5Part2Completed_$phoneNumber', olom9Lesson5Part2Completed);
      prefs.setBool('olom9Lesson5Part3Completed_$phoneNumber', olom9Lesson5Part3Completed);
      prefs.setBool('olom9Lesson6Part1Completed_$phoneNumber', olom9Lesson6Part1Completed);
      prefs.setBool('olom9Lesson6Part2Completed_$phoneNumber', olom9Lesson6Part2Completed);
      prefs.setBool('olom9Lesson6Part3Completed_$phoneNumber', olom9Lesson6Part3Completed);
      prefs.setBool('olom9Lesson7Part1Completed_$phoneNumber', olom9Lesson7Part1Completed);
      prefs.setBool('olom9Lesson7Part2Completed_$phoneNumber', olom9Lesson7Part2Completed);
      prefs.setBool('olom9Lesson7Part3Completed_$phoneNumber', olom9Lesson7Part3Completed);
      prefs.setBool('olom9Lesson8Part1Completed_$phoneNumber', olom9Lesson8Part1Completed);
      prefs.setBool('olom9Lesson8Part2Completed_$phoneNumber', olom9Lesson8Part2Completed);
      prefs.setBool('olom9Lesson8Part3Completed_$phoneNumber', olom9Lesson8Part3Completed);
      prefs.setBool('olom9Lesson9Part1Completed_$phoneNumber', olom9Lesson9Part1Completed);
      prefs.setBool('olom9Lesson9Part2Completed_$phoneNumber', olom9Lesson9Part2Completed);
      prefs.setBool('olom9Lesson9Part3Completed_$phoneNumber', olom9Lesson9Part3Completed);
      prefs.setBool('olom9Lesson10Part1Completed_$phoneNumber', olom9Lesson10Part1Completed);
      prefs.setBool('olom9Lesson10Part2Completed_$phoneNumber', olom9Lesson10Part2Completed);
      prefs.setBool('olom9Lesson10Part3Completed_$phoneNumber', olom9Lesson10Part3Completed);
      prefs.setBool('olom9Lesson11Part1Completed_$phoneNumber', olom9Lesson11Part1Completed);
      prefs.setBool('olom9Lesson11Part2Completed_$phoneNumber', olom9Lesson11Part2Completed);
      prefs.setBool('olom9Lesson11Part3Completed_$phoneNumber', olom9Lesson11Part3Completed);
      prefs.setBool('olom9Lesson12Part1Completed_$phoneNumber', olom9Lesson12Part1Completed);
      prefs.setBool('olom9Lesson12Part2Completed_$phoneNumber', olom9Lesson12Part2Completed);
      prefs.setBool('olom9Lesson12Part3Completed_$phoneNumber', olom9Lesson12Part3Completed);
      prefs.setBool('olom9Lesson13Part1Completed_$phoneNumber', olom9Lesson13Part1Completed);
      prefs.setBool('olom9Lesson13Part2Completed_$phoneNumber', olom9Lesson13Part2Completed);
      prefs.setBool('olom9Lesson13Part3Completed_$phoneNumber', olom9Lesson13Part3Completed);
      prefs.setBool('olom9Lesson14Part1Completed_$phoneNumber', olom9Lesson14Part1Completed);
      prefs.setBool('olom9Lesson14Part2Completed_$phoneNumber', olom9Lesson14Part2Completed);
      prefs.setBool('olom9Lesson14Part3Completed_$phoneNumber', olom9Lesson14Part3Completed);
      prefs.setBool('olom9Lesson15Part1Completed_$phoneNumber', olom9Lesson15Part1Completed);
      prefs.setBool('olom9Lesson15Part2Completed_$phoneNumber', olom9Lesson15Part2Completed);
      prefs.setBool('olom9Lesson15Part3Completed_$phoneNumber', olom9Lesson15Part3Completed);

      prefs.setBool('quran9Lesson8Part1Completed_$phoneNumber', quran9Lesson8Part1Completed);
      prefs.setBool('quran9Lesson8Part2Completed_$phoneNumber', quran9Lesson8Part2Completed);
      prefs.setBool('quran9Lesson8Part3Completed_$phoneNumber', quran9Lesson8Part3Completed);
      prefs.setBool('quran9Lesson9Part1Completed_$phoneNumber', quran9Lesson9Part1Completed);
      prefs.setBool('quran9Lesson9Part2Completed_$phoneNumber', quran9Lesson9Part2Completed);
      prefs.setBool('quran9Lesson9Part3Completed_$phoneNumber', quran9Lesson9Part3Completed);
      prefs.setBool('quran9Lesson10Part1Completed_$phoneNumber', quran9Lesson10Part1Completed);
      prefs.setBool('quran9Lesson10Part2Completed_$phoneNumber', quran9Lesson10Part2Completed);
      prefs.setBool('quran9Lesson10Part3Completed_$phoneNumber', quran9Lesson10Part3Completed);
      prefs.setBool('quran9Lesson11Part1Completed_$phoneNumber', quran9Lesson11Part1Completed);
      prefs.setBool('quran9Lesson11Part2Completed_$phoneNumber', quran9Lesson11Part2Completed);
      prefs.setBool('quran9Lesson11Part3Completed_$phoneNumber', quran9Lesson11Part3Completed);
      prefs.setBool('zaban7Lesson1Part1Completed_$phoneNumber', zaban7Lesson1Part1Completed);
      prefs.setBool('zaban7Lesson1Part2Completed_$phoneNumber', zaban7Lesson1Part2Completed);
      prefs.setBool('zaban7Lesson1Part3Completed_$phoneNumber', zaban7Lesson1Part3Completed);
      prefs.setBool('zaban7WelcomePart1Completed_$phoneNumber', zaban7WelcomePart1Completed);
      prefs.setBool('zaban7WelcomePart2Completed_$phoneNumber', zaban7WelcomePart2Completed);
      prefs.setBool('zaban7WelcomePart3Completed_$phoneNumber', zaban7WelcomePart3Completed);
      prefs.setBool('zaban7Lesson3Part1Completed_$phoneNumber', zaban7Lesson3Part1Completed);
      prefs.setBool('zaban7Lesson3Part2Completed_$phoneNumber', zaban7Lesson3Part2Completed);
      prefs.setBool('zaban7Lesson3Part3Completed_$phoneNumber', zaban7Lesson3Part3Completed);
      prefs.setBool('zaban7Lesson4Part1Completed_$phoneNumber', zaban7Lesson4Part1Completed);
      prefs.setBool('zaban7Lesson4Part2Completed_$phoneNumber', zaban7Lesson4Part2Completed);
      prefs.setBool('zaban7Lesson4Part3Completed_$phoneNumber', zaban7Lesson4Part3Completed);
      prefs.setBool('zaban7Lesson5Part1Completed_$phoneNumber', zaban7Lesson5Part1Completed);
      prefs.setBool('zaban7Lesson5Part2Completed_$phoneNumber', zaban7Lesson5Part2Completed);
      prefs.setBool('zaban7Lesson5Part3Completed_$phoneNumber', zaban7Lesson5Part3Completed);
      prefs.setBool('zaban7Lesson6Part1Completed_$phoneNumber', zaban7Lesson6Part1Completed);
      prefs.setBool('zaban7Lesson6Part2Completed_$phoneNumber', zaban7Lesson6Part2Completed);
      prefs.setBool('zaban7Lesson6Part3Completed_$phoneNumber', zaban7Lesson6Part3Completed);
      prefs.setBool('zaban7Lesson7Part1Completed_$phoneNumber', zaban7Lesson7Part1Completed);
      prefs.setBool('zaban7Lesson7Part2Completed_$phoneNumber', zaban7Lesson7Part2Completed);
      prefs.setBool('zaban7Lesson7Part3Completed_$phoneNumber', zaban7Lesson7Part3Completed);
      prefs.setBool('zaban8Lesson1Part1Completed_$phoneNumber', zaban8Lesson1Part1Completed);
      prefs.setBool('zaban8Lesson1Part2Completed_$phoneNumber', zaban8Lesson1Part2Completed);
      prefs.setBool('zaban8Lesson1Part3Completed_$phoneNumber', zaban8Lesson1Part3Completed);
      prefs.setBool('zaban8Lesson2Part1Completed_$phoneNumber', zaban8Lesson2Part1Completed);
      prefs.setBool('zaban8Lesson2Part2Completed_$phoneNumber', zaban8Lesson2Part2Completed);
      prefs.setBool('zaban8Lesson2Part3Completed_$phoneNumber', zaban8Lesson2Part3Completed);
      prefs.setBool('zaban8Lesson3Part1Completed_$phoneNumber', zaban8Lesson3Part1Completed);
      prefs.setBool('zaban8Lesson3Part2Completed_$phoneNumber', zaban8Lesson3Part2Completed);
      prefs.setBool('zaban8Lesson3Part3Completed_$phoneNumber', zaban8Lesson3Part3Completed);
      prefs.setBool('zaban8Lesson4Part1Completed_$phoneNumber', zaban8Lesson4Part1Completed);
      prefs.setBool('zaban8Lesson4Part2Completed_$phoneNumber', zaban8Lesson4Part2Completed);
      prefs.setBool('zaban8Lesson4Part3Completed_$phoneNumber', zaban8Lesson4Part3Completed);
      prefs.setBool('zaban8Lesson5Part1Completed_$phoneNumber', zaban8Lesson5Part1Completed);
      prefs.setBool('zaban8Lesson5Part2Completed_$phoneNumber', zaban8Lesson5Part2Completed);
      prefs.setBool('zaban8Lesson5Part3Completed_$phoneNumber', zaban8Lesson5Part3Completed);
      prefs.setBool('zaban9Lesson1Part1Completed_$phoneNumber', zaban9Lesson1Part1Completed);
      prefs.setBool('zaban9Lesson1Part2Completed_$phoneNumber', zaban9Lesson1Part2Completed);
      prefs.setBool('zaban9Lesson1Part3Completed_$phoneNumber', zaban9Lesson1Part3Completed);
      prefs.setBool('zaban9Lesson2Part1Completed_$phoneNumber', zaban9Lesson2Part1Completed);
      prefs.setBool('zaban9Lesson2Part2Completed_$phoneNumber', zaban9Lesson2Part2Completed);
      prefs.setBool('zaban9Lesson2Part3Completed_$phoneNumber', zaban9Lesson2Part3Completed);
      prefs.setBool('zaban9Lesson3Part1Completed_$phoneNumber', zaban9Lesson3Part1Completed);
      prefs.setBool('zaban9Lesson3Part2Completed_$phoneNumber', zaban9Lesson3Part2Completed);
      prefs.setBool('zaban9Lesson3Part3Completed_$phoneNumber', zaban9Lesson3Part3Completed);
      prefs.setBool('zaban9Lesson4Part1Completed_$phoneNumber', zaban9Lesson4Part1Completed);
      prefs.setBool('zaban9Lesson4Part2Completed_$phoneNumber', zaban9Lesson4Part2Completed);
      prefs.setBool('zaban9Lesson4Part3Completed_$phoneNumber', zaban9Lesson4Part3Completed);
      prefs.setBool('zaban9Lesson5Part1Completed_$phoneNumber', zaban9Lesson5Part1Completed);
      prefs.setBool('zaban9Lesson5Part2Completed_$phoneNumber', zaban9Lesson5Part2Completed);
      prefs.setBool('zaban9Lesson5Part3Completed_$phoneNumber', zaban9Lesson5Part3Completed);
      prefs.setBool('zaban9Lesson6Part1Completed_$phoneNumber', zaban9Lesson6Part1Completed);
      prefs.setBool('zaban9Lesson6Part2Completed_$phoneNumber', zaban9Lesson6Part2Completed);
      prefs.setBool('zaban9Lesson6Part3Completed_$phoneNumber', zaban9Lesson6Part3Completed);
      prefs.setBool('farsi7Lesson1Part1Completed_$phoneNumber', farsi7Lesson1Part1Completed);
      prefs.setBool('farsi7Lesson1Part2Completed_$phoneNumber', farsi7Lesson1Part2Completed);
      prefs.setBool('farsi7Lesson1Part3Completed_$phoneNumber', farsi7Lesson1Part3Completed);
      prefs.setBool('farsi7Lesson2Part1Completed_$phoneNumber', farsi7Lesson2Part1Completed);
      prefs.setBool('farsi7Lesson2Part2Completed_$phoneNumber', farsi7Lesson2Part2Completed);
      prefs.setBool('farsi7Lesson2Part3Completed_$phoneNumber', farsi7Lesson2Part3Completed);
      prefs.setBool('farsi7Lesson3Part1Completed_$phoneNumber', farsi7Lesson3Part1Completed);
      prefs.setBool('farsi7Lesson3Part2Completed_$phoneNumber', farsi7Lesson3Part2Completed);
      prefs.setBool('farsi7Lesson3Part3Completed_$phoneNumber', farsi7Lesson3Part3Completed);
      prefs.setBool('farsi7Lesson4Part1Completed_$phoneNumber', farsi7Lesson4Part1Completed);
      prefs.setBool('farsi7Lesson4Part2Completed_$phoneNumber', farsi7Lesson4Part2Completed);
      prefs.setBool('farsi7Lesson4Part3Completed_$phoneNumber', farsi7Lesson4Part3Completed);
      prefs.setBool('farsi7Lesson5Part1Completed_$phoneNumber', farsi7Lesson5Part1Completed);
      prefs.setBool('farsi7Lesson5Part2Completed_$phoneNumber', farsi7Lesson5Part2Completed);
      prefs.setBool('farsi7Lesson5Part3Completed_$phoneNumber', farsi7Lesson5Part3Completed);
      prefs.setBool('farsi7Lesson6Part1Completed_$phoneNumber', farsi7Lesson6Part1Completed);
      prefs.setBool('farsi7Lesson6Part2Completed_$phoneNumber', farsi7Lesson6Part2Completed);
      prefs.setBool('farsi7Lesson6Part3Completed_$phoneNumber', farsi7Lesson6Part3Completed);
      prefs.setBool('farsi8Lesson1Part1Completed_$phoneNumber', farsi8Lesson1Part1Completed);
      prefs.setBool('farsi8Lesson1Part2Completed_$phoneNumber', farsi8Lesson1Part2Completed);
      prefs.setBool('farsi8Lesson1Part3Completed_$phoneNumber', farsi8Lesson1Part3Completed);
      prefs.setBool('farsi8Lesson2Part1Completed_$phoneNumber', farsi8Lesson2Part1Completed);
      prefs.setBool('farsi8Lesson2Part2Completed_$phoneNumber', farsi8Lesson2Part2Completed);
      prefs.setBool('farsi8Lesson2Part3Completed_$phoneNumber', farsi8Lesson2Part3Completed);
      prefs.setBool('farsi8Lesson3Part1Completed_$phoneNumber', farsi8Lesson3Part1Completed);
      prefs.setBool('farsi8Lesson3Part2Completed_$phoneNumber', farsi8Lesson3Part2Completed);
      prefs.setBool('farsi8Lesson3Part3Completed_$phoneNumber', farsi8Lesson3Part3Completed);
      prefs.setBool('farsi8Lesson4Part1Completed_$phoneNumber', farsi8Lesson4Part1Completed);
      prefs.setBool('farsi8Lesson4Part2Completed_$phoneNumber', farsi8Lesson4Part2Completed);
      prefs.setBool('farsi8Lesson4Part3Completed_$phoneNumber', farsi8Lesson4Part3Completed);
      prefs.setBool('farsi8Lesson5Part1Completed_$phoneNumber', farsi8Lesson5Part1Completed);
      prefs.setBool('farsi8Lesson5Part2Completed_$phoneNumber', farsi8Lesson5Part2Completed);
      prefs.setBool('farsi8Lesson5Part3Completed_$phoneNumber', farsi8Lesson5Part3Completed);
      prefs.setBool('farsi8Lesson6Part1Completed_$phoneNumber', farsi8Lesson6Part1Completed);
      prefs.setBool('farsi8Lesson6Part2Completed_$phoneNumber', farsi8Lesson6Part2Completed);
      prefs.setBool('farsi8Lesson6Part3Completed_$phoneNumber', farsi8Lesson6Part3Completed);
      prefs.setBool('farsi9Lesson1Part1Completed_$phoneNumber', farsi9Lesson1Part1Completed);
      prefs.setBool('farsi9Lesson1Part2Completed_$phoneNumber', farsi9Lesson1Part2Completed);
      prefs.setBool('farsi9Lesson1Part3Completed_$phoneNumber', farsi9Lesson1Part3Completed);
      prefs.setBool('farsi9Lesson2Part1Completed_$phoneNumber', farsi9Lesson2Part1Completed);
      prefs.setBool('farsi9Lesson2Part2Completed_$phoneNumber', farsi9Lesson2Part2Completed);
      prefs.setBool('farsi9Lesson2Part3Completed_$phoneNumber', farsi9Lesson2Part3Completed);
      prefs.setBool('farsi9Lesson3Part1Completed_$phoneNumber', farsi9Lesson3Part1Completed);
      prefs.setBool('farsi9Lesson3Part2Completed_$phoneNumber', farsi9Lesson3Part2Completed);
      prefs.setBool('farsi9Lesson3Part3Completed_$phoneNumber', farsi9Lesson3Part3Completed);
      prefs.setBool('farsi9Lesson4Part1Completed_$phoneNumber', farsi9Lesson4Part1Completed);
      prefs.setBool('farsi9Lesson4Part2Completed_$phoneNumber', farsi9Lesson4Part2Completed);
      prefs.setBool('farsi9Lesson4Part3Completed_$phoneNumber', farsi9Lesson4Part3Completed);
      prefs.setBool('farsi9Lesson5Part1Completed_$phoneNumber', farsi9Lesson5Part1Completed);
      prefs.setBool('farsi9Lesson5Part2Completed_$phoneNumber', farsi9Lesson5Part2Completed);
      prefs.setBool('farsi9Lesson5Part3Completed_$phoneNumber', farsi9Lesson5Part3Completed);
      prefs.setBool('farsi9Lesson6Part1Completed_$phoneNumber', farsi9Lesson6Part1Completed);
      prefs.setBool('farsi9Lesson6Part2Completed_$phoneNumber', farsi9Lesson6Part2Completed);
      prefs.setBool('farsi9Lesson6Part3Completed_$phoneNumber', farsi9Lesson6Part3Completed);
      prefs.setBool('payam7Lesson1Part1Completed_$phoneNumber', payam7Lesson1Part1Completed);
      prefs.setBool('payam7Lesson1Part2Completed_$phoneNumber', payam7Lesson1Part2Completed);
      prefs.setBool('payam7Lesson1Part3Completed_$phoneNumber', payam7Lesson1Part3Completed);
      prefs.setBool('payam7Lesson2Part1Completed_$phoneNumber', payam7Lesson2Part1Completed);
      prefs.setBool('payam7Lesson2Part2Completed_$phoneNumber', payam7Lesson2Part2Completed);
      prefs.setBool('payam7Lesson2Part3Completed_$phoneNumber', payam7Lesson2Part3Completed);
      prefs.setBool('payam7Lesson3Part1Completed_$phoneNumber', payam7Lesson3Part1Completed);
      prefs.setBool('payam7Lesson3Part2Completed_$phoneNumber', payam7Lesson3Part2Completed);
      prefs.setBool('payam7Lesson3Part3Completed_$phoneNumber', payam7Lesson3Part3Completed);
      prefs.setBool('payam7Lesson4Part1Completed_$phoneNumber', payam7Lesson4Part1Completed);
      prefs.setBool('payam7Lesson4Part2Completed_$phoneNumber', payam7Lesson4Part2Completed);
      prefs.setBool('payam7Lesson4Part3Completed_$phoneNumber', payam7Lesson4Part3Completed);
      prefs.setBool('payam7Lesson5Part1Completed_$phoneNumber', payam7Lesson5Part1Completed);
      prefs.setBool('payam7Lesson5Part2Completed_$phoneNumber', payam7Lesson5Part2Completed);
      prefs.setBool('payam7Lesson5Part3Completed_$phoneNumber', payam7Lesson5Part3Completed);
      prefs.setBool('payam8Lesson1Part1Completed_$phoneNumber', payam8Lesson1Part1Completed);
      prefs.setBool('payam8Lesson1Part2Completed_$phoneNumber', payam8Lesson1Part2Completed);
      prefs.setBool('payam8Lesson1Part3Completed_$phoneNumber', payam8Lesson1Part3Completed);
      prefs.setBool('payam8Lesson2Part1Completed_$phoneNumber', payam8Lesson2Part1Completed);
      prefs.setBool('payam8Lesson2Part2Completed_$phoneNumber', payam8Lesson2Part2Completed);
      prefs.setBool('payam8Lesson2Part3Completed_$phoneNumber', payam8Lesson2Part3Completed);
      prefs.setBool('payam8Lesson3Part1Completed_$phoneNumber', payam8Lesson3Part1Completed);
      prefs.setBool('payam8Lesson3Part2Completed_$phoneNumber', payam8Lesson3Part2Completed);
      prefs.setBool('payam8Lesson3Part3Completed_$phoneNumber', payam8Lesson3Part3Completed);
      prefs.setBool('payam8Lesson4Part1Completed_$phoneNumber', payam8Lesson4Part1Completed);
      prefs.setBool('payam8Lesson4Part2Completed_$phoneNumber', payam8Lesson4Part2Completed);
      prefs.setBool('payam8Lesson4Part3Completed_$phoneNumber', payam8Lesson4Part3Completed);
      prefs.setBool('payam8Lesson5Part1Completed_$phoneNumber', payam8Lesson5Part1Completed);
      prefs.setBool('payam8Lesson5Part2Completed_$phoneNumber', payam8Lesson5Part2Completed);
      prefs.setBool('payam8Lesson5Part3Completed_$phoneNumber', payam8Lesson5Part3Completed);
      prefs.setBool('payam8Lesson6Part1Completed_$phoneNumber', payam8Lesson6Part1Completed);
      prefs.setBool('payam8Lesson6Part2Completed_$phoneNumber', payam8Lesson6Part2Completed);
      prefs.setBool('payam8Lesson6Part3Completed_$phoneNumber', payam8Lesson6Part3Completed);
      prefs.setBool('payam9Lesson1Part1Completed_$phoneNumber', payam9Lesson1Part1Completed);
      prefs.setBool('payam9Lesson1Part2Completed_$phoneNumber', payam9Lesson1Part2Completed);
      prefs.setBool('payam9Lesson1Part3Completed_$phoneNumber', payam9Lesson1Part3Completed);
      prefs.setBool('payam9Lesson2Part1Completed_$phoneNumber', payam9Lesson2Part1Completed);
      prefs.setBool('payam9Lesson2Part2Completed_$phoneNumber', payam9Lesson2Part2Completed);
      prefs.setBool('payam9Lesson2Part3Completed_$phoneNumber', payam9Lesson2Part3Completed);
      prefs.setBool('payam9Lesson3Part1Completed_$phoneNumber', payam9Lesson3Part1Completed);
      prefs.setBool('payam9Lesson3Part2Completed_$phoneNumber', payam9Lesson3Part2Completed);
      prefs.setBool('payam9Lesson3Part3Completed_$phoneNumber', payam9Lesson3Part3Completed);
      prefs.setBool('payam9Lesson4Part1Completed_$phoneNumber', payam9Lesson4Part1Completed);
      prefs.setBool('payam9Lesson4Part2Completed_$phoneNumber', payam9Lesson4Part2Completed);
      prefs.setBool('payam9Lesson4Part3Completed_$phoneNumber', payam9Lesson4Part3Completed);
      prefs.setBool('payam9Lesson5Part1Completed_$phoneNumber', payam9Lesson5Part1Completed);
      prefs.setBool('payam9Lesson5Part2Completed_$phoneNumber', payam9Lesson5Part2Completed);
      prefs.setBool('payam9Lesson5Part3Completed_$phoneNumber', payam9Lesson5Part3Completed);
      prefs.setBool('motaleat7Lesson1Part1Completed_$phoneNumber', motaleat7Lesson1Part1Completed);
      prefs.setBool('motaleat7Lesson1Part2Completed_$phoneNumber', motaleat7Lesson1Part2Completed);
      prefs.setBool('motaleat7Lesson1Part3Completed_$phoneNumber', motaleat7Lesson1Part3Completed);
      prefs.setBool('motaleat7Lesson2Part1Completed_$phoneNumber', motaleat7Lesson2Part1Completed);
      prefs.setBool('motaleat7Lesson2Part2Completed_$phoneNumber', motaleat7Lesson2Part2Completed);
      prefs.setBool('motaleat7Lesson2Part3Completed_$phoneNumber', motaleat7Lesson2Part3Completed);
      prefs.setBool('motaleat7Lesson3Part1Completed_$phoneNumber', motaleat7Lesson3Part1Completed);
      prefs.setBool('motaleat7Lesson3Part2Completed_$phoneNumber', motaleat7Lesson3Part2Completed);
      prefs.setBool('motaleat7Lesson3Part3Completed_$phoneNumber', motaleat7Lesson3Part3Completed);
      prefs.setBool('motaleat7Lesson4Part1Completed_$phoneNumber', motaleat7Lesson4Part1Completed);
      prefs.setBool('motaleat7Lesson4Part2Completed_$phoneNumber', motaleat7Lesson4Part2Completed);
      prefs.setBool('motaleat7Lesson4Part3Completed_$phoneNumber', motaleat7Lesson4Part3Completed);
      prefs.setBool('motaleat7Lesson5Part1Completed_$phoneNumber', motaleat7Lesson5Part1Completed);
      prefs.setBool('motaleat7Lesson5Part2Completed_$phoneNumber', motaleat7Lesson5Part2Completed);
      prefs.setBool('motaleat7Lesson5Part3Completed_$phoneNumber', motaleat7Lesson5Part3Completed);
      prefs.setBool('motaleat7Lesson6Part1Completed_$phoneNumber', motaleat7Lesson6Part1Completed);
      prefs.setBool('motaleat7Lesson6Part2Completed_$phoneNumber', motaleat7Lesson6Part2Completed);
      prefs.setBool('motaleat7Lesson6Part3Completed_$phoneNumber', motaleat7Lesson6Part3Completed);
      prefs.setBool('motaleat7Lesson7Part1Completed_$phoneNumber', motaleat7Lesson7Part1Completed);
      prefs.setBool('motaleat7Lesson7Part2Completed_$phoneNumber', motaleat7Lesson7Part2Completed);
      prefs.setBool('motaleat7Lesson7Part3Completed_$phoneNumber', motaleat7Lesson7Part3Completed);
      prefs.setBool('motaleat7Lesson8Part1Completed_$phoneNumber', motaleat7Lesson8Part1Completed);
      prefs.setBool('motaleat7Lesson8Part2Completed_$phoneNumber', motaleat7Lesson8Part2Completed);
      prefs.setBool('motaleat7Lesson8Part3Completed_$phoneNumber', motaleat7Lesson8Part3Completed);
      prefs.setBool('motaleat7Lesson9Part1Completed_$phoneNumber', motaleat7Lesson9Part1Completed);
      prefs.setBool('motaleat7Lesson9Part2Completed_$phoneNumber', motaleat7Lesson9Part2Completed);
      prefs.setBool('motaleat7Lesson9Part3Completed_$phoneNumber', motaleat7Lesson9Part3Completed);
      prefs.setBool('motaleat7Lesson10Part1Completed_$phoneNumber', motaleat7Lesson10Part1Completed);
      prefs.setBool('motaleat7Lesson10Part2Completed_$phoneNumber', motaleat7Lesson10Part2Completed);
      prefs.setBool('motaleat7Lesson10Part3Completed_$phoneNumber', motaleat7Lesson10Part3Completed);
      prefs.setBool('motaleat7Lesson11Part1Completed_$phoneNumber', motaleat7Lesson11Part1Completed);
      prefs.setBool('motaleat7Lesson11Part2Completed_$phoneNumber', motaleat7Lesson11Part2Completed);
      prefs.setBool('motaleat7Lesson11Part3Completed_$phoneNumber', motaleat7Lesson11Part3Completed);
      prefs.setBool('motaleat7Lesson12Part1Completed_$phoneNumber', motaleat7Lesson12Part1Completed);
      prefs.setBool('motaleat7Lesson12Part2Completed_$phoneNumber', motaleat7Lesson12Part2Completed);
      prefs.setBool('motaleat7Lesson12Part3Completed_$phoneNumber', motaleat7Lesson12Part3Completed);
      prefs.setBool('motaleat8Lesson1Part1Completed_$phoneNumber', motaleat8Lesson1Part1Completed);
      prefs.setBool('motaleat8Lesson1Part2Completed_$phoneNumber', motaleat8Lesson1Part2Completed);
      prefs.setBool('motaleat8Lesson1Part3Completed_$phoneNumber', motaleat8Lesson1Part3Completed);
      prefs.setBool('motaleat8Lesson2Part1Completed_$phoneNumber', motaleat8Lesson2Part1Completed);
      prefs.setBool('motaleat8Lesson2Part2Completed_$phoneNumber', motaleat8Lesson2Part2Completed);
      prefs.setBool('motaleat8Lesson2Part3Completed_$phoneNumber', motaleat8Lesson2Part3Completed);
      prefs.setBool('motaleat8Lesson3Part1Completed_$phoneNumber', motaleat8Lesson3Part1Completed);
      prefs.setBool('motaleat8Lesson3Part2Completed_$phoneNumber', motaleat8Lesson3Part2Completed);
      prefs.setBool('motaleat8Lesson3Part3Completed_$phoneNumber', motaleat8Lesson3Part3Completed);
      prefs.setBool('motaleat8Lesson4Part1Completed_$phoneNumber', motaleat8Lesson4Part1Completed);
      prefs.setBool('motaleat8Lesson4Part2Completed_$phoneNumber', motaleat8Lesson4Part2Completed);
      prefs.setBool('motaleat8Lesson4Part3Completed_$phoneNumber', motaleat8Lesson4Part3Completed);
      prefs.setBool('motaleat8Lesson5Part1Completed_$phoneNumber', motaleat8Lesson5Part1Completed);
      prefs.setBool('motaleat8Lesson5Part2Completed_$phoneNumber', motaleat8Lesson5Part2Completed);
      prefs.setBool('motaleat8Lesson5Part3Completed_$phoneNumber', motaleat8Lesson5Part3Completed);
      prefs.setBool('motaleat8Lesson6Part1Completed_$phoneNumber', motaleat8Lesson6Part1Completed);
      prefs.setBool('motaleat8Lesson6Part2Completed_$phoneNumber', motaleat8Lesson6Part2Completed);
      prefs.setBool('motaleat8Lesson6Part3Completed_$phoneNumber', motaleat8Lesson6Part3Completed);
      prefs.setBool('motaleat8Lesson7Part1Completed_$phoneNumber', motaleat8Lesson7Part1Completed);
      prefs.setBool('motaleat8Lesson7Part2Completed_$phoneNumber', motaleat8Lesson7Part2Completed);
      prefs.setBool('motaleat8Lesson7Part3Completed_$phoneNumber', motaleat8Lesson7Part3Completed);
      prefs.setBool('motaleat8Lesson8Part1Completed_$phoneNumber', motaleat8Lesson8Part1Completed);
      prefs.setBool('motaleat8Lesson8Part2Completed_$phoneNumber', motaleat8Lesson8Part2Completed);
      prefs.setBool('motaleat8Lesson8Part3Completed_$phoneNumber', motaleat8Lesson8Part3Completed);
      prefs.setBool('motaleat8Lesson9Part1Completed_$phoneNumber', motaleat8Lesson9Part1Completed);
      prefs.setBool('motaleat8Lesson9Part2Completed_$phoneNumber', motaleat8Lesson9Part2Completed);
      prefs.setBool('motaleat8Lesson9Part3Completed_$phoneNumber', motaleat8Lesson9Part3Completed);
      prefs.setBool('motaleat8Lesson10Part1Completed_$phoneNumber', motaleat8Lesson10Part1Completed);
      prefs.setBool('motaleat8Lesson10Part2Completed_$phoneNumber', motaleat8Lesson10Part2Completed);
      prefs.setBool('motaleat8Lesson10Part3Completed_$phoneNumber', motaleat8Lesson10Part3Completed);
      prefs.setBool('motaleat8Lesson11Part1Completed_$phoneNumber', motaleat8Lesson11Part1Completed);
      prefs.setBool('motaleat8Lesson11Part2Completed_$phoneNumber', motaleat8Lesson11Part2Completed);
      prefs.setBool('motaleat8Lesson11Part3Completed_$phoneNumber', motaleat8Lesson11Part3Completed);
      prefs.setBool('motaleat8Lesson12Part1Completed_$phoneNumber', motaleat8Lesson12Part1Completed);
      prefs.setBool('motaleat8Lesson12Part2Completed_$phoneNumber', motaleat8Lesson12Part2Completed);
      prefs.setBool('motaleat8Lesson12Part3Completed_$phoneNumber', motaleat8Lesson12Part3Completed);
      prefs.setBool('zaban8Lesson7Part1Completed_$phoneNumber', zaban8Lesson7Part1Completed);
      prefs.setBool('zaban8Lesson7Part2Completed_$phoneNumber', zaban8Lesson7Part2Completed);
      prefs.setBool('zaban8Lesson7Part3Completed_$phoneNumber', zaban8Lesson7Part3Completed);
      prefs.setBool('zaban8Lesson5Part2Completed_$phoneNumber', zaban8Lesson5Part2Completed);
      prefs.setBool('zaban8Lesson5Part3Completed_$phoneNumber', zaban8Lesson5Part3Completed);
      prefs.setBool('zaban8Lesson6Part1Completed_$phoneNumber', zaban8Lesson6Part1Completed);
      prefs.setBool('zaban8Lesson6Part2Completed_$phoneNumber', zaban8Lesson6Part2Completed);
      prefs.setBool('zaban8Lesson6Part3Completed_$phoneNumber', zaban8Lesson6Part3Completed);
      prefs.setBool('zaban8Lesson3Part2Completed_$phoneNumber', zaban8Lesson3Part2Completed);
      prefs.setBool('zaban8Lesson3Part3Completed_$phoneNumber', zaban8Lesson3Part3Completed);
      prefs.setBool('zaban8Lesson4Part1Completed_$phoneNumber', zaban8Lesson4Part1Completed);
      prefs.setBool('zaban8Lesson4Part2Completed_$phoneNumber', zaban8Lesson4Part2Completed);
      prefs.setBool('zaban8Lesson4Part3Completed_$phoneNumber', zaban8Lesson4Part3Completed);
      prefs.setBool('zaban8Lesson2Part2Completed_$phoneNumber', zaban8Lesson2Part2Completed);
      prefs.setBool('zaban8Lesson2Part3Completed_$phoneNumber', zaban8Lesson2Part3Completed);
      prefs.setBool('zaban7Lesson7Part2Completed_$phoneNumber', zaban7Lesson7Part2Completed);
      prefs.setBool('zaban7Lesson7Part3Completed_$phoneNumber', zaban7Lesson7Part3Completed);
      prefs.setBool('zaban7Lesson8Part1Completed_$phoneNumber', zaban7Lesson8Part1Completed);
      prefs.setBool('zaban7Lesson8Part2Completed_$phoneNumber', zaban7Lesson8Part2Completed);
      prefs.setBool('zaban7Lesson8Part3Completed_$phoneNumber', zaban7Lesson8Part3Completed);
      prefs.setBool('zaban7Lesson6Part2Completed_$phoneNumber', zaban7Lesson6Part2Completed);
      prefs.setBool('zaban7Lesson6Part3Completed_$phoneNumber', zaban7Lesson6Part3Completed);
      prefs.setBool('zaban7Lesson1Part2Completed_$phoneNumber', zaban7Lesson1Part2Completed);
      prefs.setBool('zaban7Lesson1Part3Completed_$phoneNumber', zaban7Lesson1Part3Completed);
      prefs.setBool('quran9Lesson7Part2Completed_$phoneNumber', quran9Lesson7Part2Completed);
      prefs.setBool('quran9Lesson7Part3Completed_$phoneNumber', quran9Lesson7Part3Completed);
      prefs.setBool('riyazi7Chapter1Completed_$phoneNumber', riyazi7Chapter1Completed);
      prefs.setBool('riyazi7Chapter2Completed_$phoneNumber', riyazi7Chapter2Completed);
      prefs.setBool('riyazi7Chapter3Completed_$phoneNumber', riyazi7Chapter3Completed);
      prefs.setBool('riyazi7Chapter4Completed_$phoneNumber', riyazi7Chapter4Completed);
      prefs.setBool('riyazi7Chapter5Completed_$phoneNumber', riyazi7Chapter5Completed);
      prefs.setBool('riyazi7Chapter6Completed_$phoneNumber', riyazi7Chapter6Completed);
      prefs.setBool('riyazi7Chapter7Completed_$phoneNumber', riyazi7Chapter7Completed);
      prefs.setBool('riyazi7Chapter8Completed_$phoneNumber', riyazi7Chapter8Completed);
      prefs.setBool('riyazi7Chapter9Completed_$phoneNumber', riyazi7Chapter9Completed);
      prefs.setBool('riyazi8Chapter1Completed_$phoneNumber', riyazi8Chapter1Completed);
      prefs.setBool('riyazi8Chapter2Completed_$phoneNumber', riyazi8Chapter2Completed);
      prefs.setBool('riyazi8Chapter3Completed_$phoneNumber', riyazi8Chapter3Completed);
      prefs.setBool('riyazi8Chapter4Completed_$phoneNumber', riyazi8Chapter4Completed);
      prefs.setBool('riyazi8Chapter5Completed_$phoneNumber', riyazi8Chapter5Completed);
      prefs.setBool('riyazi8Chapter6Completed_$phoneNumber', riyazi8Chapter6Completed);
      prefs.setBool('riyazi8Chapter7Completed_$phoneNumber', riyazi8Chapter7Completed);
      prefs.setBool('riyazi8Chapter8Completed_$phoneNumber', riyazi8Chapter8Completed);
      prefs.setBool('riyazi8Chapter9Completed_$phoneNumber', riyazi8Chapter9Completed);
      prefs.setBool('riyazi9Chapter1Completed_$phoneNumber', riyazi9Chapter1Completed);
      prefs.setBool('riyazi9Chapter2Completed_$phoneNumber', riyazi9Chapter2Completed);
      prefs.setBool('riyazi9Chapter3Completed_$phoneNumber', riyazi9Chapter3Completed);
      prefs.setBool('riyazi9Chapter4Completed_$phoneNumber', riyazi9Chapter4Completed);
      prefs.setBool('riyazi9Chapter5Completed_$phoneNumber', riyazi9Chapter5Completed);
      prefs.setBool('riyazi9Chapter6Completed_$phoneNumber', riyazi9Chapter6Completed);
      prefs.setBool('riyazi9Chapter7Completed_$phoneNumber', riyazi9Chapter7Completed);
      prefs.setBool('riyazi9Chapter8Completed_$phoneNumber', riyazi9Chapter8Completed);
      prefs.setBool('motaleat9Lesson1Part1Completed_$phoneNumber', motaleat9Lesson1Part1Completed);
      prefs.setBool('motaleat9Lesson1Part2Completed_$phoneNumber', motaleat9Lesson1Part2Completed);
      prefs.setBool('motaleat9Lesson1Part3Completed_$phoneNumber', motaleat9Lesson1Part3Completed);
      prefs.setBool('motaleat9Lesson2Part1Completed_$phoneNumber', motaleat9Lesson2Part1Completed);
      prefs.setBool('motaleat9Lesson2Part2Completed_$phoneNumber', motaleat9Lesson2Part2Completed);
      prefs.setBool('motaleat9Lesson2Part3Completed_$phoneNumber', motaleat9Lesson2Part3Completed);
      prefs.setBool('motaleat9Lesson3Part1Completed_$phoneNumber', motaleat9Lesson3Part1Completed);
      prefs.setBool('motaleat9Lesson3Part2Completed_$phoneNumber', motaleat9Lesson3Part2Completed);
      prefs.setBool('motaleat9Lesson3Part3Completed_$phoneNumber', motaleat9Lesson3Part3Completed);
      prefs.setBool('motaleat9Lesson4Part1Completed_$phoneNumber', motaleat9Lesson4Part1Completed);
      prefs.setBool('motaleat9Lesson4Part2Completed_$phoneNumber', motaleat9Lesson4Part2Completed);
      prefs.setBool('motaleat9Lesson4Part3Completed_$phoneNumber', motaleat9Lesson4Part3Completed);
      prefs.setBool('motaleat9Lesson5Part1Completed_$phoneNumber', motaleat9Lesson5Part1Completed);
      prefs.setBool('motaleat9Lesson5Part2Completed_$phoneNumber', motaleat9Lesson5Part2Completed);
      prefs.setBool('motaleat9Lesson5Part3Completed_$phoneNumber', motaleat9Lesson5Part3Completed);
      prefs.setBool('motaleat9Lesson6Part1Completed_$phoneNumber', motaleat9Lesson6Part1Completed);
      prefs.setBool('motaleat9Lesson6Part2Completed_$phoneNumber', motaleat9Lesson6Part2Completed);
      prefs.setBool('motaleat9Lesson6Part3Completed_$phoneNumber', motaleat9Lesson6Part3Completed);
      prefs.setBool('motaleat9Lesson7Part1Completed_$phoneNumber', motaleat9Lesson7Part1Completed);
      prefs.setBool('motaleat9Lesson7Part2Completed_$phoneNumber', motaleat9Lesson7Part2Completed);
      prefs.setBool('motaleat9Lesson7Part3Completed_$phoneNumber', motaleat9Lesson7Part3Completed);
      prefs.setBool('motaleat9Lesson8Part1Completed_$phoneNumber', motaleat9Lesson8Part1Completed);
      prefs.setBool('motaleat9Lesson8Part2Completed_$phoneNumber', motaleat9Lesson8Part2Completed);
      prefs.setBool('motaleat9Lesson8Part3Completed_$phoneNumber', motaleat9Lesson8Part3Completed);
      prefs.setBool('motaleat9Lesson9Part1Completed_$phoneNumber', motaleat9Lesson9Part1Completed);
      prefs.setBool('motaleat9Lesson9Part2Completed_$phoneNumber', motaleat9Lesson9Part2Completed);
      prefs.setBool('motaleat9Lesson9Part3Completed_$phoneNumber', motaleat9Lesson9Part3Completed);
      prefs.setBool('motaleat9Lesson10Part1Completed_$phoneNumber', motaleat9Lesson10Part1Completed);
      prefs.setBool('motaleat9Lesson10Part2Completed_$phoneNumber', motaleat9Lesson10Part2Completed);
      prefs.setBool('motaleat9Lesson10Part3Completed_$phoneNumber', motaleat9Lesson10Part3Completed);
      prefs.setBool('motaleat9Lesson11Part1Completed_$phoneNumber', motaleat9Lesson11Part1Completed);
      prefs.setBool('motaleat9Lesson11Part2Completed_$phoneNumber', motaleat9Lesson11Part2Completed);
      prefs.setBool('motaleat9Lesson11Part3Completed_$phoneNumber', motaleat9Lesson11Part3Completed);
      prefs.setBool('motaleat9Lesson12Part1Completed_$phoneNumber', motaleat9Lesson12Part1Completed);
      prefs.setBool('motaleat9Lesson12Part2Completed_$phoneNumber', motaleat9Lesson12Part2Completed);
      prefs.setBool('motaleat9Lesson12Part3Completed_$phoneNumber', motaleat9Lesson12Part3Completed);
    }

    // ارسال خودکار تمامی تغییرات (سکه، درس‌ها، آواتار و تم) به پنل ادمین
    if (isLoggedIn && phoneNumber.isNotEmpty) {
      int completedLessonsCount = 0;
      List<String> completedList = [];
      final suffix = '_$phoneNumber';
      for (String k in prefs.getKeys()) {
        if (k.contains('Completed') && k.endsWith(suffix) && prefs.getBool(k) == true) {
          completedLessonsCount++;
          completedList.add(k.replaceAll(suffix, ''));
        }
      }

      ApiService.syncStudentToAdmin(
        phoneNumber: phoneNumber,
        coins: coins,
        selectedGrade: selectedGrade,
        fullName: userName.isNotEmpty ? userName : 'دانش‌آموز دانا',
        currentAvatar: userAvatar.isNotEmpty ? userAvatar : 'image/avatar/1.webp',
        currentTheme: currentTheme,
        totalCompletedLessons: completedLessonsCount,
        completedLessons: completedList,
      );
    }
  }

  // بررسی اینکه آیا این شماره موبایل تاکنون هدیه ورود گرفته است یا خیر
  static Future<bool> hasReceivedGiftFor(String phone) async {
    if (phone.isEmpty) return true;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('gift_given_$phone') ?? false;
  }

  // ثبت دریافت هدیه برای این شماره موبایل خاص
  static Future<void> markGiftReceivedFor(String phone) async {
    if (phone.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('gift_given_$phone', true);
  }
}
