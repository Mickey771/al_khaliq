

import 'api_docs.dart';
import 'api_scheme.dart';


class PlaylistServices {


  static getUserPlaylists(
      Function callback,token, userId ) async {
    var response =
    await ApiServices.initialiseGetRequest(url: "$getPlaylistUrl$userId", token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static getUserPlaylistSongs(
      Function callback,token, playlistId ) async {
    var response =
    await ApiServices.initialiseGetRequest(url: "$getPlaylistSongsUrl$playlistId", token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }


  static getRecentlyPlayed(
      Function callback,token ) async {
    var response =
    await ApiServices.initialiseGetRequest(url: recentlyPlayedUrl, token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }


  static getFavourites(
      Function callback,token ) async {
    var response =
    await ApiServices.initialiseGetRequest(url: myFavouritesUrl, token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }


  static addFavourites(
      Function callback,token, data ) async {
    var response =
    await ApiServices.initialisePostRequest(data: data, url: addFavouriteUrl, token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }


  static removeFromFavourites(
      Function callback,token, data ) async {
    var response =
    await ApiServices.initialisePostRequest(data: data, url: removeFromFavoriteUrl, token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }



}

