
import 'package:flutter/material.dart';

import 'api_docs.dart';
import 'api_scheme.dart';

import 'package:flutter/foundation.dart';

class UserServices {
  static getUser(Function callback, token, id) async {
    var response = await ApiServices.initialiseGetRequest(
        url: '$userUrl$id', // ✅ Correct - userUrl already has ?user_id=
        token: token);

    debugPrint("🔍 UserServices response: ${response.toString()}");

    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }
}
