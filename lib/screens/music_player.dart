import 'dart:async';
import 'dart:ui';

import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:al_khaliq/helpers/svg_icons.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:al_khaliq/controllers/music_controller.dart';
import 'package:al_khaliq/helpers/audio_player.dart';
import 'package:al_khaliq/helpers/back_button.dart';
import 'package:al_khaliq/helpers/constants.dart';
import 'package:al_khaliq/helpers/playlist_dialog_helper.dart';
import 'package:al_khaliq/main.dart';

class MusicPlayer extends StatefulWidget {
  final List<MediaItem>? songList;
  final List songs;
  final int? index;
  final bool? isFavorite;

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

  // State variables for playback feedback (though build uses isPlaying)
  Widget? statusIcon;
  String audioStatus = "";
  StreamSubscription<MediaItem?>? _mediaItemSubscription;

  @override
  void initState() {
    super.initState();
    _loadPlaylist();
    // Sync currentIndex when the song changes automatically
    _mediaItemSubscription = audioHandler.mediaItem.listen((item) {
      if (item != null && widget.songList != null) {
        final index = widget.songList!.indexWhere((e) => e.id == item.id);
        if (index != -1) {
          currentIndex.value = index;
        }
      }
    });
  }

  Future<void> _loadPlaylist() async {
    if (widget.songList == null || widget.songList!.isEmpty) {
      debugPrint("Error: songList is empty or null");
      return;
    }
    final startIndex = widget.index ?? 0;
    if (startIndex < 0 || startIndex >= widget.songList!.length) {
      debugPrint("Error: index $startIndex out of bounds");
      return;
    }

    try {
      final startIndex = widget.index ?? 0;
      final targetItem = widget.songList![startIndex];
      final currentItem = audioHandler.mediaItem.value;

      // Smart Load: If same song is already playing, just update local state and return
      if (currentItem?.id == targetItem.id &&
          audioHandler.playbackState.value.playing) {
        debugPrint(
            "✅ Song already playing, skipping re-initialization to avoid interruption.");
        currentIndex.value = startIndex;
        return;
      }

      // If we reach here, it's a new song or playback was stopped
      await audioHandler.stop();
      await audioHandler.updateQueue(widget.songList!);
      await audioHandler.loadAndPlay(targetItem);
      currentIndex.value = startIndex;

      // Track Recently Played
      if (widget.songs.isNotEmpty && startIndex < widget.songs.length) {
        final songId = widget.songs[startIndex]['id'];
        musicController.addRecentlyPlayed(userController.getToken(), songId);
      }
    } catch (e) {
      debugPrint("Error loading playlist: $e");
    }
  }

  @override
  void dispose() {
    _mediaItemSubscription?.cancel();
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
      decoration: const BoxDecoration(
        color: Color(0xFF10121F),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            // Decorative background elements
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
                        color: Color(0xFF220B56),
                      )
                    ],
                  ),
                )),
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
                    ],
                  ),
                )),
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
                        color: Color(0xFF47687D),
                      )
                    ],
                  ),
                )),

            // Main UI components
            Align(
              alignment: Alignment.topCenter,
              child: StreamBuilder<MediaItem?>(
                stream: audioHandler.mediaItem,
                builder: (context, snapshot) {
                  final item = snapshot.data;
                  if (item == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // Album Art Hero
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
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: whiteColor,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Player Controls Panel
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
                                  filter:
                                      ImageFilter.blur(sigmaX: 48, sigmaY: 48),
                                  child: Container(
                                    height: height() * 0.22,
                                    width: width(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.sp),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff23232333)
                                          .withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.circular(16.sp),
                                      border: Border.all(
                                          color: whiteColor.withOpacity(0.1),
                                          width: 1.sp),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Title and Artist
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: whiteColor
                                                    .withOpacity(0.05),
                                              ),
                                              padding: const EdgeInsets.all(20),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFF89CFF0),
                                                        Color(0xFF320D78),
                                                        Color(0xFF29164B),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      stops: [0, 0.65, 1]),
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: EdgeInsets.all(20.sp),
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
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                            text: item.artist,
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
                                                              FontWeight.w500,
                                                          fontSize: 11.sp),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Seek Bar
                                        audioSlider(context),

                                        // Playback Controls
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            StreamBuilder<Duration?>(
                                              stream: audioHandler
                                                  .player.positionStream,
                                              builder: (context, snapshot) {
                                                final duration = snapshot.data;
                                                return Text(
                                                  formatDuration(duration ??
                                                      Duration.zero),
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: whiteColor),
                                                );
                                              },
                                            ),
                                            Row(
                                              children: [
                                                Obx(
                                                  () => InkWell(
                                                    onTap: () => shuffle(),
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
                                                  child: const IconSVG(
                                                    assetPath:
                                                        'assets/images/icons/previous.svg',
                                                    color: Colors.white,
                                                    height: 22,
                                                    width: 22,
                                                  ),
                                                ),
                                                horizontalSpace(0.02),
                                                InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      if (!isPlaying) {
                                                        audioHandler.play();
                                                        audioStatus = "Playing";
                                                      } else {
                                                        audioHandler.pause();
                                                        audioStatus = "";
                                                      }
                                                    });
                                                  },
                                                  child: isPlaying
                                                      ? IconSVG(
                                                          assetPath:
                                                              'assets/images/icons/stop.svg',
                                                          color: Colors.white,
                                                          height: 22.sp,
                                                          width: 22.sp,
                                                        )
                                                      : IconSVG(
                                                          assetPath:
                                                              'assets/images/icons/play.svg',
                                                          color: Colors.white,
                                                          height: 22.sp,
                                                          width: 22.sp,
                                                        ),
                                                ),
                                                horizontalSpace(0.02),
                                                InkWell(
                                                  onTap: () =>
                                                      audioHandler.skipToNext(),
                                                  child: const IconSVG(
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
                                              builder: (context, snapshot) {
                                                final duration = snapshot.data;
                                                return Text(
                                                  formatDuration(duration ??
                                                      Duration.zero),
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: whiteColor),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Back Button
                      const Align(
                        alignment: Alignment.topLeft,
                        child: BackButtonWidget(),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Upcoming / Queue Section
            Positioned(
              top: height() * 0.48,
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.sp, 20.sp, 20.sp, 0.sp),
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
                            StreamBuilder<List<MediaItem>>(
                              stream: audioHandler.queue,
                              builder: (context, snapshot) {
                                final count = snapshot.data?.length ?? 0;
                                return Text(
                                  count.toString(),
                                  style: TextStyle(
                                    color: lightBlueColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 8.sp,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Obx(() {
                          final currentIdx = currentIndex.value;
                          if (widget.songs.isEmpty ||
                              currentIdx >= widget.songs.length) {
                            return const SizedBox.shrink();
                          }
                          return InkWell(
                            onTap: () {
                              final currentItem = audioHandler.mediaItem.value;
                              final songData = currentItem?.extras?['song'] ??
                                  (widget.songs.isNotEmpty &&
                                          currentIdx < widget.songs.length
                                      ? widget.songs[currentIdx]
                                      : null);

                              if (songData != null) {
                                showPlaylistSelectionDialog(context, songData);
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "Could not identify current song",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red.withOpacity(0.8),
                                  colorText: Colors.white,
                                );
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.sp),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.sp),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 29.2, sigmaY: 29.2),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14.sp,
                                              vertical: 9.sp),
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFFFFFFF)
                                                  .withOpacity(0.09),
                                              borderRadius:
                                                  BorderRadius.circular(12.sp),
                                              border: Border.all(
                                                  color: whiteColor
                                                      .withOpacity(0.1),
                                                  width: 1.sp)),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Add to Playlist',
                                                style: TextStyle(
                                                  color: lightBlueColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10.sp,
                                                ),
                                              ),
                                              horizontalSpace(0.03),
                                              const Icon(
                                                Icons.add,
                                                color: whiteColor,
                                                size: 18,
                                              )
                                            ],
                                          ),
                                        )))),
                          );
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<MediaItem>>(
                      stream: audioHandler.queue,
                      builder: (context, snapshot) {
                        final queue = snapshot.data ?? [];
                        return StreamBuilder<MediaItem?>(
                          stream: audioHandler.mediaItem,
                          builder: (context, mediaSnapshot) {
                            final currentItem = mediaSnapshot.data;
                            final upcoming = currentItem == null
                                ? queue
                                : queue
                                    .skipWhile(
                                        (item) => item.id != currentItem.id)
                                    .skip(1)
                                    .toList();

                            return ListView.builder(
                              padding: EdgeInsets.fromLTRB(
                                  20.sp, 10.sp, 20.sp, 20.sp),
                              itemCount: upcoming.length,
                              itemBuilder: (context, index) {
                                final songItem = upcoming[index];

                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 8.sp),
                                  padding: EdgeInsets.all(12.sp),
                                  decoration: BoxDecoration(
                                    color: whiteColor.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12.sp),
                                    border: Border.all(
                                        color: whiteColor.withOpacity(0.05)),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.sp),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              songItem.artUri?.toString() ?? '',
                                          height: 50.sp,
                                          width: 50.sp,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(color: Colors.white10),
                                        ),
                                      ),
                                      horizontalSpace(0.04),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              songItem.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            Text(
                                              songItem.artist ??
                                                  'Unknown Artist',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color:
                                                    whiteColor.withOpacity(0.6),
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.play_arrow,
                                            color: lightBlueColor),
                                        onPressed: () {
                                          audioHandler.skipToQueueItem(
                                              queue.indexOf(songItem));
                                          currentIndex.value =
                                              queue.indexOf(songItem);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
