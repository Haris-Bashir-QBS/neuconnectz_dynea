import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/warehouse_bin_by_material_model.dart';

abstract class ReservationBinRemoteDataSource {
  Future<WarehouseBinByMaterialResponseModel> getWarehouseBinsByMaterial({
    required String warehouseCode,
    required String material,
  });
}

class ReservationBinRemoteDataSourceImpl
    implements ReservationBinRemoteDataSource {
  final DioClient client;

  ReservationBinRemoteDataSourceImpl({required this.client});

  @override
  Future<WarehouseBinByMaterialResponseModel> getWarehouseBinsByMaterial({
    required String warehouseCode,
    required String material,
  }) async {
    final response = await ApiErrorHandler.executeGuarded(
      () => client.get(
        endpoint: ApiEndpoints.getWarehouseBinsByMaterial.value,
        queryParams: {
          'warehouseCode': warehouseCode,
          'material': material,
        },
      ),
    );

    return WarehouseBinByMaterialResponseModel.fromJson(
      response.data ?? {},
    );
  }
}



