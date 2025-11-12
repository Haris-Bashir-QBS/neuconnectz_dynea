// import 'package:flutter/material.dart';
// import 'package:neuconnectz_dynea/src/core/barrels/itr_barrel.dart';
// import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/dashboard_card.dart';
//
// class StockMovementWorkflow extends StatelessWidget {
//   const StockMovementWorkflow({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DashboardCard(
//       title: AppTexts.stockMovementWorkflow,
//       child: Container(
//         height: 150.h,
//         padding: EdgeInsets.all(16.r),
//         decoration: BoxDecoration(
//           //   color: AppPalette.stockTransferOrderColor,
//           color: AppPalette.stockTransferOrderColor,
//           borderRadius: BorderRadius.circular(12.r),
//           boxShadow: [
//             // BoxShadow(
//             //   color: Colors.black.withAlpha(13),
//             //   blurRadius: 10,
//             //   offset: const Offset(0, 2),
//             // ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             // Nodes
//             Positioned(
//               top: 0,
//               left: 0,
//               child: _buildWorkflowNode(
//                 label: 'ITR',
//                 icon: AppAssets.stockTransferOrder,
//                 color: AppPalette.stockMovementWorkFlowColors[0],
//                 onTap: () {
//                   context.pushNamed(AppRoutes.itrListing);
//                 },
//               ),
//             ),
//             Positioned(
//               top: 0,
//               left: MediaQuery.of(context).size.width / 2 - 87.w,
//               child: _buildWorkflowNode(
//                 label: 'IT',
//                 icon: AppAssets.menuItIcon,
//                 color: AppPalette.stockMovementWorkFlowColors[1],
//                 onTap: () {
//                   context.pushNamed(AppRoutes.itListing);
//                 },
//               ),
//             ),
//             Positioned(
//               top: 0,
//               right: 0,
//               child: _buildWorkflowNode(
//                 label: 'TR',
//                 icon: AppAssets.trDashboardICon,
//                 color: AppPalette.stockMovementWorkFlowColors[2],
//                 onTap: () {
//                   context.pushNamed(AppRoutes.createTransferRequest);
//                 },
//               ),
//             ),
//             // Positioned(
//             //   bottom: 0,
//             //   left: 20.w,
//             //   child: _buildWorkflowNode(
//             //     label: 'Put Away',
//             //     icon: AppAssets.putInIcon,
//             //     color: AppPalette.stockMovementWorkFlowColors[3],
//             //     horizontal: true,
//             //   ),
//             // ),
//             // Positioned(
//             //   bottom: 0,
//             //   right: 20.w,
//             //   child: _buildWorkflowNode(
//             //     label: 'Put In',
//             //     icon: AppAssets.putAwayIcon,
//             //     color: AppPalette.stockMovementWorkFlowColors[4],
//             //     horizontal: true,
//             //   ),
//             // ),
//             // Arrows
//             Positioned(
//               top: 40.h,
//               left: 98.w,
//               child: _buildArrow(isDotted: true),
//             ),
//             // Positioned(
//             //   top: 40.h,
//             //   right: 90.w,
//             //   child: _buildArrow(isDotted: true),
//             // ),
//             // Positioned(
//             //   top: 110.h,
//             //   left: 45.w,
//             //   child: _buildArrow(isVertical: true),
//             // ),
//             // Positioned(
//             //   top: 110.h,
//             //   left: 170.w,
//             //   child: _buildArrow(isVertical: true, isReversed: true),
//             // ),
//             // Positioned(
//             //   top: 110.h,
//             //   right: 55.w,
//             //   child: _buildArrow(isVertical: true),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildWorkflowNode({
//     required String label,
//     required String icon,
//     required Color color,
//     required VoidCallback onTap,
//     bool horizontal = false,
//   }) {
//     final content = [
//       Container(
//         padding: EdgeInsets.all(16.sp),
//         decoration: BoxDecoration(shape: BoxShape.circle, color: color),
//         child: Image.asset(
//           icon,
//           color: Colors.white,
//           width: 24.w,
//           height: 24.w,
//         ),
//       ),
//       SizedBox(width: horizontal ? 8.w : 0, height: !horizontal ? 8.h : 0),
//       Text(
//         label,
//         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
//       ),
//     ];
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child:
//             horizontal
//                 ? Row(mainAxisSize: MainAxisSize.min, children: content)
//                 : Column(mainAxisSize: MainAxisSize.min, children: content),
//       ),
//     );
//   }
//
//   Widget _buildArrow({
//     bool isVertical = false,
//     bool isDotted = false,
//     bool isReversed = false,
//   }) {
//     final arrow =
//         isVertical
//             ? Icon(
//               isReversed ? Icons.arrow_upward : Icons.arrow_downward,
//               color: Colors.black,
//             )
//             : Icon(Icons.arrow_forward, color: AppPalette.darkGreyColor);
//
//     // if (isDotted) {
//     //   return Row(
//     //     children: List.generate(
//     //       5,
//     //       (index) => Padding(
//     //         padding: EdgeInsets.symmetric(horizontal: 1.w),
//     //         child: Container(width: 4.w, height: 2.h, color: Colors.grey),
//     //       ),
//     //     )..add(arrow),
//     //   );
//     // }
//     return arrow;
//   }
// }
