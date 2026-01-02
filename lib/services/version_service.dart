import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/constants.dart';

class VersionService {
  // Remote URL hosting the version manifest
  static const String _configUrl = "http://al-khaliq.org/api/app/version";

  static Future<void> checkUpdate() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;

      final response = await http
          .get(Uri.parse(_configUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String latestVersion = data['latest_version'] ?? currentVersion;
        final bool isMandatory = data['mandatory'] ?? false;
        final String storeUrl = Platform.isAndroid
            ? (data['play_store_url'] ??
                "https://play.google.com/store/apps/details?id=com.al_khaliq.app")
            : (data['app_store_url'] ??
                "https://apps.apple.com/app/id6740645065");

        if (_isVersionLower(currentVersion, latestVersion)) {
          _showUpdateDialog(latestVersion, isMandatory, storeUrl);
        }
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
    }
  }

  static bool _isVersionLower(String current, String latest) {
    try {
      List<int> currentParts = current.split('.').map(int.parse).toList();
      List<int> latestParts = latest.split('.').map(int.parse).toList();

      for (int i = 0; i < latestParts.length; i++) {
        int currentPart = i < currentParts.length ? currentParts[i] : 0;
        if (latestParts[i] > currentPart) return true;
        if (latestParts[i] < currentPart) return false;
      }
    } catch (e) {
      return latest != current;
    }
    return false;
  }

  static void _showUpdateDialog(String version, bool isMandatory, String url) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => !isMandatory,
        child: AlertDialog(
          backgroundColor: const Color(0xFF191E31),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Update Available",
              style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold)),
          content: Text(
            "A new version ($version) of Al Khaliq is available. ${isMandatory ? 'This update is required to continue using the app.' : 'Would you like to update now?'}",
            style: const TextStyle(color: whiteColor),
          ),
          actions: [
            if (!isMandatory)
              TextButton(
                onPressed: () => Get.back(),
                child: Text("Later",
                    style: TextStyle(color: whiteColor.withOpacity(0.6))),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: lightBlueColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => _launchURL(url),
              child: const Text("Update Now",
                  style: TextStyle(
                      color: blackColor, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      barrierDismissible: !isMandatory,
    );
  }

  static Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
