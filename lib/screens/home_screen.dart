// import 'dart:async';
// import 'dart:ui';

// import 'package:al_khaliq/controllers/genre_controller.dart';
// import 'package:al_khaliq/controllers/music_controller.dart';
// import 'package:al_khaliq/screens/genre/genreSongs.dart';
// import 'package:al_khaliq/screens/music_player.dart';
// import 'package:al_khaliq/screens/search.dart';
// import 'package:al_khaliq/screens/side_nav.dart';
// import 'package:audio_service/audio_service.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../helpers/constants.dart';
// import '../controllers/account_controller.dart';
// import '../helpers/music_widget.dart';
// import '../helpers/subheading.dart';
// import '../helpers/svg_icons.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {



//   AccountController accountController = Get.find();
//   GenreController genreController = Get.find();
//   MusicController musicController = Get.find();

//   @override
//   void initState() {
//     // TODO: implement initState
//     // loadApp();
//     super.initState();
//   }

//   RxBool visible = false.obs;


//   // loadApp() async {
//   //   Timer(
//   //       const Duration(seconds: 2),
//   //           () =>  _firebaseMethods.signInAnonymously()
//   //   );
//   // }

//   final GlobalKey<ScaffoldState> _key = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _key,
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.center,
//         children: [


//           SingleChildScrollView(
//             child: Padding(
//                   padding: EdgeInsets.fromLTRB(10.sp, 100.sp, 10.sp, 30.sp),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
            
            
            
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
            
            
//                           verticalSpace(0.035),
            
//                           SubHeading(
//                             subtitle: "Music Genre",
//                             seeAllFunc: (){},
//                           ),
            
//                           Obx(() => genreController.genreLoadingStatus.value == false ? SizedBox(
//                             height: height() * 0.21,
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               padding: EdgeInsets.zero,
//                               scrollDirection: Axis.horizontal,
//                               itemCount: genreController.genres.length,
//                                 itemBuilder: (context, index)
//                                 => Padding(
//                                   padding: EdgeInsets.only(right: 20.sp),
//                                   child: InkWell(
//                                     onTap: (){
//                                       Get.to(() => GenreSongs(image: genreController.genres[index]['image'],
//                                           songs: musicController.allSongs.where(((item) => item['genre_id'] == genreController.genres[index]['id'] )).toList(),
//                                           name: genreController.genres[index]['name']));
//                                     },
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Hero(
//                                           tag: genreController.genres[index]['image'],
//                                           child: SizedBox(
//                                             height: height() * 0.17,
//                                             width:  height() * 0.17,
//                                             child: ClipRRect(
//                                               borderRadius: BorderRadius.circular(8.sp),
//                                               child: CachedNetworkImage(
//                                                 imageUrl: genreController.genres[index]['image'],
//                                                 placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 1, color: whiteColor,)),
//                                                 errorWidget: (context, url, error) => Icon(Icons.error, color: whiteColor,),
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         verticalSpace(0.005),
//                                         Hero(
//                                           tag: genreController.genres[index]['name'],
//                                           child: Material(
//                                             color: Colors.transparent,
//                                             child: Text(genreController.genres[index]['name'],
//                                             style: TextStyle(
//                                               color: whiteColor,
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w500
//                                             ),),
//                                           ),
//                                         )
            
//                                       ],),
//                                   ),
//                                 )),
//                           ) : genreWidgetLoader()),

//                           verticalSpace(0.025),

//                           SubHeading(
//                             subtitle: "New Releases",
//                             seeAllFunc: (){},
//                           ),

//                           Obx(() => musicController.newReleasesLoadingStatus.value == false ? ListView.separated(
//                             padding: EdgeInsets.only(top: 5.sp),
//                               physics: NeverScrollableScrollPhysics(),
//                               separatorBuilder: (_,__) => Divider(height: 50, thickness: 0.1, color: Colors.grey,),
//                               shrinkWrap: true,
//                               itemCount: musicController.newReleases.length > 5 ? 5 : musicController.newReleases.length,
//                               itemBuilder: (context, index) => InkWell(
//                                 onTap: (){

//                                   print(musicController.newReleases[1]);
//                                   List<MediaItem> mediaItems = musicController.newReleases.map<MediaItem>((music) {
//                                     return MediaItem(
//                                       id: music['file'],
//                                       title: music['title'] ?? "",
//                                       artist: music['artist'] ?? 'Unknown Artist',
//                                       displayTitle: music['title'] ?? "",
//                                       album: music['album'] ?? 'Unknown Album',
//                                       artUri: Uri.parse(music['image'] ?? ""),
//                                     );
//                                   }).toList();


//                                   Get.to(() => MusicPlayer(
//                                     index: index,
//                                     songList: mediaItems,
//                                     songs: musicController.newReleases,
//                                   ));

//                                 },

//                                 child: MusicWidget(
//                                   favoriteList: musicController.newReleases,
//                                   favorite: musicController.newReleases[index],
//                                 ),
//                               )
//                           ) : musicWidgetLoader()),



//                           verticalSpace(0.025),

//                           SubHeading(
//                             subtitle: "Recently Played",
//                             seeAllFunc: (){},
//                           ),

//                           Obx(() => SizedBox(
//                             height: height() * 0.21,
//                             child: musicController.recentlyPlayed.isNotEmpty ? ListView.builder(
//                                 shrinkWrap: true,
//                                 padding: EdgeInsets.zero,
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: musicController.recentlyPlayed.length,
//                                 itemBuilder: (context, index)
//                                 => Padding(
//                                   padding: EdgeInsets.only(right: 20.sp),
//                                   child: InkWell(
//                                     onTap: (){
//                                       // Get.to(() => GenreSongs(image: musicController.recentlyPlayed[index]['image'],
//                                       //     songs: musicController.allSongs.where(((item) => item['genre_id'] == genreController.genres[index]['id'] )).toList(),
//                                       //     name: genreController.genres[index]['name']));
//                                     },
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Hero(
//                                           tag: musicController.recentlyPlayed[index]['image'],
//                                           child: SizedBox(
//                                             height: height() * 0.17,
//                                             width:  height() * 0.17,
//                                             child: ClipRRect(
//                                               borderRadius: BorderRadius.circular(8.sp),
//                                               child: CachedNetworkImage(
//                                                 imageUrl: musicController.recentlyPlayed[index]['image'],
//                                                 placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 1, color: whiteColor,)),
//                                                 errorWidget: (context, url, error) => Icon(Icons.error, color: whiteColor,),
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         verticalSpace(0.005),
//                                         Hero(
//                                           tag: musicController.recentlyPlayed[index]['name'],
//                                           child: Material(
//                                             color: Colors.transparent,
//                                             child: Text(musicController.recentlyPlayed[index]['name'],
//                                               style: TextStyle(
//                                                   color: whiteColor,
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w500
//                                               ),),
//                                           ),
//                                         )

//                                       ],),
//                                   ),
//                                 ),) :  Center(child: Text("No Recently Played\nSong",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: whiteColor,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 14.sp
//                                 ),)),
//                           ),),


//                           verticalSpace(0.1),

//                         ],
//                       ),
            
            
//                     ],
//                   ),
//                 ),
//           ),


//           Align(
//             alignment: Alignment.topCenter,
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(16.sp, 60.sp, 16.sp, 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: InkWell(
//                       onTap: (){
//                         Get.to(() => SideNav(), transition: Transition.leftToRight);
//                       },
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12.sp),
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 29.2, sigmaY: 29.2),
//                           child: Container(
//                             height: height() * 0.055,
//                             padding: EdgeInsets.symmetric(horizontal: 10.sp),
//                             decoration: BoxDecoration(
//                                 color: whiteColor.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(12.sp),
//                                 border: Border.all(color: whiteColor.withOpacity(0.09), width: 1.sp)
//                             ),
//                             child: IconSVG(assetPath: 'assets/images/icons/menu-icon.svg', color: whiteColor,),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   horizontalSpace(0.015),

//                   Expanded(
//                     flex: 12,
//                     child: InkWell(
//                       onTap: (){
//                         Get.to(() => Search());
//                       },
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12.sp),
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 39, sigmaY: 39),
//                           child: Container(

//                             height: height() * 0.055,
//                             // width: width() * 0.75,
//                             padding: EdgeInsets.symmetric(horizontal: 10.sp),
//                             decoration: BoxDecoration(
//                                 color: whiteColor.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(12.sp),
//                                 border: Border.all(color: whiteColor.withOpacity(0.09), width: 1.sp)
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.search, color: whiteColor,),
//                                 horizontalSpace(0.05),

//                                 Text("Search here....",
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontSize: 13.sp,
//                                         fontWeight: FontWeight.w500,
//                                         color: whiteColor
//                                     )),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),


//         ],
//       ),
//     );
//   }
// }


// genreWidgetLoader(){
//   return SizedBox(
//     height: height() * 0.21,
//     child: ListView.builder(
//         padding: EdgeInsets.zero,
//         shrinkWrap: true,
//         itemCount: 3,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) => Padding(
//           padding: EdgeInsets.only(left: 10.sp),
//           child: Shimmer.fromColors(
//               baseColor: Colors.grey.withOpacity(0.2),
//               highlightColor: Colors.white,
//               child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             verticalSpace(0.005),
//             Container(
//               height: height() * 0.17,
//               width:  height() * 0.17,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.sp),
//               ),
//             ),
//             verticalSpace(0.01),
//             Container(
//               height: height() * 0.012,
//               width: height() * 0.08,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.sp),
//               ),
//             ),
//           ],
//               ),),
//         )),
//   );
// }