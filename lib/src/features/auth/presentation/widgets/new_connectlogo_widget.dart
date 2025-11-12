import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';

class NewConnectLogoWidget extends StatelessWidget {
  const NewConnectLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 32.h, bottom: 22.h),
      child: Image.asset(AppAssets.logo, height: 24.h, width: 150.w),
    );
  }
}
