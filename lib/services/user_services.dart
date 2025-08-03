import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'api_docs.dart';
import 'api_scheme.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class UserServices {


  static getUser(
      Function callback,token, id) async {
    var response =
    await ApiServices.initialiseGetRequest(url: '$userUrl$id', token: token);
    print(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }


}

