/// سرویس انتزاعی پرداخت (Payment Service Interface)
/// جهت ایزوله کردن SDKهای پرداخت فروشگاه‌های مختلف و جلوگیری از تداخل آن‌ها
abstract class PaymentService {
  Future<bool> purchaseSubscription(String sku);
  Future<bool> restorePurchases();
  String getStoreName();
}
