import 'package:flutter/material.dart';
// import 'package:al_khaliq/services/genre_services.dart';
import 'package:al_khaliq/services/music_services.dart';
import 'package:al_khaliq/services/playlist_services.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../onboarding/auth_board.dart';
import '../onboarding/login.dart';
// import '../screens/views.dart';
// import '../services/account_services.dart';

class PlaylistController extends GetxController {
  RxBool loadingStatus = false.obs;

  RxList userPlayLists = [].obs;
  RxList playlistSongs = [].obs;
  RxList recentlyPlayed = [].obs;
  RxList favouriteMusics = [].obs;

  getUserPlaylists(token, userId) async {
    loadingStatus.value = true;
    PlaylistServices.getUserPlaylists((status, response) {
      debugPrint("🔍 getUserPlaylists response: $response");
      loadingStatus.value = false;
      if (status) {
        List fetched = [];
        if (response is Map && response.containsKey('data')) {
          fetched = List.from(response['data'] ?? []);
        } else if (response is List) {
          fetched = List.from(response);
        }

        // Senior approach: Merge fetched data with local truth (preserve songs & precise counts)
        for (var newPlaylist in fetched) {
          var oldPlaylist = userPlayLists
              .firstWhereOrNull((p) => p['id'] == newPlaylist['id']);
          if (oldPlaylist != null && oldPlaylist.containsKey('songs')) {
            newPlaylist['songs'] = oldPlaylist['songs'];
            // Prefer the length of the actual song list as the source of truth
            newPlaylist['songs_count'] = (oldPlaylist['songs'] as List).length;
          }
        }

        userPlayLists.assignAll(fetched);
      }
    }, token, userId);
  }

  getPlaylistSongs(token, playlistId) async {
    // Senior approach: Don't clear the list if we already have data (Stale-while-revalidate)
    // This removes the "blank screen" lag perception.
    if (playlistSongs.isEmpty) {
      loadingStatus.value = true;
    }

    PlaylistServices.getUserPlaylistSongs((status, response) {
      debugPrint("🔍 getPlaylistSongs ($playlistId) response: $response");
      loadingStatus.value = false;
      if (status) {
        List fetchedSongs = [];
        if (response is Map && response.containsKey('data')) {
          var data = response['data'];
          if (data is List) {
            fetchedSongs = data;
          } else if (data is Map && data.containsKey('songs')) {
            fetchedSongs = data['songs'] ?? [];
          }
        } else if (response is List) {
          fetchedSongs = response;
        }

        playlistSongs.assignAll(fetchedSongs);

        // Senior approach: Patch the local userPlayLists to keep counts & covers in sync
        int index = userPlayLists.indexWhere((p) => p['id'] == playlistId);
        if (index != -1) {
          userPlayLists[index]['songs_count'] = fetchedSongs.length;
          userPlayLists[index]['songs'] = fetchedSongs;
          userPlayLists
              .refresh(); // Crucial for GetX to trigger UI update for Map items
        }
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

  createPlaylist(token, userId, name, description) async {
    loadingStatus.value = true;
    PlaylistServices.createPlaylist((status, response) {
      if (status) {
        loadingStatus.value = false;
        getUserPlaylists(token, userId);
        Get.back();
        Get.snackbar("Success", "Playlist created successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor.withOpacity(0.7),
            colorText: Get.theme.colorScheme.onPrimary);
      } else {
        loadingStatus.value = false;
        Get.snackbar("Error", response.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white);
      }
    }, token, {'name': name, 'description': description});
  }

  addSongToPlaylist(token, playlistId, musicId, userId) async {
    loadingStatus.value = true;
    PlaylistServices.addSongToPlaylist((status, response) {
      loadingStatus.value = false;
      if (status) {
        // Refresh both lists to keep counts and UI in sync
        getPlaylistSongs(token, playlistId);
        getUserPlaylists(token, userId);

        Get.back();
        Get.snackbar("Success", "Song added to playlist",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor.withOpacity(0.7),
            colorText: Get.theme.colorScheme.onPrimary);
      } else {
        Get.snackbar("Error", response.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white);
      }
    }, token, {'playlist_id': playlistId, 'music_id': musicId});
  }

  removeSongFromPlaylist(token, playlistId, musicId, userId) async {
    loadingStatus.value = true;
    PlaylistServices.removeSongFromPlaylist((status, response) {
      loadingStatus.value = false;
      if (status) {
        // Refresh both lists to keep counts and UI in sync
        getPlaylistSongs(token, playlistId);
        getUserPlaylists(token, userId);

        Get.snackbar("Success", "Song removed from playlist",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", response.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white);
      }
    }, token, {'playlist_id': playlistId, 'music_id': musicId});
  }

  deletePlaylist(token, playlistId, userId) async {
    loadingStatus.value = true;
    PlaylistServices.deletePlaylist((status, response) {
      loadingStatus.value = false;
      if (status) {
        getUserPlaylists(token, userId);
        Get.snackbar("Success", "Playlist deleted successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor.withOpacity(0.7),
            colorText: Get.theme.colorScheme.onPrimary);
      } else {
        Get.snackbar("Error", response.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white);
      }
    }, token, playlistId);
  }

  renamePlaylist(token, playlistId, name, userId) async {
    loadingStatus.value = true;
    PlaylistServices.renamePlaylist((status, response) {
      loadingStatus.value = false;
      if (status) {
        getUserPlaylists(token, userId);
        Get.snackbar("Success", "Playlist renamed successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor.withOpacity(0.7),
            colorText: Get.theme.colorScheme.onPrimary);
      } else {
        Get.snackbar("Error", response.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white);
      }
    }, token, playlistId, {'name': name});
  }

  signOut(token) async {
    // Get.to(() => Loading());
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    Get.offAll(() => Login());
  }
}
