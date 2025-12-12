// import 'dart:math' as math;
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:neuconnectz_dynea/src/core/enums/component_type.dart';
// import 'package:neuconnectz_dynea/src/core/models/dashboard_component_model.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/domain/entities/dashboard_analytics_entity.dart';
//
// import '../blocs/home_bloc.dart';
// import 'bar_chart_card.dart';
// import 'bin_to_bin_card.dart';
// import 'pie_chart_card.dart';
// import 'production_order_carousel.dart';
// import 'purchase_order_carousel.dart';
// import 'purchase_order_workflow.dart';
// import 'stacked_bar_chart_card.dart';
// import 'stock_movement_workflow.dart';
// import 'stock_transfer_order_widget.dart';
//
// class DashboardDynamicComponentWidget extends StatelessWidget {
//   final DashboardComponent component;
//
//   final DashboardAnalyticsEntity? data;
//   final bool isAnimation;
//   final AnimationController? animationController;
//
//   const DashboardDynamicComponentWidget({
//     super.key,
//     required this.component,
//     required this.data,
//     this.isAnimation = false,
//     this.animationController,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     Widget child;
//     final homeState = context.watch<DashboardAnalyticsBloc>().state;
//     List<DashboardComponent> shortcutList = [];
//     if (homeState is HomeDashboardWithShortcutsState) {
//       shortcutList = homeState.dashboardShortcuts;
//     } else if (homeState is DashboardShortcutsLoadedState) {
//       shortcutList = homeState.dashboardShortcuts;
//     }
//     switch (component.type) {
//       case ComponentType.stockTransferOrder:
//         if (data?.transferStatistics != null) {
//           final stockTransferComponent = shortcutList.firstWhere(
//             (c) => c.type == ComponentType.stockTransferOrder,
//             orElse: () => component,
//           );
//           child = StockTransferOrderWidget(
//             transferStatisticsEntity: data!.transferStatistics!,
//             visibleSubItems:
//                 stockTransferComponent.subItems.map((e) => e.name).toList(),
//             onRemoveSubitem: (_) {},
//             onReorder: (newOrder) {
//               BlocProvider.of<DashboardAnalyticsBloc>(context).add(
//                 ReorderStockTransferOrderSubItemsEvent(
//                   group: component.type.name,
//                   newOrder: newOrder,
//                 ),
//               );
//             },
//             editMode: isAnimation,
//           );
//         } else {
//           child = const SizedBox.shrink();
//         }
//         break;
//       case ComponentType.purchaseOrder:
//         if (data?.grnStatistics != null) {
//           child = PurchaseOrderCarousel(
//             grnStatisticsModel: data!.grnStatistics!,
//             visibleSubItems: component.subItems.map((e) => e.name).toList(),
//             onReorder: (newOrder) {
//               BlocProvider.of<DashboardAnalyticsBloc>(context).add(
//                 ReorderPurchaseOrderSubItemsEvent(
//                   group: component.type.name,
//                   newOrder: newOrder,
//                 ),
//               );
//             },
//             onRemoveSubitem: (subitemName) {
//               BlocProvider.of<DashboardAnalyticsBloc>(context).add(
//                 RemoveDashboardShortcutEvent(
//                   group: component.type.name,
//                   subItems: [subitemName],
//                 ),
//               );
//             },
//           );
//         } else {
//           child = const SizedBox.shrink();
//         }
//         break;
//       case ComponentType.binToBin:
//         final binToBinComponent = shortcutList.firstWhere(
//           (c) => c.type == ComponentType.binToBin,
//           orElse: () => component,
//         );
//         child = BinToBinCard(
//           visibleSubItems:
//               binToBinComponent.subItems.map((e) => e.name).toList(),
//           onReorder: (newOrder) {
//             BlocProvider.of<DashboardAnalyticsBloc>(context).add(
//               ReorderBinToBinSubItemsEvent(
//                 group: component.type.name,
//                 newOrder: newOrder,
//               ),
//             );
//           },
//         );
//         break;
//       case ComponentType.productionOrder:
//         child = ProductionOrderCarousel(
//           visibleSubItems: component.subItems.map((e) => e.name).toList(),
//         );
//         break;
//       case ComponentType.barChart:
//         child = const BarChartCard();
//         break;
//       case ComponentType.pieChart:
//         child = const PieChartCard();
//         break;
//       case ComponentType.stackedBar:
//         child = const StackedBarChartCard();
//         break;
//       case ComponentType.stockMovementWorkflow:
//         child = const StockMovementWorkflow();
//         break;
//       case ComponentType.purchaseOrderWorkflow:
//         child = const PurchaseOrderWorkflow();
//         break;
//     }
//     if (isAnimation && animationController != null) {
//       return AnimatedBuilder(
//         animation: animationController!,
//         builder: (context, widgetChild) {
//           return Transform.rotate(
//             angle:
//                 isAnimation
//                     ? math.sin(animationController!.value * 2 * math.pi) * 0.008
//                     : 0,
//             child: widgetChild,
//           );
//         },
//         child: child,
//       );
//     } else {
//       return child;
//     }
//   }
// }


