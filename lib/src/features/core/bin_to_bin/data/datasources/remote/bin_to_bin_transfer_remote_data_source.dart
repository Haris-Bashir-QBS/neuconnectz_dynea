import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/process_bin_to_bin_transfer_params.dart';

abstract class BinToBinTransferRemoteDataSource {
  Future<ApiResponse<bool>> processBinToBinTransfer(
    ProcessBinToBinTransferParams params,
  );
}

class BinToBinTransferRemoteDataSourceImpl
    implements BinToBinTransferRemoteDataSource {
  BinToBinTransferRemoteDataSourceImpl({required this.client});

  final DioClient client;

  @override
  Future<ApiResponse<bool>> processBinToBinTransfer(
    ProcessBinToBinTransferParams params,
  ) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await client.post(
        endpoint: ApiEndpoints.processBinToBinTransfer.value,
        data: params.toJson(),
      );

      final code = response.statusCode;

      if (code == 200 || code == 201) {
        return ApiResponse<bool>.fromJson(response.data);
      }

      throw ServerException(
        statusCode: code,
        message: response.data?['message'] ?? 'Failed to process bin to bin transfer.',
      );
    });
  }
}
