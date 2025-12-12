// part of 'home_bloc.dart';
//
// abstract class HomeState extends Equatable {
//   const HomeState();
//   @override
//   List<Object?> get props => [];
// }
//
// class HomeShimmerState extends HomeState {}
//
// class HomeLoadedState extends HomeState {
//   final DashboardAnalyticsEntity data;
//   const HomeLoadedState(this.data);
//   @override
//   List<Object?> get props => [data];
// }
//
// class HomeErrorState extends HomeState {
//   final String message;
//   const HomeErrorState(this.message);
//   @override
//   List<Object?> get props => [message];
// }
//
// class HomeNoDataState extends HomeState {}
//
// // New states for dashboard shortcut management
// class DashboardShortcutsLoadedState extends HomeState {
//   final List<DashboardComponent> availableShortcuts;
//   final List<DashboardComponent> dashboardShortcuts;
//   const DashboardShortcutsLoadedState({
//     required this.availableShortcuts,
//     required this.dashboardShortcuts,
//   });
//   @override
//   List<Object?> get props => [availableShortcuts, dashboardShortcuts];
// }
//
// class DashboardShortcutsErrorState extends HomeState {
//   final String message;
//   const DashboardShortcutsErrorState(this.message);
//   @override
//   List<Object?> get props => [message];
// }
//
// class DashboardShortcutsLoadingState extends HomeState {}
//
// class HomeDashboardWithShortcutsState extends HomeState {
//   final DashboardAnalyticsEntity data;
//   final List<DashboardComponent> dashboardShortcuts;
//   const HomeDashboardWithShortcutsState(this.data, this.dashboardShortcuts);
//
//   @override
//   List<Object?> get props => [data, dashboardShortcuts];
// }


