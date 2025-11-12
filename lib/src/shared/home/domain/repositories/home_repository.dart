import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';

import '../entities/dashboard_analytics_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, DashboardAnalyticsEntity?>> getDashboardAnalytics({
    required String userId,
  });
}
