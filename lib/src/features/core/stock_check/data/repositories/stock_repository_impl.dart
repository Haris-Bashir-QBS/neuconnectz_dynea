import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/data/datasources/stock_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/params/stock_query_params.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/repositories/stock_repository.dart';

class StockRepositoryImpl implements StockRepository {
  StockRepositoryImpl({required this.remoteDataSource});

  final StockRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, StockResultEntity>> getStocks(
    StockQueryParams params,
  ) async {
    try {
      final response = await remoteDataSource.fetchStocks(params);
      return right(response.toEntity());
    } on Failure catch (failure) {
      return left(failure);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }
}



