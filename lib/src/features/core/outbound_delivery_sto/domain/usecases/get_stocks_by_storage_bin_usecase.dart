import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/stocks_by_storage_bin_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/repositories/stocks_by_storage_bin_repository.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_result_entity.dart';

class GetStocksByStorageBinUseCase
    implements UseCase<StockResultEntity, StocksByStorageBinParams> {
  final StocksByStorageBinRepository repository;

  GetStocksByStorageBinUseCase(this.repository);

  @override
  Future<Either<Failure, StockResultEntity>> call(
    StocksByStorageBinParams params,
  ) {
    return repository.getStocksByStorageBin(params);
  }
}

