// import 'dart:math' as math;
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:logger/logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:neuconnectz_dynea/src/core/enums/component_type.dart';
// import 'package:neuconnectz_dynea/src/core/models/dashboard_component_model.dart';
// import 'package:neuconnectz_dynea/src/core/services/session_service.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/domain/entities/dashboard_analytics_entity.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/blocs/home_bloc.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/add_shortcut_bottom_sheet.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/dashboard_dynamic_component_widget.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/dashboard_error_widget.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/empty_dashboard_shortcuts_widget.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/purchase_order_carousel.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/stock_slider_widget.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/stock_transfer_order_widget.dart';
//
// import '../../../../../core/utils/utils.dart';
// import '../widgets/home_dashboard_shimmer.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
//   bool _isEditMode = false;
//   late AnimationController _shakeController;
//   final Map<ComponentType, AnimationController> _shakeControllers = {};
//   List<String>? _optimisticStockTransferOrder;
//   final Map<String, List<String>> _optimisticSubItemLists = {};
//   final List<ComponentType> _optimisticRemovedComponents = [];
//   List<String>? _optimisticComponentOrder;
//
//   @override
//   void initState() {
//     super.initState();
//     _shakeController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _loadComponentOrder();
//     _fetchDashboardAnalyticsEvent();
//   }
//
//   Future<void> _saveComponentOrder(List<DashboardComponent> components) async {
//     final prefs = await SharedPreferences.getInstance();
//     final order = components.map((c) => c.type.name).toList();
//     await prefs.setStringList('dashboard_shortcut_order', order);
//     debugPrint('Saved dashboard_shortcut_order: $order');
//     Logger().i("Saved dashboard_shortcut_order: $order");
//   }
//
//   Future<void> _loadComponentOrder() async {
//     final prefs = await SharedPreferences.getInstance();
//     final saved = prefs.getStringList('dashboard_shortcut_order');
//     if (saved != null && mounted) {
//       setState(() {
//         _optimisticComponentOrder = saved;
//       });
//     }
//   }
//
//   void _toggleEditMode() {
//     setState(() {
//       _isEditMode = !_isEditMode;
//       if (_isEditMode) {
//         _shakeController.repeat(reverse: true);
//       } else {
//         _shakeController.stop();
//         for (var controller in _shakeControllers.values) {
//           controller.stop();
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<DashboardAnalyticsBloc, HomeState>(
//       builder: (context, state) {
//         if (state is HomeDashboardWithShortcutsState) {
//           final dashboardShortcuts = state.dashboardShortcuts;
//           return _buildDashboard(state.data, dashboardShortcuts);
//         } else if (state is DashboardShortcutsLoadedState) {
//           final dashboardShortcuts = state.dashboardShortcuts;
//           return _buildDashboard(null, dashboardShortcuts);
//         } else if (state is HomeShimmerState) {
//           return _sliderWithShimmer();
//         } else if (state is HomeErrorState) {
//           return _dashboardErrorWidget(state);
//         } else if (state is HomeNoDataState) {
//           return _sliderWithShimmer();
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }
//
//   Widget _dashboardErrorWidget(HomeErrorState state) {
//     return DashboardErrorWidget(
//       message: state.message,
//       onRetry: _fetchDashboardAnalyticsEvent,
//     );
//   }
//
//   Widget _sliderWithShimmer() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10.w),
//       child: Column(
//         children: [
//           SizedBox(height: 16.h),
//           StockSliderWidget(),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.w),
//               child: HomeDashboardShimmer(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDashboard(
//     DashboardAnalyticsEntity? data,
//     List<DashboardComponent> dashboardShortcuts,
//   ) {
//     final filteredShortcuts =
//         dashboardShortcuts
//             .where((c) => !_optimisticRemovedComponents.contains(c.type))
//             .toList();
//     // Apply optimistic/saved order if available
//     final orderedShortcuts = List<DashboardComponent>.from(filteredShortcuts);
//     final savedOrder = _optimisticComponentOrder;
//     if (savedOrder != null && savedOrder.isNotEmpty) {
//       final unknown =
//           orderedShortcuts
//               .where((c) => !savedOrder.contains(c.type.name))
//               .toList();
//       final known =
//           orderedShortcuts
//               .where((c) => savedOrder.contains(c.type.name))
//               .toList()
//             ..sort((a, b) {
//               final aIndex = savedOrder.indexOf(a.type.name);
//               final bIndex = savedOrder.indexOf(b.type.name);
//               return aIndex.compareTo(bIndex);
//             });
//       orderedShortcuts
//         ..clear()
//         ..addAll(unknown)
//         ..addAll(known);
//     }
//     return GestureDetector(
//       onTap: () {
//         if (_isEditMode) {
//           _toggleEditMode();
//         }
//       },
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10.w),
//         child: Column(
//           children: [
//             16.verticalSpace,
//             StockSliderWidget(),
//             16.verticalSpace,
//             if (filteredShortcuts.isEmpty)
//               Expanded(
//                 child: EmptyDashboardShortcutsWidget(
//                   onAddPressed: _openAddShortcutSheet,
//                 ),
//               )
//             else
//               _componentsList(data, orderedShortcuts),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _componentsList(
//     DashboardAnalyticsEntity? data,
//     List<DashboardComponent> dashboardShortcuts,
//   ) {
//     return Expanded(
//       child: ReorderableListView(
//         padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 24.h),
//         onReorder: (oldIndex, newIndex) async {
//           setState(() {
//             if (newIndex > oldIndex) {
//               newIndex -= 1;
//             }
//             final item = dashboardShortcuts.removeAt(oldIndex);
//             dashboardShortcuts.insert(newIndex, item);
//             _isEditMode = false;
//             _shakeController.stop();
//             for (var controller in _shakeControllers.values) {
//               controller.stop();
//             }
//             _optimisticComponentOrder =
//                 dashboardShortcuts.map((c) => c.type.name).toList();
//           });
//           await _saveComponentOrder(dashboardShortcuts);
//         },
//         onReorderStart: (index) {
//           if (!_isEditMode) {
//             _toggleEditMode();
//           }
//         },
//         children: [
//           ...dashboardShortcuts.map((component) {
//             return _component(component, data, dashboardShortcuts);
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _component(
//     DashboardComponent component,
//     DashboardAnalyticsEntity? data, [
//     List<DashboardComponent>? dashboardShortcuts,
//   ]) {
//     return Material(
//       key: ValueKey('padding_${component.type.toString()}'),
//       color: Colors.transparent,
//       shadowColor: Colors.transparent,
//       elevation: 0,
//       borderRadius: BorderRadius.circular(8.r),
//       child: Stack(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(bottom: 10),
//             child:
//                 component.type == ComponentType.stockTransferOrder
//                     ? AnimatedBuilder(
//                       animation: _shakeController,
//                       builder:
//                           (context, child) => Transform.rotate(
//                             angle:
//                                 _isEditMode
//                                     ? math.sin(
//                                           _shakeController.value * 2 * math.pi,
//                                         ) *
//                                         0.008
//                                     : 0,
//                             child: child,
//                           ),
//                       child: Builder(
//                         builder: (context) {
//                           final visibleSubItems =
//                               _optimisticStockTransferOrder ??
//                               component.subItems.map((e) => e.name).toList();
//                           return StockTransferOrderWidget(
//                             transferStatisticsEntity: data!.transferStatistics!,
//                             visibleSubItems: visibleSubItems,
//                             onReorder: (newOrder) {
//                               setState(() {
//                                 _optimisticStockTransferOrder = newOrder;
//                               });
//                               BlocProvider.of<DashboardAnalyticsBloc>(
//                                 context,
//                               ).add(
//                                 ReorderStockTransferOrderSubItemsEvent(
//                                   group: component.type.name,
//                                   newOrder: newOrder,
//                                 ),
//                               );
//                             },
//                             onRemoveSubitem: (subitemName) {
//                               BlocProvider.of<DashboardAnalyticsBloc>(
//                                 context,
//                               ).add(
//                                 RemoveDashboardShortcutEvent(
//                                   group: component.type.name,
//                                   subItems: [subitemName],
//                                 ),
//                               );
//                             },
//                             editMode: _isEditMode,
//                           );
//                         },
//                       ),
//                     )
//                     : component.type == ComponentType.purchaseOrder
//                     ? AnimatedBuilder(
//                       animation: _shakeController,
//                       builder:
//                           (context, child) => Transform.rotate(
//                             angle:
//                                 _isEditMode
//                                     ? math.sin(
//                                           _shakeController.value * 2 * math.pi,
//                                         ) *
//                                         0.008
//                                     : 0,
//                             child: child,
//                           ),
//                       child: Builder(
//                         builder: (context) {
//                           final visibleSubItems =
//                               _optimisticSubItemLists[component.type.name] ??
//                               component.subItems.map((e) => e.name).toList();
//                           return PurchaseOrderCarousel(
//                             grnStatisticsModel: data!.grnStatistics!,
//                             visibleSubItems: visibleSubItems,
//                             onReorder: (newOrder) {
//                               // Not implemented for this component
//                             },
//                             onRemoveSubitem: (subitemName) {
//                               final currentList =
//                                   _optimisticSubItemLists[component
//                                       .type
//                                       .name] ??
//                                   component.subItems
//                                       .map((e) => e.name)
//                                       .toList();
//                               final newList = List<String>.from(currentList)
//                                 ..remove(subitemName);
//                               setState(() {
//                                 _optimisticSubItemLists[component.type.name] =
//                                     newList;
//                               });
//                               BlocProvider.of<DashboardAnalyticsBloc>(
//                                 context,
//                               ).add(
//                                 RemoveDashboardShortcutEvent(
//                                   group: component.type.name,
//                                   subItems: [subitemName],
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     )
//                     : DashboardDynamicComponentWidget(
//                       component: component,
//                       data: data,
//                       isAnimation: _isEditMode,
//                       animationController:
//                           _shakeControllers[component.type] ?? _shakeController,
//                     ),
//           ),
//           if (_isEditMode)
//             _removeComponentWidget(component, dashboardShortcuts),
//         ],
//       ),
//     );
//   }
//
//   Widget _removeComponentWidget(
//     DashboardComponent component,
//     List<DashboardComponent>? dashboardShortcuts,
//   ) {
//     return Utils.removeComponentWidget(
//       component: component,
//       onRemove: () {
//         _removeDashboardShortcutEvent(component);
//         if ((dashboardShortcuts?.length ?? 1) <= 1) {
//           setState(() {
//             _isEditMode = false;
//           });
//         }
//       },
//     );
//   }
//
//   void _openAddShortcutSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       builder: (BuildContext context) {
//         return AddShortcutBottomSheet();
//       },
//     );
//   }
//
//   /// ======================= Events ======================
//
//   void _removeDashboardShortcutEvent(DashboardComponent component) {
//     setState(() {
//       _optimisticRemovedComponents.add(component.type);
//     });
//     context.read<DashboardAnalyticsBloc>().add(
//       RemoveDashboardShortcutEvent(
//         group: component.type.name,
//         subItems:
//             component.subItems.isEmpty
//                 ? [component.type.name]
//                 : component.subItems.map((e) => e.name).toList(),
//       ),
//     );
//   }
//
//   void _fetchDashboardAnalyticsEvent() {
//     final userId = SessionManager.userId;
//     context.read<DashboardAnalyticsBloc>().add(
//       LoadDashboardAnalyticsEvent(userId ?? ""),
//     );
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final homeState = context.watch<DashboardAnalyticsBloc>().state;
//     if (homeState is HomeDashboardWithShortcutsState ||
//         homeState is DashboardShortcutsLoadedState) {
//       _optimisticStockTransferOrder = null;
//       _optimisticSubItemLists.clear();
//       _optimisticRemovedComponents.clear();
//     }
//   }
//
//   @override
//   void dispose() {
//     _shakeController.dispose();
//     for (var controller in _shakeControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
