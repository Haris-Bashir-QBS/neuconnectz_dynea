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
  _registerReservationDependencies();
  _registerStockDependencies();
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
  sl.registerLazySingleton<GrnRemoteDataSource>(
    () => GrnRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<PutAwayRemoteDataSource>(
    () => PutAwayRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<BinRemoteDataSource>(
    () => BinRemoteDataSourceImpl(dio: sl()),
  );
  // Repositories
  sl.registerLazySingleton<GrnRepository>(
    () => GrnRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PutAwayRepository>(
    () => PutAwayRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<BinRepository>(
    () => BinRepositoryImpl(remoteDataSource: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetGrnListUseCase(sl()));
  sl.registerLazySingleton(() => GetGrnItemsUseCase(sl()));
  sl.registerLazySingleton(() => GetCompletedGrnItemsUseCase(sl()));
  sl.registerLazySingleton(() => CreatePutAwayAgainstGrUseCase(sl()));
  sl.registerLazySingleton(() => GetBinsUseCase(sl()));
  // Blocs
  sl.registerFactory(
    () => GrnBloc(
      getGrnListUseCase: sl(),
      getGrnItemsUseCase: sl(),
      getCompletedGrnItemsUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => PutAwayBloc(
      createPutAwayUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => BinBloc(
      getBinsUseCase: sl(),
    ),
  );
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
    ..registerLazySingleton(() => CreatePickingAgainstReservationUseCase(sl()));

  // Blocs
  sl.registerFactory(
    () => MovementTypeBloc(
      getMovementTypesUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ReservationBloc(
      getReservationListUseCase: sl(),
      getReservationItemsUseCase: sl(),
      getCompletedReservationItemsUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ReservationBinBloc(
      getWarehouseBinsByMaterialUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => PickingBloc(
      createPickingAgainstReservationUseCase: sl(),
    ),
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

  sl.registerFactory(
    () => StockBloc(
      getStocksUseCase: sl(),
    ),
  );
}
