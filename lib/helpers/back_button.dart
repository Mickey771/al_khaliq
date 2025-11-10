import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'constants.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Padding(
        padding: EdgeInsets.only(left: 16.sp, top: 61.sp),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.sp),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 29.2, sigmaY: 29.2),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
              decoration: BoxDecoration(
                  color: whiteColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12.sp),
                  border: Border.all(
                      color: whiteColor.withValues(alpha: 0.10),
                      width: 1.3.sp)),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: whiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
