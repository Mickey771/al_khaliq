import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

// ------------------------------------------------------------------
// CONFIGURATION - FILL THESE IN BEFORE RUNNING
// ------------------------------------------------------------------
const String teamId = 'AKS84H33J4'; // Your Team ID
const String keyId = 'SPRM5W4P4P'; // Your Key ID
const String clientId = 'com.microstatik.alKhaliq'; // Your Bundle ID
const String p8FilePath =
    'c:\\Users\\LENOVO\\Documents\\al_khaliq\\AuthKey_SPRM5W4P4P.p8';
// ^ UPDATE THIS PATH to where your .p8 file actually is!
// ------------------------------------------------------------------

void main() async {
  try {
    print('🔵 Reading Private Key from: $p8FilePath');
    final File p8File = File(p8FilePath);

    if (!await p8File.exists()) {
      print('🔴 Error: File not found at $p8FilePath');
      print('👉 Please update the p8FilePath variable in this script.');
      return;
    }

    final String pemContent = await p8File.readAsString();

    final jwt = JWT(
      {
        'iss': teamId,
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'exp': DateTime.now().add(Duration(days: 180)).millisecondsSinceEpoch ~/
            1000, // 6 months validity
        'aud': 'https://appleid.apple.com',
        'sub': clientId,
      },
      header: {
        'kid': keyId,
        'alg': 'ES256',
      },
    );

    // Sign the JWT
    final key = ECPrivateKey(pemContent);
    final token = jwt.sign(key, algorithm: JWTAlgorithm.ES256);

    print('\n✅ GENERATED CLIENT SECRET (Valid for 6 months):');
    print('---------------------------------------------------');
    print(token);
    print('---------------------------------------------------');
    print(
        '👉 Copy the string above and paste it into the Supabase "Secret Key" field.');
  } catch (e) {
    print('🔴 Error: $e');
  }
}
