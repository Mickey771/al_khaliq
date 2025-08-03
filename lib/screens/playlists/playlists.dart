
import 'dart:ui';

import 'package:al_khaliq/controllers/playlist_controller.dart';
import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:al_khaliq/screens/playlists/playlist_songs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../helpers/constants.dart';
import '../../helpers/music_widget.dart';
import '../../helpers/svg_icons.dart';
import '../search.dart';
import '../side_nav.dart';

class Playlists extends StatefulWidget {

  Playlists({super.key});

  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  PlaylistController playlistController = Get.find();
  UserController userController = Get.find();


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:  Color(0xFF10121f),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
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

            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.sp, 120.sp, 10.sp, 30.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    verticalSpace(0.01),

                    Text("Playlists",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: whiteColor
                      ),),

                    verticalSpace(0.02),


                    ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (_,__) => Divider(height: 50, thickness: 0.1, color: Colors.grey,),
                        shrinkWrap: true,
                        itemCount: playlistController.userPlayLists.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: (){
                            Get.to(() => PlaylistSongs(playlistId: playlistController.userPlayLists[index]['id'],playlistName: playlistController.userPlayLists[index]['name'],));
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(playlistController.userPlayLists[index]['name'],
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: whiteColor
                                        ),),
                                      verticalSpace(0.007),
                                      Text(playlistController.userPlayLists[index]['description'],
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                            color: lightBlueColor
                                        ),),
                                    ],
                                  ),

                                  Icon(Icons.arrow_forward_ios, color: lightBlueColor,)
                                ],
                              ),
                              Divider(height: 40.sp, color: whiteColor.withOpacity(0.4), thickness: 0.5,)
                            ],
                          ),
                        )
                    ),



                  ],
                ),
              ),
            ),


            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.sp, 60.sp, 16.sp, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: (){
                          Get.to(() => SideNav(), transition: Transition.leftToRight);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.sp),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 29.2, sigmaY: 29.2),
                            child: Container(
                              height: height() * 0.055,
                              padding: EdgeInsets.symmetric(horizontal: 10.sp),
                              decoration: BoxDecoration(
                                  color: whiteColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.sp),
                                  border: Border.all(color: whiteColor.withOpacity(0.09), width: 1.sp)
                              ),
                              child: IconSVG(assetPath: 'assets/images/icons/menu-icon.svg', color: whiteColor,),
                            ),
                          ),
                        ),
                      ),
                    ),
                    horizontalSpace(0.015),

                    Expanded(
                      flex: 12,
                      child: InkWell(
                        onTap: (){
                          Get.to(() => Search());
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.sp),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 39, sigmaY: 39),
                            child: Container(

                              height: height() * 0.055,
                              // width: width() * 0.75,
                              padding: EdgeInsets.symmetric(horizontal: 10.sp),
                              decoration: BoxDecoration(
                                  color: whiteColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.sp),
                                  border: Border.all(color: whiteColor.withOpacity(0.09), width: 1.sp)
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: whiteColor,),
                                  horizontalSpace(0.05),

                                  Text("Search here....",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: whiteColor
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

