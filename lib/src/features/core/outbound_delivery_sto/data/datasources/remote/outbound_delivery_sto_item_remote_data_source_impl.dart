import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/datasources/remote/outbound_delivery_sto_item_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/get_and_update_stocks_request_model.dart';
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
        endpoint: ApiEndpoints.getCompletedItemsInStoWithBatch.value,
        queryParams: {
          'DeliveryNo': params.deliveryNo,
          'lastCount': params.lastCount,
          'skipRecords': params.skipRecords,
        },
      );

      return OutboundDeliveryStoItemResponseModel.fromJson(response.data);
    });
  }

  @override
  Future<ApiResponse<bool>> getAndUpdateStocksFromSap({
    required GetAndUpdateStocksRequestModel request,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await dioClient.post(
        endpoint: ApiEndpoints.getAndUpdateStocksFromSap.value,
        data: request.toJson(),
      );

      final code = response.statusCode;

      if (code == 200 || code == 201) {
        // Return bool regardless of actual response structure
        return ApiResponse<bool>.fromJson(
          response.data,
          fromJsonT: (_) => true,
        );
      }

      throw ServerException(
        statusCode: code,
        message:
            response.data?['message'] ??
            'Failed to get and update stocks from SAP.',
      );
    });
  }
}


