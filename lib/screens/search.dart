import 'dart:async';
import 'dart:ui';

import 'package:al_khaliq/controllers/genre_controller.dart';
import 'package:al_khaliq/controllers/music_controller.dart';
import 'package:al_khaliq/screens/music_player.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../helpers/constants.dart';
import '../controllers/account_controller.dart';
import '../helpers/music_widget.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {



  AccountController accountController = Get.find();
  GenreController genreController = Get.find();
  MusicController musicController = Get.find();

  RxBool visible = false.obs;

  RxList songs = [].obs;


  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    // TODO: implement initState
    // loadApp();
    super.initState();
    songs = musicController.allSongs;
  }


  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.toLowerCase();
      if(_searchController.text.isNotEmpty){
          musicController.filteredSongs.value = songs
              .where((music) => music['title'].toLowerCase().contains(query))
              .toList();
      }
      else{
          musicController.filteredSongs.clear();
          songs = musicController.allSongs;
          musicController.filteredSongs.value = songs;
      }
    });
  }



  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF10121f),
      ),
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.transparent,
        body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
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

            Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 110.sp, 10.sp, 0.sp),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                
                
                    Obx(() => musicController.allSongsLoadingStatus.value == false ? ListView.separated(
                        padding: EdgeInsets.only(top: 20.sp, bottom: 22.sp),
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (_,__) => Divider(height: 50, thickness: 0.1, color: Colors.grey,),
                        shrinkWrap: true,
                        itemCount: musicController.filteredSongs.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: (){
                            List<MediaItem> mediaItems = musicController.filteredSongs.map<MediaItem>((music) {
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
                              songs: musicController.filteredSongs,
                            ));
                          },
                
                          child: MusicWidget(
                            favoriteList: musicController.filteredSongs,
                            favorite: musicController.filteredSongs[index],
                          ),
                        )
                    ) : musicWidgetLoader()),
                
                
                  ],
                ),
              ),
            ),


            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(5.sp, 60.sp, 16.sp, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: (){
                        Get.back();
                        },
                        child: Icon(Icons.arrow_back_ios_new, color: whiteColor, size: 30.sp,)
                      ),
                    ),
                    horizontalSpace(0.015),

                    Expanded(
                      flex: 12,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.sp),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 39, sigmaY: 39),
                          child: Container(

                            // height: height() * 0.05,
                            // width: width() * 0.75,
                            // padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            decoration: BoxDecoration(
                                color: whiteColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.sp),
                                border: Border.all(color: whiteColor.withOpacity(0.09), width: 1.sp)
                            ),
                            child: TextField(
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp
                              ),
                              onChanged: (v){
                                onSearchChanged();
                              },
                              controller: _searchController,
                              decoration: InputDecoration(
                                prefixIcon:  Icon(Icons.search, color: whiteColor,),
                                hintText: 'Search Here',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 10.sp),
                                hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: whiteColor
                                ),
                                fillColor: Colors.transparent,
                              ),
                            )
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


genreWidgetLoader(){
  return SizedBox(
    height: height() * 0.21,
    child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(left: 10.sp),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(0.005),
                Container(
                  height: height() * 0.17,
                  width:  height() * 0.17,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                ),
                verticalSpace(0.01),
                Container(
                  height: height() * 0.012,
                  width: height() * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                ),
              ],
            ),),
        )),
  );
}