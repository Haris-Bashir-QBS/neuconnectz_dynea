class AppRoutes {
  AppRoutes._();
  //============================== Auth ==============================
  static const String splash = 'splash';
  static const String login = 'login';
  static const String signUp = 'signup';
  static const String forgotPassword = 'forgot_password';
  static const String resetPassword = 'reset_password';
  static const String changePassword = 'change_password';
  static const String verifyOtp = 'verify_otp';
  // ============================ Core ==============================
  static const String home = 'home';
  static const String settings = 'settings';
  static const String dashboard = 'dashboard';
  // ============================ Selection ==========================
  static const documentSelection = 'document_selection';
  // =========================== PutAway against GRN ============================
  static const grnListing = 'grn_listing';
  static const grnItems = 'grn_items';
  static const grnQuantity = 'grn_quantity';
  static const completedGrnItemDetail = "completed_grn_item_detail";
  // =========================== Inbound Delivery ============================
  static const inboundDeliveryListing = 'inbound_delivery_listing';
  static const inboundDeliveryItems = 'inbound_delivery_items';
  static const inboundDeliveryQuantity = 'inbound_delivery_quantity';
  static const completedInboundDeliveryItemDetail = "completed_inbound_delivery_item_detail";
  // ============================ Reservation ============================
  static const reservationListing = 'reservation_listing';
  static const reservationItems = 'reservation_items';
  static const reservationQuantity = 'reservation_quantity';
  static const completedReservationItemDetail =
      "completed_reservation_item_detail";

  // ============================ Stock Check =============================
  static const String stockCheck = 'stockCheck';
  static const String outboundDeliveryStoListing = 'outboundDeliveryStoListing';
  static const String outboundDeliveryStoItemsListing =
      'outboundDeliveryStoItemsListing';
  static const String outboundDeliveryStoQuantity = 'outbound_delivery_sto_quantity';
  static const String completedOutboundDeliveryStoItemDetail =
      'completed_outbound_delivery_sto_item_detail';
  // ============================ Outbound Delivery (Sales Order) ============================
  static const outboundDeliverySalesListing = 'outbound_delivery_sales_listing';
  static const outboundDeliverySalesItems = 'outbound_delivery_sales_items';
  static const outboundDeliverySalesQuantity = 'outbound_delivery_sales_quantity';
  static const completedOutboundDeliverySalesItemDetail =
      'completed_outbound_delivery_sales_item_detail';
  // ============================ Bin to Bin Transfer ============================
  static const String binTransferReportListing = 'bin_transfer_report_listing';
  static const String binSelection = 'bin_selection';
  static const String sourceBinMaterialListing = 'source_bin_material_listing';
  static const String binToBinQuantity = 'bin_to_bin_quantity';
  static const String destinationBinSelection = 'destination_bin_selection';

  // ============================ Production Receipts ============================
  static const String productionReceiptListing = 'production_receipt_listing';
  static const String productionReceiptItems = 'production_receipt_items';
  static const String productionReceiptQuantity = 'production_receipt_quantity';
  static const String completedProductionReceiptItemDetail = 'completed_production_receipt_item_detail';
}


