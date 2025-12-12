import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/create_stock_transfer_order_request_model.dart';

abstract class StoRepository {
  Future<Either<Failure, ApiResponse<bool>>> createStockTransferOrder({
    required CreateStockTransferOrderRequestModel request,
  });
}



