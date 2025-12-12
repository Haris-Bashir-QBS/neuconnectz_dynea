import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/params/stock_query_params.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/repositories/stock_repository.dart';

class GetStocksUseCase extends UseCase<StockResultEntity, StockQueryParams> {
  GetStocksUseCase(this.repository);

  final StockRepository repository;

  @override
  Future<Either<Failure, StockResultEntity>> call(
    StockQueryParams params,
  ) {
    return repository.getStocks(params);
  }
}


