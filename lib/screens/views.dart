import 'dart:ui';

import 'package:al_khaliq/screens/favorites.dart';
import 'package:al_khaliq/screens/playlists/playlists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:al_khaliq/controllers/playlist_controller.dart';
import 'package:al_khaliq/helpers/mini_player.dart';
import 'package:al_khaliq/helpers/constants.dart';
import 'package:al_khaliq/helpers/svg_icons.dart';
import 'package:al_khaliq/screens/home.dart';
import 'package:al_khaliq/screens/notifications.dart';

TabController? tabNavigationController;
int selectedNavigationIndex = 0;

class Views extends StatefulWidget {
  const Views({super.key});

  @override
  State<Views> createState() => _ViewsState();
}

class _ViewsState extends State<Views> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<PlaylistController>()) {
      Get.put(PlaylistController(), permanent: true);
    }

    tabNavigationController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      tabNavigationController!.index = selectedNavigationIndex = index;
    });
  }

  List titles = [
    "Home",
    // "Library",
    "Favorites",
    "Playlists",
    "Notifications",
  ];

  List icons = [
    "home",
    "heart",
    'library',
    "notifications",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF10121f),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 70,
                left: -50,
                child: Container(
                  height: 300,
                  width: 300,
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 150,
                      spreadRadius: 0,
                      color: Color(0xFF220b56),
                      // color: Colors.red
                    )
                  ]),
                )),
            Positioned(
                top: 300,
                right: -80,
                child: Container(
                  height: 300,
                  width: 300,
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 170,
                      spreadRadius: 0,
                      color: Color(0xFF584171),
                    )
                  ]),
                )),
            Positioned(
                bottom: -50,
                right: 90,
                child: Container(
                  height: 300,
                  width: 300,
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 180,
                      spreadRadius: 0,
                      color: Color(0xFF47687d),
                    )
                  ]),
                )),
            TabBarView(
              physics: NeverScrollableScrollPhysics(),
              // swipe navigation handling is not supported
              controller: tabNavigationController,
              children: [
                Home(),
                // MusicPlayer(),
                Favorites(),
                Playlists(),
                Notifications(),
                // Discover(),
                // AddPhoto(),
                // Messages(),
                // MyProfile(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MiniPlayer(),
                  BottomNav(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget BottomNav() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.sp, 0, 16.sp, 16.sp),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(16.sp),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 39, sigmaY: 39),
              child: Container(
                height: height() * 0.075,
                // width: double.infinity, // Removed to fix 99774px overflow
                decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16.sp),
                    border: Border.all(
                        color: whiteColor.withValues(alpha: 0.9), width: 1.sp)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15.sp, 10.sp, 15.sp, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          splashColor: lightBlueColor,
                          highlightColor: lightBlueColor,
                          onTap: () => _onItemTapped(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconSVG(
                                assetPath:
                                    'assets/images/icons/${icons[0]}-${selectedNavigationIndex == 0 ? "filled" : 'outlined'}.svg',
                                color: whiteColor,
                              ),
                              verticalSpace(0.005),
                              Text(
                                titles[0],
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        InkWell(
                          splashColor: lightBlueColor,
                          highlightColor: lightBlueColor,
                          onTap: () => _onItemTapped(1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconSVG(
                                assetPath:
                                    'assets/images/icons/${icons[1]}-${selectedNavigationIndex == 1 ? "filled" : 'outlined'}.svg',
                                color: whiteColor,
                              ),
                              verticalSpace(0.005),
                              Text(
                                titles[1],
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        InkWell(
                          splashColor: lightBlueColor,
                          highlightColor: lightBlueColor,
                          onTap: () => _onItemTapped(2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconSVG(
                                assetPath:
                                    'assets/images/icons/${icons[2]}-${selectedNavigationIndex == 2 ? "filled" : 'outlined'}.svg',
                                color: whiteColor,
                              ),
                              verticalSpace(0.005),
                              Text(
                                titles[2],
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        InkWell(
                          splashColor: lightBlueColor,
                          highlightColor: lightBlueColor,
                          onTap: () => _onItemTapped(3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconSVG(
                                assetPath:
                                    'assets/images/icons/${icons[3]}-${selectedNavigationIndex == 3 ? "filled" : 'outlined'}.svg',
                                color: whiteColor,
                              ),
                              verticalSpace(0.005),
                              Text(
                                titles[3],
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // InkWell(
                        //   splashColor: lightBlueColor,
                        //   highlightColor: lightBlueColor,
                        //   onTap: () => _onItemTapped(3),
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       IconSVG(assetPath: 'assets/images/icons/${icons[4]}-${selectedNavigationIndex == 4 ? "filled" : 'outlined'}.svg', color: whiteColor,),
                        //       verticalSpace(0.005),
                        //       Text(titles[4],
                        //         style: TextStyle(
                        //           color: whiteColor,
                        //           fontWeight: FontWeight.w500,
                        //           fontSize: 10.sp,
                        //         ),),
                        //     ],
                        //   ),
                        // ),
                      ]),
                ),
              ))),
    );
  }
}
