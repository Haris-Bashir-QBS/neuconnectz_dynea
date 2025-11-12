// part of 'home_bloc.dart';
//
// abstract class HomeEvent extends Equatable {
//   const HomeEvent();
//   @override
//   List<Object?> get props => [];
// }
//
// class LoadDashboardAnalyticsEvent extends HomeEvent {
//   final String userId;
//   const LoadDashboardAnalyticsEvent(this.userId);
//   @override
//   List<Object?> get props => [userId];
// }
//
// // New events for dashboard shortcut management
// class LoadDashboardShortcutsEvent extends HomeEvent {}
//
// // Refresh dashboard shortcuts from local prefs without hitting analytics API
// class RefreshDashboardShortcutsEvent extends HomeEvent {}
//
// class AddDashboardShortcutEvent extends HomeEvent {
//   final String group;
//   final List<String> subItems; // names of sub-items to add
//   const AddDashboardShortcutEvent({
//     required this.group,
//     required this.subItems,
//   });
//   @override
//   List<Object?> get props => [group, subItems];
// }
//
// class RemoveDashboardShortcutEvent extends HomeEvent {
//   final String group;
//   final List<String> subItems; // names of sub-items to remove
//   const RemoveDashboardShortcutEvent({
//     required this.group,
//     required this.subItems,
//   });
//   @override
//   List<Object?> get props => [group, subItems];
// }
//
// class ReorderStockTransferOrderSubItemsEvent extends HomeEvent {
//   final String group;
//   final List<String> newOrder;
//   const ReorderStockTransferOrderSubItemsEvent({
//     required this.group,
//     required this.newOrder,
//   });
//   @override
//   List<Object?> get props => [group, newOrder];
// }
//
// class ReorderPurchaseOrderSubItemsEvent extends HomeEvent {
//   final String group;
//   final List<String> newOrder;
//   const ReorderPurchaseOrderSubItemsEvent({
//     required this.group,
//     required this.newOrder,
//   });
//   @override
//   List<Object?> get props => [group, newOrder];
// }
//
// class ReorderBinToBinSubItemsEvent extends HomeEvent {
//   final String group;
//   final List<String> newOrder;
//   const ReorderBinToBinSubItemsEvent({
//     required this.group,
//     required this.newOrder,
//   });
//   @override
//   List<Object?> get props => [group, newOrder];
// }
