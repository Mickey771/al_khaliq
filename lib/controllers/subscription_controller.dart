import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/revenue_cat_service.dart';
import 'package:flutter/foundation.dart';

class SubscriptionController extends GetxController {
  final RevenueCatService revenueCat = RevenueCatService();

  var hasSubscription = false.obs;
  var isLoading = false.obs;
  var customerInfo = Rxn<CustomerInfo>();

  // DO NOT do navigation inside here because setUser() now controls that flow
  Future<void> refreshSubscription({CustomerInfo? info}) async {
    try {
      isLoading.value = true;
      final effectiveInfo = info ?? await revenueCat.getCustomerInfo();
      customerInfo.value = effectiveInfo;
      hasSubscription.value = revenueCat.hasActiveSubscription(effectiveInfo);
      debugPrint('Has subscription: ${hasSubscription.value}');
    } catch (e) {
      debugPrint('refreshSubscription error: $e');
      hasSubscription.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // keep this method because you may use it outside of login sequence
  // (like user manually pressing restore or subscription settings screen)
  // keep this method because you may use it outside of login sequence
  // (like user manually pressing restore or subscription settings screen)
  Future<void> checkSubscription({CustomerInfo? info}) async {
    await refreshSubscription(info: info);

    if (!hasSubscription.value) {
      Get.offAllNamed('/paywall');
    } else {
      Get.offAllNamed('/home');
    }
  }
}
