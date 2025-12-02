import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/datasources/remote/grn_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/models/grn_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/models/grn_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_list_params.dart';

class GrnRemoteDataSourceImpl implements GrnRemoteDataSource {
  final DioClient dio;

  GrnRemoteDataSourceImpl({required this.dio});

  @override
  Future<GrnListResponseModel> listAllGrDocFromSAP({
    required GrnListParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'plant': params.plant,
        'location': params.location,
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
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

  @override
  Future<GrnItemResponseModel> listAllGrItemsFromSAP({
    required GrnItemQueryParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'plant': params.plant,
        'location': params.location,
        'materialdoc': params.materialDoc,
        'year': params.materialDocYear,
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
      };

      final response = await dio.get(
        endpoint: ApiEndpoints.listAllGrItemsFromSAP.value,
        queryParams: queryParams,
      );
      return GrnItemResponseModel.fromJson(response.data);
    });
  }

  @override
  Future<GrnItemResponseModel> listCompletedGrnItems({
    required GrnItemQueryParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'plant': params.plant,
        'location': params.location,
        'materialdoc': params.materialDoc,
        'trNumber': params.trNumber,
        'year': params.materialDocYear,
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
      };

      final response = await dio.get(
        endpoint: ApiEndpoints.completedGrnItems.value,
        queryParams: queryParams,
      );
      return GrnItemResponseModel.fromJson(response.data ?? {});
    });
  }
}
