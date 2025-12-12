import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import '../entities/dashboard_analytics_entity.dart';
import '../repositories/home_repository.dart';

class GetDashboardAnalyticsUseCase
    extends UseCase<DashboardAnalyticsEntity?, String> {
  final HomeRepository repository;
  GetDashboardAnalyticsUseCase(this.repository);

  @override
  Future<Either<Failure, DashboardAnalyticsEntity?>> call(String userId) async {
    return await repository.getDashboardAnalytics(userId: userId);
  }
}


