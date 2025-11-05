import 'dart:io';

class RevenueCatConfig {
  static const String androidApiKey = 'goog_XjcZKizVWrzuuRNgBZPOMcAKujt';
  static const String iosApiKey = 'appl_kwtiCJexCINGLuExXMHADKdQuIx';

  static String get apiKey {
    // Returns appropriate key based on platform
    return Platform.isAndroid ? androidApiKey : iosApiKey;
  }
}
