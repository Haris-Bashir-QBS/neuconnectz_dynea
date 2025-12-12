import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/data/datasources/remote/inbound_delivery_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/data/models/create_putaway_inbound_sto_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/data/models/inbound_delivery_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/data/models/inbound_delivery_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/params/inbound_delivery_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/params/inbound_delivery_list_params.dart';

class InboundDeliveryRemoteDataSourceImpl
    implements InboundDeliveryRemoteDataSource {
  final DioClient dio;

  InboundDeliveryRemoteDataSourceImpl({required this.dio});

  @override
  Future<InboundDeliveryListResponseModel> listAllInboundDeliveryFromSAP({
    required InboundDeliveryListParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'plant': params.plant,
        'storageLocation': params.storageLocation,
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
        if (params.keyword != null && params.keyword!.isNotEmpty)
          'keyword': params.keyword,
      };

      final response = await dio.get(
        endpoint: ApiEndpoints.listAllInboundDeliveryFromSAP.value,
        queryParams: queryParams,
      );
      return InboundDeliveryListResponseModel.fromJson(
        response.data ?? {},
      );
    });
  }

  @override
  Future<InboundDeliveryItemResponseModel>
      listAllInboundDeliveryItemsFromSAP({
    required InboundDeliveryItemQueryParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'plant': params.plant,
        'storageLocation': params.storageLocation,
        'outboundDeliveryNo': params.outboundDeliveryNo,
        'stoNo': params.stoNo,
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
      };

      final response = await dio.get(
        endpoint: ApiEndpoints.listAllInboundDeliveryItemsFromSAP.value,
        queryParams: queryParams,
      );
      return InboundDeliveryItemResponseModel.fromJson(response.data);
    });
  }

  @override
  Future<InboundDeliveryItemResponseModel> listCompletedInboundDeliveryItems({
    required InboundDeliveryItemQueryParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'plant': params.plant,
        'storageLocation': params.storageLocation,
        'outboundDeliveryNo': params.outboundDeliveryNo,
        'stoNo': params.stoNo,
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
      };

      final response = await dio.get(
        endpoint: ApiEndpoints.completedInboundDeliveryItems.value,
        queryParams: queryParams,
      );
      return InboundDeliveryItemResponseModel.fromJson(
        response.data ?? {},
      );
    });
  }

  @override
  Future<ApiResponse<bool>> createPutAwayAgainstInboundDelivery({
    required CreatePutAwayInboundStoRequestModel request,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await dio.post(
        endpoint: ApiEndpoints.createPutAwayAgainstInboundDelivery.value,
        data: request.toJson(),
      );

      final code = response.statusCode;

      if (code == 200 || code == 201) {
        return ApiResponse<bool>.fromJson(response.data);
      }

      throw ServerException(
        statusCode: code,
        message: response.data?['message'] ??
            'Failed to create put away against inbound delivery.',
      );
    });
  }
}



