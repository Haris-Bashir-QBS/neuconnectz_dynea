import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/app_palette.dart';

class BottomSheetHandle extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  final double? borderRadius;

  const BottomSheetHandle({
    super.key,
    this.color,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width ?? 80.w,
        height: height ?? 4.h,
        margin: EdgeInsets.only(top: 0.h, bottom: 4.h),
        decoration: BoxDecoration(
          color: color ?? AppPalette.greyColor.withAlpha(100),
          borderRadius: BorderRadius.circular(borderRadius ?? 2.r),
        ),
      ),
    );
  }
}
