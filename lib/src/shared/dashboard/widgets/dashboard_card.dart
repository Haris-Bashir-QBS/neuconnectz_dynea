import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/models/dashboard_item.dart';

import '../../../widgets/custom_text.dart';

class DashBoardCard extends StatelessWidget {
  final DashboardItem item;
  final Color? color;
  final Color? textColor;
  final Widget? moreWidget;
  final VoidCallback onTap, onTapMore;

  const DashBoardCard({
    super.key,
    required this.item,
    this.textColor,
    required this.onTap,
    this.color,
    this.moreWidget,
    required this.onTapMore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        //margin: EdgeInsets.zero,
        color: color ?? AppPalette.primaryGreyColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            5.verticalSpace,
            if (moreWidget != null) moreWidget!,
            SizedBox(height: 80.h, width: 100.w, child: Image.asset(item.icon)),
            const SizedBox(height: 10),
            CustomText(
              text: item.title,
              textAlign: TextAlign.center,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              // color: Colors.black,
              color: textColor ?? context.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}


