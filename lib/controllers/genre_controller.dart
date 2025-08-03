
import 'package:al_khaliq/services/genre_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../onboarding/auth_board.dart';
import '../onboarding/login.dart';
import '../screens/views.dart';
import '../services/account_services.dart';




class GenreController extends GetxController {




  RxBool genreLoadingStatus = false.obs;

  RxList genres = [].obs;




  getGenres(token) async {
    genreLoadingStatus.value = true;
    GenreServices.getGenres((status, response) {
      if (status) {
        genreLoadingStatus.value = false;
        genres.value = response['data'];

      } else {
        genreLoadingStatus.value = false;
        // showFlashError(context, response);
        Get.back();
      }
    }, token);
  }



  signOut(token) async {
    // Get.to(() => Loading());
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    Get.offAll(() => Login());
  }


}
