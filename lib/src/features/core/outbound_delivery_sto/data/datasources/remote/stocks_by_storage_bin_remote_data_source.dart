import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/stocks_by_storage_bin_params.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/data/models/stock_model.dart';

abstract class StocksByStorageBinRemoteDataSource {
  Future<StockResponseModel> getStocksByStorageBin(
    StocksByStorageBinParams params,
  );
}

class StocksByStorageBinRemoteDataSourceImpl
    implements StocksByStorageBinRemoteDataSource {
  StocksByStorageBinRemoteDataSourceImpl({required this.client});

  final DioClient client;

  @override
  Future<StockResponseModel> getStocksByStorageBin(
    StocksByStorageBinParams params,
  ) async {
    final response = await ApiErrorHandler.executeGuarded(
      () => client.get(
        endpoint: ApiEndpoints.getStocksByStorageBin.value,
        queryParams: params.toJson(),
      ),
    );

    return StockResponseModel.fromJson(response.data ?? {});
  }
}

