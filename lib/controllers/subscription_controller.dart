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
  Future<void> refreshSubscription() async {
    try {
      isLoading.value = true;
      final info = await revenueCat.getCustomerInfo();
      customerInfo.value = info;
      hasSubscription.value = revenueCat.hasActiveSubscription(info);
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
  Future<void> checkSubscription() async {
    await refreshSubscription();

    if (!hasSubscription.value) {
      Get.offAllNamed('/paywall');
    } else {
      Get.offAllNamed('/home');
    }
  }
}
