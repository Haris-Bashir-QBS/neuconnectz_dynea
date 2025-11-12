import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';

import '../../domain/entities/dashboard_analytics_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/local/home_local_data_source.dart';
import '../data_sources/remote/home_remote_data_source.dart';
import '../models/dashboard_analytics_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, DashboardAnalyticsEntity?>> getDashboardAnalytics({
    required String userId,
  }) async {
    final connectivityResults = await Connectivity().checkConnectivity();
    final isConnected =
        connectivityResults.contains(ConnectivityResult.mobile) ||
        connectivityResults.contains(ConnectivityResult.wifi);

    if (isConnected) {
      try {
        final model = await remoteDataSource.getDashboardAnalytics(
          userId: userId,
        );
        await localDataSource.cacheDashboardAnalytics(model);
        return right(_toEntity(model));
      } on Failure catch (e) {
        return left(Failure(message: e.message));
      }
    } else {
      final cached = await localDataSource.getCachedDashboardAnalytics();
      if (cached != null) {
        return right(_toEntity(cached));
      } else {
        return left(Failure(message: 'No data found in cache.'));
      }
    }
  }

  DashboardAnalyticsEntity _toEntity(DashboardAnalyticsModel model) {
    final data = model.data;
    return DashboardAnalyticsEntity(
      transferStatistics:
          data?.transferStatistics != null
              ? TransferStatisticsEntity(
                totalItrIntegrated:
                    data!.transferStatistics!.totalItrIntegrated,
                totalItrPending: data.transferStatistics!.totalItrPending,
                totalItIntegrated: data.transferStatistics!.totalItIntegrated,
                totalItPending: data.transferStatistics!.totalItPending,
                totalTrIntegrated: data.transferStatistics!.totalTrIntegrated,
                totalTrPending: data.transferStatistics!.totalTrPending,
              )
              : null,
      grnStatistics:
          data?.grnStatistics != null
              ? GrnStatisticsEntity(
                totalGrnIntegrated: data!.grnStatistics!.totalGrnIntegrated,
                totalGrnPending: data.grnStatistics!.totalGrnPending,
              )
              : null,
      topCreatedItems:
          data?.topCreatedItems
              .map(
                (e) =>
                    TopCreatedItemEntity(itemCode: e.itemCode, count: e.count),
              )
              .toList(),
      lastIntegrationDates:
          data?.lastIntegrationDates != null
              ? LastIntegrationDatesEntity(
                lastItrIntegrationDate:
                    data!.lastIntegrationDates!.lastItrIntegrationDate,
                lastItIntegrationDate:
                    data.lastIntegrationDates!.lastItIntegrationDate,
                lastTrIntegrationDate:
                    data.lastIntegrationDates!.lastTrIntegrationDate,
                lastGrnIntegrationDate:
                    data.lastIntegrationDates!.lastGrnIntegrationDate,
              )
              : null,
    );
  }
}
