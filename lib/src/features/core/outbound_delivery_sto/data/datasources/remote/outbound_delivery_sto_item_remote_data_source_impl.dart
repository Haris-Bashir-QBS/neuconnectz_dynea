import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/datasources/remote/outbound_delivery_sto_item_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/outbound_delivery_sto_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_item_params.dart';

class OutboundDeliveryStoItemRemoteDataSourceImpl
    implements OutboundDeliveryStoItemRemoteDataSource {
  final DioClient dioClient;

  OutboundDeliveryStoItemRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<OutboundDeliveryStoItemResponseModel> getStockDocItemFromSAP({
    required OutboundDeliveryStoItemParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await dioClient.get(
        endpoint: ApiEndpoints.stoItems.value,
        queryParams: params.toJson(),
      );

      return OutboundDeliveryStoItemResponseModel.fromJson(response.data);
    });
  }

  @override
  Future<OutboundDeliveryStoItemResponseModel> getCompletedStoItems({
    required OutboundDeliveryStoItemParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await dioClient.get(
        endpoint: ApiEndpoints.completedStoItems.value,
        queryParams: params.toJson(),
      );

      return OutboundDeliveryStoItemResponseModel.fromJson(response.data);
    });
  }
}
