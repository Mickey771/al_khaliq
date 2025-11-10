import 'package:al_khaliq/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubHeading extends StatelessWidget {
  final String? subtitle;
  final Function? seeAllFunc;

  const SubHeading({super.key, this.subtitle, this.seeAllFunc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subtitle!,
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.w700,
              fontSize: 22.sp,
            ),
          ),
          InkWell(
            onTap: () {
              seeAllFunc;
            },
            child: Text(
              'See all',
              style: TextStyle(
                color: lightBlueColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
