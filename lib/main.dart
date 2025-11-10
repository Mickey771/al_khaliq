import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'helpers/audio_handler.dart';
import 'onboarding/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/paywall/paywall_screen.dart';
import 'controllers/subscription_controller.dart';
import 'onboarding/login.dart';
import 'controllers/account_controller.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'config/revenue_cat_config.dart';
import 'controllers/genre_controller.dart';
import 'controllers/music_controller.dart';
import 'screens/views.dart';

late MyAudioHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Configure RevenueCat with anonymous user
  await Purchases.configure(
      PurchasesConfiguration(RevenueCatConfig.apiKey)..appUserID = 'anonymous');
  debugPrint('RevenueCat configured in main');

  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.example.channel.audio',
      androidNotificationChannelName: 'Music Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );

  Get.put(UserController(), permanent: true);
  Get.put(AccountController(), permanent: true);
  Get.put(SubscriptionController(), permanent: true);
  Get.put(GenreController(), permanent: true); // <-- ADD THIS
  Get.put(MusicController(), permanent: true); // <-- AND THIS
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) => GetMaterialApp(
        // ❌ Remove initialBinding - controllers already initialized above
        debugShowCheckedModeBanner: false,
        title: 'Al Khaliq',
        transitionDuration: const Duration(milliseconds: 500),
        theme: ThemeData(fontFamily: 'Excon'),
        initialRoute: '/splash',
        getPages: [
          GetPage(name: '/splash', page: () => const SplashScreen()),
          GetPage(name: '/login', page: () => Login()),
          GetPage(name: '/home', page: () => Views()),
          GetPage(name: '/paywall', page: () => const CustomPaywall()),
        ],
      ),
    );
  }
}
