// import 'package:flutter/material.dart';
// import 'package:neuconnectz_dynea/src/core/barrels/itr_barrel.dart';
// import 'package:neuconnectz_dynea/src/core/utils/app_static_data.dart';
//
// class PurchaseOrderCarouselItemCard extends StatelessWidget {
//   final PurchaseOrderCarouselItem item;
//   const PurchaseOrderCarouselItemCard({super.key, required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 6),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       decoration: BoxDecoration(
//         color: AppPalette.scaffoldBackgroundColor,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             item.title,
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF555555),
//               fontSize: 14.sp,
//             ),
//           ),
//           2.verticalSpace,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CircleAvatar(
//                 backgroundColor: item.backgroundColor,
//                 radius: 16,
//                 child: Image.asset(
//                   item.iconPath,
//                   width: 22,
//                   height: 22,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 item.value ?? "",
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF555555),
//                   fontSize: 22,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
