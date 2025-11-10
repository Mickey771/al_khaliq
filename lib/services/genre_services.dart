import 'package:flutter/foundation.dart';
import 'api_docs.dart';
import 'api_scheme.dart';

class GenreServices {
  static getGenres(Function callback, token) async {
    var response =
        await ApiServices.initialiseGetRequest(url: genreUrl, token: token);
    debugPrint(response);
    if (response is String) {
      callback(false, response);
    } else {
      callback(true, response);
    }
  }
}
