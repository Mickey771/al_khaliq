import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

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
        // Firestore check
        // final userDoc =
        //     FirebaseFirestore.instance.collection("users").doc(user.uid);
        // final snapshot = await userDoc.get();

        // if (!snapshot.exists) {
        //   await userDoc.set({
        //     "email": user.email,
        //     "name": user.displayName,
        //     "createdAt": DateTime.now(),
        //   });
        // }

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
      debugPrint('Google Sign In Error: $e');
      rethrow;
    }
    return null;
  }

  // Apple Sign In
  // Apple Sign In with detailed logging
// Apple Sign In
  static Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      debugPrint('🔵 Starting Apple Sign In...');
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce); // This should work now

      debugPrint('🔵 Requesting Apple ID credential...');
      debugPrint('🔵 Client ID: com.microstatik.alKhaliq.signin');
      debugPrint(
          '🔵 Redirect URI: https://al-khalid.firebaseapp.com/__/auth/handler');

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.microstatik.alKhaliq.signin',
          redirectUri:
              Uri.parse('https://al-khalid.firebaseapp.com/__/auth/handler'),
        ),
      );

      debugPrint('🟢 Apple credential received successfully');

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      debugPrint('🔵 Signing in to Firebase...');
      final UserCredential result =
          await _auth.signInWithCredential(oauthCredential);
      final User? user = result.user;

      if (user != null) {
        debugPrint('🟢 Firebase sign-in successful');

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
    } catch (e, stackTrace) {
      debugPrint('🔴 Apple Sign In Error: $e');
      debugPrint('🔴 Stack trace: $stackTrace');
      rethrow;
    }
    return null;
  }

// Make sure these helper methods are at the bottom of your class
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

  // Get Current User
  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}
