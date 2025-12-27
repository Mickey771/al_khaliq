import 'package:al_khaliq/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class UserController extends GetxController {
  RxBool loadingStatus = false.obs;

  var user = {}.obs;

  String _token = '';
  String _refreshToken = '';

  RxList allUsers = [].obs;

  String getToken() => _token;
  String getRefreshToken() => _refreshToken;

  setToken(token) {
    _token = token;
    debugPrint("=====$_token");
  }

  setRefresh(refreshToken) => _refreshToken = refreshToken;

  setPersistToken(token, refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    // await prefs.setString('refreshToken', refreshToken);
  }

  Future<void> getUser(token, userId) async {
    loadingStatus.value = true;

    // Add a small delay to ensure the callback completes
    // await Future.delayed(Duration(milliseconds: 100));

    UserServices.getUser((status, response) {
      loadingStatus.value = false;
      debugPrint("🔍 UserServices.getUser callback - status: $status");
      debugPrint("🔍 UserServices.getUser callback - response: $response");

      if (status) {
        user.assignAll(response);
        debugPrint("✅ User set: $user");
      } else {
        debugPrint("❌ Failed to get user: $response");
        user.clear(); // Clear user on failure
      }
    }, token, userId);

    // Wait a bit for the callback to execute
    // await Future.delayed(Duration(milliseconds: 500));

    debugPrint("🔍 After getUser - user: $user");
  }

  fetchUser(token) {}

  void setUser(Map<String, dynamic> newUser) {
    user.assignAll(newUser);
    debugPrint("User saved in controller: $newUser");
  }
}
