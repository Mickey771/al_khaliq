import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../controllers/subscription_controller.dart';
import '../../services/revenue_cat_service.dart';
import 'package:al_khaliq/screens/web_view.dart';
import 'dart:io';
import 'package:al_khaliq/helpers/logout_dialog.dart';

class CustomPaywall extends StatefulWidget {
  const CustomPaywall({super.key});

  @override
  State<CustomPaywall> createState() => _CustomPaywallState();
}

class _CustomPaywallState extends State<CustomPaywall> {
  final SubscriptionController _controller = Get.find<SubscriptionController>();
  final RevenueCatService _rc = RevenueCatService();

  // UI state
  String? _monthlyPrice;
  String? _yearlyPrice;
  bool _loading = false;
  String? _error;

  // ✅ FIXED: Single source of truth for product IDs
  String get monthlyProductId =>
      Platform.isIOS ? 'monthly_premium' : 'monthly_premium:monthlypro';

  String get yearlyProductId =>
      Platform.isIOS ? 'premium_yearly' : 'premium_yearly:yearly';

  // Links
  final String privacyUrl = 'https://al-khaliq.info/privacy';
  final String termsUrl = 'https://al-khaliq.info/terms';

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final Offerings offerings = await _rc.getOfferings();

      // Get current offering
      final current = offerings.current;

      if (current != null && current.availablePackages.isNotEmpty) {
        for (final package in current.availablePackages) {
          final productId = package.storeProduct.identifier;
          final price = package.storeProduct.priceString;

          debugPrint('Found product: $productId - $price');

          if (productId == monthlyProductId) {
            _monthlyPrice = price;
          } else if (productId == yearlyProductId) {
            _yearlyPrice = price;
          }
        }
      }

      // Fallback prices if not found
      _monthlyPrice ??= '\$4.99 / month';
      _yearlyPrice ??= '\$59.99 / year';

      if (mounted) setState(() => _loading = false);
    } catch (e, st) {
      debugPrint('Offerings load error: $e\n$st');

      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Failed to load offerings';
          _monthlyPrice = '\$4.99 / month';
          _yearlyPrice = '\$59.99 / year';
        });
      }
    }
  }

  Future<void> _purchase(String productId) async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      debugPrint('Attempting purchase: $productId');

      await Purchases.purchaseProduct(productId);

      // Check subscription status
      await _controller.checkSubscription();

      if (_controller.hasSubscription.value) {
        if (mounted) {
          Get.snackbar('Success', 'Subscription activated!');
          Get.offAllNamed('/home');
        }
      }
    } on PlatformException catch (e) {
      debugPrint('Purchase error: ${e.code} - ${e.message}');

      if (e.code == '1') {
        // User cancelled
        if (mounted) Get.snackbar('Cancelled', 'Purchase was cancelled');
      } else {
        if (mounted) Get.snackbar('Error', e.message ?? 'Purchase failed');
      }
    } catch (e) {
      debugPrint('Unknown error: $e');
      if (mounted) Get.snackbar('Error', 'Purchase failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _restore() async {
    setState(() => _loading = true);

    try {
      await _rc.restorePurchases();
      await _controller.checkSubscription();

      if (mounted) {
        if (_controller.hasSubscription.value) {
          Get.snackbar('Success', 'Purchases restored!');
          Get.offAllNamed('/home');
        } else {
          Get.snackbar('Info', 'No active subscription found');
        }
      }
    } catch (e) {
      debugPrint('Restore error: $e');
      if (mounted) Get.snackbar('Error', 'Failed to restore');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upgrade to Pro',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Ad-free, offline playback, unlimited skips',
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String productId,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade700, Colors.blue.shade400],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.white24, Colors.white10],
                ),
              ),
              child: Icon(Icons.music_note, color: Colors.white, size: 30),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Get',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F0522), Color(0xFF0B1022)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => LogoutDialog(),
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                  Text(
                    'Pro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
              SizedBox(height: 8),
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_error != null) ...[
                        Text(_error!,
                            style: TextStyle(color: Colors.redAccent)),
                        SizedBox(height: 8),
                      ],
                      _buildPlanCard(
                        title: 'Monthly',
                        price: _monthlyPrice ?? '\$4.99 / month',
                        productId: monthlyProductId,
                        subtitle: 'Best for short term - cancel anytime',
                        onTap: () => _purchase(monthlyProductId),
                      ),
                      _buildPlanCard(
                        title: 'Yearly',
                        price: _yearlyPrice ?? '\$59.99 / year',
                        productId: yearlyProductId,
                        subtitle: 'Best value for heavy listeners',
                        onTap: () => _purchase(yearlyProductId),
                      ),
                      SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildBenefit('Offline playback'),
                            SizedBox(height: 8),
                            _buildBenefit('Ad-free listening'),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: _restore,
                                  child: Text(
                                    'Restore purchases',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () => Get.to(() => WebViewPage(
                                            title: "Terms of Service",
                                            url: termsUrl,
                                          )),
                                      child: Text(
                                        'Terms',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                    Text(' • ',
                                        style:
                                            TextStyle(color: Colors.white24)),
                                    TextButton(
                                      onPressed: () => Get.to(() => WebViewPage(
                                            title: "Privacy Policy",
                                            url: privacyUrl,
                                          )),
                                      child: Text(
                                        'Privacy',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              if (_loading) LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Row(
      children: [
        Icon(Icons.check_circle_outline, color: Colors.white70),
        SizedBox(width: 8),
        Expanded(
          child: Text(text, style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }
}
