import 'dart:ui';
import 'package:al_khaliq/controllers/account_controller.dart';
import 'package:al_khaliq/controllers/music_controller.dart';
import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:al_khaliq/helpers/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../onboarding/auth_board.dart';
import 'constants.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});



  // MusicController musicController = Get.find();
  // AccountController accountController = Get.find();
  // UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      // insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.sp),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.all(20.sp),
            width: width() * 0.5,
            decoration: BoxDecoration(
              color: Color(0xFF675a75).withOpacity(0.60),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            // padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text("Are you sure you want to log out?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: whiteColor,
                  fontWeight: FontWeight.w600
                ),),

                verticalSpace(0.03),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        onTap: (){
                          Get.back;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 9.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.sp),
                            border: Border.all(color: whiteColor, width: 0.5.sp),
                          ),
                          child: Center(
                            child: Text("Cancel",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              color: whiteColor
                            ),),
                          ),
                        ),
                      ),
                    ),

                    horizontalSpace(0.05),

                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          Get.offAll(() => AuthBoard());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 9.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.sp),
                            color: Colors.red,
                            border: Border.all(color: whiteColor, width: 0.5.sp),
                          ),
                          child: Center(
                            child: Text("Yes, Log Out",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  color: whiteColor
                              ),),
                          ),
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(icon, String label, {onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
        child: Row(
          children: [
            IconSVG(assetPath: 'assets/images/icons/$icon.svg', color: whiteColor),
            SizedBox(width: 10.sp),
            Text(
              label,
              style:  TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
