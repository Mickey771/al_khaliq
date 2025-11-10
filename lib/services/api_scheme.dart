import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';

class ApiServices {
  static makePostRequest({apiUrl, data, token}) async {
    debugPrint('Auth - $token');

    final uri = Uri.parse(apiUrl);
    final jsonString = json.encode(data);
    Map<String, String> headers;
    if (token == null) {
      headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
    } else {
      headers = {
        'accept': 'application/json',
        'token': '$token',
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };
    }
    return await http.post(uri, body: jsonString, headers: headers);
  }

  static makeDeleteRequest({apiUrl, data, token}) async {
    debugPrint('Auth - $token');

    final uri = Uri.parse(apiUrl);
    final jsonString = json.encode(data);
    Map<String, String> headers;
    if (token == null) {
      headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
    } else {
      headers = {
        'accept': 'application/json',
        'token': '$token',
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };
    }
    return await http.delete(uri, body: jsonString, headers: headers);
  }

  static makePatchRequest({apiUrl, data, token}) async {
    debugPrint('Auth - $token');

    final uri = Uri.parse(apiUrl);
    final jsonString = json.encode(data);
    Map<String, String> headers;

    headers = {
      'accept': 'application/json',
      'token': '$token',
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    return await http.patch(uri, body: jsonString, headers: headers);
  }

  static makeGetRequest({apiUrl, token}) async {
    debugPrint('Auth - $token');

    var uri = Uri.parse(apiUrl);
    Map<String, String> headers;

    headers = {
      // 'Accept': '*/*',
      'Authorization': 'Bearer $token',
      // HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/json'
    };

    return await http.get(uri, headers: headers);
  }

  static initialisePostRequest(
      {required data, required String url, token}) async {
    try {
      debugPrint(token);
      debugPrint(data);
      debugPrint(url);

      http.Response response = await ApiServices.makePostRequest(
          apiUrl: url, data: data, token: token);
      var body = jsonDecode(response.body);
      // debugPrint(response.statusCode);
      debugPrint(response.body);
      debugPrint('Res  $url ---- $body');

      if (ApiServices.isRequestSuccessful(response.statusCode)) {
        debugPrint('Success');
        return body;
      } else {
        debugPrint('INVALID LOGIN');
        return ApiServices.handleError(response);
      }
    } catch (e) {
      debugPrint('Error - $e');
      if (e.toString().contains('HandshakeException')) {
        return 'Check your internet connection';
      } else {
        return e.toString();
      }
    }
  }

  static initialisePostMultiPart(
      {required data, required String url, token, banner}) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'token': '$token',
      'Content-Type': 'multipart/form-data',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    try {
      debugPrint(token);
      debugPrint(data);
      debugPrint(url);

      var uri = Uri.parse(url);

      var request = http.MultipartRequest("POST", uri);

      request.fields.addAll(data);

      request.headers.addAll(headers);

      for (var i in banner) {
        debugPrint(i.path);
        request.files.add(await http.MultipartFile.fromPath('banner', i.path,
            contentType: MediaType('image', 'jpeg')));
      }

      var response = await request.send();
      debugPrint("ressssss $response");

      // response.stream.bytesToString();

      // Print(response.statusCode);
      // print(response.stream);
      // Print(response.request);

      if (ApiServices.isRequestSuccessful(response.statusCode)) {
        debugPrint('Success');
        var body;
        response.stream.transform(utf8.decoder).listen((value) {
          body = jsonDecode(value);
        });
        return response;
      } else {
        debugPrint('i am here now ERROR');
        Get.back();
      }
    } catch (e) {
      debugPrint('Error - $e');

      if (e.toString().contains('HandshakeException')) {
        return 'Check your internet connection';
      } else {
        return e.toString();
      }
    }
  }

  static initialiseDeleteRequest(
      {required data, required String url, token}) async {
    try {
      debugPrint(token);
      debugPrint(data);
      debugPrint(url);

      http.Response response = await ApiServices.makeDeleteRequest(
          apiUrl: url, data: data, token: token);
      var body = jsonDecode(response.body);
      // debugPrint(response.statusCode);
      debugPrint(response.body);
      debugPrint('Res  $url ---- $body');

      if (ApiServices.isRequestSuccessful(response.statusCode)) {
        debugPrint('Success');
        return body;
      } else {
        debugPrint('i am here now ERROR');
        return ApiServices.handleError(response);
      }
    } catch (e) {
      debugPrint('Errororor - $e');

      if (e.toString().contains('HandshakeException')) {
        return 'Check your internet connection';
      } else {
        return e.toString();
      }
    }
  }

  static initialisePatchRequest(
      {required Map<String, dynamic> data, required String url, token}) async {
    // if (await InternetServices.checkConnectivity()) {
    try {
      debugPrint(url);
      var response = await ApiServices.makePatchRequest(
          apiUrl: url, data: data, token: token);
      var body = jsonDecode(response.body);
      debugPrint('Res  $url ---- $body');

      if (ApiServices.isRequestSuccessful(response.statusCode)) {
        return body;
      } else {
        return ApiServices.handleError(response);
      }
    } catch (e) {
      debugPrint(e.toString());

      return e.toString();
    }
    // } else {
    //   return 'Check your internet connection';
    // }
  }

  static initialiseGetRequest({required String url, token}) async {
    // if (await InternetServices.checkConnectivity()) {
    try {
      debugPrint('ddf');

      debugPrint(url);
      http.Response response =
          await ApiServices.makeGetRequest(apiUrl: url, token: token);

      // debugPrint(response.headers);
      // debugPrint(response.request);
      // debugPrint(response.statusCode);
      debugPrint(response.body);
      var body = jsonDecode(response.body);

      debugPrint('dd3f');
      debugPrint('Res  $url ---- $body');
      if (ApiServices.isRequestSuccessful(response.statusCode)) {
        return body;
      } else {
        return ApiServices.handleError(response);
      }
    } catch (e) {
      debugPrint('Erroror - - - - - $e');

      return e.toString();
    }
  }

  static handleError(http.Response response) {
    String errorMessage;
    try {
      var responseBody = jsonDecode(response.body);
      if (responseBody['error'] != null) {
        errorMessage = responseBody['error'].toString();
      } else if (responseBody['message'] != null) {
        errorMessage = responseBody['message'].toString();
      } else if (responseBody['data'] != null &&
          responseBody['data']['detail'] != null) {
        errorMessage = responseBody['data']['detail'].toString();
      } else if (responseBody['data'] != null &&
          responseBody['data']['errors'] != null) {
        errorMessage = responseBody['data']['errors'].toString();
      } else if (responseBody['result'] != null &&
          responseBody['result']['errors'] != null) {
        errorMessage = responseBody['result']['errors'].toString();
      } else if (responseBody['result'] != null &&
          responseBody['result']['detail'] != null) {
        errorMessage = responseBody['result']['detail'].toString();
      } else {
        errorMessage = 'Failed response';
      }
    } catch (e) {
      errorMessage = 'Failed to parse error response';
    }

    debugPrint(errorMessage);
    switch (response.statusCode) {
      case 400:
        throw (errorMessage);

      case 401:
        throw 'Unauthorized request - $errorMessage';

      case 403:
        throw 'Forbidden Error - $errorMessage';
      case 404:
        throw 'Not Found - $errorMessage';

      case 422:
        throw 'Unable to process - $errorMessage';

      case 500:
        throw 'Server error - $errorMessage';
      default:
        throw 'Error occurred with code : ${response.statusCode}';
    }
  }

  static isRequestSuccessful(int? statusCode) {
    return statusCode! >= 200 && statusCode < 300;
  }
}
