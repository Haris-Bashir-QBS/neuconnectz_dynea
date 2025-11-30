import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/params/stock_query_params.dart';

import '../models/stock_model.dart';

abstract class StockRemoteDataSource {
  Future<StockResponseModel> fetchStocks(StockQueryParams params);
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  StockRemoteDataSourceImpl({required this.client});

  final DioClient client;

  @override
  Future<StockResponseModel> fetchStocks(StockQueryParams params) async {
    final Map<String, dynamic> query = {
      'plant': params.plant,
      'warehouseNumber': params.warehouseNumber,
      'lastCount': params.lastCount,
      'skipRecords': params.skipRecords,
    };

    if ((params.searchQuery ?? '').isNotEmpty) {
      switch (params.filterType) {
        case StockFilterType.material:
          query['material'] = params.searchQuery;
          break;
        case StockFilterType.storageType:
          query['storageType'] = params.searchQuery;
          break;
        case StockFilterType.storageBin:
          query['storageBin'] = params.searchQuery;
          break;
        case StockFilterType.batch:
          query['batch'] = params.searchQuery;
          break;
        case StockFilterType.all:
          query['keyword'] = params.searchQuery;
          break;
      }
    }

    final response = await ApiErrorHandler.executeGuarded(
      () => client.get(
        endpoint: ApiEndpoints.listStockItems.value,
        queryParams: query,
      ),
    );

    return StockResponseModel.fromJson(response.data ?? {});
  }
}
