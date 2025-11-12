// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:neuconnectz_dynea/src/core/models/stock_transfer_order_model.dart';
// import 'package:neuconnectz_dynea/src/core/utils/app_static_data.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/domain/entities/dashboard_analytics_entity.dart';
//
// import '../../../../../core/constants/app_palette.dart';
// import '../../../../../core/constants/app_texts.dart';
// import '../../../../../widgets/custom_text.dart';
//
// class StockTransferOrderWidget extends StatefulWidget {
//   final TransferStatisticsEntity transferStatisticsEntity;
//   final List<String> visibleSubItems;
//   final bool editMode;
//   final void Function(List<String> newOrder) onReorder;
//   final void Function(String subitemName) onRemoveSubitem;
//   const StockTransferOrderWidget({
//     super.key,
//     required this.transferStatisticsEntity,
//     required this.visibleSubItems,
//     required this.onReorder,
//     required this.onRemoveSubitem,
//     this.editMode = false,
//   });
//
//   @override
//   State<StockTransferOrderWidget> createState() =>
//       _StockTransferOrderWidgetState();
// }
//
// class _StockTransferOrderWidgetState extends State<StockTransferOrderWidget> {
//   int? _activeRemoveIndex;
//
//   List<StockTransferOrderModel> _buildModels() {
//     return widget.visibleSubItems.map((title) {
//       final order = AppStaticData.stockTransferOrders.firstWhere(
//         (order) => order.title == title,
//       );
//       final index = AppStaticData.stockTransferOrders.indexOf(order);
//       return order.copyWith(
//         description:
//             [
//               widget.transferStatisticsEntity.totalItrPending.toString(),
//               widget.transferStatisticsEntity.totalItPending.toString(),
//               widget.transferStatisticsEntity.totalTrPending.toString(),
//               widget.transferStatisticsEntity.totalItrIntegrated.toString(),
//               widget.transferStatisticsEntity.totalItIntegrated.toString(),
//               widget.transferStatisticsEntity.totalTrIntegrated.toString(),
//             ][index],
//       );
//     }).toList();
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
//     final updatedModels = _buildModels();
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomText(
//             text: AppTexts.stockTransferOrder,
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: AppPalette.darkGreyColor,
//           ),
//           12.verticalSpace,
//           if (updatedModels.isEmpty)
//             CustomText(
//               text: 'No shortcuts added.',
//               fontSize: 14.sp,
//               color: AppPalette.greyColor,
//             ),
//           if (updatedModels.isNotEmpty)
//             ReorderableListView(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               onReorder: (oldIndex, newIndex) {
//                 final newOrder = List<String>.from(widget.visibleSubItems);
//                 if (newIndex > oldIndex) newIndex -= 1;
//                 final item = newOrder.removeAt(oldIndex);
//                 newOrder.insert(newIndex, item);
//                 setState(() {
//                   _activeRemoveIndex = null; // Close remove icon after drop
//                 });
//                 widget.onReorder(newOrder);
//               },
//               children: [
//                 for (int index = 0; index < updatedModels.length; index++)
//                   GestureDetector(
//                     key: ValueKey(updatedModels[index].id),
//                     onTap: () => _handleTap(index),
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(
//                             bottom: index == updatedModels.length - 1 ? 0 : 4.h,
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12.w,
//                             vertical: 8.h,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppPalette.stockTransferOrderColor.withAlpha(
//                               150,
//                             ),
//                             borderRadius: BorderRadius.circular(16.r),
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 45.w,
//                                 height: 45.h,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       updatedModels[index]
//                                           .leadingIconBackgroundColor,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Transform.scale(
//                                   scale: 0.6,
//                                   child: Image.asset(
//                                     updatedModels[index].leadingIconPath,
//                                     width: 10,
//                                     height: 10,
//                                   ),
//                                 ),
//                               ),
//                               10.horizontalSpace,
//                               CustomText(
//                                 text: updatedModels[index].title,
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppPalette.darkGreyColor,
//                               ),
//                               Spacer(),
//                               CustomText(
//                                 text: updatedModels[index].description,
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppPalette.darkGreyColor,
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (_activeRemoveIndex == index)
//                           Positioned(
//                             top: -10,
//                             right: -10,
//
//                             child: GestureDetector(
//                               onTap: () {
//                                 widget.onRemoveSubitem(
//                                   updatedModels[index].title,
//                                 );
//                                 setState(() {
//                                   _activeRemoveIndex = null;
//                                 });
//                               },
//                               child: Container(
//                                 width: 28,
//                                 height: 28,
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black12,
//                                       blurRadius: 4,
//                                       offset: Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Icon(
//                                   Icons.remove,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }
