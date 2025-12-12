import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class HomeWelcomeCard extends StatelessWidget {
  const HomeWelcomeCard({
    super.key,
    required this.userName,
    required this.userInitial,
    required this.isConnected,
  });

  final String userName;
  final String userInitial;
  final bool? isConnected;

  @override
  Widget build(BuildContext context) {
    final connectionStatus = isConnected;
    final isOnline = connectionStatus ?? false;
    final statusText =
        connectionStatus == null
            ? AppTexts.checkingConnection
            : isOnline
            ? AppTexts.connected
            : AppTexts.disconnected;
    final statusColor =
        connectionStatus == null
            ? AppPalette.yellowColor
            : isOnline
            ? AppPalette.lightGreenColor
            : Colors.redAccent;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppPalette.lightGreyColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: CustomText(
              text: userInitial,
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppPalette.darkGreyColor,
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: AppTexts.welcome,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.darkGreyColor,
                ),
                2.verticalSpace,
                CustomText(
                  text: userName,
                  fontSize: 16.sp,
                  color: AppPalette.greyColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          6.horizontalSpace,
          CustomText(text: statusText, fontSize: 12.sp, color: statusColor),
        ],
      ),
    );
  }
}



