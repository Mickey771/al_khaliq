import 'api_docs.dart';
import 'api_scheme.dart';

class PlaylistServices {
  static getUserPlaylists(Function callback, token, id) async {
    var response = await ApiServices.initialiseGetRequest(
        url: getPlaylistUrl, token: token);
    // print(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static getUserPlaylistSongs(Function callback, token, id) async {
    var response = await ApiServices.initialiseGetRequest(
        url: "$getPlaylistSongsUrl$id/music", token: token);
    // print(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static getRecentlyPlayed(Function callback, token) async {
    var response = await ApiServices.initialiseGetRequest(
        url: recentlyPlayedUrl, token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static getFavourites(Function callback, token) async {
    var response = await ApiServices.initialiseGetRequest(
        url: myFavouritesUrl, token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static addFavourites(Function callback, token, data) async {
    var response = await ApiServices.initialisePostRequest(
        data: data, url: addFavouriteUrl, token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static removeFromFavourites(Function callback, token, data) async {
    var response = await ApiServices.initialisePostRequest(
        data: data, url: removeFromFavoriteUrl, token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static createPlaylist(Function callback, token, data) async {
    var response = await ApiServices.initialisePostRequest(
        data: data, url: createPlaylistUrl, token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static addSongToPlaylist(Function callback, token, data) async {
    var response = await ApiServices.initialisePostRequest(
        data: data, url: addSongToPlaylistUrl, token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static removeSongFromPlaylist(Function callback, token, data) async {
    var response = await ApiServices.initialisePostRequest(
        data: data, url: removeSongFromPlaylistUrl, token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static deletePlaylist(Function callback, token, playlistId) async {
    var response = await ApiServices.initialisePostRequest(
        data: {}, url: "$deletePlaylistUrl$playlistId", token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static renamePlaylist(Function callback, token, playlistId, data) async {
    var response = await ApiServices.initialisePostRequest(
        data: data, url: "$renamePlaylistUrl$playlistId", token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }
}
