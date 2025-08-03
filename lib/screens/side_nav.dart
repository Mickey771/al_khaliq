import 'package:al_khaliq/controllers/account_controller.dart';
import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:al_khaliq/helpers/constants.dart';
import 'package:al_khaliq/helpers/logout_dialog.dart';
import 'package:al_khaliq/onboarding/auth_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';


class SideNav extends StatelessWidget {
   SideNav({super.key});

  List navOptions = [
    "Privacy Policy",
    "Terms & Conditions",
    "Rate App",
    "Get help",
    "About",
    "FAQs",
    "Delete My Data"
  ];


  UserController userController = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF191E31),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF191E31),
        leading: InkWell(
          onTap: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_new, color: whiteColor,),
        ),
        title:  Text("Settings",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: whiteColor,
          ),),
      ),
      body:  Padding(
        padding: EdgeInsets.fromLTRB(16.sp, 25.sp, 16.sp, 40.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                children: [

                 Row(
                   children: [
                     Container(
                       padding: EdgeInsets.all(15.sp),
                       decoration: BoxDecoration(
                         color: Colors.grey,
                         shape: BoxShape.circle,
                       ),
                       child: Icon(Icons.person, color: Colors.white, size: 35.sp,),
                     ),
                     horizontalSpace(0.05),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("${userController.user['name'] ?? 'John Doe'}",
                       style: TextStyle(
                         fontSize: 13.sp,
                         fontWeight: FontWeight.w700,
                         color: whiteColor,
                       ),),
                         Text("View Profile",
                         style: TextStyle(
                           fontSize: 11.sp,
                           fontWeight: FontWeight.w500,
                           color: lightBlueColor,
                         ),),
                       ],
                     )
                   ],
                 ),
                  verticalSpace(0.03),

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: navOptions.length,
                      itemBuilder: (context, index) =>  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            verticalSpace(0.005),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(navOptions[index],
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor,
                                  ),),

                                Icon(Icons.arrow_forward_ios, color: whiteColor, size: 16.sp,)
                              ],
                            ),
                            Divider(height: 20,)
                          ],
                        ),
                      ),
                  ),

                ],
              ),


            InkWell(
              onTap: () async{
                showDialog(
                    context: context,
                    builder: (context) => const LogoutDialog());
              },
              child: Text("Logout",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: whiteColor,
                ),),
            ),
          ],
        ),
      ),
    );
  }
}
