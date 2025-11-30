import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/data/datasources/remote/outbound_delivery_sales_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/data/models/outbound_delivery_sales_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/data/models/outbound_delivery_sales_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_list_params.dart';

class OutboundDeliverySalesRemoteDataSourceImpl
    implements OutboundDeliverySalesRemoteDataSource {
  final DioClient dio;

  OutboundDeliverySalesRemoteDataSourceImpl({required this.dio});

  @override
  Future<OutboundDeliverySalesListResponseModel> listAllSalesOrderDocFromSAP({
    required OutboundDeliverySalesListParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'plant': params.plant,
        'storageLocation': params.storageLocation,
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
        if (params.deliveryNo != null && params.deliveryNo!.isNotEmpty)
          'deliveryNo': params.deliveryNo,
      };

      final response = await dio.get(
        endpoint: ApiEndpoints.listAllSalesOrderDocFromSAP.value,
        queryParams: queryParams,
      );
      return OutboundDeliverySalesListResponseModel.fromJson(
        response.data ?? {},
      );
    });
  }

  @override
  Future<OutboundDeliverySalesItemResponseModel> listAllSalesOrderItemFromSAP({
    required OutboundDeliverySalesItemParams params,
  }) async {
    return _fetchSalesOrderItems(
      endpoint: ApiEndpoints.listAllSalesOrderItemFromSAP.value,
      params: params,
    );
  }

  @override
  Future<OutboundDeliverySalesItemResponseModel> listCompletedSalesOrderItems({
    required OutboundDeliverySalesItemParams params,
  }) async {
    return _fetchSalesOrderItems(
      endpoint: ApiEndpoints.completedSalesorderItems.value,
      params: params,
    );
  }

  Future<OutboundDeliverySalesItemResponseModel> _fetchSalesOrderItems({
    required String endpoint,
    required OutboundDeliverySalesItemParams params,
  }) {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'deliveryNo': params.deliveryNo,
        'plant': params.plant,
        'storageLocation': params.storageLocation,
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
      };

      final response = await dio.get(
        endpoint: endpoint,
        queryParams: queryParams,
      );
      return OutboundDeliverySalesItemResponseModel.fromJson(
        response.data ?? {},
      );
    });
  }
}

