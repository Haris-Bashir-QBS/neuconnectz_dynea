// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:neuconnectz_dynea/src/core/barrels/itr_barrel.dart';
// import 'package:neuconnectz_dynea/src/core/utils/app_static_data.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/dashboard_card.dart';
//
// class ProductionOrderCarousel extends StatelessWidget {
//   final List<String> visibleSubItems;
//   const ProductionOrderCarousel({super.key, required this.visibleSubItems});
//
//   @override
//   Widget build(BuildContext context) {
//     final filteredItems =
//         productionOrderCarouselItems
//             .where((item) => visibleSubItems.contains(item.text))
//             .toList();
//     return DashboardCard(
//       title: AppTexts.productionOrder,
//       child: Container(
//         height: 160,
//         padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child:
//             filteredItems.isEmpty
//                 ? Center(child: Text('No shortcuts added.'))
//                 : CarouselSlider(
//                   options: CarouselOptions(
//                     height: 160,
//                     autoPlay: false,
//                     enableInfiniteScroll: false,
//                     padEnds: false,
//                     enlargeCenterPage: true,
//                     viewportFraction: 0.75,
//                     autoPlayInterval: Duration(seconds: 3),
//                   ),
//                   items:
//                       filteredItems.map((item) {
//                         return Builder(
//                           builder:
//                               (context) => SizedBox(
//                                 width: 260,
//                                 child: ProductionOrderCarouselItemCard(
//                                   item: item,
//                                 ),
//                               ),
//                         );
//                       }).toList(),
//                 ),
//       ),
//     );
//   }
// }
//
// class ProductionOrderCarouselItemCard extends StatelessWidget {
//   final ProductionOrderCarouselItem item;
//   const ProductionOrderCarouselItemCard({super.key, required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 0),
//       decoration: BoxDecoration(
//         color: AppPalette.stockTransferOrderColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               backgroundColor: item.backgroundColor,
//               radius: 20,
//               child: Image.asset(
//                 item.iconPath,
//                 width: 24,
//                 height: 24,
//                 fit: BoxFit.contain,
//                 color: Colors.white,
//               ),
//             ),
//             4.verticalSpace,
//             CustomText(
//               text: item.text,
//               fontWeight: FontWeight.w500,
//               color: AppPalette.greyColor,
//               maxLines: 2,
//               fontSize: 14.sp,
//               textAlign: TextAlign.center,
//             ),
//             4.verticalSpace,
//             CustomText(
//               text: item.value,
//               fontWeight: FontWeight.w600,
//               color: AppPalette.darkGreyColor,
//               fontSize: 18.sp,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


