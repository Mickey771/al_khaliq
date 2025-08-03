
import 'package:al_khaliq/services/genre_services.dart';
import 'package:al_khaliq/services/music_services.dart';
import 'package:al_khaliq/services/playlist_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../onboarding/auth_board.dart';
import '../onboarding/login.dart';
import '../screens/views.dart';
import '../services/account_services.dart';




class PlaylistController extends GetxController {




  RxBool loadingStatus = false.obs;

  RxList userPlayLists = [].obs;
  RxList playlistSongs = [].obs;
  RxList recentlyPlayed = [].obs;
  RxList favouriteMusics = [].obs;




  getUserPlaylists(token, userId) async {
    loadingStatus.value = true;
    PlaylistServices.getUserPlaylists((status, response) {
      if (status) {
        loadingStatus.value = false;
        userPlayLists.value = response;

      } else {
        loadingStatus.value = false;
        // showFlashError(context, response);
        Get.back();
      }
    }, token, userId);
  }


  getPlaylistSongs(token, playlistId) async {
    loadingStatus.value = true;
    PlaylistServices.getUserPlaylistSongs((status, response) {
      if (status) {
        loadingStatus.value = false;
        playlistSongs.value = response['songs'];

      } else {
        loadingStatus.value = false;
        // showFlashError(context, response);
        Get.back();
      }
    }, token, playlistId);
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

  addFavourites(token, musicId) async {
    loadingStatus.value = true;
    MusicServices.addFavourites((status, response) {
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
