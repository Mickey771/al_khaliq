
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../main.dart';
import 'constants.dart';



String audioStatus = "";


Widget statusIcon = Play(buttonColor: Colors.teal);

bool isLoading = false;


String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return "$minutes:$seconds";
}

String getTimeString(int seconds) {
  String minuteString =
      '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
  String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
  return '$minuteString:$secondString'; // Returns a string with the format mm:ss
}


Widget audioSlider(context) {
  return StreamBuilder<Duration>(
    stream: audioHandler.player.positionStream,
    builder: (context, positionSnapshot) {
      return StreamBuilder<Duration?>(
        stream: audioHandler.player.durationStream,
        builder: (context, durationSnapshot) {
          final position = positionSnapshot.data ?? Duration.zero;
          final duration = durationSnapshot.data ?? Duration.zero;
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            width: width() ,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0, disabledThumbRadius: 8),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),),
              child: Slider(
                  value: position.inSeconds.toDouble(),
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  inactiveColor: Colors.grey,
                  activeColor: lightBlueColor,
                  thumbColor: Colors.white,
                  onChanged: (value) {
                    audioHandler.seek(Duration(seconds: value.toInt()));
                  }),
            ),
          );
        },
      );
    },
  );
}




class Pause extends StatelessWidget {
  const Pause({
    super.key,
    required this.buttonColor,
  });

  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2.sp),
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.pause, size: 10.sp, color: Colors.white,)
    );
  }
}


class Play extends StatelessWidget {
  const Play({
    super.key,
    required this.buttonColor,
  });

  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2.sp),
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.play_arrow, size: 10.sp, color: Colors.white,)
    );
  }
}