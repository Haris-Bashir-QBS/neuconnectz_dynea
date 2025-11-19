import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/app_palette.dart';
import '../core/constants/app_texts.dart';
import 'custom_text.dart';

class ItemListingHeader extends StatelessWidget {
  final String? leftHeading;
  final String? rightHeading;
  final double? horizontalPadding;
  const ItemListingHeader({
    super.key,
    this.leftHeading,
    this.rightHeading,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 15.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: leftHeading ?? AppTexts.itemName,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppPalette.greyColor,
          ),
          CustomText(
            text: rightHeading ?? AppTexts.itemCode,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppPalette.greyColor,
          ),
        ],
      ),
    );
  }
}
