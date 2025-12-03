import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/create_stock_transfer_order_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/repositories/sto_repository.dart';

class CreateStockTransferOrderUseCase
    implements UseCase<ApiResponse<bool>, CreateStockTransferOrderRequestModel> {
  final StoRepository repository;

  CreateStockTransferOrderUseCase(this.repository);

  @override
  Future<Either<Failure, ApiResponse<bool>>> call(
    CreateStockTransferOrderRequestModel params,
  ) {
    return repository.createStockTransferOrder(request: params);
  }
}

