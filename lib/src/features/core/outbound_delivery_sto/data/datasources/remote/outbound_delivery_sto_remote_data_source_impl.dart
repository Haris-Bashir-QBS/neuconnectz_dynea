import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/datasources/remote/outbound_delivery_sto_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/outbound_delivery_sto_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_list_params.dart';

class OutboundDeliveryStoRemoteDataSourceImpl
    implements OutboundDeliveryStoRemoteDataSource {
  final DioClient dioClient;

  OutboundDeliveryStoRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<OutboundDeliveryStoListResponseModel> listAllStockDocFromSAP({
    required OutboundDeliveryStoListParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await dioClient.get(
        endpoint: ApiEndpoints.listAllStockDocFromSAP.value,
        queryParams: params.toJson(),
      );

      return OutboundDeliveryStoListResponseModel.fromJson(response.data);
    });
  }
}


