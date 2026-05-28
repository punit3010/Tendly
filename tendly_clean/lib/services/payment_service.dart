import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../config/keys.dart';

class PaymentService {
  static Future<void> initialize() async {
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(PurchasesConfiguration(
      Platform.isIOS ? '' : AppKeys.revenueCatGoogle,
    ));
  }

  static Future<List<Package>> getPackages() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } catch (_) { return []; }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      final info = await Purchases.purchasePackage(package);
      return info.entitlements.active.containsKey('pro');
    } catch (_) { return false; }
  }

  static Future<bool> get isProActive async {
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey('pro');
    } catch (_) { return false; }
  }
}
