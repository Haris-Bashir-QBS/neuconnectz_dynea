// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:neuconnectz_dynea/src/core/utils/app_static_data.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/domain/entities/dashboard_analytics_entity.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/dashboard_card.dart';
//
// import '../../../../../core/constants/app_texts.dart' show AppTexts;
// import 'purchase_order_carousel_item_card.dart';
//
// class PurchaseOrderCarousel extends StatefulWidget {
//   final GrnStatisticsEntity grnStatisticsModel;
//   final List<String> visibleSubItems;
//   final void Function(List<String> newOrder) onReorder;
//   final void Function(String subitemName) onRemoveSubitem;
//   const PurchaseOrderCarousel({
//     super.key,
//     required this.grnStatisticsModel,
//     required this.visibleSubItems,
//     required this.onReorder,
//     required this.onRemoveSubitem,
//   });
//
//   @override
//   State<PurchaseOrderCarousel> createState() => _PurchaseOrderCarouselState();
// }
//
// class _PurchaseOrderCarouselState extends State<PurchaseOrderCarousel> {
//   int? _activeRemoveIndex;
//
//   List<PurchaseOrderCarouselItem> _buildItems() {
//     var values = [
//       widget.grnStatisticsModel.totalGrnPending.toString(),
//       widget.grnStatisticsModel.totalGrnIntegrated.toString(),
//       "-",
//       "-",
//       "-",
//     ];
//
//     final allItems = AppStaticData.purchaseOrderCarouselItems;
//
//     final filteredItems =
//         allItems
//             .asMap()
//             .entries
//             .where(
//               (entry) => widget.visibleSubItems.contains(entry.value.title),
//             )
//             .map((entry) => entry.value.copyWith(value: values[entry.key]))
//             .toList();
//
//     debugPrint("------ PurchaseOrderCarousel Debug ------");
//     debugPrint(
//       "Visible SubItems (${widget.visibleSubItems.length}): ${widget.visibleSubItems}",
//     );
//     debugPrint(
//       "All Available Items (${allItems.length}): ${allItems.map((e) => e.title).toList()}",
//     );
//     debugPrint(
//       "Filtered Items (${filteredItems.length}): ${filteredItems.map((e) => e.title).toList()}",
//     );
//     debugPrint("----------------------------------------");
//
//     return filteredItems;
//   }
//
//   void _handleTap(int index) {
//     setState(() {
//       if (_activeRemoveIndex == index) {
//         _activeRemoveIndex = null;
//       } else {
//         _activeRemoveIndex = index;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final updatedPurchaseOrderCarouselItems = _buildItems();
//     return DashboardCard(
//       title: AppTexts.purchaseOrder,
//       child: SizedBox(
//         height: 90,
//         child:
//             updatedPurchaseOrderCarouselItems.isEmpty
//                 ? Center(child: Text('No shortcuts added.'))
//                 : CarouselSlider(
//                   options: CarouselOptions(
//                     height: 90,
//                     autoPlay: false,
//                     enableInfiniteScroll: false,
//                     padEnds: false,
//                     enlargeCenterPage: false,
//                     viewportFraction: 0.5,
//                   ),
//                   items:
//                       updatedPurchaseOrderCarouselItems.map((item) {
//                         final index = updatedPurchaseOrderCarouselItems.indexOf(
//                           item,
//                         );
//                         return GestureDetector(
//                           onTap: () => _handleTap(index),
//                           child: Stack(
//                             children: [
//                               PurchaseOrderCarouselItemCard(item: item),
//                               if (_activeRemoveIndex == index)
//                                 Positioned(
//                                   top: 0,
//                                   right: 0,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       widget.onRemoveSubitem(item.title);
//                                       setState(() {
//                                         _activeRemoveIndex = null;
//                                       });
//                                     },
//                                     child: const CircleAvatar(
//                                       radius: 12,
//                                       backgroundColor: Colors.red,
//                                       child: Icon(
//                                         Icons.close,
//                                         color: Colors.white,
//                                         size: 16,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                 ),
//       ),
//     );
//   }
// }
