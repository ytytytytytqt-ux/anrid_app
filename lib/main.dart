import 'package:flutter/material.dart';
import 'managers/auth_manager.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthManager.init(); // بارگذاری اطلاعات قبلی کاربر
  runApp(const DanaProApp());
}