import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/outbound_delivery_sto_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_item_params.dart';

abstract class OutboundDeliveryStoItemRemoteDataSource {
  Future<OutboundDeliveryStoItemResponseModel> getStockDocItemFromSAP({
    required OutboundDeliveryStoItemParams params,
  });

  Future<OutboundDeliveryStoItemResponseModel> getCompletedStoItems({
    required OutboundDeliveryStoItemParams params,
  });
}
