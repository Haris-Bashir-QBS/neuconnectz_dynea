import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/get_and_update_stocks_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_item_params.dart';

abstract class OutboundDeliveryStoItemRepository {
  Future<Either<Failure, List<OutboundDeliveryStoItemEntity>>>
      getStockDocItemFromSAP({required OutboundDeliveryStoItemParams params});

  Future<Either<Failure, List<OutboundDeliveryStoItemEntity>>>
      getCompletedStoItems({required OutboundDeliveryStoItemParams params});

  Future<Either<Failure, ApiResponse<bool>>> getAndUpdateStocksFromSap(
    GetAndUpdateStocksRequestModel request,
  );

  Future<Either<Failure, ApiResponse<bool>>> deletePickingAgainstOutboundDeliverySto({
    required int docNum,
  });
}


