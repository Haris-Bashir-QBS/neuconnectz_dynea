import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/models/create_putaway_request_model.dart';

abstract class PutAwayRemoteDataSource {
  Future<bool> createPutAwayAgainstGr({
    required CreatePutAwayRequestModel request,
  });
}

class PutAwayRemoteDataSourceImpl implements PutAwayRemoteDataSource {
  final DioClient dio;

  PutAwayRemoteDataSourceImpl({required this.dio});

  @override
  Future<bool> createPutAwayAgainstGr({
    required CreatePutAwayRequestModel request,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await dio.post(
        endpoint: ApiEndpoints.createPutAwayAgainstGr.value,
        data: request.toJson(),
      );

      final isSuccess =
          (response.data?['isRequestSuccess'] ?? false) == true &&
          (response.statusCode ?? 500) < 400;

      if (!isSuccess) {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data?['message'] ??
              'Failed to create put away against GR.',
        );
      }

      return true;
    });
  }
}

