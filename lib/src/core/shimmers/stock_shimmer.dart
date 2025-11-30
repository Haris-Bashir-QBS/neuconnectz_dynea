import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class StockCardShimmer extends StatelessWidget {
  const StockCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer circle
              // _shimmerBox(width: 34.w, height: 34.w, radius: 50),
              // 12.horizontalSpace,

              // Title + description shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(width: 120.w, height: 14.h),
                    6.verticalSpace,
                    _shimmerBox(width: 170.w, height: 12.h),
                  ],
                ),
              ),

              12.horizontalSpace,

              // Stock shimmer
              _shimmerBox(width: 80.w, height: 24.h),
            ],
          ),

          14.verticalSpace,

          // View Details button shimmer bar
          _shimmerBox(width: double.infinity, height: 40.h, radius: 10),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(radius.r),
        ),
      ),
    );
  }
}
