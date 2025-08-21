import 'package:al_khaliq/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/account_services.dart';
import 'package:page_transition/page_transition.dart';

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
    print("=====$_token");
  }

  setRefresh(refreshToken) => _refreshToken = refreshToken;

  @override
  void onInit() {
    super.onInit();
  }

  setPersistToken(token, refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    // await prefs.setString('refreshToken', refreshToken);
  }

  getUser(token, userId) async {
    loadingStatus.value = true;
    UserServices.getUser((status, response) {
      if (status) {
        loadingStatus.value = false;
        user.value = response;
        print(response);
      } else {
        loadingStatus.value = false;
        // showFlashError(context, response);
        // Get.back();
      }
    }, token, userId);
  }

  fetchUser(token) {}

  void setUser(Map<String, dynamic> newUser) {
    user.value = newUser;
    print("User saved in controller: $newUser");
  }
}
