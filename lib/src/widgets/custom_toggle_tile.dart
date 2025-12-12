import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';

import '../core/constants/app_palette.dart';
import 'custom_text.dart';

class CustomToggleTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomToggleTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.backgroundColor = Colors.white,
    this.borderRadius = 20,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            fontSize: 15.sp,
            color: AppPalette.darkGreyColor,
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: context.primaryColor,
            inactiveTrackColor: AppPalette.lightGreyColor,
            // thumbColor: WidgetStateProperty.all(Colors.white),
          ),
        ],
      ),
    );
  }
}


