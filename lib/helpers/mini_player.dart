import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:al_khaliq/main.dart';
import 'package:al_khaliq/screens/music_player.dart';
import 'package:al_khaliq/helpers/constants.dart';
import 'package:al_khaliq/helpers/svg_icons.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final item = snapshot.data;
        if (item == null) return const SizedBox.shrink();

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
          child: GestureDetector(
            onTap: () {
              final queue = audioHandler.queue.value;
              final index = audioHandler.playbackState.value.queueIndex;
              if (queue.isNotEmpty &&
                  index != null &&
                  index >= 0 &&
                  index < queue.length) {
                Get.to(() => MusicPlayer(
                      songs: queue
                          .map((m) => m.extras?['song'] as Map? ?? {})
                          .toList(),
                      songList: queue,
                      index: index,
                    ));
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.sp),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  height: 64.sp,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16.sp),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1.sp,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Artwork
                      Container(
                        width: 48.sp,
                        height: 48.sp,
                        margin: EdgeInsets.all(8.sp),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.sp),
                          child: CachedNetworkImage(
                            imageUrl: item.artUri?.toString() ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: Colors.grey[900]),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.music_note),
                          ),
                        ),
                      ),
                      // Title & Artist
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              item.artist ?? 'Unknown Artist',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: lightBlueColor,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Play/Pause Button
                      StreamBuilder<PlaybackState>(
                        stream: audioHandler.playbackState,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          final isPlaying = state?.playing ?? false;
                          return IconButton(
                            icon: IconSVG(
                              assetPath: isPlaying
                                  ? 'assets/images/icons/stop.svg'
                                  : 'assets/images/icons/play.svg',
                              color: Colors.white,
                              height: 24.sp,
                              width: 24.sp,
                            ),
                            onPressed: () {
                              if (isPlaying) {
                                audioHandler.pause();
                              } else {
                                audioHandler.play();
                              }
                            },
                          );
                        },
                      ),
                      // Next Button
                      IconButton(
                        icon: IconSVG(
                          assetPath: 'assets/images/icons/next.svg',
                          color: Colors.white,
                          height: 24.sp,
                          width: 24.sp,
                        ),
                        onPressed: () => audioHandler.skipToNext(),
                      ),
                      SizedBox(width: 8.sp),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
