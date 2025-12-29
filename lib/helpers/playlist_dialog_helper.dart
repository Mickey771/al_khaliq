import 'package:al_khaliq/controllers/playlist_controller.dart';
import 'package:al_khaliq/controllers/user_controller.dart';
import 'package:al_khaliq/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showPlaylistSelectionDialog(BuildContext context, Map song) {
  final PlaylistController playlistController = Get.find();
  final UserController userController = Get.find();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF10121f),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Select Playlist", style: TextStyle(color: whiteColor)),
      content: Obx(() {
        if (playlistController.loadingStatus.value &&
            playlistController.userPlayLists.isEmpty) {
          return const SizedBox(
            height: 100,
            child:
                Center(child: CircularProgressIndicator(color: lightBlueColor)),
          );
        }

        if (playlistController.userPlayLists.isEmpty) {
          return const Text("No playlists created yet.",
              style: TextStyle(color: whiteColor));
        }

        return SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: playlistController.userPlayLists.length,
            itemBuilder: (context, index) {
              final playlist = playlistController.userPlayLists[index];
              return ListTile(
                leading: const Icon(Icons.playlist_add, color: lightBlueColor),
                title: Text(playlist['name'] ?? 'Unnamed Playlist',
                    style: const TextStyle(color: whiteColor)),
                onTap: () {
                  playlistController.addSongToPlaylist(
                    userController.getToken(),
                    playlist['id'],
                    song['id'],
                    userController.getUserId(),
                  );
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close", style: TextStyle(color: lightBlueColor)),
        ),
      ],
    ),
  );
}
