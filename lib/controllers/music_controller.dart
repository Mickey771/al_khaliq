// import 'package:al_khaliq/services/genre_services.dart';
import 'package:al_khaliq/services/music_services.dart';
import 'package:flutter/material.dart';
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
  RxBool recentlyPlayedLoadingStatus = false.obs;
  RxBool favouriteLoadingStatus = false.obs;

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
        if (response is Map && response.containsKey('data')) {
          allSongs.value = response['data'] ?? [];
        } else if (response is List) {
          allSongs.value = response;
        } else {
          debugPrint("⚠️ Unexpected response structure for allSongs");
        }
      } else {
        allSongsLoadingStatus.value = false;
        // Get.back();
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
    recentlyPlayedLoadingStatus.value = true;
    MusicServices.getRecentlyPlayed((status, response) {
      if (status) {
        recentlyPlayedLoadingStatus.value = false;
        if (response is Map && response.containsKey('data')) {
          recentlyPlayed.value = response['data'] ?? [];
        } else if (response is List) {
          recentlyPlayed.value = response;
        } else {
          debugPrint("⚠️ Unexpected response structure for recentlyPlayed");
        }
      } else {
        recentlyPlayedLoadingStatus.value = false;
      }
    }, token);
  }

  getFavourites(token) async {
    favouriteLoadingStatus.value = true;
    MusicServices.getFavourites((status, response) {
      if (status) {
        favouriteLoadingStatus.value = false;
        favouriteMusics.value = response['data'];
      } else {
        favouriteLoadingStatus.value = false;
        // showFlashError(context, response);
        // Get.back();
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

  addRecentlyPlayed(token, musicId) async {
    // We don't necessarily need a loading state for this background task
    MusicServices.addRecentlyPlayed((status, response) {
      if (status) {
        getRecentlyPlayed(token);
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
