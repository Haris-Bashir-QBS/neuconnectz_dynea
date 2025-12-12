import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';

import '../entities/stock_result_entity.dart';
import '../params/stock_query_params.dart';

abstract class StockRepository {
  Future<Either<Failure, StockResultEntity>> getStocks(
    StockQueryParams params,
  );
}



