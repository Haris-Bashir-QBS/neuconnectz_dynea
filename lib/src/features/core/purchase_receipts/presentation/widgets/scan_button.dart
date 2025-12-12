import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';

import '../../../../../core/constants/asset_paths.dart';

class ScanButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool? isSearch;
  const ScanButton({super.key, required this.onTap, this.isSearch});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 8.w, top: 0.h, bottom: 0.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Image.asset(
            isSearch == true ? AppAssets.searchIcon : AppAssets.scanIcon,
            color: Colors.white,
            width: 20.w,
            height: 20.w,
          ),
        ),
      ),
    );
  }
}


