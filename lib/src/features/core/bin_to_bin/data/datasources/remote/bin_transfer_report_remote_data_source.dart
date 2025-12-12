import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/data/models/bin_transfer_report_model.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/get_bin_transfer_report_params.dart';

abstract class BinTransferReportRemoteDataSource {
  Future<ApiResponse<List<BinTransferReportModel>>> getBinTransferReport(
    GetBinTransferReportParams params,
  );
}

class BinTransferReportRemoteDataSourceImpl
    implements BinTransferReportRemoteDataSource {
  BinTransferReportRemoteDataSourceImpl({required this.client});

  final DioClient client;

  @override
  Future<ApiResponse<List<BinTransferReportModel>>> getBinTransferReport(
    GetBinTransferReportParams params,
  ) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = params.toQueryParams();

      final response = await client.get(
        endpoint: ApiEndpoints.getBinTransferReport.value,
        queryParams: queryParams,
      );

      final code = response.statusCode;

      if (code == 200 || code == 201) {
        final apiResponse = ApiResponse<List<dynamic>>.fromJson(response.data);
        
        if (apiResponse.data != null) {
          final reports = apiResponse.data!
              .map((item) => BinTransferReportModel.fromJson(
                  item as Map<String, dynamic>))
              .toList();
          
          return ApiResponse<List<BinTransferReportModel>>(
            isApiHandled: apiResponse.isApiHandled,
            isRequestSuccess: apiResponse.isRequestSuccess,
            statusCode: apiResponse.statusCode,
            message: apiResponse.message,
            data: reports,
            exception: apiResponse.exception,
          );
        }
        
        return ApiResponse<List<BinTransferReportModel>>(
          isApiHandled: apiResponse.isApiHandled,
          isRequestSuccess: apiResponse.isRequestSuccess,
          statusCode: apiResponse.statusCode,
          message: apiResponse.message,
          data: [],
          exception: apiResponse.exception,
        );
      }

      throw ServerException(
        statusCode: code,
        message: response.data?['message'] ?? 'Failed to get bin transfer report.',
      );
    });
  }
}


