import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class EmptyDashboardShortcutsWidget extends StatelessWidget {
  final VoidCallback onAddPressed;
  const EmptyDashboardShortcutsWidget({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 140.h, left: 24, right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.dashboard_customize_rounded,
            size: 54,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 10),
          CustomText(
            text: 'No dashboard shortcuts',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[700],
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: 'Tap below to add your favorite dashboard components.',
            fontSize: 13,
            textAlign: TextAlign.center,
            color: AppPalette.darkGreyColor,
          ),
          const SizedBox(height: 14),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: CustomButton(
              onPressed: onAddPressed,
              icon: Icons.add,
              text: 'Add Components',
              fontSize: 14,
              height: 40,
              radius: 8,
            ),
          ),
        ],
      ),
    );
  }
}
