import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class GrnListItemShimmer extends StatelessWidget {
  const GrnListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ), // ❗REAL TILE LOOK WITHOUT FILL
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon placeholder
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(160.w, 14.h),
                  SizedBox(height: 6.h),
                  _line(120.w, 12.h),
                  SizedBox(height: 6.h),
                  _line(140.w, 12.h),
                  SizedBox(height: 8.h),

                  // Row(
                  //   children: [
                  //     _line(60.w, 12.h),
                  //     Spacer(),
                  //     Container(
                  //       width: 20.w,
                  //       height: 20.w,
                  //       decoration: BoxDecoration(
                  //         color: Colors.grey.shade300,
                  //         borderRadius: BorderRadius.circular(4.r),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
