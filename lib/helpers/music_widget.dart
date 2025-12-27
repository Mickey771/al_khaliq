import 'package:al_khaliq/helpers/svg_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/music_controller.dart';
import '../controllers/user_controller.dart';
import 'constants.dart';
import 'music_dialog.dart';

class MusicWidget extends StatelessWidget {
  MusicWidget({
    super.key,
    this.isFavorite,
    this.favorite,
    this.favoriteList,
  });

  final bool? isFavorite;
  final List? favoriteList;
  final Map? favorite;

  final MusicController musicController = Get.find();
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height() * 0.07,
              width: height() * 0.07,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.sp),
                child: CachedNetworkImage(
                  imageUrl: favorite!['image'],
                  memCacheWidth: (height() * 0.07 * 3)
                      .toInt(), // Cache properly sized image
                  placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: whiteColor,
                  )),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: whiteColor,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            horizontalSpace(0.05),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  favorite!['title'],
                  style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp),
                ),
                verticalSpace(0.003),
                RichText(
                  text: TextSpan(
                    text: 'By - ',
                    children: [
                      TextSpan(
                          text: favorite!['artist'],
                          style: TextStyle(
                              color: lightBlueColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp))
                    ],
                    style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp),
                  ),
                )
              ],
            )
          ],
        ),
        InkWell(
          onTap: () {
            isFavorite == true
                ? musicController.removeFromFavourites(
                    userController.getToken(), favorite!['id'])
                : showDialog(
                    context: context,
                    builder: (context) => MusicDialog(
                      favorite: favorite,
                      favoriteList: favoriteList,
                    ),
                  );
          },
          child: isFavorite == true
              ? IconSVG(assetPath: 'assets/images/icons/heart-filled.svg')
              : Icon(
                  Icons.more_vert,
                  color: whiteColor,
                ),
        )
      ],
    );
  }
}

musicWidgetLoader() {
  return ListView.separated(
    itemCount: 3,
    padding: EdgeInsets.zero,
    physics: NeverScrollableScrollPhysics(),
    separatorBuilder: (_, __) => Divider(
      height: 50,
      thickness: 0.1,
      color: Colors.grey,
    ),
    shrinkWrap: true,
    itemBuilder: (context, index) => Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.2),
        highlightColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: height() * 0.07,
                  width: height() * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                ),
                horizontalSpace(0.05),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    verticalSpace(0.005),
                    Container(
                      height: height() * 0.015,
                      width: height() * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                    ),
                    verticalSpace(0.01),
                    Container(
                      height: height() * 0.01,
                      width: height() * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.more_vert,
              color: whiteColor,
            )
          ],
        ),
      ),
    ),
  );
}
