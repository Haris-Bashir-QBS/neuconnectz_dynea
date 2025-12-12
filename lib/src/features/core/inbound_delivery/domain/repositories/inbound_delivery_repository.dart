import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/data/models/create_putaway_inbound_sto_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/params/inbound_delivery_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/params/inbound_delivery_list_params.dart';

abstract class InboundDeliveryRepository {
  Future<Either<Failure, InboundDeliveryListResultEntity>>
      listAllInboundDeliveryFromSAP(
    InboundDeliveryListParams params,
  );

  Future<Either<Failure, InboundDeliveryItemResultEntity>>
      listAllInboundDeliveryItemsFromSAP(
    InboundDeliveryItemQueryParams params,
  );

  Future<Either<Failure, InboundDeliveryItemResultEntity>>
      listCompletedInboundDeliveryItems(
    InboundDeliveryItemQueryParams params,
  );

  Future<Either<Failure, ApiResponse<bool>>> createPutAwayAgainstInboundDelivery(
    CreatePutAwayInboundStoRequestModel request,
  );
}


