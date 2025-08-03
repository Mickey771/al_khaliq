import 'dart:ui';
import 'package:al_khaliq/controllers/account_controller.dart';
import 'package:al_khaliq/controllers/music_controller.dart';
import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:al_khaliq/helpers/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'constants.dart';

class MusicDialog extends StatelessWidget {
   MusicDialog({this.favorite, this.favoriteList, super.key});

   Map? favorite;
   List? favoriteList;

   MusicController musicController = Get.find();
   AccountController accountController = Get.find();
   UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      // insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
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
                _buildMenuItem('close-circle', 'Remove'),
                Divider(color: whiteColor.withOpacity(0.1),),
                Obx(() => _buildMenuItem(musicController.favouriteMusics.where((e) => e['id'] == favorite!['id']).isNotEmpty ? 'heart-filled' : 'heart-outlined', musicController.favouriteMusics.where((e) => e['id'] == favorite!['id']).isNotEmpty ? 'Remove From Favorite' : 'Add To My Favorite',
                    onTap: (){
                  //
                      musicController.favouriteMusics.where((e) => e['id'] == favorite!['id']).isNotEmpty ?  musicController.removeFromFavourites(userController.getToken(), favorite!['id'])
                          : musicController.addFavourites(userController.getToken(), favorite!['id']);
                    }),),
                Divider(color: whiteColor.withOpacity(0.1),),
                _buildMenuItem('shuffle', 'Share'),
                Divider(color: whiteColor.withOpacity(0.1),),
                _buildMenuItem('download', 'Download'),
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
