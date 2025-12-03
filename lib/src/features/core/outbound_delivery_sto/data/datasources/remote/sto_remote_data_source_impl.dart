import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/datasources/remote/sto_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/create_stock_transfer_order_request_model.dart';

class StoRemoteDataSourceImpl implements StoRemoteDataSource {
  final DioClient dio;

  StoRemoteDataSourceImpl({required this.dio});

  @override
  Future<ApiResponse<bool>> createStockTransferOrder({
    required CreateStockTransferOrderRequestModel request,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await dio.post(
        endpoint: ApiEndpoints.createStockTransferOrder.value,
        data: request.toJson(),
      );

      final code = response.statusCode;

      if (code == 200 || code == 201) {
        return ApiResponse<bool>.fromJson(response.data);
      }

      throw ServerException(
        statusCode: code,
        message:
            response.data?['message'] ??
            'Failed to create stock transfer order.',
      );
    });
  }
}

