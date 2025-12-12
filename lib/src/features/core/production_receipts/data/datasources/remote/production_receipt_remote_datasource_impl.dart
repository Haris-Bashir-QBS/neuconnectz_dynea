import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/data/datasources/remote/production_receipt_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/data/models/production_receipt_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/data/models/production_receipt_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_list_params.dart';

class ProductionReceiptRemoteDataSourceImpl
    implements ProductionReceiptRemoteDataSource {
  final DioClient dio;

  ProductionReceiptRemoteDataSourceImpl({required this.dio});

  @override
  Future<ProductionReceiptListResponseModel> listProductionReceiptsFromSAP({
    required ProductionReceiptListParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'plant': params.plant,
        'warehouseNumber': params.warehouseNumber,
        'storageLocation': params.storageLocation,
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
        if (params.keyword != null && params.keyword!.isNotEmpty)
          'keyword': params.keyword,
      };

      final response = await dio.get(
        endpoint: ApiEndpoints.listProductionReceiptsFromSAP.value,
        queryParams: queryParams,
      );

      return ProductionReceiptListResponseModel.fromJson(response.data ?? {});
    });
  }

  @override
  Future<ProductionReceiptItemResponseModel> listProductionReceiptItemsFromSAP({
    required ProductionReceiptItemQueryParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'plant': params.plant,
        'warehouseNumber': params.warehouseNumber,
        'storageLocation': params.storageLocation,
        'trNumber': params.trNumber,
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
      };

      final response = await dio.get(
        endpoint: ApiEndpoints.listProductionReceiptItemsFromSAP.value,
        queryParams: queryParams,
      );

      return ProductionReceiptItemResponseModel.fromJson(response.data ?? {});
    });
  }
}

