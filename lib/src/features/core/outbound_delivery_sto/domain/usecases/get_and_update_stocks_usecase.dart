import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/get_and_update_stocks_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/repositories/outbound_delivery_sto_item_repository.dart';

class GetAndUpdateStocksUseCase {
  final OutboundDeliveryStoItemRepository repository;

  GetAndUpdateStocksUseCase(this.repository);

  Future<Either<Failure, ApiResponse<bool>>> call(
    GetAndUpdateStocksRequestModel request,
  ) {
    return repository.getAndUpdateStocksFromSap(request);
  }
}



