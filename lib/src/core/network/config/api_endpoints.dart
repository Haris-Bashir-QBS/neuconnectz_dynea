var _rootAuth = "Auth-Dynea-Stg";
var _rootApi = "ZCAPI-Dynea-Stg";

var _auth = "$_rootAuth/IAuthFeature";
var _dashboard = "$_rootApi/IDashboardFeature";
var _putAway = "$_rootApi/IPutAwayFeature";
var _reservation = "$_rootApi/IReservationFeature";
var _movementType = "$_rootApi/IMovementTypeFeature";
var _binManagement = "$_rootApi/IBinManagementFeature";
var _plant = "$_rootApi/IPlantFeature";
var _warehouse = "$_rootApi/IWarehouseFeature";
var _stocks = "$_rootApi/IStocksFeature";
var _stockTransferOrder = "$_rootApi/IStockTransferOrderFeature";
var _salesOrder = "$_rootApi/ISalesOrderFeature";
var _sapDataSync = "$_rootApi/ISAPDataSyncFeature";

enum ApiEndpoints {
  /// ================= Auth =======================
  signup,
  logout,
  changePassword,
  refreshToken,
  login,

  /// ============ Forget Password ===================
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
  listMovementTypesAssignedToUser,

  /// ========================  Stocks =================================
  listStockItems,

  /// ========================  Plant/Warehouse =========================
  listAllPlantsAssignedToUser,
  listAllWarehousesByUserPlants,

  /// ===================== Outbound Delivery (STO) =====================
  listAllStockDocFromSAP,
  stoItems,
  completedStoItems,
  getCompletedItemsInStoWithBatch,
  getStocksByStorageBin,
  createStockTransferOrder,
  getAndUpdateStocksFromSap,

  /// ===================== Outbound Delivery (Sales Order) =====================
  listAllSalesOrderDocFromSAP,
  listAllSalesOrderItemFromSAP,
  completedSalesorderItems,
  getCompletedItemsInSalesWithBatch,
  createSalesOrder,

  /// ===================== Bin to Bin Transfer =====================
  processBinToBinTransfer,
  getBinTransferReport;

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

      /// ============== Get Dashboard Analytics =====================
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

      /// ============================ Reservation =====================
      case ApiEndpoints.listAllReservationsFromSAP:
        return "$_reservation/ListAllReservationsFromSAP";
      case ApiEndpoints.listAllReservationItemsFromSAP:
        return "$_reservation/ListAllItemsOfReservationFromSAP";
      case ApiEndpoints.listCompletedReservationItemsFromSAP:
        return "$_reservation/GetCompletedReservationItemWithBins";
      case ApiEndpoints.createPickingAgainstReservation:
        return "$_reservation/CreateReservationList";
      case ApiEndpoints.getWarehouseBinsByMaterial:
        return "$_binManagement/GetWarehouseBinsByMaterial";

      /// ======================== Movement Types =======================
      case ApiEndpoints.listMovementTypesAssignedToUser:
        return "$_movementType/ListAllMovementTypesAssignedToUser";

      /// ======================== Stocks ===============================
      case ApiEndpoints.listStockItems:
        return "$_stocks/ListAllStocks";

      /// ======================== Plant/Warehouse ======================
      case ApiEndpoints.listAllPlantsAssignedToUser:
        return "$_plant/ListAllPlantsAssignedToUser";
      case ApiEndpoints.listAllWarehousesByUserPlants:
        return "$_warehouse/ListAllWarehousesByUserPlants";

      /// ======================== Outbound Delivery (STO) ===============

      case ApiEndpoints.listAllStockDocFromSAP:
        return "$_stockTransferOrder/ListAllStockDocFromSAP";
      case ApiEndpoints.stoItems:
        return "$_stockTransferOrder/StockDocItemFromSAP";
      case ApiEndpoints.completedStoItems:
        return "$_stockTransferOrder/CompletedStoItems";
      case ApiEndpoints.getCompletedItemsInStoWithBatch:
        return "$_stockTransferOrder/GetCompletedItemsInStoWithBatch";
      case ApiEndpoints.getStocksByStorageBin:
        return "$_binManagement/GetStocksByStorageBin";
      case ApiEndpoints.createStockTransferOrder:
        return "$_stockTransferOrder/CreateStockTransferOrder";
      case ApiEndpoints.getAndUpdateStocksFromSap:
        return "$_sapDataSync/GetAndUpdateStocksFromSap";

      /// ======================== Outbound Delivery (Sales Order) ===============
      case ApiEndpoints.listAllSalesOrderDocFromSAP:
        return "$_salesOrder/ListAllSalesOrderDocFromSAP";
      case ApiEndpoints.listAllSalesOrderItemFromSAP:
        return "$_salesOrder/ListAllSalesOrderItemFromSAP";
      case ApiEndpoints.completedSalesorderItems:
        return "$_salesOrder/completedSalesorderItems";
      case ApiEndpoints.getCompletedItemsInSalesWithBatch:
        return "$_salesOrder/GetCompletedItemsInSalesWithBatch";
      case ApiEndpoints.createSalesOrder:
        return "$_salesOrder/CreateSalesOrder";

      /// ===================== Bin to Bin Transfer =====================
      case ApiEndpoints.processBinToBinTransfer:
        return "$_binManagement/ProcessBinToBinTransfer";
      case ApiEndpoints.getBinTransferReport:
        return "$_binManagement/GetBinTransferReport";
    }
  }
}
