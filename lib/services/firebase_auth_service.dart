import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google Sign In
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result =
          await _auth.signInWithCredential(credential);
      final User? user = result.user;

      if (user != null) {
        final String? idToken = await user.getIdToken();
        return {
          'user': user,
          'idToken': idToken,
          'email': user.email,
          'name': user.displayName,
          'uid': user.uid,
        };
      }
    } catch (e) {
      print('Google Sign In Error: $e');
      throw e;
    }
    return null;
  }

  // Apple Sign In
  static Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final UserCredential result =
          await _auth.signInWithCredential(oauthCredential);
      final User? user = result.user;

      if (user != null) {
        final String? idToken = await user.getIdToken();
        return {
          'user': user,
          'idToken': idToken,
          'email': user.email ?? appleCredential.email,
          'name': user.displayName ??
              '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                  .trim(),
          'uid': user.uid,
        };
      }
    } catch (e) {
      print('Apple Sign In Error: $e');
      throw e;
    }
    return null;
  }

  // Helper functions for Apple Sign In
  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Sign Out
  static Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
