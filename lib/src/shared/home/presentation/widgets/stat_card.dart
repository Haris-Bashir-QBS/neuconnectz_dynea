// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
// import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
// import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
//
// class StatCard extends StatelessWidget {
//   final String iconPath;
//   final String label;
//   final String value;
//   final Color color;
//
//   const StatCard({
//     super.key,
//     required this.iconPath,
//     required this.label,
//     required this.value,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(0.sp),
//       padding: EdgeInsets.symmetric(horizontal: 10.w),
//       decoration: BoxDecoration(
//         color: AppPalette.stockTransferOrderColor,
//         borderRadius: BorderRadius.circular(18.r),
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(left: 0.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // 10.verticalSpace,
//             // SizedBox(height: 10.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomText(
//                   text: label,
//                   fontSize: 14.sp,
//                   color: AppPalette.darkGreyColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//
//                 Container(
//                   padding: EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: AppPalette.lightGreenColor,
//                       width: 2,
//                     ),
//                   ),
//                   child: Center(
//                     child: Image.asset(
//                       AppAssets.upIcon,
//                       width: 12.w,
//                       height: 12.h,
//                       color: AppPalette.lightGreenColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 4.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(10.r),
//                     child: Image.asset(iconPath, width: 20.w, height: 20.h),
//                   ),
//                 ),
//                 CustomText(
//                   text: value,
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.bold,
//                   color: AppPalette.darkGreyColor,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


