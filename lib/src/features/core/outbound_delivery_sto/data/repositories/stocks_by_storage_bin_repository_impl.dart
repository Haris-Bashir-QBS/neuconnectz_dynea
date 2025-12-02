import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/datasources/remote/stocks_by_storage_bin_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/stocks_by_storage_bin_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/repositories/stocks_by_storage_bin_repository.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_result_entity.dart';

class StocksByStorageBinRepositoryImpl implements StocksByStorageBinRepository {
  StocksByStorageBinRepositoryImpl({required this.remoteDataSource});

  final StocksByStorageBinRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, StockResultEntity>> getStocksByStorageBin(
    StocksByStorageBinParams params,
  ) async {
    try {
      final response = await remoteDataSource.getStocksByStorageBin(params);
      return Right(response.toEntity());
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
