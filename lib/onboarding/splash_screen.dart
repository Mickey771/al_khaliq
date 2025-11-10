import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/account_controller.dart';
import 'auth_board.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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

    // Wait 1.5 seconds for splash screen visibility
    await Future.delayed(const Duration(milliseconds: 500));

    debugPrint("🔍 Splash - token: ${token != null ? 'exists' : 'null'}");
    debugPrint("🔍 Splash - uid: ${uid != null ? 'exists' : 'null'}");

    // Check if logged in
    if (token == null || token.isEmpty || uid == null || uid.isEmpty) {
      debugPrint("🔍 No credentials found, going to login");
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthBoard()),
        );
      }
    } else {
      debugPrint("🔍 Credentials found, calling setUser");
      AccountController accountController = Get.find<AccountController>();
      await accountController.setUser(context, token, uid: uid);
    }
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
