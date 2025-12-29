import 'dart:ui';

import 'package:al_khaliq/controllers/playlist_controller.dart';
import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:al_khaliq/screens/playlists/playlist_songs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../helpers/constants.dart';
import '../../helpers/music_widget.dart';
import '../../helpers/playlist_collage.dart';
import '../../helpers/svg_icons.dart';
import '../search.dart';
import '../side_nav.dart';

class Playlists extends StatefulWidget {
  const Playlists({super.key});

  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  PlaylistController playlistController = Get.find();
  UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
    playlistController.getUserPlaylists(
        userController.getToken(), userController.getUserId());
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
                padding: EdgeInsets.fromLTRB(10.sp, 120.sp, 10.sp, 30.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Playlists",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: whiteColor),
                        ),
                        InkWell(
                          onTap: () {
                            _showCreatePlaylistDialog(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5.sp),
                            decoration: BoxDecoration(
                                color: whiteColor.withOpacity(0.1),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.add,
                              color: whiteColor,
                              size: 24.sp,
                            ),
                          ),
                        )
                      ],
                    ),
                    verticalSpace(0.02),
                    Obx(() => playlistController.loadingStatus.value &&
                            playlistController.userPlayLists.isEmpty
                        ? musicWidgetLoader()
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) => Divider(
                                  height: 30.sp,
                                  thickness: 0.1,
                                  color: Colors.white10,
                                ),
                            shrinkWrap: true,
                            itemCount: playlistController.userPlayLists.length,
                            itemBuilder: (context, index) {
                              var playlist =
                                  playlistController.userPlayLists[index];
                              return InkWell(
                                onTap: () {
                                  Get.to(() => PlaylistSongs(
                                        playlistId: playlist['id'],
                                        playlistName: playlist['name'],
                                      ));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                                  child: Row(
                                    children: [
                                      // Collage cover on the left
                                      PlaylistCollage(
                                        songs: playlist['songs'] ?? [],
                                        size: 60.sp,
                                        borderRadius: 12,
                                      ),
                                      horizontalSpace(0.04),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              playlist['name'] ?? "",
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: whiteColor,
                                                  letterSpacing: 0.5),
                                            ),
                                            verticalSpace(0.005),
                                            Text(
                                              "${playlist['songs_count'] ?? 0} ${playlist['songs_count'] == 1 ? 'song' : 'songs'} • ${playlist['description'] ?? "No description"}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: lightBlueColor
                                                      .withOpacity(0.7)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: whiteColor.withOpacity(0.5),
                                          size: 22.sp,
                                        ),
                                        onSelected: (value) {
                                          if (value == 'rename') {
                                            _showRenamePlaylistDialog(
                                                context, playlist);
                                          } else if (value == 'delete') {
                                            _showDeleteConfirmationDialog(
                                                context, playlist);
                                          }
                                        },
                                        color: Color(0xFF1c1f2e),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 'rename',
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,
                                                    color: whiteColor,
                                                    size: 18.sp),
                                                horizontalSpace(0.02),
                                                Text("Rename",
                                                    style: TextStyle(
                                                        color: whiteColor)),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors.redAccent,
                                                    size: 18.sp),
                                                horizontalSpace(0.02),
                                                Text("Delete",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.redAccent)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
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
                        onTap: () {
                          Get.to(() => SideNav(),
                              transition: Transition.leftToRight);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.sp),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 29.2, sigmaY: 29.2),
                            child: Container(
                              height: height() * 0.055,
                              padding: EdgeInsets.symmetric(horizontal: 10.sp),
                              decoration: BoxDecoration(
                                  color: whiteColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12.sp),
                                  border: Border.all(
                                      color: whiteColor.withValues(alpha: 0.9),
                                      width: 1.sp)),
                              child: IconSVG(
                                assetPath: 'assets/images/icons/menu-icon.svg',
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    horizontalSpace(0.015),
                    Expanded(
                      flex: 12,
                      child: InkWell(
                        onTap: () {
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
                                  color: whiteColor.withValues(alpha: .1),
                                  borderRadius: BorderRadius.circular(12.sp),
                                  border: Border.all(
                                      color: whiteColor.withValues(alpha: .09),
                                      width: 1.sp)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: whiteColor,
                                  ),
                                  horizontalSpace(0.05),
                                  Text("Search here....",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: whiteColor)),
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
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    String name = "";
    String description = "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF10121f),
        title: Text("Create Playlist", style: TextStyle(color: whiteColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: TextStyle(color: whiteColor),
              onChanged: (v) => name = v,
              decoration: InputDecoration(
                hintText: "Playlist Name",
                hintStyle: TextStyle(color: whiteColor.withOpacity(0.5)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: whiteColor.withOpacity(0.5))),
              ),
            ),
            verticalSpace(0.02),
            TextField(
              style: TextStyle(color: whiteColor),
              onChanged: (v) => description = v,
              decoration: InputDecoration(
                hintText: "Description (Optional)",
                hintStyle: TextStyle(color: whiteColor.withOpacity(0.5)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: whiteColor.withOpacity(0.5))),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: lightBlueColor)),
          ),
          TextButton(
            onPressed: () {
              if (name.isNotEmpty) {
                playlistController.createPlaylist(
                  userController.getToken(),
                  userController.getUserId(),
                  name,
                  description,
                );
              } else {
                Get.snackbar("Error", "Playlist name cannot be empty",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.withOpacity(0.7),
                    colorText: whiteColor);
              }
            },
            child: Text("Create", style: TextStyle(color: whiteColor)),
          ),
        ],
      ),
    );
  }

  void _showRenamePlaylistDialog(BuildContext context, dynamic playlist) {
    String newName = playlist['name'] ?? "";
    TextEditingController controller = TextEditingController(text: newName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF10121f),
        title: Text("Rename Playlist", style: TextStyle(color: whiteColor)),
        content: TextField(
          controller: controller,
          style: TextStyle(color: whiteColor),
          onChanged: (v) => newName = v,
          decoration: InputDecoration(
            hintText: "New Playlist Name",
            hintStyle: TextStyle(color: whiteColor.withOpacity(0.5)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: whiteColor.withOpacity(0.5))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: lightBlueColor)),
          ),
          TextButton(
            onPressed: () {
              if (newName.isNotEmpty) {
                playlistController.renamePlaylist(
                  userController.getToken(),
                  playlist['id'],
                  newName,
                  userController.getUserId(),
                );
                Navigator.pop(context);
              }
            },
            child: Text("Rename", style: TextStyle(color: whiteColor)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, dynamic playlist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF10121f),
        title: Text("Delete Playlist", style: TextStyle(color: Colors.red)),
        content: Text(
          "Are you sure you want to delete '${playlist['name']}'? This action cannot be undone.",
          style: TextStyle(color: whiteColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: lightBlueColor)),
          ),
          TextButton(
            onPressed: () {
              playlistController.deletePlaylist(
                userController.getToken(),
                playlist['id'],
                userController.getUserId(),
              );
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
