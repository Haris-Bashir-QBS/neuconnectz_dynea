// import 'package:flutter/material.dart';
// import 'package:neuconnectz_dynea/src/core/barrels/itr_barrel.dart';
// import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
//
// import 'dashboard_card.dart';
//
// class PurchaseOrderWorkflow extends StatelessWidget {
//   const PurchaseOrderWorkflow({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DashboardCard(
//       title: AppTexts.purchaseOrderAndGrn,
//       child: Container(
//         padding: EdgeInsets.all(16.r),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildWorkflowBox(
//                   icon: AppAssets.purchaseOrderIcon,
//                   label: AppTexts.poAndGrn,
//                   color: AppPalette.d1Color,
//                   iconColor: Colors.white,
//                   onTap: () {
//                     context.pushNamed(AppRoutes.purchaseOrderListing);
//                   },
//                 ),
//                 _buildArrow(),
//                 _buildWorkflowBox(
//                   icon: AppAssets.pendingIcon,
//                   label: AppTexts.pendingGrn,
//                   color: AppPalette.d3Color,
//                   iconColor: Colors.white,
//                   onTap: () {
//                     context.pushNamed(AppRoutes.purchaseOrderListing);
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 24.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildWorkflowBox(
//                   icon: AppAssets.receiveFromProductionIcon,
//                   label: AppTexts.grn,
//                   color: AppPalette.d7Color,
//                   iconColor: Colors.white,
//                   onTap: () {
//                     context.pushNamed(AppRoutes.createNewGRN);
//                   },
//                 ),
//                 _buildArrow(),
//                 _buildWorkflowBox(
//                   icon: AppAssets.pendingIcon,
//                   label: AppTexts.pendingGrn,
//                   color: AppPalette.d3Color,
//                   iconColor: Colors.white,
//                   onTap: () {
//                     context.pushNamed(AppRoutes.pendingGRNs);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildWorkflowBox({
//     required String icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//     Color? iconColor,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 140.w,
//         //height: 110.h,
//         padding: EdgeInsets.symmetric(vertical: 14.h),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 40.r,
//               height: 40.r,
//               decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//               child: Center(
//                 child: Image.asset(
//                   icon,
//                   width: 24.r,
//                   height: 24.r,
//                   color: iconColor,
//                 ),
//               ),
//             ),
//             SizedBox(height: 8.h),
//             CustomText(
//               text: label,
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w500,
//               color: AppPalette.darkGreyColor,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildArrow() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.w),
//       child: Icon(Icons.arrow_forward, color: Colors.grey[700], size: 32.r),
//     );
//   }
// }
