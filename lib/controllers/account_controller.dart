import 'package:al_khaliq/controllers/genre_controller.dart';
import 'package:al_khaliq/controllers/music_controller.dart';
import 'package:al_khaliq/controllers/playlist_controller.dart';
import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:al_khaliq/controllers/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../onboarding/login.dart';
// import '../screens/views.dart';
import '../services/account_services.dart';
import '../services/firebase_auth_service.dart';
import '../services/revenue_cat_service.dart';

class AccountController extends GetxController {
  TextEditingController get firstName => _firstName;
  final TextEditingController _firstName = TextEditingController();

  TextEditingController get lastName => _lastName;
  final TextEditingController _lastName = TextEditingController();

  TextEditingController get email => _email;
  final TextEditingController _email = TextEditingController();

  TextEditingController get password => _password;
  final TextEditingController _password = TextEditingController();

  RxBool loadingStatus = false.obs;

  // Helper method to get or create controllers safely
  T _getOrPutController<T extends GetxController>(T Function() builder) {
    if (Get.isRegistered<T>()) {
      return Get.find<T>();
    }
    return Get.put(builder());
  }

  Future<void> signInWithGoogle({context}) async {
    try {
      loadingStatus.value = true;

      final result = await FirebaseAuthService.signInWithGoogle();
      if (result != null) {
        // Try to login first
        AccountServices.loginUser((status, response) async {
          if (status) {
            // User exists, proceed normally
            if (response != null &&
                response['token'] != null &&
                response['user'] != null &&
                response['user']['id'] != null) {
              await setUser(context, response['token'],
                  uid: response['user']['id'].toString());
            } else {
              loadingStatus.value = false;
              _handleError('Invalid response from server');
            }
          } else {
            // User doesn't exist, register them
            AccountServices.registerUser((regStatus, regResponse) async {
              if (regStatus) {
                // Now login
                AccountServices.loginUser((loginStatus, loginResponse) async {
                  if (loginStatus) {
                    if (loginResponse != null &&
                        loginResponse['token'] != null &&
                        loginResponse['user'] != null &&
                        loginResponse['user']['id'] != null) {
                      await setUser(context, loginResponse['token'],
                          uid: loginResponse['user']['id'].toString());
                    } else {
                      loadingStatus.value = false;
                      _handleError('Invalid response from server');
                    }
                  } else {
                    loadingStatus.value = false;
                    _handleError('Login after registration failed');
                  }
                },
                    email: result['email'],
                    password: 'social_login_${result['uid']}');
              } else {
                loadingStatus.value = false;
                _handleError('Registration failed');
              }
            },
                email: result['email'],
                name: result['name'],
                password: 'social_login_${result['uid']}');
          }
        }, email: result['email'], password: 'social_login_${result['uid']}');
      } else {
        loadingStatus.value = false;
      }
    } catch (e) {
      loadingStatus.value = false;
      _handleError('Google sign in failed: ${e.toString()}');
    }
  }

  signInWithApple({context}) async {
    try {
      loadingStatus.value = true;

      final result = await FirebaseAuthService.signInWithApple();
      debugPrint('🍎 AccountController: Result from Apple Sign In: $result');

      if (result != null) {
        if (result['email'] == null) {
          loadingStatus.value = false;
          _handleError(
              'Could not retrieve email. Please go to iOS Settings -> Apple ID -> Password & Security -> Apps Using Apple ID -> [App Name] -> Stop Using Apple ID, then try again.');
          return;
        }

        AccountServices.loginUser((status, response) async {
          if (status) {
            if (response != null &&
                response['token'] != null &&
                response['user'] != null &&
                response['user']['id'] != null) {
              await setUser(context, response['token'],
                  uid: response['user']['id'].toString());
            } else {
              loadingStatus.value = false;
              _handleError('Invalid response from server');
            }
          } else {
            // Login failed, try to register
            debugPrint('🍎 Login failed, attempting registration...');

            // Ensure we have a name
            String nameToUse = result['name'];
            if (nameToUse.trim().isEmpty) {
              nameToUse = "Apple User"; // Fallback name
              debugPrint('🍎 Name was empty, using fallback: $nameToUse');
            }

            AccountServices.registerUser((regStatus, regResponse) async {
              debugPrint('🍎 Registration Status: $regStatus');
              debugPrint('🍎 Registration Response: $regResponse');

              if (regStatus) {
                AccountServices.loginUser((loginStatus, loginResponse) async {
                  if (loginStatus) {
                    if (loginResponse != null &&
                        loginResponse['token'] != null &&
                        loginResponse['user'] != null &&
                        loginResponse['user']['id'] != null) {
                      await setUser(context, loginResponse['token'],
                          uid: loginResponse['user']['id'].toString());
                    } else {
                      loadingStatus.value = false;
                      _handleError('Invalid response from server');
                    }
                  } else {
                    loadingStatus.value = false;
                    _handleError('Login after registration failed');
                  }
                },
                    email: result['email'],
                    password: 'social_login_${result['uid']}');
              } else {
                loadingStatus.value = false;
                _handleError('Registration failed: $regResponse');
              }
            },
                email: result['email'],
                name: nameToUse,
                password: 'social_login_${result['uid']}');
          }
        }, email: result['email'], password: 'social_login_${result['uid']}');
      } else {
        loadingStatus.value = false;
      }
    } catch (e) {
      loadingStatus.value = false;
      _handleError('Apple sign in failed: ${e.toString()}');
    }
  }

  signOut([token]) async {
    try {
      loadingStatus.value = true;

      // Sign out from Firebase
      await FirebaseAuthService.signOut();

      // Clear SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Delete controllers in correct order
      // Don't delete AccountController or SubscriptionController as they're permanent
      if (Get.isRegistered<PlaylistController>()) {
        Get.delete<PlaylistController>(force: true);
      }
      if (Get.isRegistered<MusicController>()) {
        Get.delete<MusicController>(force: true);
      }
      if (Get.isRegistered<GenreController>()) {
        Get.delete<GenreController>(force: true);
      }
      if (Get.isRegistered<UserController>()) {
        Get.delete<UserController>(force: true);
      }

      loadingStatus.value = false;

      // Clear text fields
      _firstName.clear();
      _lastName.clear();
      _email.clear();
      _password.clear();

      Get.offAll(() => Login());
    } catch (e) {
      loadingStatus.value = false;
      debugPrint('Sign out error: ${e.toString()}');
      Get.offAll(() => Login());
    }
  }

  signUp({context}) async {
    try {
      // Validate inputs
      if (_firstName.text.isEmpty ||
          _email.text.isEmpty ||
          _password.text.isEmpty) {
        _handleError('All fields are required');
        return;
      }

      loadingStatus.value = true;
      AccountServices.registerUser(
        (status, response) {
          debugPrint('==> $response');
          if (status) {
            loadingStatus.value = false;
            signIn(context: context);
          } else {
            loadingStatus.value = false;
            _handleError(response);
          }
        },
        email: _email.text,
        password: _password.text,
        name: _firstName.text,
      );
    } catch (e) {
      loadingStatus.value = false;
      _handleError('Sign up failed: ${e.toString()}');
    }
  }

  signIn({context}) async {
    try {
      loadingStatus.value = true;
      AccountServices.loginUser((status, response) async {
        if (status) {
          // Validate response data
          if (response != null &&
              response['token'] != null &&
              response['user'] != null &&
              response['user']['id'] != null) {
            await setUser(context, response['token'],
                uid: response['user']['id'].toString());
          } else {
            loadingStatus.value = false;
            _handleError('Invalid response from server');
          }
        } else {
          loadingStatus.value = false;
          _handleError(response ?? 'Login failed');
        }
      }, email: _email.text, password: _password.text);
    } catch (e) {
      loadingStatus.value = false;
      _handleError('Login failed: ${e.toString()}');
    }
  }

  setUser(context, token,
      {uid, isFirst = false, bool shouldNavigate = true}) async {
    try {
      if (token == null || token.isEmpty) throw Exception('Invalid token');
      if (uid == null || uid.isEmpty) throw Exception('Invalid user ID');

      var userController = _getOrPutController(() => UserController());
      var genreController = _getOrPutController(() => GenreController());
      var musicController = _getOrPutController(() => MusicController());
      var playlistController = _getOrPutController(() => PlaylistController());

      debugPrint("================");
      debugPrint('Setting user with token: $token');
      debugPrint('User ID: $uid');

      userController.setToken(token);

      /// >>> RevenueCat integration added here <<<
      await RevenueCatService().updateUserId(uid);
      final subController = Get.find<SubscriptionController>();
      await subController.checkSubscription();

      /// >>> end addition <<<

      await userController.getUser(token, uid);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('uid', uid);
      genreController.getGenres(token);
      musicController.getAllSongs(token);
      musicController.getNewReleases(token);
      musicController.getFavourites(token);
      playlistController.getUserPlaylists(token, uid);

      loadingStatus.value = false;

      // NAVIGATION HANDLING HERE
      if (shouldNavigate) {
        if (subController.hasSubscription.value) {
          Get.offAllNamed('/home');
        } else {
          Get.offAllNamed('/paywall');
        }
      }
    } catch (e) {
      loadingStatus.value = false;
      _handleError('Setup failed: ${e.toString()}');
    }
  }

  void _handleError(dynamic error) {
    debugPrint('Error: $error');

    // Extract meaningful error message
    String errorMessage = 'An error occurred';

    if (error != null) {
      if (error is String) {
        errorMessage = error;
      } else if (error is Map && error.containsKey('message')) {
        errorMessage = error['message'].toString();
      } else if (error is Map && error.containsKey('error')) {
        errorMessage = error['error'].toString();
      } else {
        errorMessage = error.toString();
      }
    }

    // Show user-friendly snackbar
    Get.snackbar(
      'Error',
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
    );
  }

  @override
  void onClose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.onClose();
  }
}
