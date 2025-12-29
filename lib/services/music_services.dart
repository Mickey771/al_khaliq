// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';

import 'api_docs.dart';
import 'api_scheme.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

class MusicServices {
  static getAllSongs(Function callback, token) async {
    var response =
        await ApiServices.initialiseGetRequest(url: allSongsUrl, token: token);
    // print(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static getNewReleases(Function callback, token) async {
    var response = await ApiServices.initialiseGetRequest(
        url: newReleaseUrl, token: token);
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
    // print(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static getFavourites(Function callback, token) async {
    var response = await ApiServices.initialiseGetRequest(
        url: myFavouritesUrl, token: token);
    // print(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static addFavourites(Function callback, token, data) async {
    var response = await ApiServices.initialisePostRequest(
        data: data, url: addFavouriteUrl, token: token);
    // print(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static removeFromFavourites(Function callback, token, data) async {
    var response = await ApiServices.initialisePostRequest(
        data: data, url: removeFromFavoriteUrl, token: token);
    // print(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static addRecentlyPlayed(Function callback, token, data) async {
    var response = await ApiServices.initialisePostRequest(
        data: data, url: addRecentlyPlayedUrl, token: token);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }
}
