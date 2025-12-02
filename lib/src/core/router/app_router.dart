import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/observers/navigator_observer.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/core/services/session_service.dart';
import 'package:neuconnectz_dynea/src/core/utils/utils.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/params/verify_code_params.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/pages/change_password.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/pages/forget_password_page.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/pages/login_page.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/pages/reset_password.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/pages/splash_page.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/pages/outbound_delivery_sto_items_page.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/pages/outbound_delivery_sto_list_page.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/pages/outbound_delivery_sto_quantity_page.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/pages/completed_grn_item_detail_page.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/params/grn_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/params/grn_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/params/grn_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/pages/grn_items_page.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/pages/grn_listing_page.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/pages/grn_quantity_page.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/params/outbound_delivery_sto_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/params/outbound_delivery_sto_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/pages/completed_reservation_detail_page.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/params/reservation_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/params/reservation_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/pages/reservation_listing_page.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/pages/reservation_items_page.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/pages/reservation_quantity_page.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/presentation/pages/stock_listing_page.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/presentation/params/stock_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/pages/completed_outbound_delivery_sales_detail_page.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/pages/outbound_delivery_sales_items_page.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/pages/outbound_delivery_sales_listing_page.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/params/outbound_delivery_sales_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/params/outbound_delivery_sales_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/pages/dashboard_page.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/pages/settings_page.dart';
import 'package:neuconnectz_dynea/src/shared/selection/pages/document_selection_page.dart';
import 'package:neuconnectz_dynea/src/shared/selection/params/document_selection_params.dart';
import 'package:neuconnectz_dynea/src/widgets/connectivity_overlay.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/${AppRoutes.splash}',
  navigatorKey: SessionManager.navigatorKey,
  observers: [UnFocusOnNavigateObserver()],
  routes: [
    /// ====================== Auth Routes ======================
    ...authRoutes,
    ...putAwayRoutes,
    ...reservationRoutes,
    ...salesOrderRoutes,

    /// ====================== Core Routes ======================
    ShellRoute(
      builder: (context, GoRouterState state, child) {
        if (Utils.isAuthRoute(state.matchedLocation)) {
          return child;
        }
        return ConnectivityOverlay(child: child);
      },
      routes: [_dashboard()],
    ),
  ],
);

List<GoRoute> authRoutes = [
  _splash(),
  _login(),
  _verifyOtp(),
  _forgotPassword(),
  _resetPassword(),
  _changePassword(),
  _settings(),
];

GoRoute _settings() {
  return GoRoute(
    path: '/${AppRoutes.settings}',
    name: AppRoutes.settings,
    builder: (context, state) => SettingsPage(),
  );
}

GoRoute _dashboard() {
  return GoRoute(
    path: '/${AppRoutes.dashboard}',
    name: AppRoutes.dashboard,
    builder: (context, state) => DashboardPage(),
  );
}

GoRoute _login() {
  return GoRoute(
    path: '/${AppRoutes.login}',
    name: AppRoutes.login,
    builder: (context, state) => LoginPage(),
  );
}

GoRoute _splash() {
  return GoRoute(
    path: '/${AppRoutes.splash}',
    name: AppRoutes.splash,
    builder: (context, state) => SplashPage(),
  );
}

GoRoute _changePassword() {
  return GoRoute(
    path: '/${AppRoutes.changePassword}',
    name: AppRoutes.changePassword,
    builder: (context, state) => ChangePasswordPage(),
  );
}

GoRoute _resetPassword() {
  return GoRoute(
    path: '/${AppRoutes.resetPassword}',
    name: AppRoutes.resetPassword,
    builder:
        (context, state) => ResetPasswordPage(email: state.extra as String?),
  );
}

GoRoute _forgotPassword() {
  return GoRoute(
    path: '/${AppRoutes.forgotPassword}',
    name: AppRoutes.forgotPassword,
    builder: (context, state) => ForgetPasswordPage(),
  );
}

GoRoute _verifyOtp() {
  return GoRoute(
    path: '/${AppRoutes.verifyOtp}',
    name: AppRoutes.verifyOtp,
    builder: (context, state) {
      final params = state.extra as VerifyCodeParams;
      return VerifyOtpPage(
        email: params.email ?? '',
        verificationType: params.type,
        user: params.user,
      );
    },
  );
}

GoRoute _documentSelection() {
  return GoRoute(
    path: '/${AppRoutes.documentSelection}',
    name: AppRoutes.documentSelection,
    builder: (context, state) {
      final params =
          state.extra as DocumentSelectionParams? ??
          DocumentSelectionConfigs.grn();
      return DocumentSelectionPage(params: params);
    },
  );
}

GoRoute _grnListing() {
  return GoRoute(
    path: '/${AppRoutes.grnListing}',
    name: AppRoutes.grnListing,
    builder: (context, state) {
      final args = state.extra as GrnListingPageParams;
      return GrnListingPage(params: args);
    },
  );
}

GoRoute _grnItems() {
  return GoRoute(
    path: '/${AppRoutes.grnItems}',
    name: AppRoutes.grnItems,
    builder: (context, state) {
      final args = state.extra as GrnItemsPageParams;
      return GrnItemsPage(params: args);
    },
  );
}

GoRoute _grnQuantity() {
  return GoRoute(
    path: '/${AppRoutes.grnQuantity}',
    name: AppRoutes.grnQuantity,
    builder: (context, state) {
      final args = state.extra as GrnQuantityPageParams;
      return GrnQuantityPage(params: args);
    },
  );
}

GoRoute _completedGrnItemDetail() {
  return GoRoute(
    path: '/${AppRoutes.completedGrnItemDetail}',
    name: AppRoutes.completedGrnItemDetail,
    builder: (context, state) {
      final args = state.extra as GrnItemEntity;
      return CompletedGrnItemDetailPage(item: args);
    },
  );
}

List<GoRoute> putAwayRoutes = [
  _documentSelection(),
  _grnListing(),
  _grnItems(),
  _grnQuantity(),
  _stockCheck(),
  _completedGrnItemDetail(),
  _outboundDeliveryStoListing(),
      _outboundDeliveryStoItems(),
      _outboundDeliveryStoQuantity(),
];

GoRoute _outboundDeliveryStoListing() {
  return GoRoute(
    path: '/${AppRoutes.outboundDeliveryStoListing}',
    name: AppRoutes.outboundDeliveryStoListing,
    builder: (context, state) {
      final args = state.extra as OutboundDeliveryStoListParams;
      return OutboundDeliveryStoListingPage(params: args);
    },
  );
}

GoRoute _outboundDeliveryStoItems() {
  return GoRoute(
    path: '/${AppRoutes.outboundDeliveryStoItemsListing}',
    name: AppRoutes.outboundDeliveryStoItemsListing,
    builder: (context, state) {
      final params = state.extra as OutboundDeliveryStoItemsPageParams;
      return OutboundDeliveryStoItemsPage(params: params);
    },
  );
}

GoRoute _outboundDeliveryStoQuantity() {
  return GoRoute(
    path: '/${AppRoutes.outboundDeliveryStoQuantity}',
    name: AppRoutes.outboundDeliveryStoQuantity,
    builder: (context, state) {
      final params = state.extra as OutboundDeliveryStoQuantityPageParams;
      return OutboundDeliveryStoQuantityPage(params: params);
    },
  );
}

GoRoute _reservationListing() {
  return GoRoute(
    path: '/${AppRoutes.reservationListing}',
    name: AppRoutes.reservationListing,
    builder: (context, state) {
      final args = state.extra as ReservationListingPageParams;
      return ReservationListingPage(params: args);
    },
  );
}

GoRoute _reservationItems() {
  return GoRoute(
    path: '/${AppRoutes.reservationItems}',
    name: AppRoutes.reservationItems,
    builder: (context, state) {
      final args = state.extra as ReservationItemParams;
      return ReservationItemsPage(params: args);
    },
  );
}

GoRoute _reservationQuantity() {
  return GoRoute(
    path: '/${AppRoutes.reservationQuantity}',
    name: AppRoutes.reservationQuantity,
    builder: (context, state) {
      final args = state.extra as ReservationQuantityPageParams;
      return ReservationQuantityPage(params: args);
    },
  );
}

GoRoute _completeGrnItemDetails() {
  return GoRoute(
    path: '/${AppRoutes.completedReservationItemDetail}',
    name: AppRoutes.completedReservationItemDetail,
    builder: (context, state) {
      final args = state.extra as ReservationItemEntity;
      return CompletedReservationDetailPage(item: args);
    },
  );
}

List<GoRoute> reservationRoutes = [
  _reservationListing(),
  _reservationItems(),
  _reservationQuantity(),
  _completeGrnItemDetails(),
];

GoRoute _stockCheck() {
  return GoRoute(
    path: '/${AppRoutes.stockCheck}',
    name: AppRoutes.stockCheck,
    builder: (context, state) {
      final args = state.extra as StockListingPageParams;
      return StockListingPage(params: args);
    },
  );
}

GoRoute _outboundDeliverySalesListing() {
  return GoRoute(
    path: '/${AppRoutes.outboundDeliverySalesListing}',
    name: AppRoutes.outboundDeliverySalesListing,
    builder: (context, state) {
      final args = state.extra as OutboundDeliverySalesListingPageParams;
      return OutboundDeliverySalesListingPage(params: args);
    },
  );
}

GoRoute _outboundDeliverySalesItems() {
  return GoRoute(
    path: '/${AppRoutes.outboundDeliverySalesItems}',
    name: AppRoutes.outboundDeliverySalesItems,
    builder: (context, state) {
      final args = state.extra as OutboundDeliverySalesItemsPageParams;
      return OutboundDeliverySalesItemsPage(params: args);
    },
  );
}

GoRoute _completedOutboundDeliverySalesItemDetail() {
  return GoRoute(
    path: '/${AppRoutes.completedOutboundDeliverySalesItemDetail}',
    name: AppRoutes.completedOutboundDeliverySalesItemDetail,
    builder: (context, state) {
      final args = state.extra as OutboundDeliverySalesItemEntity;
      return CompletedOutboundDeliverySalesDetailPage(item: args);
    },
  );
}

List<GoRoute> salesOrderRoutes = [
  _outboundDeliverySalesListing(),
  _outboundDeliverySalesItems(),
  _completedOutboundDeliverySalesItemDetail(),
];
