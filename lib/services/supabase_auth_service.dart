import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SupabaseAuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Apple Sign In (Hybrid Flow)
  static Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      debugPrint('🔵 Starting Supabase Apple Sign In (Hybrid Flow)...');

      // 1. Get raw Apple ID Credential using the native package
      //    (This mirrors exactly what we did for Firebase, which we know works)
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      debugPrint('🟢 Native Apple Credential Received');
      debugPrint(
          '  - Identity Token: ${appleCredential.identityToken?.substring(0, 10)}...');

      // 2. Exchange this token with Supabase
      if (appleCredential.identityToken == null) {
        throw 'Apple Identity Token is null';
      }

      final AuthResponse res = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: appleCredential.identityToken!,
        accessToken:
            appleCredential.authorizationCode, // Optional but good practice
      );

      final User? user = res.user;

      if (user != null) {
        debugPrint('🟢 Supabase Sign In Verification Successful');
        debugPrint('  - User UID: ${user.id}');
        debugPrint('  - User Email: ${user.email}');

        // Get the session access token to send to backend
        final String? accessToken = res.session?.accessToken;

        return {
          'user': user,
          'idToken': accessToken, // Send this to PHP backend
          'email':
              user.email ?? appleCredential.email, // Fallback to Apple's email
          'name': user.userMetadata?['full_name'] ??
              '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                  .trim(),
          'uid': user.id,
          'provider': 'supabase_apple',
          'avatar':
              user.userMetadata?['avatar_url'] ?? user.userMetadata?['picture'],
        };
      }
    } catch (e) {
      debugPrint('🔴 Supabase Apple Sign In Error: $e');
      rethrow;
    }
    return null;
  }

  // Google Sign In
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      debugPrint('🔵 Starting Supabase Google Sign In...');

      // 1. Trigger native Google Sign In
      // NOTE: serverClientId is its Web Client ID from Google Cloud / google-services.json
      // It is required to get an idToken on Android.
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId:
            '980313543309-f5v5tpafso25t524oap3h3mcdge06s92.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      debugPrint('🟢 Native Google Account Received: ${googleUser.email}');

      // 2. Get authentication details (idToken)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'Google ID Token is null';
      }

      debugPrint('🔵 Exchanging Google ID Token with Supabase...');

      // 3. Exchange token with Supabase
      final AuthResponse res = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );

      final User? user = res.user;

      if (user != null) {
        debugPrint('🟢 Supabase Google Sign In Successful');
        final String? accessToken = res.session?.accessToken;

        return {
          'user': user,
          'idToken': accessToken, // Send session token to backend
          'email': user.email ?? googleUser.email,
          'name': user.userMetadata?['full_name'] ?? googleUser.displayName,
          'uid': user.id,
          'provider': 'supabase_google',
          'avatar': user.userMetadata?['avatar_url'] ??
              user.userMetadata?['picture'] ??
              googleUser.photoUrl,
        };
      }
    } catch (e) {
      debugPrint('🔴 Supabase Google Sign In Error: $e');
      rethrow;
    }
    return null;
  }

  // Helper to get current user
  static User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Sign out (only Supabase session)
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
