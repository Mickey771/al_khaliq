import 'package:flutter/foundation.dart';
import 'api_docs.dart';
import 'api_scheme.dart';

class MusicServices {
  static getAllSongs(Function callback, token) async {
    var response =
        await ApiServices.initialiseGetRequest(url: allSongsUrl, token: token);
    debugPrint(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static getNewReleases(Function callback, token) async {
    var response = await ApiServices.initialiseGetRequest(
        url: newReleaseUrl, token: token);
    debugPrint(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static getRecentlyPlayed(Function callback, token) async {
    var response = await ApiServices.initialiseGetRequest(
        url: recentlyPlayedUrl, token: token);
    debugPrint(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static getFavourites(Function callback, token) async {
    var response = await ApiServices.initialiseGetRequest(
        url: myFavouritesUrl, token: token);
    debugPrint(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static addFavourites(Function callback, token, data) async {
    var response = await ApiServices.initialisePostRequest(
        data: data, url: addFavouriteUrl, token: token);
    debugPrint(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static removeFromFavourites(Function callback, token, data) async {
    var response = await ApiServices.initialisePostRequest(
        data: data, url: removeFromFavoriteUrl, token: token);
    debugPrint(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }
}
