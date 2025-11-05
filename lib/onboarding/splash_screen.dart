import 'dart:async';
import 'package:al_khaliq/services/revenue_cat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/account_controller.dart';
import '../controllers/subscription_controller.dart';
import 'auth_board.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadApp();
  }

  loadApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var uid = prefs.getString('uid');

    Timer(const Duration(milliseconds: 2000), () async {
      // STEP 1: Check if logged in
      if (token == null || token.isEmpty) {
        // Not logged in → Go to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthBoard()),
        );
      } else {
        // STEP 2: Logged in → Set user
        AccountController accountController = Get.find<AccountController>();
        await accountController.setUser(context, token, uid: uid);

        // STEP 3: Update RevenueCat with user ID
        if (uid != null && uid.isNotEmpty) {
          await RevenueCatService().updateUserId(uid);
          debugPrint('RevenueCat user set to: $uid');
        }

        // STEP 4: Check subscription
        Get.find<SubscriptionController>().checkSubscription();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF10121f),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 70,
            left: -50,
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 150,
                    spreadRadius: 0,
                    color: Color(0xFF220b56),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 300,
            right: -80,
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 170,
                    spreadRadius: 0,
                    color: Color(0xFF584171),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: 90,
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 180,
                    spreadRadius: 0,
                    color: Color(0xFF47687d),
                  )
                ],
              ),
            ),
          ),
          Container(
            color: const Color(0xFF191E31).withOpacity(0.284),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Image.asset(
                'assets/images/assetImages/AppLogo.png',
                fit: BoxFit.cover,
                scale: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
