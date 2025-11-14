import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_palette.dart';

class DialogShimmerListView extends StatelessWidget {
  final int itemCount;
  final bool? showTrailingWidget;

  const DialogShimmerListView({
    super.key,
    this.itemCount = 20,
    this.showTrailingWidget = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? Colors.grey.shade700 : const Color(0xFFBDBDBD);
    final highlightColor = isDark ? Colors.grey.shade500 : Colors.grey.shade100;
    final boxColor = isDark ? Colors.grey.shade800 : Colors.grey[300];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => 12.verticalSpace,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.grey.shade900
                      : AppPalette.lightBlue.withAlpha(55),
              // Colors.white.withAlpha(200),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
              ],
            ),
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Row(
                children: [
                  // Leading avatar
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: boxColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  12.horizontalSpace,

                  // Title & subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12.h,
                          width: 0.5.sw,
                          decoration: BoxDecoration(
                            color: boxColor,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        8.verticalSpace,
                        Container(
                          height: 10.h,
                          width: 0.35.sw,
                          decoration: BoxDecoration(
                            color: boxColor?.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Optional trailing
                  if (showTrailingWidget ?? true) ...[
                    12.horizontalSpace,
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
