import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'api_docs.dart';
import 'api_scheme.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AccountServices {
  static socialLogin(
    Function callback, {
    required String provider,
    required String idToken,
    required String email,
    required String name,
    required String firebaseUid,
  }) async {
    try {
      debugPrint('🔐 Social Login - Provider: $provider, Email: $email');

      var data = {
        "provider": provider,
        "id_token": idToken,
        "email": email,
        "name": name,
        "firebase_uid": firebaseUid,
      };

      var response = await ApiServices.initialisePostRequest(
        url: socialurl,
        data: data,
      );

      if (response is String) {
        debugPrint('❌ Social Login Failed: $response');
        callback(false, response);
      } else {
        debugPrint('✅ Social Login Success');
        callback(true, response);
      }
    } catch (e) {
      debugPrint('❌ Social Login Exception: $e');
      callback(false, 'Social login failed: ${e.toString()}');
    }
  }

  static loginUser(
    Function callback, {
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔐 Login User - Email: $email');

      var data = {
        "email": email,
        "password": password,
      };

      var response = await ApiServices.initialisePostRequest(
        url: loginUrl,
        data: data,
      );

      // FIX: Properly handle response - don't pass to debugPrint directly
      debugPrint('Login Response Type: ${response.runtimeType}');
      if (response is Map) {
        debugPrint('Login Response: ${jsonEncode(response)}');
      } else {
        debugPrint('Login Response: $response');
      }

      if (response is String) {
        debugPrint('❌ Login Failed: $response');
        callback(false, response);
      } else {
        debugPrint('✅ Login Success');
        callback(true, response);
      }
    } catch (e) {
      debugPrint('❌ Login Exception: $e');
      callback(false, 'Login failed: ${e.toString()}');
    }
  }

  static refreshToken(Function callback, String refreshToken) async {
    try {
      debugPrint('🔄 Refreshing Token');

      var data = {
        "refresh_token": refreshToken,
      };

      var response = await ApiServices.initialisePostRequest(
        url: refreshUrl,
        data: data,
      );

      // FIX: Properly handle response
      if (response is Map) {
        debugPrint('Refresh Response: ${jsonEncode(response)}');
      } else {
        debugPrint('Refresh Response: $response');
      }

      if (response is String) {
        debugPrint('❌ Refresh Failed: $response');
        callback(false, response);
      } else {
        debugPrint('✅ Refresh Success');
        callback(true, response);
      }
    } catch (e) {
      debugPrint('❌ Refresh Exception: $e');
      callback(false, 'Token refresh failed: ${e.toString()}');
    }
  }

  static registerUser(
    Function callback, {
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      debugPrint('📝 Register User - Email: $email, Name: $name');

      var data = {
        "email": email,
        "password": password,
        "name": name,
        "password_confirmation": password,
      };

      debugPrint('Registration data prepared, sending request...');

      var response = await ApiServices.initialisePostRequest(
        url: registerUrl,
        data: data,
      );

      // FIX: This is line 102 - properly handle Map response
      debugPrint('Register Response Type: ${response.runtimeType}');
      if (response is Map) {
        debugPrint('Register Response: ${jsonEncode(response)}');
      } else {
        debugPrint('Register Response: $response');
      }

      if (response is String) {
        debugPrint('❌ Registration Failed: $response');
        callback(false, response);
      } else {
        debugPrint('✅ Registration Success');
        callback(true, response);
      }
    } catch (e) {
      debugPrint('❌ Registration Exception: $e');
      callback(false, 'Registration failed: ${e.toString()}');
    }
  }

  static uploadFile(
    Function callback,
    String url, {
    String? token,
    required String title,
    required List images,
  }) async {
    try {
      debugPrint('📤 Upload File - URL: $url, Title: $title');

      var headers = {
        "Accept": "application/json",
      };

      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      var uri = Uri.parse(url);
      var request = http.MultipartRequest("POST", uri);

      debugPrint('Adding files to request...');
      for (var i in images) {
        debugPrint('Adding file: ${i.path}');
        request.files.add(
          await http.MultipartFile.fromPath(
            title,
            i.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      request.headers.addAll(headers);

      debugPrint('Sending multipart request...');
      var response = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('File upload timeout');
        },
      );

      debugPrint('Upload Response Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        response.stream.transform(utf8.decoder).listen((value) {
          log('Upload Success: $value');
          var body = jsonDecode(value);
          callback(true, body);
        });
      } else {
        debugPrint('❌ Upload Failed: ${response.statusCode}');
        callback(false, 'Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Upload Exception: $e');
      callback(false, 'File upload failed: ${e.toString()}');
    }
  }
}
