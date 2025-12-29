import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../helpers/constants.dart';
import '../../helpers/music_widget.dart';
import '../music_player.dart';

class GenreSongs extends StatelessWidget {
  final String? image;
  final List? songs;
  final String? name;
  const GenreSongs({super.key, this.image, this.name, this.songs});

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height() * 0.23,
                    width: width(),
                    child: Hero(
                      tag: image!,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.sp),
                        child: CachedNetworkImage(
                          imageUrl: image!,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: whiteColor,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  verticalSpace(0.015),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Hero(
                      tag: name!,
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          name!,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => Divider(
                              height: 50,
                              thickness: 0.1,
                              color: Colors.grey,
                            ),
                        shrinkWrap: true,
                        itemCount: songs!.length,
                        itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                List<MediaItem> mediaItems =
                                    songs!.map<MediaItem>((music) {
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
                                      songs: songs!,
                                    ));
                              },
                              child: MusicWidget(
                                favoriteList: songs,
                                favorite: songs![index],
                              ),
                            )),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 60.sp, left: 20.sp),
                child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: whiteColor,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
