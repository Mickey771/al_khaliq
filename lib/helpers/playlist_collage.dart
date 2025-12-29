import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlaylistCollage extends StatelessWidget {
  final List songs;
  final double size;
  final double borderRadius;

  const PlaylistCollage({
    super.key,
    required this.songs,
    required this.size,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius.sp),
      child: SizedBox(
        width: size,
        height: size,
        child: _buildCollage(),
      ),
    );
  }

  Widget _buildCollage() {
    if (songs.isEmpty) {
      return Container(
        color: Colors.white.withOpacity(0.05),
        child: Icon(Icons.music_note, color: Colors.white24, size: size * 0.4),
      );
    }

    // If 1-3 songs, show the first one
    if (songs.length < 4) {
      return _buildImage(songs[0]['image']);
    }

    // If 4 or more, show 2x2 grid
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImage(songs[0]['image'])),
              Expanded(child: _buildImage(songs[1]['image'])),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImage(songs[2]['image'])),
              Expanded(child: _buildImage(songs[3]['image'])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String? url) {
    if (url == null || url.isEmpty) {
      return Container(color: Colors.grey[900]);
    }
    // Optimization: Resize image at decode time to save memory
    // Grid images are 1/2 of the total size
    final double cacheSize = (size * 0.5 * 1.5); // 1.5x for pixel density

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      memCacheHeight: cacheSize.toInt(),
      memCacheWidth: cacheSize.toInt(),
      placeholder: (context, url) =>
          Container(color: Colors.white.withOpacity(0.05)),
      errorWidget: (context, url, error) => Container(color: Colors.grey[900]),
    );
  }
}
