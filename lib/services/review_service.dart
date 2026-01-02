import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ReviewService {
  static final InAppReview _inAppReview = InAppReview.instance;
  static const String _reviewKey = 'review_prompt_count';

  /// Triggers the native review dialog if available.
  static Future<void> requestReview() async {
    try {
      debugPrint('🔔 ReviewService: Requesting review...');
      if (await _inAppReview.isAvailable()) {
        debugPrint(
            '✅ ReviewService: Review is available, showing native prompt');
        await _inAppReview.requestReview();
      } else {
        debugPrint(
            '⚠️ ReviewService: Review NOT available, falling back to Store Listing');
        // Fallback: Open store listing
        await _inAppReview.openStoreListing(
          appStoreId: '6740645065', // App Store ID
        );
      }
    } catch (e) {
      debugPrint('❌ ReviewService Error: $e');
    }
  }

  /// Automatically prompts for review after a certain number of meaningful actions.
  static Future<void> checkAndPromptAutoReview() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(_reviewKey) ?? 0;
    count++;
    await prefs.setInt(_reviewKey, count);

    // Prompt after 10 meaningful actions (e.g., songs played, playlists created)
    if (count == 10 || count == 50 || count == 100) {
      if (await _inAppReview.isAvailable()) {
        // Use requestReview (which is non-guaranteed by OS) for auto-prompts
        await _inAppReview.requestReview();
      }
    }
  }
}
