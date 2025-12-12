import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/datasources/remote/purchase_order_grn_putaway_remote_datasource.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/models/purchase_order_grn_create_putaway_request_model.dart';

class PurchaseOrderGrnPutAwayRemoteDataSourceImpl
    implements PurchaseOrderGrnPutAwayRemoteDataSource {
  final DioClient dio;

  PurchaseOrderGrnPutAwayRemoteDataSourceImpl({required this.dio});
  @override
  Future<ApiResponse<bool>> createPutAwayAgainstGr({
    required CreatePurchaseOrderGrnPutAwayRequestModel request,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await dio.post(
        endpoint: ApiEndpoints.createPutAwayAgainstGr.value,
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
            'Failed to create put away against GR.',
      );
    });
  }

  @override
  Future<ApiResponse<bool>> deletePutAwayOfPurchaseOrderGrn({
    required int docNum,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await dio.put(
        endpoint: ApiEndpoints.deletePutAwayOfPurchaseOrderGrn.value,
        queryParams: {'docNum': docNum},
      );

      // Always parse the ApiResponse to get the actual success/error status
      final apiResponse = ApiResponse<bool>.fromJson(
        response.data ?? {},
        fromJsonT: (data) => data as bool? ?? false,
      );

      // Check if the API request was successful
      if (apiResponse.isRequestSuccess && (response.statusCode == 200 || response.statusCode == 201)) {
        return apiResponse;
      }

      // If not successful, throw exception with the message from API response
      throw ServerException(
        statusCode: apiResponse.statusCode,
        message: apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Failed to delete put away request.',
      );
    });
  }
}
