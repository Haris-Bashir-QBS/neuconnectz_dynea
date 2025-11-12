// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/component_heading_widget.dart';
//
// import '../../../../../core/constants/app_palette.dart';
// import '../../../../../core/constants/app_texts.dart';
// import '../../../../../widgets/custom_text.dart';
//
// class AverageTimeCard extends StatefulWidget {
//   final double percentage;
//   final double trend;
//
//   const AverageTimeCard({
//     super.key,
//     required this.percentage,
//     required this.trend,
//   });
//
//   @override
//   State<AverageTimeCard> createState() => _AverageTimeCardState();
// }
//
// class _AverageTimeCardState extends State<AverageTimeCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _percentageAnimation;
//   late Animation<double> _progressAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );
//
//     _percentageAnimation = Tween<double>(
//       begin: 0,
//       end: widget.percentage,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
//
//     _progressAnimation = Tween<double>(
//       begin: 0,
//       end: widget.percentage / 100,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
//
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //  final isPositive = widget.trend >= 0;
//
//     return Container(
//       margin: const EdgeInsets.all(0),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppPalette.stockTransferOrderColor,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ComponentSubHeadingWidget(text: AppTexts.averageTransferTime),
//           6.verticalSpace,
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               AnimatedBuilder(
//                 animation: _percentageAnimation,
//                 builder: (context, child) {
//                   return CustomText(
//                     // text: _percentageAnimation.value.toStringAsFixed(1),
//                     text: "1m 6s",
//                     //text: "-",
//                     color: AppPalette.lightGreenColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20.sp,
//                   );
//                 },
//               ),
//               Spacer(),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: AppPalette.lightGreenColor.withAlpha(30),
//                 ),
//                 child: Row(
//                   children: [
//                     Image.asset(AppAssets.upIcon, width: 20, height: 20),
//                     CustomText(
//                       //  text: ' +${widget.trend.toStringAsFixed(0)}%',
//                       text: ' +19.01%',
//                       color: AppPalette.lightGreenColor,
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           AnimatedBuilder(
//             animation: _progressAnimation,
//             builder: (context, child) {
//               return SizedBox(
//                 height: 8.h,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(15.r),
//                   child: LinearProgressIndicator(
//                     value: _progressAnimation.value,
//                     backgroundColor: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(15),
//                     // stopIndicatorRadius: 100,
//                     valueColor: const AlwaysStoppedAnimation<Color>(
//                       AppPalette.lightGreenColor,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
