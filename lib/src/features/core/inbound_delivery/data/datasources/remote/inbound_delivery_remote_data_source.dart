import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/data/models/create_putaway_inbound_sto_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/data/models/inbound_delivery_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/data/models/inbound_delivery_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/params/inbound_delivery_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/params/inbound_delivery_list_params.dart';

abstract class InboundDeliveryRemoteDataSource {
  Future<InboundDeliveryListResponseModel> listAllInboundDeliveryFromSAP({
    required InboundDeliveryListParams params,
  });

  Future<InboundDeliveryItemResponseModel> listAllInboundDeliveryItemsFromSAP({
    required InboundDeliveryItemQueryParams params,
  });

  Future<InboundDeliveryItemResponseModel> listCompletedInboundDeliveryItems({
    required InboundDeliveryItemQueryParams params,
  });

  Future<ApiResponse<bool>> createPutAwayAgainstInboundDelivery({
    required CreatePutAwayInboundStoRequestModel request,
  });
}



