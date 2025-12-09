import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class HomeActionCardData {
  final String title;
  final String iconPath;
  final bool spanFullWidth;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;

  const HomeActionCardData({
    required this.title,
    this.iconPath = AppAssets.purchaseOrderIcon,
    this.spanFullWidth = false,
    this.onTap,
    this.backgroundColor,
    this.iconBackgroundColor,
    this.iconColor,
  });
}

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({super.key, required this.data});

  final HomeActionCardData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: data.backgroundColor ?? AppPalette.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: data.iconBackgroundColor ?? AppPalette.primaryColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Image.asset(
                    data.iconPath,
                    width: 20.w,
                    height: 20.w,
                    color: Colors.white,
                  ),
                ),
              ),
              10.verticalSpace,
              CustomText(
                text: data.title,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

