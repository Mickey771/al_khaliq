import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
          'provider': 'supabase_apple', // Marker for backend
        };
      }
    } catch (e) {
      debugPrint('🔴 Supabase Apple Sign In Error: $e');
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
