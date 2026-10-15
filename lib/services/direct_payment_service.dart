import 'package:flutter/foundation.dart';
import 'payment_service.dart';

/// پیاده‌سازی سرویس پرداخت مستقیم / مستقل (Direct / Gateway / Standalone)
class DirectPaymentService implements PaymentService {
  @override
  Future<bool> purchaseSubscription(String sku) async {
    // منطق اتصال به درگاه بانکی مستقیم یا کارت به کارت
    debugPrint('پرداخت مستقیم برای محصول: $sku');
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<bool> restorePurchases() async {
    debugPrint('بازیابی خریدها از سرور مستقیم');
    return true;
  }

  @override
  String getStoreName() => 'نسخه مستقیم (Direct / Standalone)';
}
