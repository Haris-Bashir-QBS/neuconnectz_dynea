import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class WelcomeCard extends StatelessWidget {
  final String name;
  const WelcomeCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.h,
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 50.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.primaryColor, context.primaryColor.withAlpha(130)],
        ),
        // image: DecorationImage(image: AssetImage(AppAssets.dashboardCard)),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: AppTexts.welcomeBack,
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              CustomText(
                text: name,
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              SizedBox(height: 10.h),
            ],
          ),
          Spacer(),
          Image.asset(AppAssets.cubeIcon, width: 50.w, height: 50.w),
        ],
      ),
    );
  }
}
