import 'dart:ui';

import 'package:al_khaliq/controllers/playlist_controller.dart';
import 'package:al_khaliq/helpers/playlist_collage.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:al_khaliq/helpers/constants.dart';
import 'package:al_khaliq/helpers/music_widget.dart';
import 'package:al_khaliq/screens/music_player.dart';

class PlaylistSongs extends StatefulWidget {
  final int? playlistId;
  final String? playlistName;

  const PlaylistSongs({super.key, this.playlistId, this.playlistName});

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  int? playlistId;

  PlaylistController playlistController = Get.find();
  UserController userController = Get.find();

  RxInt playedIndex = 0.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playlistController.getPlaylistSongs(
        userController.getToken(), widget.playlistId!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF10121f),
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

            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.sp, 110.sp, 10.sp, 30.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Premium Header
                    Obx(() {
                      // 🚀 Get songs from the multi-playlist cache
                      final songs =
                          playlistController.songsCache[widget.playlistId] ??
                              [];
                      final isLoading = playlistController.loadingStatus.value;

                      return Center(
                        child: Column(
                          children: [
                            PlaylistCollage(
                              songs: songs,
                              size: 180.sp,
                              borderRadius: 16,
                            ),
                            verticalSpace(0.02),
                            Text(
                              widget.playlistName!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: whiteColor,
                                  letterSpacing: 1),
                            ),
                            verticalSpace(0.005),
                            isLoading && songs.isEmpty
                                ? Text(
                                    "Loading count...",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: lightBlueColor.withOpacity(0.5)),
                                  )
                                : Text(
                                    "${songs.length} ${songs.length == 1 ? 'song' : 'songs'}",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: lightBlueColor.withOpacity(0.7)),
                                  ),
                          ],
                        ),
                      );
                    }),
                    verticalSpace(0.03),
                    Obx(
                      () {
                        final songs =
                            playlistController.songsCache[widget.playlistId] ??
                                [];
                        final isLoading =
                            playlistController.loadingStatus.value;

                        if (isLoading && songs.isEmpty) {
                          return musicWidgetLoader();
                        }
                        if (songs.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(top: 50.sp),
                            child: Center(
                              child: Text(
                                "No songs in this playlist yet",
                                style: TextStyle(
                                    color: whiteColor.withOpacity(0.5),
                                    fontSize: 14.sp),
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: songs.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              List<MediaItem> mediaItems =
                                  songs.map<MediaItem>((music) {
                                return MediaItem(
                                  id: music['file'],
                                  title: music['title'] ?? "",
                                  artist: music['artist'] ?? 'Unknown Artist',
                                  displayTitle: music['title'] ?? "",
                                  album: music['album'] ?? 'Unknown Album',
                                  artUri: Uri.parse(music['image'] ?? ""),
                                  extras: {'song': music},
                                );
                              }).toList();

                              Get.to(() => MusicPlayer(
                                    index: index,
                                    songList: mediaItems,
                                    songs: songs,
                                  ));
                            },
                            child: MusicWidget(
                              favorite: songs[index],
                              favoriteList: songs,
                              playlistId: widget.playlistId,
                            ),
                          ),
                          separatorBuilder: (_, __) => Divider(
                            height: 40.sp,
                            thickness: 0.1,
                            color: Colors.white10,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.sp, 60.sp, 16.sp, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.sp),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 29.2, sigmaY: 29.2),
                          child: Container(
                            height: height() * 0.055,
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            decoration: BoxDecoration(
                                color: whiteColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.sp),
                                border: Border.all(
                                    color: whiteColor.withValues(alpha: 0.9),
                                    width: 1.sp)),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Obx(() => Padding(
            //     padding: EdgeInsets.fromLTRB(16.sp, 0.sp, 16.sp, 30.sp),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         InkWell(
            //           onTap: (){
            //             Get.back();
            //           },
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(12.sp),
            //             child: BackdropFilter(
            //               filter: ImageFilter.blur(sigmaX: 29.2, sigmaY: 29.2),
            //               child: Container(
            //                 height: height() * 0.065,
            //                 decoration: BoxDecoration(
            //                     color: blackColor.withOpacity(0.5),
            //                     borderRadius: BorderRadius.circular(12.sp),
            //                     border: Border.all(color: whiteColor.withOpacity(0.09), width: 1.sp)
            //                 ),
            //                 child: Row(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     SizedBox(
            //                       height: height() * 0.065,
            //                       width: height() * 0.065,
            //                       child: ClipRRect(
            //                         borderRadius: BorderRadius.circular(8.sp),
            //                         child: CachedNetworkImage(
            //                           imageUrl: playlistController.playlistSongs[playedIndex.value]['image'],
            //                           placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 1, color: whiteColor,)),
            //                           errorWidget: (context, url, error) => Icon(Icons.error, color: whiteColor,),
            //                           fit: BoxFit.cover,
            //                         ),
            //                       ),
            //                     ),
            //                     horizontalSpace(0.05),
            //                     Column(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text( playlistController.playlistSongs[playedIndex.value]['title'],
            //                           style: TextStyle(
            //                               color: whiteColor,
            //                               fontWeight: FontWeight.w600,
            //                               fontSize: 13.sp
            //                           ),),
            //                         verticalSpace(0.003),
            //                         Text(playlistController.playlistSongs[playedIndex.value]['artist'],
            //                             style: TextStyle(
            //                                 color: whiteColor,
            //                                 fontWeight: FontWeight.w500,
            //                                 fontSize: 11.sp
            //                             )
            //                         )
            //                       ],
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //
            //       ],
            //     ),
            //   ),)
            // ),
          ],
        ),
      ),
    );
  }
}
