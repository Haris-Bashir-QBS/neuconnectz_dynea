import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/datasources/remote/movement_type_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/movement_type_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/movement_type_params.dart';

class MovementTypeRemoteDataSourceImpl implements MovementTypeRemoteDataSource {
  final DioClient dio;

  MovementTypeRemoteDataSourceImpl({required this.dio});

  @override
  Future<MovementTypeResponseModel> listMovementTypes({
    required MovementTypeQueryParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
        if (params.keyword != null && params.keyword!.isNotEmpty)
          'keyword': params.keyword,
      };

      final response = await dio.get(
        endpoint: ApiEndpoints.listMovementTypes.value,
        queryParams: queryParams,
      );

      return MovementTypeResponseModel.fromJson(response.data ?? {});
    });
  }
}

