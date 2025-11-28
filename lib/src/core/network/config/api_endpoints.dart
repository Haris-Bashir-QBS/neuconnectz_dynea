var _auth = "Auth-Dynea-Stg/IAuthFeature";
var _dashboard = "ZCAPI-Dynea-Stg/IDashboardFeature";
var _putAway = "ZCAPI-Dynea-Stg/IPutAwayFeature";
var _reservation = "ZCAPI-Dynea-Stg/IReservationFeature";
var _movementType = "ZCAPI-Dynea-Stg/IMovementTypeFeature";
var _binManagement = "ZCAPI-Dynea-Stg/IBinManagementFeature";
var _plant = "ZCAPI-Dynea-Stg/IPlantFeature";
var _warehouse = "ZCAPI-Dynea-Stg/IWarehouseFeature";
var _stocks = "ZCAPI-Dynea-Stg/IStocksFeature";

enum ApiEndpoints {
  /// ================= Auth =======================
  signup,
  logout,
  changePassword,
  refreshToken,
  login,

  /// ======================== Forget Password =========================
  forgetPassword,
  verifyOtpForForgetPassword,
  resetPassword,

  /// ==================== 2FA =====================
  get2FASecretKey,
  addOrUpdate2FA,
  remove2FA,
  verifyOtp,

  /// ========================  Dashboard =========================
  getDashboardAnalytics,

  /// ========================  Put Away =========================
  listAllGrDocFromSAP,
  listAllGrItemsFromSAP,
  completedGrnItems,
  listAllBins,
  createPutAwayAgainstGr,

  /// ========================  Reservation =========================
  listAllReservationsFromSAP,
  listAllReservationItemsFromSAP,
  listCompletedReservationItemsFromSAP,
  createPickingAgainstReservation,
  getWarehouseBinsByMaterial,

  /// ========================  Movement Types =========================
  listMovementTypes,

  /// ========================  Stocks =========================
  listStockItems,

  /// ========================  Plant/Warehouse =========================
  listAllPlantsAssignedToUser,
  listAllWarehousesByUserPlants;

  String get value {
    switch (this) {
      /// ================= Authentication =======================
      case ApiEndpoints.signup:
        return "signup";
      case ApiEndpoints.login:
        return "$_auth/login";
      case ApiEndpoints.logout:
        return "logout";
      case ApiEndpoints.refreshToken:
        return "$_auth/RefreshToken";

      /// ==================== 2FA =====================
      case ApiEndpoints.get2FASecretKey:
        return "ExposedGetSecretKey";
      case ApiEndpoints.addOrUpdate2FA:
        return "$_auth/AddOrUpdate2FA";
      case ApiEndpoints.remove2FA:
        return "$_auth/Remove2FA";
      case ApiEndpoints.verifyOtp:
        return "ExposedVerifyCode";

      /// ======================== Forget Password =========================
      case ApiEndpoints.forgetPassword:
        return "$_auth/ForgetPassword";
      case ApiEndpoints.verifyOtpForForgetPassword:
        return "$_auth/VerifyOTP";
      case ApiEndpoints.resetPassword:
        return "$_auth/CreateNewPasswordAfterOTP";
      case ApiEndpoints.changePassword:
        return "$_auth/ChangePassword";

      /// ======================== Get Dashboard Analytics =========================
      case ApiEndpoints.getDashboardAnalytics:
        return "$_dashboard/GetDashboardAnalytics";

      /// ======================== Put Away =========================
      case ApiEndpoints.listAllGrDocFromSAP:
        return "$_putAway/ListAllGrDocFromSAP";
      case ApiEndpoints.listAllGrItemsFromSAP:
        return "$_putAway/ListAllItemsOfGrFromSAP";
      case ApiEndpoints.completedGrnItems:
        return "$_putAway/GetCompletedItemWithBins";
      case ApiEndpoints.listAllBins:
        return "$_binManagement/ListAllBinsByWarehouseAndStorageType";
      case ApiEndpoints.createPutAwayAgainstGr:
        return "$_putAway/CreatePutAwayAgainstGr";

      /// ============================ Reservation =========================
      case ApiEndpoints.listAllReservationsFromSAP:
        return "$_reservation/ListAllReservationsFromSAP";
      case ApiEndpoints.listAllReservationItemsFromSAP:
        return "$_reservation/ListAllItemsOfReservationFromSAP";
      case ApiEndpoints.listCompletedReservationItemsFromSAP:
        return "$_reservation/ListAllCompletedItemsOfReservation";
      case ApiEndpoints.createPickingAgainstReservation:
        return "$_reservation/CreatePickingAgainstReservation";
      case ApiEndpoints.getWarehouseBinsByMaterial:
        return "$_binManagement/GetWarehouseBinsByMaterial";

      /// ======================== Movement Types =========================
      case ApiEndpoints.listMovementTypes:
        return "$_movementType/ListAllMovementTypes";

      /// ======================== Stocks =========================
      case ApiEndpoints.listStockItems:
        return "$_stocks/ListAllStocks";

      /// ======================== Plant/Warehouse =========================
      case ApiEndpoints.listAllPlantsAssignedToUser:
        return "$_plant/ListAllPlantsAssignedToUser";
      case ApiEndpoints.listAllWarehousesByUserPlants:
        return "$_warehouse/ListAllWarehousesByUserPlants";
    }
  }
}
