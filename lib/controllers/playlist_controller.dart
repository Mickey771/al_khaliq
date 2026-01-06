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
  RxList playlistSongs =
      [].obs; // Deprecated, but keeping for compatibility if needed
  RxMap<int, List> songsCache = <int, List>{}.obs;

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
          final int id = newPlaylist['id'];

          // Priority 1: Check the dedicated multi-playlist songsCache
          if (songsCache.containsKey(id)) {
            newPlaylist['songs'] = songsCache[id];
            newPlaylist['songs_count'] = songsCache[id]!.length;
          }
          // Priority 2: Check the old userPlayLists list (stale session data)
          else {
            var oldPlaylist =
                userPlayLists.firstWhereOrNull((p) => p['id'] == id);
            if (oldPlaylist != null && oldPlaylist.containsKey('songs')) {
              newPlaylist['songs'] = oldPlaylist['songs'];
              newPlaylist['songs_count'] =
                  (oldPlaylist['songs'] as List).length;
            }
          }
        }

        userPlayLists.assignAll(fetched);
      }
    }, token, userId);
  }

  getPlaylistSongs(token, playlistId) async {
    // 🚀 Senior optimization: Stale-while-revalidate
    // No full screen loader if we already have data for this specific playlist
    if (!songsCache.containsKey(playlistId)) {
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

        // Update the specific cache for this playlist
        songsCache[playlistId] = fetchedSongs;
        playlistSongs
            .assignAll(fetchedSongs); // Keep old list updated for safety

        // Update the main list's count and song reference
        int index = userPlayLists.indexWhere((p) => p['id'] == playlistId);
        if (index != -1) {
          userPlayLists[index]['songs_count'] = fetchedSongs.length;
          userPlayLists[index]['songs'] = fetchedSongs;
          userPlayLists.refresh();
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
    // ⚡ Optimistic Update: Increment UI count immediately
    int playlistIdx = userPlayLists.indexWhere((p) => p['id'] == playlistId);
    if (playlistIdx != -1) {
      userPlayLists[playlistIdx]['songs_count'] =
          (userPlayLists[playlistIdx]['songs_count'] ?? 0) + 1;
      userPlayLists.refresh();
    }

    loadingStatus.value = true;
    PlaylistServices.addSongToPlaylist((status, response) {
      loadingStatus.value = false;
      if (status) {
        getPlaylistSongs(token, playlistId);
        getUserPlaylists(token, userId);

        Get.back();
        Get.snackbar("Success", "Song added to playlist",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor.withOpacity(0.7),
            colorText: Get.theme.colorScheme.onPrimary,
            duration: const Duration(seconds: 1));
      } else {
        // 🔄 Rollback on error
        if (playlistIdx != -1) {
          userPlayLists[playlistIdx]['songs_count'] =
              (userPlayLists[playlistIdx]['songs_count'] ?? 1) - 1;
          userPlayLists.refresh();
        }
        Get.snackbar("Error", response.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white);
      }
    }, token, {'playlist_id': playlistId, 'music_id': musicId});
  }

  removeSongFromPlaylist(token, playlistId, musicId, userId) async {
    // ⚡ Optimistic Update: Decrement UI count immediately
    int playlistIdx = userPlayLists.indexWhere((p) => p['id'] == playlistId);
    if (playlistIdx != -1) {
      int currentCount = userPlayLists[playlistIdx]['songs_count'] ?? 1;
      userPlayLists[playlistIdx]['songs_count'] =
          currentCount > 0 ? currentCount - 1 : 0;

      // Also remove from cache if exists
      if (songsCache.containsKey(playlistId)) {
        songsCache[playlistId]!.removeWhere((s) => s['id'] == musicId);
        songsCache.refresh();
      }
      userPlayLists.refresh();
    }

    loadingStatus.value = true;
    PlaylistServices.removeSongFromPlaylist((status, response) {
      loadingStatus.value = false;
      if (status) {
        getPlaylistSongs(token, playlistId);
        getUserPlaylists(token, userId);

        Get.snackbar("Success", "Song removed from playlist",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1));
      } else {
        // 🔄 Rollback count on error
        if (playlistIdx != -1) {
          userPlayLists[playlistIdx]['songs_count'] =
              (userPlayLists[playlistIdx]['songs_count'] ?? 0) + 1;
          userPlayLists.refresh();
        }
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
