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

    // Only add filter-specific search params if searchQuery is not null and not empty
    final searchQuery = params.searchQuery?.trim();
    if (searchQuery != null && searchQuery.isNotEmpty) {
      switch (params.filterType) {
        case StockFilterType.material:
          query['material'] = searchQuery;
          break;
        case StockFilterType.storageType:
          query['storageType'] = searchQuery;
          break;
        case StockFilterType.storageBin:
          query['storageBin'] = searchQuery;
          break;
        case StockFilterType.batch:
          query['batch'] = searchQuery;
          break;
        case StockFilterType.all:
          query['keyword'] = searchQuery;
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


