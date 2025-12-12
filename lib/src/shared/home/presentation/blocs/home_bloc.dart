// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
// import 'package:neuconnectz_dynea/src/core/enums/component_type.dart';
// import 'package:neuconnectz_dynea/src/core/models/dashboard_component_model.dart';
// import 'package:neuconnectz_dynea/src/core/services/session_service.dart';
//
// import '../../domain/entities/dashboard_analytics_entity.dart';
// import '../../domain/usecases/get_dashboard_analytics_usecase.dart';
//
// part 'home_event.dart';
// part 'home_state.dart';
//
// class DashboardAnalyticsBloc extends Bloc<HomeEvent, HomeState> {
//   final GetDashboardAnalyticsUseCase getDashboardAnalyticsUseCase;
//
//   final List<DashboardComponent> allShortcuts = [
//     DashboardComponent(
//       type: ComponentType.stockMovementWorkflow,
//       title: AppTexts.stockMovementWorkflow,
//       subItems: [],
//       isAdded: true,
//     ),
//     DashboardComponent(
//       type: ComponentType.stockTransferOrder,
//       title: AppTexts.stockTransferOrder,
//       subItems:
//           AppTexts.stockTransferOrderOptionsText
//               .map((e) => DashboardSubItem(name: e))
//               .toList(),
//       isAdded: true,
//     ),
//     DashboardComponent(
//       type: ComponentType.purchaseOrder,
//       title: AppTexts.purchaseOrders,
//       subItems:
//           AppTexts.purchaseOrderOptionsText
//               .map((e) => DashboardSubItem(name: e))
//               .toList(),
//       isAdded: true,
//     ),
//     DashboardComponent(
//       type: ComponentType.binToBin,
//       title: AppTexts.binToBin,
//       subItems:
//           AppTexts.binToBinTexts.map((e) => DashboardSubItem(name: e)).toList(),
//       isAdded: true,
//     ),
//     DashboardComponent(
//       type: ComponentType.barChart,
//       title: AppTexts.barChart,
//       subItems: [], // No subitems
//       isAdded: true,
//     ),
//     DashboardComponent(
//       type: ComponentType.pieChart,
//       title: AppTexts.pieChart,
//       subItems: [],
//       isAdded: true,
//     ),
//     DashboardComponent(
//       type: ComponentType.stackedBar,
//       title: AppTexts.stackedBar,
//       subItems: [],
//       isAdded: true,
//     ),
//     DashboardComponent(
//       type: ComponentType.productionOrder,
//       title: AppTexts.productionOrders,
//       subItems:
//           AppTexts.productionOrderOptionsText
//               .map((e) => DashboardSubItem(name: e))
//               .toList(),
//       isAdded: true,
//     ),
//     DashboardComponent(
//       type: ComponentType.purchaseOrderWorkflow,
//       title: AppTexts.purchaseOrderWorkflow,
//       subItems: [],
//       isAdded: true,
//     ),
//   ];
//
//   DashboardAnalyticsBloc({required this.getDashboardAnalyticsUseCase})
//     : super(HomeShimmerState()) {
//     on<LoadDashboardAnalyticsEvent>(_onLoadDashboardAnalytics);
//     on<LoadDashboardShortcutsEvent>(_onLoadDashboardShortcuts);
//     on<RefreshDashboardShortcutsEvent>(_onRefreshDashboardShortcuts);
//     on<AddDashboardShortcutEvent>(_onAddDashboardShortcut);
//     on<RemoveDashboardShortcutEvent>(_onRemoveDashboardShortcut);
//     on<ReorderStockTransferOrderSubItemsEvent>(
//       _onReorderStockTransferOrderSubItems,
//     );
//     on<ReorderPurchaseOrderSubItemsEvent>(_onReorderPurchaseOrderSubItems);
//     on<ReorderBinToBinSubItemsEvent>(_onReorderBinToBinSubItems);
//   }
//
//   Future<List<String>> _getOrInitDashboardShortcutsPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? addedMap = prefs.getStringList('dashboard_shortcuts');
//     // If the list is null, initialize with all shortcuts (first app launch only)
//     if (addedMap == null) {
//       addedMap = [];
//       for (final group in allShortcuts) {
//         if (group.subItems.isEmpty) {
//           // Add the type name for single components
//           debugPrint('INIT KEY: ${group.type.name}');
//           addedMap.add(group.type.name);
//         } else {
//           for (final sub in group.subItems) {
//             final key = '${group.type.name}|${sub.name}';
//             debugPrint('INIT KEY: $key');
//             addedMap.add(key);
//           }
//         }
//       }
//       await prefs.setStringList('dashboard_shortcuts', addedMap);
//     }
//     debugPrint('LOADED KEYS: $addedMap');
//     return addedMap;
//   }
//
//   Future<List<String>> _getDashboardShortcutOrderPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList('dashboard_shortcut_order') ?? [];
//   }
//
//   Future<void> _onLoadDashboardAnalytics(
//     LoadDashboardAnalyticsEvent event,
//     Emitter<HomeState> emit,
//   ) async {
//     emit(HomeShimmerState());
//     final result = await getDashboardAnalyticsUseCase(event.userId);
//
//     DashboardAnalyticsEntity? data;
//     String? failureMessage;
//     result.fold(
//       (failure) => failureMessage = failure.message,
//       (success) => data = success,
//     );
//
//     if (failureMessage != null) {
//       emit(HomeErrorState(failureMessage!));
//       return;
//     }
//
//     if (data == null) {
//       emit(HomeNoDataState());
//       return;
//     }
//
//     final dashboardShortcuts = await _buildDashboardShortcuts();
//     emit(HomeDashboardWithShortcutsState(data!, dashboardShortcuts));
//   }
//
//   Future<List<DashboardComponent>> _buildDashboardShortcuts() async {
//     final addedMap = await _getOrInitDashboardShortcutsPrefs();
//     // Load saved subitem order per group from prefs
//     final prefs = await SharedPreferences.getInstance();
//
//     List<DashboardComponent> dashboardShortcuts = [];
//     for (final group in allShortcuts) {
//       if (group.subItems.isEmpty) {
//         // For single components, check if type name is present
//         if (addedMap.contains(group.type.name)) {
//           dashboardShortcuts.add(
//             DashboardComponent(
//               type: group.type,
//               title: group.title,
//               subItems: [],
//               isAdded: true,
//             ),
//           );
//         }
//       } else {
//         final addedSubItems = <DashboardSubItem>[];
//         for (final sub in group.subItems) {
//           final key = '${group.type.name}|${sub.name}';
//           if (addedMap.contains(key)) {
//             addedSubItems.add(DashboardSubItem(name: sub.name, isAdded: true));
//           }
//         }
//         if (addedSubItems.isNotEmpty) {
//           // Order subitems by saved order for this group if available
//           List<DashboardSubItem> orderedSubItems = addedSubItems;
//           final savedOrder = prefs.getStringList(
//             'dashboard_shortcut_order_${group.type.name}',
//           );
//           if (savedOrder != null && savedOrder.isNotEmpty) {
//             orderedSubItems = [
//               ...savedOrder
//                   .where(
//                     (name) => addedSubItems.any((item) => item.name == name),
//                   )
//                   .map(
//                     (name) =>
//                         addedSubItems.firstWhere((item) => item.name == name),
//                   ),
//             ];
//             // Add any subitems not in the saved order at the end
//             orderedSubItems.addAll(
//               addedSubItems.where((item) => !savedOrder.contains(item.name)),
//             );
//           }
//           dashboardShortcuts.add(
//             DashboardComponent(
//               type: group.type,
//               title: group.title,
//               subItems: orderedSubItems,
//               isAdded: true,
//             ),
//           );
//         }
//       }
//     }
//     // Restore order if saved
//     final order = await _getDashboardShortcutOrderPrefs();
//     if (order.isNotEmpty) {
//       dashboardShortcuts.sort((a, b) {
//         int indexA = order.indexOf(a.type.name);
//         int indexB = order.indexOf(b.type.name);
//         if (indexA == -1) indexA = order.length;
//         if (indexB == -1) indexB = order.length;
//         return indexA.compareTo(indexB);
//       });
//     }
//     return dashboardShortcuts;
//   }
//
//   Future<void> _onLoadDashboardShortcuts(
//     LoadDashboardShortcutsEvent event,
//     Emitter<HomeState> emit,
//   ) async {
//     emit(DashboardShortcutsLoadingState());
//     final addedMap = await _getOrInitDashboardShortcutsPrefs();
//     List<DashboardComponent> allSheetShortcuts = [];
//     List<DashboardComponent> dashboardShortcuts = [];
//     for (final group in allShortcuts) {
//       final List<DashboardSubItem> subItems = [];
//       final List<DashboardSubItem> addedSubItems = [];
//       for (final sub in group.subItems) {
//         final key = '${group.type.name}|${sub.name}';
//         final isAdded = addedMap.contains(key);
//         subItems.add(DashboardSubItem(name: sub.name, isAdded: isAdded));
//         if (isAdded) {
//           addedSubItems.add(DashboardSubItem(name: sub.name, isAdded: true));
//         }
//       }
//       allSheetShortcuts.add(
//         DashboardComponent(
//           type: group.type,
//           title: group.title,
//           subItems: subItems,
//           isAdded: subItems.any((s) => s.isAdded),
//         ),
//       );
//       if (addedSubItems.isNotEmpty) {
//         dashboardShortcuts.add(
//           DashboardComponent(
//             type: group.type,
//             title: group.title,
//             subItems: addedSubItems,
//             isAdded: true,
//           ),
//         );
//       }
//     }
//     emit(
//       DashboardShortcutsLoadedState(
//         availableShortcuts: allSheetShortcuts,
//         dashboardShortcuts: dashboardShortcuts,
//       ),
//     );
//   }
//
//   Future<void> _onRefreshDashboardShortcuts(
//     RefreshDashboardShortcutsEvent event,
//     Emitter<HomeState> emit,
//   ) async {
//     // If current state has analytics data, keep it; otherwise do not fetch.
//     DashboardAnalyticsEntity? currentData;
//     if (state is HomeDashboardWithShortcutsState) {
//       currentData = (state as HomeDashboardWithShortcutsState).data;
//     }
//     final newShortcuts = await _buildDashboardShortcuts();
//     if (currentData != null) {
//       emit(HomeDashboardWithShortcutsState(currentData, newShortcuts));
//     } else {
//       emit(
//         DashboardShortcutsLoadedState(
//           availableShortcuts:
//               allShortcuts
//                   .map(
//                     (g) => DashboardComponent(
//                       type: g.type,
//                       title: g.title,
//                       subItems: g.subItems,
//                       isAdded: g.isAdded,
//                     ),
//                   )
//                   .toList(),
//           dashboardShortcuts: newShortcuts,
//         ),
//       );
//     }
//   }
//
//   Future<void> _onAddDashboardShortcut(
//     AddDashboardShortcutEvent event,
//     Emitter<HomeState> emit,
//   ) async {
//     final prefs = await SharedPreferences.getInstance();
//     final addedMap = prefs.getStringList('dashboard_shortcuts') ?? [];
//     for (final sub in event.subItems) {
//       final key = '${event.group}|$sub';
//       debugPrint('ADD KEY: $key');
//       if (!addedMap.contains(key)) {
//         addedMap.add(key);
//       }
//     }
//     await prefs.setStringList('dashboard_shortcuts', addedMap);
//     // Always reload analytics/dashboard after shortcut change
//     final userId = SessionManager.userId;
//     add(LoadDashboardAnalyticsEvent(userId ?? ""));
//   }
//
//   Future<void> _onRemoveDashboardShortcut(
//     RemoveDashboardShortcutEvent event,
//     Emitter<HomeState> emit,
//   ) async {
//     // Ensure we have data to work with
//     if (state is! HomeDashboardWithShortcutsState) {
//       // Fallback to full reload if we're in a weird state
//       final userId = SessionManager.userId;
//       add(LoadDashboardAnalyticsEvent(userId ?? ""));
//       return;
//     }
//     final currentState = state as HomeDashboardWithShortcutsState;
//     final currentData = currentState.data;
//
//     final prefs = await SharedPreferences.getInstance();
//     final addedMap = prefs.getStringList('dashboard_shortcuts') ?? [];
//     for (final sub in event.subItems) {
//       String key;
//       if (sub == event.group) {
//         key = event.group;
//       } else {
//         key = '${event.group}|$sub';
//       }
//       addedMap.remove(key);
//     }
//     await prefs.setStringList('dashboard_shortcuts', addedMap);
//
//     final newDashboardShortcuts = await _buildDashboardShortcuts();
//
//     emit(HomeDashboardWithShortcutsState(currentData, newDashboardShortcuts));
//   }
//
//   Future<void> _onReorderStockTransferOrderSubItems(
//     ReorderStockTransferOrderSubItemsEvent event,
//     Emitter<HomeState> emit,
//   ) async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = 'dashboard_shortcut_order_${event.group}';
//     await prefs.setStringList(key, event.newOrder);
//
//     debugPrint('[BLoC] Reorder event for group: ${event.group}');
//     debugPrint('[BLoC] New subitem order: ${event.newOrder}');
//     if (state is HomeDashboardWithShortcutsState) {
//       final currentState = state as HomeDashboardWithShortcutsState;
//       final updatedShortcuts =
//           currentState.dashboardShortcuts.map((component) {
//             if (component.type.name == event.group) {
//               final reordered = [
//                 ...event.newOrder
//                     .where(
//                       (name) =>
//                           component.subItems.any((item) => item.name == name),
//                     )
//                     .map(
//                       (name) => component.subItems.firstWhere(
//                         (item) => item.name == name,
//                       ),
//                     ),
//                 ...component.subItems.where(
//                   (item) => !event.newOrder.contains(item.name),
//                 ),
//               ];
//               debugPrint(
//                 '[BLoC] Updated subitems for ${component.type.name}: ${reordered.map((e) => e.name).toList()}',
//               );
//               return DashboardComponent(
//                 type: component.type,
//                 title: component.title,
//                 subItems: reordered,
//                 isAdded: component.isAdded,
//               );
//             }
//             return component;
//           }).toList();
//
//       debugPrint('[BLoC] Emitting new dashboardShortcuts:');
//       for (final comp in updatedShortcuts) {
//         debugPrint(
//           '  ${comp.type.name}: ${comp.subItems.map((e) => e.name).toList()}',
//         );
//       }
//       emit(
//         HomeDashboardWithShortcutsState(currentState.data, updatedShortcuts),
//       );
//       debugPrint('[BLoC] State emitted!');
//     }
//     // Do NOT reload analytics here!
//   }
//
//   Future<void> _onReorderPurchaseOrderSubItems(
//     ReorderPurchaseOrderSubItemsEvent event,
//     Emitter<HomeState> emit,
//   ) async {
//     final prefs = await SharedPreferences.getInstance();
//     final keyPrefix = '${event.group}|';
//     final shortcuts = prefs.getStringList('dashboard_shortcuts') ?? [];
//     // Remove all subitems for this group
//     final filtered = shortcuts.where((s) => !s.startsWith(keyPrefix)).toList();
//     // Add reordered subitems at the start
//     final reordered = event.newOrder.map((e) => '$keyPrefix$e').toList();
//     final updated = [...reordered, ...filtered];
//     await prefs.setStringList('dashboard_shortcuts', updated);
//     add(LoadDashboardAnalyticsEvent(SessionManager.userId ?? ""));
//   }
//
//   Future<void> _onReorderBinToBinSubItems(
//     ReorderBinToBinSubItemsEvent event,
//     Emitter<HomeState> emit,
//   ) async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = 'dashboard_shortcut_order_${event.group}';
//     await prefs.setStringList(key, event.newOrder);
//
//     if (state is HomeDashboardWithShortcutsState) {
//       final currentState = state as HomeDashboardWithShortcutsState;
//       final updatedShortcuts =
//           currentState.dashboardShortcuts.map((component) {
//             if (component.type.name == event.group) {
//               final reordered = [
//                 ...event.newOrder
//                     .where(
//                       (name) => component.subItems.any((i) => i.name == name),
//                     )
//                     .map(
//                       (name) =>
//                           component.subItems.firstWhere((i) => i.name == name),
//                     ),
//                 ...component.subItems.where(
//                   (i) => !event.newOrder.contains(i.name),
//                 ),
//               ];
//               return DashboardComponent(
//                 type: component.type,
//                 title: component.title,
//                 subItems: reordered,
//                 isAdded: component.isAdded,
//               );
//             }
//             return component;
//           }).toList();
//       emit(
//         HomeDashboardWithShortcutsState(currentState.data, updatedShortcuts),
//       );
//     }
//   }
// }


