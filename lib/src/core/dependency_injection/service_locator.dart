part of 'di_barrel.dart';

final sl = GetIt.instance;

Future<void> initializeDI() async {
  await AppPreferences().init();
  await _initCoreDependencies();
  await _initAuthDependencies();
}

/// ------------------------
/// Core DEPENDENCIES
/// ------------------------

Future<void> _initCoreDependencies() async {
  sl
    ..registerFactory(() => ThemeCubit())
    ..registerLazySingleton(() => DioClient());
}

/// ------------------------
/// AUTH DEPENDENCIES
/// ------------------------

Future<void> _initAuthDependencies() async {
  sl.registerLazySingleton(() => UserCubit());
  _registerAuthRemoteDatasources();
  _registerAuthRepositories();
  _registerAuthUsecases();
  _registerAuthBloc();
  _registerInventoryDependencies();
  _registerGrnListDependencies();
  _registerInboundDeliveryDependencies();
  _registerProductionReceiptDependencies();
  _registerReservationDependencies();
  _registerStockDependencies();
  _registerOutboundDeliveryStoDependencies();
  _registerOutboundDeliveryStoItemsDependencies();
  _registerOutboundDeliverySalesDependencies();
  _registerBinToBinDependencies();
}

void _registerAuthRemoteDatasources() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImplementation(client: sl()),
  );
}

void _registerAuthRepositories() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImplementation(remoteDataSource: sl()),
  );
}

void _registerAuthUsecases() {
  sl
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => SignupUseCase(sl()))
    ..registerLazySingleton(() => FetchSecretKeyUsecase(sl()))
    ..registerLazySingleton(() => Add2FAUseCase(sl()))
    ..registerLazySingleton(() => VerifyOtpUseCase(sl()))
    ..registerLazySingleton(() => Remove2FAUseCase(sl()))
    ..registerLazySingleton(() => ChangePasswordUsecase(sl()))
    ..registerLazySingleton(() => ForgetPasswordUsecase(sl()))
    ..registerLazySingleton(() => VerifyOtpForgetPasswordUsecase(sl()))
    ..registerLazySingleton(() => ResetPasswordUsecase(sl()));
}

void _registerAuthBloc() {
  sl.registerFactory(
    () => AuthenticationBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      userCubit: sl(),
      getSecretKeyUsecase: sl(),
      add2FAUseCase: sl(),
      remove2FAUseCase: sl(),
      verifyOptUseCase: sl(),
      changePasswordUseCase: sl(),
      forgetPasswordUsecase: sl(),
      verifyOtpForgetPasswordUsecase: sl(),
      resetPasswordUsecase: sl(),
    ),
  );
}

/// ------------------------
/// SHARED INVENTORY DEPENDENCIES
/// ------------------------
void _registerInventoryDependencies() {
  // Data sources
  sl.registerLazySingleton<PlantWarehouseRemoteDataSource>(
    () => PlantWarehouseRemoteDataSourceImpl(dio: sl()),
  );
  // Repositories
  sl.registerLazySingleton<PlantWarehouseRepository>(
    () => PlantWarehouseRepositoryImpl(remoteDataSource: sl()),
  );
  // Use cases
  sl
    ..registerLazySingleton(() => GetUserPlantsUseCase(sl()))
    ..registerLazySingleton(() => GetUserWarehousesUseCase(sl()));
  // Blocs
  sl.registerFactory(
    () => PlantWarehouseBloc(
      getUserPlantsUseCase: sl(),
      getUserWarehousesUseCase: sl(),
    ),
  );
}

/// ------------------------
/// GRN DEPENDENCIES
/// ------------------------
void _registerGrnListDependencies() {
  // Data sources
  sl.registerLazySingleton<PurchaseOrderGrnRemoteDataSource>(
    () => PurchaseOrderGrnRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<PurchaseOrderGrnPutAwayRemoteDataSource>(
    () => PurchaseOrderGrnPutAwayRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<BinRemoteDataSource>(
    () => BinRemoteDataSourceImpl(dio: sl()),
  );
  // Repositories
  sl.registerLazySingleton<PurchaseOrderGrnRepository>(
    () => PurchaseOrderGrnRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PurchaseOrderGrnPutAwayRepository>(
    () => PurchaseOrderGrnPutAwayRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<BinRepository>(
    () => BinRepositoryImpl(remoteDataSource: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetPurchaseOrderGrnListUseCase(sl()));
  sl.registerLazySingleton(() => GetPurchaseOrderGrnItemsUseCase(sl()));
  sl.registerLazySingleton(
    () => GetCompletedPurchaseOrderGrnItemsUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => CreatePutAwayAgainstPurchaseOrderGrnUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => DeletePutAwayOfPurchaseOrderGrnUseCase(sl()),
  );
  sl.registerLazySingleton(() => GetBinsUseCase(sl()));
  // Blocs
  sl.registerFactory(
    () => PurchaseOrderGrnBloc(
      getGrnListUseCase: sl(),
      getGrnItemsUseCase: sl(),
      getCompletedGrnItemsUseCase: sl(),
      deletePutAwayOfPurchaseOrderGrnUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => PurchaseOrderGrnPutAwayBloc(createPutAwayUseCase: sl()),
  );
  sl.registerFactory(() => BinBloc(getBinsUseCase: sl()));
}

/// ------------------------
/// INBOUND DELIVERY DEPENDENCIES
/// ------------------------
void _registerInboundDeliveryDependencies() {
  // Data source (merged - all methods in one)
  sl.registerLazySingleton<InboundDeliveryRemoteDataSource>(
    () => InboundDeliveryRemoteDataSourceImpl(dio: sl()),
  );
  // Repository
  sl.registerLazySingleton<InboundDeliveryRepository>(
    () => InboundDeliveryRepositoryImpl(remoteDataSource: sl()),
  );
  // Use case
  sl.registerLazySingleton(() => DeletePutawayAgainstInboundDeliveryStoUseCase(sl()));
  // Blocs
  sl.registerFactory(() => InboundDeliveryBloc(
    repository: sl(),
    deletePutawayAgainstInboundDeliveryStoUseCase: sl(),
  ));
  sl.registerFactory(() => InboundDeliveryPutAwayBloc(repository: sl()));
}

/// ------------------------
/// PRODUCTION RECEIPT DEPENDENCIES
/// ------------------------
void _registerProductionReceiptDependencies() {
  // Data source
  sl.registerLazySingleton<ProductionReceiptRemoteDataSource>(
    () => ProductionReceiptRemoteDataSourceImpl(dio: sl()),
  );
  // Repository
  sl.registerLazySingleton<ProductionReceiptRepository>(
    () => ProductionReceiptRepositoryImpl(remoteDataSource: sl()),
  );
  // Use case
  sl.registerLazySingleton<DeletePutawayAgainstProductionReceiptUseCase>(
    () => DeletePutawayAgainstProductionReceiptUseCase(sl()),
  );
  // Bloc
  sl.registerFactory(() => ProductionReceiptBloc(
    repository: sl(),
    deletePutawayAgainstProductionReceiptUseCase: sl(),
  ));
}

/// ------------------------
/// RESERVATION DEPENDENCIES
/// ------------------------
void _registerReservationDependencies() {
  // Data sources
  sl
    ..registerLazySingleton<ReservationRemoteDataSource>(
      () => ReservationRemoteDataSourceImpl(dio: sl()),
    )
    ..registerLazySingleton<MovementTypeRemoteDataSource>(
      () => MovementTypeRemoteDataSourceImpl(dio: sl()),
    )
    ..registerLazySingleton<ReservationBinRemoteDataSource>(
      () => ReservationBinRemoteDataSourceImpl(client: sl()),
    );

  // Repositories
  sl
    ..registerLazySingleton<ReservationRepository>(
      () => ReservationRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton<MovementTypeRepository>(
      () => MovementTypeRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton<ReservationBinRepository>(
      () => ReservationBinRepositoryImpl(remoteDataSource: sl()),
    );

  // Use cases
  sl
    ..registerLazySingleton(() => GetReservationListUseCase(sl()))
    ..registerLazySingleton(() => GetReservationItemsUseCase(sl()))
    ..registerLazySingleton(() => GetCompletedReservationItemsUseCase(sl()))
    ..registerLazySingleton(() => GetMovementTypesUseCase(sl()))
    ..registerLazySingleton(() => GetWarehouseBinsByMaterialUseCase(sl()))
    ..registerLazySingleton(() => CreatePickingAgainstReservationUseCase(sl()))
    ..registerLazySingleton(() => DeleteReservationUseCase(sl()));

  // Blocs
  sl.registerFactory(() => MovementTypeBloc(getMovementTypesUseCase: sl()));
  sl.registerFactory(
    () => ReservationBloc(
      getReservationListUseCase: sl(),
      getReservationItemsUseCase: sl(),
      getCompletedReservationItemsUseCase: sl(),
      deleteReservationUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ReservationBinBloc(getWarehouseBinsByMaterialUseCase: sl()),
  );
  sl.registerFactory(
    () => PickingBloc(createPickingAgainstReservationUseCase: sl()),
  );
}

void _registerStockDependencies() {
  sl
    ..registerLazySingleton<StockRemoteDataSource>(
      () => StockRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<StockRepository>(
      () => StockRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton(() => GetStocksUseCase(sl()));

  sl.registerFactory(() => StockBloc(getStocksUseCase: sl()));
}

void _registerOutboundDeliveryStoDependencies() {
  sl
    ..registerLazySingleton<OutboundDeliveryStoRemoteDataSource>(
      () => OutboundDeliveryStoRemoteDataSourceImpl(dioClient: sl()),
    )
    ..registerLazySingleton<OutboundDeliveryStoRepository>(
      () => OutboundDeliveryStoRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetOutboundDeliveryStoListUseCase(sl()))
    // STO creation dependencies
    ..registerLazySingleton<StoRemoteDataSource>(
      () => StoRemoteDataSourceImpl(dio: sl()),
    )
    ..registerLazySingleton<StoRepository>(
      () => StoRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton(() => CreateStockTransferOrderUseCase(sl()));

  sl.registerFactory(
    () => OutboundDeliveryStoBloc(
      getOutboundDeliveryStoListUseCase: sl(),
      createStockTransferOrderUseCase: sl(),
      getAndUpdateStocksUseCase: sl(),
    ),
  );
}

void _registerOutboundDeliveryStoItemsDependencies() {
  sl
    ..registerLazySingleton<OutboundDeliveryStoItemRemoteDataSource>(
      () => OutboundDeliveryStoItemRemoteDataSourceImpl(dioClient: sl()),
    )
    ..registerLazySingleton<OutboundDeliveryStoItemRepository>(
      () => OutboundDeliveryStoItemRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetStockDocItemFromSAPUseCase(sl()))
    ..registerLazySingleton(() => GetCompletedStoItemsUseCase(sl()))
    ..registerLazySingleton(() => GetAndUpdateStocksUseCase(sl()))
    ..registerLazySingleton(() => DeletePickingAgainstOutboundDeliveryStoUseCase(sl()))
    // Stocks by Storage Bin dependencies
    ..registerLazySingleton<StocksByStorageBinRemoteDataSource>(
      () => StocksByStorageBinRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<StocksByStorageBinRepository>(
      () => StocksByStorageBinRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton(() => GetStocksByStorageBinUseCase(sl()));

  sl.registerFactory(
    () => OutboundDeliveryStoItemBloc(
      getStockDocItemFromSAPUseCase: sl(),
      getCompletedStoItemsUseCase: sl(),
      deletePickingAgainstOutboundDeliveryStoUseCase: sl(),
    ),
  );

  sl.registerFactory(() => StocksByStorageBinBloc(useCase: sl()));
}

void _registerOutboundDeliverySalesDependencies() {
  sl
    ..registerLazySingleton<OutboundDeliverySalesRemoteDataSource>(
      () => OutboundDeliverySalesRemoteDataSourceImpl(dio: sl()),
    )
    ..registerLazySingleton<OutboundDeliverySalesRepository>(
      () => OutboundDeliverySalesRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton(() => GetOutboundDeliverySalesListUseCase(sl()))
    ..registerLazySingleton(() => GetOutboundDeliverySalesItemsUseCase(sl()))
    ..registerLazySingleton(
      () => GetCompletedOutboundDeliverySalesItemsUseCase(sl()),
    )
    ..registerLazySingleton(() => CreateSalesOrderUseCase(sl()))
    ..registerLazySingleton(() => DeletePickingAgainstOutboundDeliverySalesUseCase(sl()));

  sl.registerFactory(
    () => OutboundDeliverySalesBloc(
      getOutboundDeliverySalesListUseCase: sl(),
      getOutboundDeliverySalesItemsUseCase: sl(),
      getCompletedOutboundDeliverySalesItemsUseCase: sl(),
      createSalesOrderUseCase: sl(),
      getAndUpdateStocksUseCase: sl(),
      deletePickingAgainstOutboundDeliverySalesUseCase: sl(),
    ),
  );
}

void _registerBinToBinDependencies() {
  // GetStocksByStorageBinUseCase is already registered in _registerOutboundDeliveryStoItemsDependencies
  sl.registerFactory(() => SourceBinMaterialListingBloc(useCase: sl()));

  // Bin to Bin Transfer dependencies
  // Data sources
  sl.registerLazySingleton<BinToBinTransferRemoteDataSource>(
    () => BinToBinTransferRemoteDataSourceImpl(client: sl()),
  );
  // Repositories
  sl.registerLazySingleton<BinToBinTransferRepository>(
    () => BinToBinTransferRepositoryImpl(remoteDataSource: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => ProcessBinToBinTransferUseCase(sl()));
  // BLoC
  sl.registerFactory(
    () => BinToBinTransferBloc(useCase: sl(), binTransferReportBloc: sl()),
  );

  // Bin Transfer Report dependencies
  // Data sources
  sl.registerLazySingleton<BinTransferReportRemoteDataSource>(
    () => BinTransferReportRemoteDataSourceImpl(client: sl()),
  );
  // Repositories
  sl.registerLazySingleton<BinTransferReportRepository>(
    () => BinTransferReportRepositoryImpl(remoteDataSource: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetBinTransferReportUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteBinRecordUseCase(sl()));
  // BLoC
  sl.registerFactory(
    () => BinTransferReportBloc(
      getBinTransferReportUseCase: sl(),
      deleteBinRecordUseCase: sl(),
    ),
  );
}
