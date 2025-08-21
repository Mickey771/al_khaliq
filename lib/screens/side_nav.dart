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
import 'package:al_khaliq/screens/web_view.dart';

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
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: whiteColor,
          ),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: whiteColor,
          ),
        ),
      ),
      body: Padding(
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
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 35.sp,
                      ),
                    ),
                    horizontalSpace(0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${userController.user['name'] ?? 'John Doe'}",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: whiteColor,
                          ),
                        ),
                        Text(
                          "View Profile",
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: lightBlueColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                verticalSpace(0.03),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: navOptions.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.to(() => WebViewPage(
                                title: "Privacy Policy",
                                url:
                                    "https://app.termly.io/policy-viewer/policy.html?policyUUID=7ddc89fa-948c-4c8c-a13d-64e0e51c5012"));
                            break;
                          case 1:
                            Get.to(() => WebViewPage(
                                title: "Terms & Conditions",
                                url:
                                    "https://url4140.termly.io/ls/click?upn=u001.DLyPg4GD5BzyE5FEzu8sZpbqVBN-2FAi97yuA5mWyg-2FwEcNdTnx2s2ZUYCLRCONL-2FVOhSo3JdfR5kDEOox10luHr6Q9zuTMpZ8fLVRO-2BAl9fDnfTNAwUcSY6kK2f1vf1DE5bBNbf5Y67KAyfIVU5hBQA-3D-3DNv7a_vTb4ulaCoZxef0WTOAW9Z-2FV2IK3Jn9u4ubvW0pTOReuzn-2FsnWa5JkfwMgIq6KyoxzN-2FSs74DchXxM72-2B4NsAhul1dPKQ6Ych2YK-2FDiRg5IslRqinqfF8XttT4Yf1nyKVEFCaeS1bjetD8wYcDH-2FL3bEpRYWw87AtS4JlAACBqutbyCeSWb2oIPCMMyoN08LSi-2F7tqJhT-2FboTvrfrnvDcl-2BkHXYRBYo44jCu7PBZEN8RODmWk-2F7zH5wjdy1HqDLqD-2FgoheQJ-2FdZf1gVo76av8Qs0zBZwBySJyhfJPrBf7T9Uzp-2BbLuDtu7VM-2F2cacTvEgcnQWTmiYX-2FJQn4fXGBwHmX-2FlT0nLBmpnuiiBNaLdhVTaW-2FDSKv5jJZbMs3j-2B7sF-2ByayCeOtfgRPmrI-2B7Lb7N-2F1ou1RIEV6eVz3ZTnWbhPxniVmKysj1zC5ImRlGddMID"));
                            break;
                          case 2:
                            // Implement rate app functionality
                            break;
                          case 3:
                            Get.to(() => WebViewPage(
                                  title: "Rate App",
                                  url:
                                      "https://play.google.com/store/apps/details?id=com.al_khaliq.app",
                                ));
                            break;
                          case 4:
                            Get.toNamed('/about');
                            break;
                          case 5:
                            Get.toNamed('/faqs');
                            break;
                          case 6:
                            Get.to(() => WebViewPage(
                                title: "Delete My Data",
                                url: "https:forms.gle/cKPv9mVpYdWeFWE88"));
                            break;
                        }
                      },
                      child: Column(
                        children: [
                          verticalSpace(0.005),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                navOptions[index],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: whiteColor,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: whiteColor,
                                size: 16.sp,
                              )
                            ],
                          ),
                          Divider(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) => const LogoutDialog());
              },
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
