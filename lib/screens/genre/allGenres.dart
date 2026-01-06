import 'dart:ui';
import 'package:al_khaliq/controllers/genre_controller.dart';
import 'package:al_khaliq/controllers/music_controller.dart';
import 'package:al_khaliq/screens/genre/genreSongs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../helpers/constants.dart';
import '../../controllers/account_controller.dart';

class AllGenres extends StatelessWidget {
  const AllGenres({super.key});

  @override
  Widget build(BuildContext context) {
    final GenreController genreController = Get.find();
    final MusicController musicController = Get.find();
    final AccountController accountController = Get.find();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF10121f),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Background decor
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
                    )
                  ]),
                )),
            // Content
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.sp, 110.sp, 20.sp, 20.sp),
                    child: Text(
                      "All Genres",
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2),
                    ),
                  ),
                ),
                Obx(() => SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20.sp,
                          mainAxisSpacing: 20.sp,
                          childAspectRatio: 0.85,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final genre = genreController.genres[index];
                            return InkWell(
                              onTap: () async {
                                if (musicController.allSongs.isEmpty) {
                                  await musicController
                                      .getAllSongs(accountController.token);
                                }
                                Get.to(() => GenreSongs(
                                      image: genre['image'],
                                      songs: musicController.allSongs
                                          .where(((item) =>
                                              item['genre_id'] == genre['id']))
                                          .toList(),
                                      name: genre['name'],
                                    ));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Hero(
                                      tag: genre['image'],
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.sp),
                                        child: CachedNetworkImage(
                                          imageUrl: genre['image'],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: whiteColor.withOpacity(0.05),
                                            child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 1,
                                                        color: whiteColor)),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.music_note,
                                                  color: whiteColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                  verticalSpace(0.01),
                                  Text(
                                    genre['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: genreController.genres.length,
                        ),
                      ),
                    )),
                SliverToBoxAdapter(child: verticalSpace(0.1)),
              ],
            ),
            // Back Button
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.sp, 60.sp, 16.sp, 0),
                child: InkWell(
                  onTap: () => Get.back(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.sp),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                            color: whiteColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.sp),
                            border: Border.all(
                                color: whiteColor.withOpacity(0.1), width: 1)),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: whiteColor, size: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
