import 'package:flutter/material.dart';
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
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/pages/outbound_delivery_sto_items_page.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/pages/outbound_delivery_sto_list_page.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/pages/outbound_delivery_sto_quantity_page.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/pages/completed_outbound_delivery_sto_detail_page.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/pages/completed_inbound_delivery_item_detail_page.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/pages/inbound_delivery_items_page.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/pages/inbound_delivery_listing_page.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/pages/inbound_delivery_quantity_page.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/params/inbound_delivery_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/params/inbound_delivery_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/params/inbound_delivery_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/pages/completed_production_receipt_item_detail_page.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/pages/production_receipt_items_page.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/pages/production_receipt_listing_page.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/pages/production_receipt_quantity_page.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/params/production_receipt_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/params/production_receipt_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/params/production_receipt_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/params/outbound_delivery_sto_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/params/outbound_delivery_sto_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/pages/completed_purchase_order_grn_item_detail_page.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/pages/purchase_order_grn_items_page.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/pages/purchase_order_grn_listing_page.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/pages/purchase_order_grn_quantity_page.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/params/purchase_order_grn_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/params/purchase_order_grn_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/params/purchase_order_grn_quantity_page_params.dart';
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
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/pages/outbound_delivery_sales_quantity_page.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/params/outbound_delivery_sales_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/params/outbound_delivery_sales_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/params/outbound_delivery_sales_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/pages/bin_selection_page.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/pages/bin_to_bin_quantity_page.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/pages/bin_transfer_report_listing_page.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/pages/destination_bin_selection_page.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/pages/source_bin_material_listing_page.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/bin_selection_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/bin_to_bin_quantity_bottom_sheet_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/destination_bin_selection_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/source_bin_material_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/pages/dashboard_page.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/pages/settings_page.dart';
import 'package:neuconnectz_dynea/src/shared/selection/pages/document_selection_page.dart';
import 'package:neuconnectz_dynea/src/shared/selection/params/document_selection_params.dart';
import 'package:neuconnectz_dynea/src/widgets/connectivity_overlay.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
final GoRouter appRouter = GoRouter(
  initialLocation: '/${AppRoutes.splash}',
  navigatorKey: SessionManager.navigatorKey,
  observers: [UnFocusOnNavigateObserver(), routeObserver],
  routes: [
    /// ====================== Auth Routes ======================
    ...authRoutes,
    ...putAwayRoutes,
    ...reservationRoutes,
    ...salesOrderRoutes,
    ...binToBinRoutes,

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
      final args = state.extra as PurchaseOrderGrnListingPageParams;
      return PurchaseOrderGrnListingPage(params: args);
    },
  );
}

GoRoute _grnItems() {
  return GoRoute(
    path: '/${AppRoutes.grnItems}',
    name: AppRoutes.grnItems,
    builder: (context, state) {
      final args = state.extra as PurchaseOrderGrnItemsPageParams;
      return PurchaseOrderGrnItemsPage(params: args);
    },
  );
}

GoRoute _grnQuantity() {
  return GoRoute(
    path: '/${AppRoutes.grnQuantity}',
    name: AppRoutes.grnQuantity,
    builder: (context, state) {
      final args = state.extra as PurchaseOrderGrnQuantityPageParams;
      return PurchaseOrderGrnQuantityPage(params: args);
    },
  );
}

GoRoute _completedGrnItemDetail() {
  return GoRoute(
    path: '/${AppRoutes.completedGrnItemDetail}',
    name: AppRoutes.completedGrnItemDetail,
    builder: (context, state) {
      final args = state.extra as PurchaseOrderGrnItemEntity;
      return CompletedPurchaseOrderGrnItemDetailPage(item: args);
    },
  );
}

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

GoRoute _completedOutboundDeliveryStoItemDetail() {
  return GoRoute(
    path: '/${AppRoutes.completedOutboundDeliveryStoItemDetail}',
    name: AppRoutes.completedOutboundDeliveryStoItemDetail,
    builder: (context, state) {
      final item = state.extra as OutboundDeliveryStoItemEntity;
      return CompletedOutboundDeliveryStoDetailPage(item: item);
    },
  );
}

GoRoute _inboundDeliveryListing() {
  return GoRoute(
    path: '/${AppRoutes.inboundDeliveryListing}',
    name: AppRoutes.inboundDeliveryListing,
    builder: (context, state) {
      final args = state.extra as InboundDeliveryListingPageParams;
      return InboundDeliveryListingPage(params: args);
    },
  );
}

GoRoute _inboundDeliveryItems() {
  return GoRoute(
    path: '/${AppRoutes.inboundDeliveryItems}',
    name: AppRoutes.inboundDeliveryItems,
    builder: (context, state) {
      final args = state.extra as InboundDeliveryItemsPageParams;
      return InboundDeliveryItemsPage(params: args);
    },
  );
}

GoRoute _inboundDeliveryQuantity() {
  return GoRoute(
    path: '/${AppRoutes.inboundDeliveryQuantity}',
    name: AppRoutes.inboundDeliveryQuantity,
    builder: (context, state) {
      final args = state.extra as InboundDeliveryQuantityPageParams;
      return InboundDeliveryQuantityPage(params: args);
    },
  );
}

GoRoute _completedInboundDeliveryItemDetail() {
  return GoRoute(
    path: '/${AppRoutes.completedInboundDeliveryItemDetail}',
    name: AppRoutes.completedInboundDeliveryItemDetail,
    builder: (context, state) {
      final args = state.extra as InboundDeliveryItemEntity;
      return CompletedInboundDeliveryItemDetailPage(item: args);
    },
  );
}

GoRoute _productionReceiptListing() {
  return GoRoute(
    path: '/${AppRoutes.productionReceiptListing}',
    name: AppRoutes.productionReceiptListing,
    builder: (context, state) {
      final args = state.extra as ProductionReceiptListingPageParams;
      return ProductionReceiptListingPage(params: args);
    },
  );
}

GoRoute _productionReceiptItems() {
  return GoRoute(
    path: '/${AppRoutes.productionReceiptItems}',
    name: AppRoutes.productionReceiptItems,
    builder: (context, state) {
      final args = state.extra as ProductionReceiptItemsPageParams;
      return ProductionReceiptItemsPage(params: args);
    },
  );
}

GoRoute _productionReceiptQuantity() {
  return GoRoute(
    path: '/${AppRoutes.productionReceiptQuantity}',
    name: AppRoutes.productionReceiptQuantity,
    builder: (context, state) {
      final args = state.extra as ProductionReceiptQuantityPageParams;
      return ProductionReceiptQuantityPage(params: args);
    },
  );
}

GoRoute _completedProductionReceiptItemDetail() {
  return GoRoute(
    path: '/${AppRoutes.completedProductionReceiptItemDetail}',
    name: AppRoutes.completedProductionReceiptItemDetail,
    builder: (context, state) {
      final args = state.extra as ProductionReceiptItemEntity;
      return CompletedProductionReceiptItemDetailPage(item: args);
    },
  );
}

GoRoute _binTransferReportListing() {
  return GoRoute(
    path: '/${AppRoutes.binTransferReportListing}',
    name: AppRoutes.binTransferReportListing,
    builder: (context, state) => const BinTransferReportListingPage(),
  );
}

GoRoute _binSelection() {
  return GoRoute(
    path: '/${AppRoutes.binSelection}',
    name: AppRoutes.binSelection,
    builder: (context, state) {
      final args = state.extra as BinSelectionPageParams;
      return BinSelectionPage(params: args);
    },
  );
}

GoRoute _sourceBinMaterialListing() {
  return GoRoute(
    path: '/${AppRoutes.sourceBinMaterialListing}',
    name: AppRoutes.sourceBinMaterialListing,
    builder: (context, state) {
      final args = state.extra as SourceBinMaterialListingPageParams;
      return SourceBinMaterialListingPage(params: args);
    },
  );
}

GoRoute _binToBinQuantity() {
  return GoRoute(
    path: '/${AppRoutes.binToBinQuantity}',
    name: AppRoutes.binToBinQuantity,
    builder: (context, state) {
      final args = state.extra as BinToBinQuantityBottomSheetParams;
      return BinToBinQuantityPage(params: args);
    },
  );
}

GoRoute _destinationBinSelection() {
  return GoRoute(
    path: '/${AppRoutes.destinationBinSelection}',
    name: AppRoutes.destinationBinSelection,
    builder: (context, state) {
      final args = state.extra as DestinationBinSelectionPageParams;
      return DestinationBinSelectionPage(params: args);
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

GoRoute _outboundDeliverySalesQuantity() {
  return GoRoute(
    path: '/${AppRoutes.outboundDeliverySalesQuantity}',
    name: AppRoutes.outboundDeliverySalesQuantity,
    builder: (context, state) {
      final args = state.extra as OutboundDeliverySalesQuantityPageParams;
      return OutboundDeliverySalesQuantityPage(params: args);
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

/// ====================== Routes Lists ======================

List<GoRoute> authRoutes = [
  _splash(),
  _login(),
  _verifyOtp(),
  _forgotPassword(),
  _resetPassword(),
  _changePassword(),
  _settings(),
];

List<GoRoute> salesOrderRoutes = [
  _outboundDeliverySalesListing(),
  _outboundDeliverySalesItems(),
  _outboundDeliverySalesQuantity(),
  _completedOutboundDeliverySalesItemDetail(),
];

List<GoRoute> reservationRoutes = [
  _reservationListing(),
  _reservationItems(),
  _reservationQuantity(),
  _completeGrnItemDetails(),
];

List<GoRoute> binToBinRoutes = [
  _binTransferReportListing(),
  _binSelection(),
  _sourceBinMaterialListing(),
  _binToBinQuantity(),
  _destinationBinSelection(),
];

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
  _completedOutboundDeliveryStoItemDetail(),
  _inboundDeliveryListing(),
  _inboundDeliveryItems(),
  _inboundDeliveryQuantity(),
  _completedInboundDeliveryItemDetail(),
  _productionReceiptListing(),
  _productionReceiptItems(),
  _productionReceiptQuantity(),
  _completedProductionReceiptItemDetail(),
];
