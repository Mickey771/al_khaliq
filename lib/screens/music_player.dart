// import 'dart:math';
import 'dart:ui';

import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:al_khaliq/helpers/svg_icons.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../controllers/music_controller.dart';
import '../helpers/audio_player.dart';
import '../helpers/back_button.dart';
import '../helpers/constants.dart';
import '../main.dart';

class MusicPlayer extends StatefulWidget {
  final List<MediaItem>? songList;
  final List songs;
  final int? index;
  final bool? isFavorite;
  // Map? song;

  const MusicPlayer(
      {super.key,
      this.index,
      this.isFavorite,
      required this.songs,
      this.songList});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  RxInt currentIndex = 0.obs;

  RxBool isShuffleEnabled = false.obs;

  MusicController musicController = Get.find();
  UserController userController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPlaylist();
  }

  Future<void> _loadPlaylist() async {
    await audioHandler.stop(); // reset existing playback
    await audioHandler.updateQueue(widget.songList!); // pass the whole list
    await audioHandler
        .loadAndPlay(widget.songList![widget.index!]); // play starting song
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void shuffle() {
    final enable = !isShuffleEnabled.value;
    isShuffleEnabled.value = enable;
    if (enable) {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
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
            Align(
              alignment: Alignment.topCenter,
              child: StreamBuilder<MediaItem?>(
                stream: audioHandler.mediaItem,
                builder: (context, snapshot) {
                  final item = snapshot.data;
                  if (item == null) return const CircularProgressIndicator();
                  return Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: height() * 0.32,
                          width: width(),
                          child: Hero(
                            tag: item.artUri!.toString(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.sp),
                              child: CachedNetworkImage(
                                imageUrl: item.artUri!.toString(),
                                placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                  strokeWidth: 2.sp,
                                )),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: whiteColor,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height() * 0.24,
                        child: Container(
                          width: width() * 0.95,
                          margin: EdgeInsets.symmetric(horizontal: 16.sp),
                          child: StreamBuilder<PlaybackState>(
                              stream: audioHandler.playbackState,
                              builder: (context, snapshot) {
                                final state = snapshot.data;
                                final isPlaying = state?.playing ?? false;
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(16.sp),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 48, sigmaY: 48),
                                        child: Container(
                                          height: height() * 0.22,
                                          width: width(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.sp),
                                          decoration: BoxDecoration(
                                              color: Color(0xff23232333)
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(16.sp),
                                              border: Border.all(
                                                  color: whiteColor
                                                      .withOpacity(0.1),
                                                  width: 1.sp)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white
                                                          .withOpacity(0.05),
                                                    ),
                                                    padding: EdgeInsets.all(20),
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xFF89CFF0),
                                                                  Color(
                                                                      0xFF320D78),
                                                                  Color(
                                                                      0xFF29164B),
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                                stops: [
                                                                  0,
                                                                  0.65,
                                                                  1
                                                                ]),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(20.sp),
                                                      child: IconSVG(
                                                        assetPath:
                                                            'assets/images/icons/play.svg',
                                                        color: Colors.white,
                                                        height: 22.sp,
                                                        width: 22.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  horizontalSpace(0.05),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        item.title,
                                                        style: TextStyle(
                                                            color: whiteColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15.sp),
                                                      ),
                                                      verticalSpace(0.003),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: 'By - ',
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    item.artist,
                                                                style: TextStyle(
                                                                    color:
                                                                        lightBlueColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        11.sp))
                                                          ],
                                                          style: TextStyle(
                                                              color: whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 11.sp),
                                                        ),
                                                      ),
                                                      verticalSpace(0.01),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              audioSlider(context),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  StreamBuilder<Duration?>(
                                                    stream: audioHandler
                                                        .player.positionStream,
                                                    builder:
                                                        (context, snapshot) {
                                                      final duration =
                                                          snapshot.data;
                                                      if (duration == null) {
                                                        return Text("00:00",
                                                            style: TextStyle(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    whiteColor));
                                                      }
                                                      return Text(
                                                          formatDuration(
                                                              duration),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  whiteColor));
                                                    },
                                                  ),
                                                  Row(
                                                    children: [
                                                      Obx(
                                                        () => InkWell(
                                                          onTap: () =>
                                                              shuffle(),
                                                          child: IconSVG(
                                                            assetPath:
                                                                'assets/images/icons/shuffle.svg',
                                                            color: isShuffleEnabled
                                                                        .value ==
                                                                    true
                                                                ? lightBlueColor
                                                                : whiteColor,
                                                            height: 22.sp,
                                                            width: 22.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      horizontalSpace(0.07),
                                                      InkWell(
                                                        onTap: () => audioHandler
                                                            .skipToPrevious(),
                                                        child: IconSVG(
                                                          assetPath:
                                                              'assets/images/icons/previous.svg',
                                                          color: Colors.white,
                                                          height: 22.sp,
                                                          width: 22.sp,
                                                        ),
                                                      ),
                                                      horizontalSpace(0.02),
                                                      InkWell(
                                                        onTap: () async {
                                                          setState(() {
                                                            if (!isPlaying) {
                                                              audioHandler
                                                                  .play();
                                                              statusIcon = Pause(
                                                                  buttonColor:
                                                                      Color(
                                                                          0xFFDADADA));
                                                              audioStatus =
                                                                  "Playing";
                                                            } else {
                                                              audioHandler
                                                                  .pause();
                                                              audioStatus = "";
                                                              statusIcon = Play(
                                                                  buttonColor:
                                                                      Colors
                                                                          .teal);
                                                            }
                                                          });
                                                          // await controller.startPlayer(finishMode: FinishMode.stop);
                                                          // final duration = await controller.getDuration(DurationType.max);
                                                          // print(duration);
                                                        },
                                                        child: isPlaying
                                                            ? IconSVG(
                                                                assetPath:
                                                                    'assets/images/icons/stop.svg',
                                                                color: Colors
                                                                    .white,
                                                                height: 22.sp,
                                                                width: 22.sp,
                                                              )
                                                            : IconSVG(
                                                                assetPath:
                                                                    'assets/images/icons/play.svg',
                                                                color: Colors
                                                                    .white,
                                                                height: 22.sp,
                                                                width: 22.sp,
                                                              ),
                                                      ),
                                                      horizontalSpace(0.02),
                                                      InkWell(
                                                        onTap: () =>
                                                            audioHandler
                                                                .skipToNext(),
                                                        child: IconSVG(
                                                          assetPath:
                                                              'assets/images/icons/next.svg',
                                                          color: Colors.white,
                                                          height: 22,
                                                          width: 22,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  StreamBuilder<Duration?>(
                                                    stream: audioHandler
                                                        .player.durationStream,
                                                    builder:
                                                        (context, snapshot) {
                                                      final duration =
                                                          snapshot.data;
                                                      if (duration == null) {
                                                        return Text("00:00",
                                                            style: TextStyle(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    whiteColor));
                                                      }
                                                      return Text(
                                                          formatDuration(
                                                              duration),
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  whiteColor));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )));
                              }),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: BackButtonWidget(),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding:
                              EdgeInsets.fromLTRB(20.sp, 20.sp, 20.sp, 00.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Upcoming",
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22.sp,
                                    ),
                                  ),
                                  horizontalSpace(0.02),
                                  Text(
                                    "14,458",
                                    style: TextStyle(
                                      color: lightBlueColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 8.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Obx(
                                () => InkWell(
                                  onTap: () {
                                    musicController.favouriteMusics
                                            .where((e) =>
                                                e['id'] ==
                                                widget.songs[currentIndex.value]
                                                    ['id'])
                                            .isNotEmpty
                                        ? musicController.removeFromFavourites(
                                            userController.getToken(),
                                            widget.songs[currentIndex.value]
                                                ['id'])
                                        : musicController.addFavourites(
                                            userController.getToken(),
                                            widget.songs[currentIndex.value]
                                                ['id'],
                                            fromPage: true);
                                  },
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.sp),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.sp),
                                          child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 29.2, sigmaY: 29.2),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 14.sp,
                                                    vertical: 9.sp),
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFFFFFFF)
                                                        .withOpacity(0.09),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.sp),
                                                    border: Border.all(
                                                        color: whiteColor
                                                            .withOpacity(0.1),
                                                        width: 1.sp)),
                                                child: musicController
                                                        .favouriteMusics
                                                        .where((e) =>
                                                            e['id'] ==
                                                            widget.songs[
                                                                    currentIndex
                                                                        .value]
                                                                ['id'])
                                                        .isNotEmpty
                                                    ? Row(
                                                        children: [
                                                          Text(
                                                            'Remove from Playlist',
                                                            style: TextStyle(
                                                              color:
                                                                  lightBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 10.sp,
                                                            ),
                                                          ),
                                                          horizontalSpace(0.03),
                                                          Icon(
                                                            Icons.remove,
                                                            color: whiteColor,
                                                            size: 18,
                                                          )
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          Text(
                                                            'Add to Playlist',
                                                            style: TextStyle(
                                                              color:
                                                                  lightBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 10.sp,
                                                            ),
                                                          ),
                                                          horizontalSpace(0.03),
                                                          Icon(
                                                            Icons.add,
                                                            color: whiteColor,
                                                            size: 18,
                                                          )
                                                        ],
                                                      ),
                                              )))),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
