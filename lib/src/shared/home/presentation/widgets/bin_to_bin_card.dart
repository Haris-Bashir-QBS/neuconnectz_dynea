// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:reorderable_grid_view/reorderable_grid_view.dart';
// import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
// import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
// import 'package:neuconnectz_dynea/src/core/utils/app_static_data.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/animated_stat_card.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/average_time_card.dart';
// import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
//
// class BinToBinCard extends StatelessWidget {
//   final List<String> visibleSubItems;
//   final void Function(List<String> newOrder) onReorder;
//   const BinToBinCard({super.key, required this.visibleSubItems, required this.onReorder});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           // BoxShadow(
//           //   color:   Colors.black.withAlpha(13),
//           //   blurRadius: 10,
//           //   offset: const Offset(0, 2),
//           // ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomText(
//             text: AppTexts.binToBinTransfer,
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//             color: AppPalette.darkGreyColor,
//           ),
//           8.verticalSpace,
//           ReorderableGridView.count(
//             crossAxisCount: visibleSubItems.length == 1 ? 1 : 2,
//             mainAxisSpacing: 5,
//             crossAxisSpacing: 6,
//             padding: EdgeInsets.zero,
//             childAspectRatio: visibleSubItems.length == 1 ? 3.4 : 1.7,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             onReorder: (oldIndex, newIndex) {
//               final newOrder = List<String>.from(visibleSubItems);
//               if (newIndex > oldIndex) newIndex -= 1;
//               final item = newOrder.removeAt(oldIndex);
//               newOrder.insert(newIndex, item);
//               onReorder(newOrder);
//             },
//             children: visibleSubItems.map((label) {
//               final stat = AppStaticData.statCardRows.firstWhere(
//                 (s) => s.label == label,
//               );
//               final index = visibleSubItems.indexOf(label);
//               return AnimatedStatCard(
//                 key: ValueKey('stat_$label'),
//                 iconPath: stat.iconPath,
//                 label: stat.label,
//                 //value: stat.value ?? "",
//                 value: "-",
//                 color: stat.color,
//                 delay: Duration(milliseconds: index * 100),
//               );
//             }).toList(),
//           ),
//           8.verticalSpace,
//           const AverageTimeCard(percentage: 58.8, trend: 12),
//         ],
//       ),
//     );
//   }
// }


