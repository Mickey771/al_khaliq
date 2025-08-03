import 'dart:ui';

import 'package:al_khaliq/controllers/genre_controller.dart';
import 'package:al_khaliq/controllers/music_controller.dart';
import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:al_khaliq/screens/music_player.dart';
import 'package:al_khaliq/screens/search.dart';
import 'package:al_khaliq/screens/side_nav.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../helpers/constants.dart';
import '../helpers/music_widget.dart';
import '../helpers/subheading.dart';
import '../helpers/svg_icons.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {



  GenreController genreController = Get.find();
  MusicController musicController = Get.find();
  UserController userController = Get.find();


  @override
  void initState() {
    // TODO: implement initState
    // loadApp();
    super.initState();
  }

  RxBool visible = false.obs;


  // loadApp() async {
  //   Timer(
  //       const Duration(seconds: 2),
  //           () =>  _firebaseMethods.signInAnonymously()
  //   );
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [


          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 100.sp, 10.sp, 30.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [



                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                      verticalSpace(0.035),

                      SubHeading(
                        subtitle: "My Favourites",
                        seeAllFunc: (){},
                      ),


                      Obx(() => ListView.separated(
                          padding: EdgeInsets.only(top: 5.sp),
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (_,__) => Divider(height: 50, thickness: 0.1, color: Colors.grey,),
                          shrinkWrap: true,
                          itemCount: musicController.favouriteMusics.length > 5 ? 5 : musicController.favouriteMusics.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: (){
                              List<MediaItem> mediaItems = musicController.favouriteMusics.map<MediaItem>((music) {
                                return MediaItem(
                                  id: music['file'],
                                  title: music['title'] ?? "",
                                  artist: music['artist'] ?? 'Unknown Artist',
                                  displayTitle: music['title'] ?? "",
                                  album: music['album'] ?? 'Unknown Album',
                                  artUri: Uri.parse(music['image'] ?? ""),
                                );
                              }).toList();


                              Get.to(() => MusicPlayer(
                                index: index,
                                songList: mediaItems,
                                songs: musicController.favouriteMusics,
                              ));
                            },
                            child: MusicWidget(
                              isFavorite: true,
                              favoriteList: musicController.favouriteMusics,
                              favorite: musicController.favouriteMusics[index],
                            ),
                          )
                      ),),





                      verticalSpace(0.1),

                    ],
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
                                const Icon(Icons.search, color: whiteColor,),
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
    );
  }
}
