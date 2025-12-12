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
}
