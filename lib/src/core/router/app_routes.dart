import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/pages/completed_grn_item_detail_page.dart';

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
  static const completedGrnItemDetail = "completed_grn_item_detail";
  // ============================ Reservation ============================
  static const reservationListing = 'reservation_listing';
  static const reservationItems = 'reservation_items';
  static const completedReservationItemDetail =
      "completed_reservation_item_detail";

  // ============================ Stock Check =============================
  static const String stockCheck = 'stockCheck';
  static const String outboundDeliveryStoListing = 'outboundDeliveryStoListing';
  static const String outboundDeliveryStoItemsListing =
      'outboundDeliveryStoItemsListing';
}
