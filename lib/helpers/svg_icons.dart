import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconSVG extends StatelessWidget {
  const IconSVG({
    Key? key,
    required this.assetPath,
    this.color,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  final String assetPath;
  final Color? color;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      semanticsLabel: assetPath,
      width: width ?? 24.sp,
      height: height ?? 24.sp,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(
        color!,
        BlendMode.srcIn,
      ),
      fit: BoxFit.scaleDown,
    );
  }
}
