import 'package:purchases_flutter/purchases_flutter.dart';
import '../config/revenue_cat_config.dart';
import 'package:flutter/foundation.dart';

class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  Future<void> initialize(String userId) async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration =
        PurchasesConfiguration(RevenueCatConfig.apiKey)..appUserID = userId;

    await Purchases.configure(configuration);
  }

  Future<Offerings> getOfferings() async {
    return await Purchases.getOfferings();
  }

  Future<CustomerInfo> getCustomerInfo() async {
    return await Purchases.getCustomerInfo();
  }

  bool hasActiveSubscription(CustomerInfo customerInfo) {
    return customerInfo.entitlements.active.containsKey('Pro');
  }

  Future<void> restorePurchases() async {
    await Purchases.restorePurchases();
  }

  Future<void> updateUserId(String userId) async {
    await Purchases.logIn(userId);
    debugPrint('RevenueCat user updated to: $userId');
  }
}
