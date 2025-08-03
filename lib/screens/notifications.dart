
import 'package:al_khaliq/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Text("Coming Soon...!",
        style: TextStyle(
          fontSize: 28.sp,
          color: whiteColor,
          fontWeight: FontWeight.w700
        ),),
      ),
    );
  }
}
