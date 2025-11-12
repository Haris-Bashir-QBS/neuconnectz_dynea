import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/models/grn_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_list_params.dart';

abstract class GrnListRemoteDataSource {
  Future<GrnListResponseModel> listAllGrDocFromSAP({
    required GrnListParams params,
  });
}

class GrnListRemoteDataSourceImpl implements GrnListRemoteDataSource {
  final DioClient dio;

  GrnListRemoteDataSourceImpl({required this.dio});

  @override
  Future<GrnListResponseModel> listAllGrDocFromSAP({
    required GrnListParams params,
  }) {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'plant': params.plant,
        'location': params.location,
        'pageSize': params.pageSize,
        'pageNumber': params.pageNumber,
        if (params.keyword != null && params.keyword!.isNotEmpty)
          'keyword': params.keyword,
      };

      final response = await dio.get(
        endpoint: ApiEndpoints.listAllGrDocFromSAP.value,
        queryParams: queryParams,
      );
      return GrnListResponseModel.fromJson(response.data ?? {});
    });
  }
}

