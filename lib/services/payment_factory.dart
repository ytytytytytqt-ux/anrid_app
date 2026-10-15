import 'payment_service.dart';
import 'cafebazaar_payment_service.dart';
import 'myket_payment_service.dart';
import 'direct_payment_service.dart';

/// کارخانه ساخت سرویس پرداخت (Payment Factory)
/// سرویس پرداخت مناسب را بر اساس فلور (Flavor) فعال در زمان کامپایل انتخاب می‌کند
class PaymentFactory {
  static PaymentService getPaymentService() {
    // خواندن مقدار فلور از متغیر کامپایل: flutter run --dart-define=FLAVOR=cafebazaar
    const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'direct');

    switch (flavor) {
      case 'cafebazaar':
        return CafeBazaarPaymentService();
      case 'myket':
        return MyketPaymentService();
      case 'direct':
      default:
        return DirectPaymentService();
    }
  }
}
