// lib/screens/paywall/custom_paywall.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../controllers/subscription_controller.dart';
import '../../services/revenue_cat_service.dart';
import 'package:al_khaliq/screens/web_view.dart';

class CustomPaywall extends StatefulWidget {
  const CustomPaywall({Key? key}) : super(key: key);

  @override
  State<CustomPaywall> createState() => _CustomPaywallState();
}

class _CustomPaywallState extends State<CustomPaywall> {
  final SubscriptionController _controller = Get.find<SubscriptionController>();
  final RevenueCatService _rc = RevenueCatService();

  // UI state
  String? _monthlyPrice; // e.g. "$4.99 / month"
  String? _yearlyPrice; // e.g. "$59.99 / year"
  String? _monthlyProductId = 'monthly_premium:monthlypro';
  String? _yearlyProductId = 'premium_yearly:yearly';
  bool _loading = false;
  String? _error;

  // Placeholder links (you asked to use placeholders)
  final String privacyUrl = 'https://example.com/privacy';
  final String termsUrl = 'https://example.com/terms';

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
      final dynamic offerings = await _rc.getOfferings();

      // Defensive parsing: the return type from Purchases.getOfferings()
      // can vary depending on SDK versions. We'll try multiple strategies.
      // 1) If it's an Offerings object (common newer shape)
      // 2) If it's a List<Offering> (older shape you mentioned earlier)
      // 3) As a final fallback, try to get product details directly

      bool foundMonthly = false;
      bool foundYearly = false;

      // Strategy A: Offerings (object with 'all' or 'current' maps)
      try {
        // Using dynamic access to avoid strict typing issues
        if (offerings != null) {
          // try 'all' map
          final dynamic all = (offerings as dynamic).all;
          if (all != null && (all as Map).isNotEmpty) {
            // iterate offerings
            for (final entry in (all as Map).entries) {
              final dynamic offering = entry.value;
              final dynamic packages =
                  offering?.availablePackages ?? offering?.packages;
              if (packages != null) {
                for (final pack in packages) {
                  final product = pack?.product;
                  final id = product?.identifier ?? product?.productIdentifier;
                  final price =
                      (product?.presentedPrice ?? product?.priceString)
                          ?.toString();
                  if (id == _monthlyProductId && !foundMonthly) {
                    _monthlyPrice = price ?? _monthlyPrice;
                    foundMonthly = true;
                  }
                  if (id == _yearlyProductId && !foundYearly) {
                    _yearlyPrice = price ?? _yearlyPrice;
                    foundYearly = true;
                  }
                }
              }
            }
          }
        }
      } catch (_) {
        // ignore - we'll try other strategies
      }

      // Strategy B: Offerings as a List<Offering>
      if (!foundMonthly || !foundYearly) {
        try {
          if (offerings is List) {
            for (final offering in offerings) {
              final dynamic packages =
                  offering?.availablePackages ?? offering?.packages;
              if (packages != null) {
                for (final pack in packages) {
                  final product = pack?.product;
                  final id = product?.identifier ?? product?.productIdentifier;
                  final price =
                      (product?.presentedPrice ?? product?.priceString)
                          ?.toString();
                  if (id == _monthlyProductId && !foundMonthly) {
                    _monthlyPrice = price ?? _monthlyPrice;
                    foundMonthly = true;
                  }
                  if (id == _yearlyProductId && !foundYearly) {
                    _yearlyPrice = price ?? _yearlyPrice;
                    foundYearly = true;
                  }
                }
              }
            }
          }
        } catch (_) {}
      }

      // Strategy C: enumerate offerings directly if present on the root
      if (!foundMonthly || !foundYearly) {
        try {
          final dynamic current = (offerings as dynamic).current;
          if (current != null) {
            final dynamic packages =
                current?.availablePackages ?? current?.packages;
            if (packages != null) {
              for (final pack in packages) {
                final product = pack?.product;
                final id = product?.identifier ?? product?.productIdentifier;
                final price = (product?.presentedPrice ?? product?.priceString)
                    ?.toString();
                if (id == _monthlyProductId && !foundMonthly) {
                  _monthlyPrice = price ?? _monthlyPrice;
                  foundMonthly = true;
                }
                if (id == _yearlyProductId && !foundYearly) {
                  _yearlyPrice = price ?? _yearlyPrice;
                  foundYearly = true;
                }
              }
            }
          }
        } catch (_) {}
      }

      // Final fallback: if still not found, set simple defaults (so UI shows something)
      if (_monthlyPrice == null) _monthlyPrice = '\$4.99 / month';
      if (_yearlyPrice == null) _yearlyPrice = '\$59.99 / year';

      if (mounted) setState(() => _loading = false);
    } catch (e, st) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Failed to load offerings';
          // keep default price placeholders
          _monthlyPrice ??= '\$4.99 / month';
          _yearlyPrice ??= '\$59.99 / year';
        });
      }
      // You may also want to log e/st to your logger
      debugPrint('Offerings load error: $e\n$st');
    }
  }

  Future<void> _purchase(String productId) async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      // Use the purchaseProduct path — different SDK versions might return different types,
      // so we avoid assigning the result to a strict type. Instead, after attempting purchase
      // we fetch the latest CustomerInfo.
      await Purchases.purchaseProduct(productId);

      await _controller.checkSubscription();
      // After purchase, fetch customer info and update the controller
      final CustomerInfo info = await _rc.getCustomerInfo();
      _controller.customerInfo.value = info;
      _controller.hasSubscription.value = _rc.hasActiveSubscription(info);

      if (mounted) {
        if (_controller.hasSubscription.value) {
          Get.snackbar('Success', 'Subscription activated!');
          // Use Get to navigate — ensure you only use context if mounted
          Get.offAllNamed('/home');
        } else {
          Get.snackbar(
              'Info', 'Purchase complete but subscription not active yet.');
        }
      }
    } on PlatformException catch (e) {
      // handle cancellations / errors
      final code = e.code;
      debugPrint('PlatformException during purchase: $code ${e.message}');
      if (mounted) Get.snackbar('Purchase error', '${e.message ?? e.code}');
    } catch (e) {
      debugPrint('Unknown purchase error: $e');
      if (mounted) Get.snackbar('Purchase error', '$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _restore() async {
    setState(() => _loading = true);
    try {
      await _rc.restorePurchases();
      await _controller.checkSubscription();

      final CustomerInfo info = await _rc.getCustomerInfo();
      _controller.customerInfo.value = info;
      _controller.hasSubscription.value = _rc.hasActiveSubscription(info);

      if (mounted) {
        if (_controller.hasSubscription.value) {
          Get.offAllNamed('/home');
        } else {
          Get.snackbar('Restore', 'No active subscription found.');
        }
      }
    } catch (e) {
      debugPrint('Restore error: $e');
      if (mounted) Get.snackbar('Restore error', '$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upgrade to Pro',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(height: 8),
        Text('Ad-free, offline playback, unlimited skips',
            style: TextStyle(color: Colors.white70)),
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
            // neon look: purple -> blue
            colors: [Colors.deepPurple.shade700, Colors.blue.shade400],
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                offset: Offset(0, 6)),
            BoxShadow(
                color: Colors.white.withOpacity(0.03),
                blurRadius: 1,
                offset: Offset(0, -1)),
          ],
        ),
        child: Row(
          children: [
            // icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient:
                    LinearGradient(colors: [Colors.white24, Colors.white10]),
              ),
              child: Icon(Icons.music_note, color: Colors.white, size: 30),
            ),
            SizedBox(width: 14),
            // text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            // price + CTA
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Get',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // dark background gradient (app music theme)
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
              colors: [
                Color(0xFF0F0522), // deep purple-black
                Color(0xFF0B1022),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      // dismiss paywall as modal style — stay in app
                      if (mounted) Get.back();
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                  Text('Pro',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 48), // keep spacing
                ],
              ),

              SizedBox(height: 8),
              _buildHeader(context),

              // Price cards
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
                        productId: _monthlyProductId ?? 'monthly_premium',
                        subtitle: 'Best for short term - cancel anytime',
                        onTap: () =>
                            _purchase(_monthlyProductId ?? 'monthly_premium'),
                      ),
                      _buildPlanCard(
                        title: 'Yearly',
                        price: _yearlyPrice ?? '\$59.99 / year',
                        productId: _yearlyProductId ?? 'premium_yearly',
                        subtitle: 'Best value for heavy listeners',
                        onTap: () =>
                            _purchase(_yearlyProductId ?? 'premium_yearly'),
                      ),

                      SizedBox(height: 14),

                      // restore + benefits
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.check_circle_outline,
                                    color: Colors.white70),
                                SizedBox(width: 8),
                                Expanded(
                                    child: Text('Offline playback',
                                        style:
                                            TextStyle(color: Colors.white70))),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.check_circle_outline,
                                    color: Colors.white70),
                                SizedBox(width: 8),
                                Expanded(
                                    child: Text('Ad-free listening',
                                        style:
                                            TextStyle(color: Colors.white70))),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: _restore,
                                  child: Text('Restore purchases',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        // open placeholder links via Get.toNamed or url_launcher if available
                                        // for now show a snackbar with placeholder
                                        Get.to(() => WebViewPage(
                                            title: "terms of Service",
                                            url: termsUrl));
                                      },
                                      child: Text('terms of Service',
                                          style:
                                              TextStyle(color: Colors.white70)),
                                    ),
                                    Text(' • ',
                                        style:
                                            TextStyle(color: Colors.white24)),
                                    TextButton(
                                      onPressed: () {
                                        Get.to(() => WebViewPage(
                                            title: "Privacy Policy",
                                            url: privacyUrl));
                                      },
                                      child: Text('Privacy Policy',
                                          style:
                                              TextStyle(color: Colors.white70)),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Note about Apple review compliance
                      Text(
                        'This paywall blocks access until a subscription is purchased. Links to Terms & Privacy provided (placeholder).',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Bottom CTA area: small legal + restore again
              if (_loading) LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
