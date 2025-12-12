import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/datasources/remote/purchase_order_grn_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/models/purchase_order_grn_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/models/purchase_order_grn_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/params/purchase_order_grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/params/purchase_order_grn_list_params.dart';

class PurchaseOrderGrnRemoteDataSourceImpl
    implements PurchaseOrderGrnRemoteDataSource {
  final DioClient dio;

  PurchaseOrderGrnRemoteDataSourceImpl({required this.dio});

  @override
  Future<PurchaseOrderGrnListResponseModel> listAllGrDocFromSAP({
    required PurchaseOrderGrnListParams params,
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
      return PurchaseOrderGrnListResponseModel.fromJson(response.data ?? {});
    });
  }

  @override
  Future<PurchaseOrderGrnItemResponseModel> listAllGrItemsFromSAP({
    required PurchaseOrderGrnItemQueryParams params,
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
      return PurchaseOrderGrnItemResponseModel.fromJson(response.data);
    });
  }

  @override
  Future<PurchaseOrderGrnItemResponseModel> listCompletedGrnItems({
    required PurchaseOrderGrnItemQueryParams params,
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
      return PurchaseOrderGrnItemResponseModel.fromJson(response.data ?? {});
    });
  }
}
