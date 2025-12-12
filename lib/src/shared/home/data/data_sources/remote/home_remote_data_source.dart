import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/shared/home/data/models/dashboard_analytics_model.dart';

abstract class HomeRemoteDataSource {
  Future<DashboardAnalyticsModel> getDashboardAnalytics({
    required String userId,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dio;
  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<DashboardAnalyticsModel> getDashboardAnalytics({
    required String userId,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await dio.get(
        endpoint: ApiEndpoints.getDashboardAnalytics.value,
        queryParams: {'userId': userId},
      );
      return DashboardAnalyticsModel.fromJson(response.data);
    });
  }
}


