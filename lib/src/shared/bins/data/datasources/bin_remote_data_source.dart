import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/shared/bins/data/models/bin_response_model.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/params/bin_params.dart';

abstract class BinRemoteDataSource {
  Future<BinResponseModel> listAllBins({required BinParams params});
}

class BinRemoteDataSourceImpl implements BinRemoteDataSource {
  final DioClient dio;

  BinRemoteDataSourceImpl({required this.dio});

  @override
  Future<BinResponseModel> listAllBins({required BinParams params}) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = <String, dynamic>{};
      // if (params.plant != null && params.plant!.isNotEmpty) {
      //   queryParams['plant'] = params.plant;
      // }
      // if (params.storageType != null && params.storageType!.isNotEmpty) {
      queryParams['storageType'] = params.storageType;
      //}
      if (params.warehouseCode != null && params.warehouseCode!.isNotEmpty) {
        queryParams['warehouseCode'] = params.warehouseCode;
      }
      if (params.keyword != null && params.keyword!.isNotEmpty) {
        // Backend expects bin search as `binCode`
        queryParams['binCode'] = params.keyword;
      }

      // Pagination params
      if (params.lastCount != null) {
        queryParams['lastCount'] = params.lastCount;
      }
      if (params.skipRecords != null) {
        queryParams['skipRecords'] = params.skipRecords;
      }

      final response = await dio.get(
        endpoint: ApiEndpoints.listAllBins.value,
        queryParams: queryParams,
      );
      return BinResponseModel.fromJson(response.data ?? {});
    });
  }
}


