import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/stocks_by_storage_bin_params.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_result_entity.dart';

abstract class StocksByStorageBinRepository {
  Future<Either<Failure, StockResultEntity>> getStocksByStorageBin(
    StocksByStorageBinParams params,
  );
}

