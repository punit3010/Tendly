import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaymentService {
  static const _appleKey  = 'YOUR_REVENUECAT_APPLE_KEY';   // TODO: from RevenueCat
  static const _googleKey = 'YOUR_REVENUECAT_GOOGLE_KEY';  // TODO: from RevenueCat

  static const monthlyId = 'tendly_pro_monthly';
  static const yearlyId  = 'tendly_pro_yearly';

  static Future<void> initialize() async {
    await Purchases.setLogLevel(LogLevel.debug);
    final config = PurchasesConfiguration(
      Platform.isIOS ? _appleKey : _googleKey,
    );
    await Purchases.configure(config);
  }

  static Future<List<Package>> getPackages() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } catch (_) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      final info = await Purchases.purchasePackage(package);
      return info.entitlements.active.containsKey('pro');
    } catch (_) {
      return false;
    }
  }

  static Future<bool> restorePurchases() async {
    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.active.containsKey('pro');
    } catch (_) {
      return false;
    }
  }

  static Future<bool> get isProActive async {
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey('pro');
    } catch (_) {
      return false;
    }
  }
}
