import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/outbound_delivery_sto_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_list_params.dart';

abstract class OutboundDeliveryStoRemoteDataSource {
  Future<OutboundDeliveryStoListResponseModel> listAllStockDocFromSAP({
    required OutboundDeliveryStoListParams params,
  });
}
