import 'dart:async';
import 'dart:ui';

import 'package:al_khaliq/screens/views.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/account_controller.dart';
import '../helpers/audio_handler.dart';
import '../helpers/constants.dart';
import '../main.dart';
import 'auth_board.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    loadApp();
    super.initState();

    // Future.delayed(Duration(seconds: 4), () async{
    //   audioHandler = await AudioService.init(
    //     builder: () => MyAudioHandler(),
    //     config: AudioServiceConfig(
    //       androidNotificationChannelId: 'com.example.channel.audio',
    //       androidNotificationChannelName: 'Music Playback',
    //       androidNotificationOngoing: true,
    //       androidStopForegroundOnPause: false,
    //     ),
    //   );
    // });
  }

  loadApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var uid = prefs.getString('uid');
    var refreshToken = prefs.getString('refreshToken');
    AccountController accountController = Get.put(AccountController());
    // Get.off(() => Login());
    Timer(
        const Duration(milliseconds: 2000),
            () => token == null || token.isEmpty
            ? Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AuthBoard()))
            :  accountController.setUser(context, token, uid: uid)
            // :  accountController.refreshToken(refreshToken,fetchUser : true)
    );
  }
  // loadApp() async {
  //   AccountController accountController = Get.put(AccountController());
  //   Timer(
  //       const Duration(seconds: 2),
  //           () =>  Get.to(() => AuthBoard())
  //   );
  // }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:  Color(0xFF10121f),

        // gradient: LinearGradient(
        //     colors: gradientColors,
        //   begin: Alignment (0, 0),
        //   end: Alignment (1, 1),
        //     stops: [0, 0.2, 0.5, 0.8, 1],
        // )
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
              top: 70,
              left: -50,
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 150,
                        spreadRadius: 0,
                        color: Color(0xFF220b56),
                        // color: Colors.red
                      )
                    ]
                ),
              )
          ),

          Positioned(
              top: 300,
              right: -80,
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 170,
                        spreadRadius: 0,
                        color: Color(0xFF584171),
                      )
                    ]
                ),
              )
          ),

          Positioned(
              bottom: -50,
              right: 90,
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 180,
                        spreadRadius: 0,
                        color: Color(0xFF47687d),
                      )
                    ]
                ),
              )
          ),

          Container(
            color: Color(0xFF191E31).withOpacity(0.284),
          ),


          Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                  child: Image.asset('assets/images/assetImages/AppLogo.png', fit: BoxFit.cover, scale: 4,))
          ),

        ],
      ),
    );
  }
}
