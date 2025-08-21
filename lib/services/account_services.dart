import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'api_docs.dart';
import 'api_scheme.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AccountServices {
// Add this to AccountServices class
  // static socialLogin(
  //   Function callback, {
  //   required String provider, // 'google' or 'apple'
  //   required String idToken,
  //   required String email,
  //   required String name,
  //   required String firebaseUid,
  // }) async {
  //   var data = {
  //     "provider": provider,
  //     "id_token": idToken,
  //     "email": email,
  //     "name": name,
  //     "firebase_uid": firebaseUid,
  //   };

  //   var response = await ApiServices.initialisePostRequest(
  //       url: //socialLoginUrl, // Add this URL to your api_docs.dart
  //       data: data);

  //   if (response is String) {
  //     callback(false, response);
  //   } else {
  //     callback(true, response);
  //   }
  // }

  static loginUser(
    Function callback, {
    email,
    password,
  }) async {
    var data = {"email": email, "password": password};
    print(data);
    var response =
        await ApiServices.initialisePostRequest(url: loginUrl, data: data);
    print(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  // static changePassword(
  //     Function callback,data,token) async {
  //   var response =
  //   await ApiServices.initialisePostRequest(url: changePasswordUrl, token: token,data: data);
  //   print(response);
  //   if (response is String) {
  //     callback(false, response);
  //   } else {
  //     callback(true, response);
  //   }
  // }

  // static deleteAccount(
  //     Function callback,data,token) async {
  //   var response =
  //   await ApiServices.initialiseDeleteRequest(url: changePasswordUrl, token: token,data: data);
  //   print(response);
  //   if (response is String) {
  //     callback(false, response);
  //   } else {
  //     callback(true, response);
  //   }
  // }

  static refreshToken(Function callback, refreshToken) async {
    var data = {
      "refresh_token": refreshToken,
    };
    var response =
        await ApiServices.initialisePostRequest(url: refreshUrl, data: data);
    print(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  static registerUser(Function callback, {email, password, name}) async {
    var data = {
      "email": email,
      "password": password,
      "name": name,
      "password_confirmation": password,
    };
    var response =
        await ApiServices.initialisePostRequest(url: registerUrl, data: data);
    print(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }

  // static loginOutUser(
  //     Function callback, token) async {
  //   var data = {};
  //   var response =
  //   await ApiServices.initialisePostRequest(url: logoutUrl, data: data, token: token);
  //   print(response);
  //   if (response is String) {
  //     callback(false, response);
  //   } else {
  //     callback(true, response);
  //   }
  // }

  // static resendVerificationEmail(
  //     Function callback,data) async {
  //   var response =
  //   await ApiServices.initialisePostRequest(url: resentVerificationUrl, data: data);
  //   print(response);
  //   if (response is String) {
  //     callback(false, response);
  //   } else {
  //     callback(true, response);
  //   }
  // }

  static uploadFile(Function callback, url, {token, title, images}) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };

    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);

    // if(data != null){
    //   request.fields.addAll(
    //       data
    //   );
    // }

    print("ds");
    for (var i in images) {
      print(i.path);
      request.files.add(await http.MultipartFile.fromPath(title, i.path,
          contentType: MediaType('image', 'jpeg')));
    }

    print("dssss");

    request.headers.addAll(headers);
    print("dsssqes");

    var response = await request.send();

    print("dssss");

    if (response.statusCode.toString() == '200' ||
        response.statusCode.toString() == '201') {
      response.stream.transform(utf8.decoder).listen((value) {
        log(value);
        var body = jsonDecode(value);
        callback(true, body);
      });
    } else {
      callback(false, response);
    }
  }
}
