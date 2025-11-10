// import 'package:al_khaliq/services/genre_services.dart';
import 'package:al_khaliq/services/music_services.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../onboarding/auth_board.dart';
import '../onboarding/login.dart';
// import '../screens/views.dart';
// import '../services/account_services.dart';

class MusicController extends GetxController {
  RxBool loadingStatus = false.obs;
  RxBool allSongsLoadingStatus = false.obs;
  RxBool newReleasesLoadingStatus = false.obs;

  RxList allSongs = [].obs;
  RxList filteredSongs = [].obs;

  RxList newReleases = [].obs;
  RxList recentlyPlayed = [].obs;
  RxList favouriteMusics = [].obs;

  getAllSongs(token) async {
    allSongsLoadingStatus.value = true;
    MusicServices.getAllSongs((status, response) {
      if (status) {
        allSongsLoadingStatus.value = false;
        allSongs.value = response['songs'];
      } else {
        allSongsLoadingStatus.value = false;
        // showFlashError(context, response);
        Get.back();
      }
    }, token);
  }

  getNewReleases(token) async {
    newReleasesLoadingStatus.value = true;
    MusicServices.getNewReleases((status, response) {
      if (status) {
        newReleasesLoadingStatus.value = false;
        newReleases.value = response['data'];
      } else {
        newReleasesLoadingStatus.value = false;
        // showFlashError(context, response);
        Get.back();
      }
    }, token);
  }

  getRecentlyPlayed(token) async {
    loadingStatus.value = true;
    MusicServices.getRecentlyPlayed((status, response) {
      if (status) {
        loadingStatus.value = false;
        recentlyPlayed.value = response['data'];
      } else {
        loadingStatus.value = false;
        // showFlashError(context, response);
        Get.back();
      }
    }, token);
  }

  getFavourites(token) async {
    loadingStatus.value = true;
    MusicServices.getFavourites((status, response) {
      if (status) {
        loadingStatus.value = false;
        favouriteMusics.value = response['data'];
      } else {
        loadingStatus.value = false;
        // showFlashError(context, response);
        Get.back();
      }
    }, token);
  }

  addFavourites(token, musicId, {fromPage}) async {
    loadingStatus.value = true;
    MusicServices.addFavourites((status, response) {
      if (status) {
        loadingStatus.value = false;
        getFavourites(token);
        if (fromPage == false) {
          Get.back();
        } else {}
      } else {
        loadingStatus.value = false;
        // showFlashError(context, response);
        Get.back();
      }
    }, token, {'id': musicId});
  }

  removeFromFavourites(token, musicId) async {
    loadingStatus.value = true;
    MusicServices.removeFromFavourites((status, response) {
      if (status) {
        loadingStatus.value = false;
        getFavourites(token);
        Get.back();
      } else {
        loadingStatus.value = false;
        // showFlashError(context, response);
        Get.back();
      }
    }, token, {'id': musicId});
  }

  signOut(token) async {
    // Get.to(() => Loading());
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    Get.offAll(() => Login());
  }
}
