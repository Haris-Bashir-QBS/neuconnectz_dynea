import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/data/models/plant_model.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/data/models/warehouse_model.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/params/plant_warehouse_params.dart';

abstract class PlantWarehouseRemoteDataSource {
  Future<List<PlantModel>> listPlantsAssignedToUser({
    required PlantQueryParams params,
  });

  Future<List<WarehouseModel>> listWarehousesByUserPlants({
    required WarehouseQueryParams params,
  });
}

class PlantWarehouseRemoteDataSourceImpl
    implements PlantWarehouseRemoteDataSource {
  final DioClient dio;
  PlantWarehouseRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PlantModel>> listPlantsAssignedToUser({
    required PlantQueryParams params,
  }) {
    return ApiErrorHandler.executeGuarded(() async {
      final userId = params.userId;
      if (userId == null || userId.isEmpty) {
        throw UnknownException(message: 'User id is required to fetch plants.');
      }
      final response = await dio.get(
        endpoint:
            'ZCAPI-Dynea-Stg/IPlantFeature/ListAllPlantsAssignedToUser',
        queryParams: {'userId': userId},
      );
      final List<dynamic> items = (response.data?['data']?['data']) ?? [];
      return items.map((e) => PlantModel.fromJson(e)).toList();
    });
  }

  @override
  Future<List<WarehouseModel>> listWarehousesByUserPlants({
    required WarehouseQueryParams params,
  }) {
    return ApiErrorHandler.executeGuarded(() async {
      final userId = params.userId;
      if (userId == null || userId.isEmpty) {
        throw UnknownException(
          message: 'User id is required to fetch warehouses.',
        );
      }
      final response = await dio.get(
        endpoint:
            'ZCAPI-Dynea-Stg/IWarehouseFeature/ListAllWarehousesByUserPlants',
        queryParams: {
          'userId': userId,
          if ((params.plantId ?? '').isNotEmpty) 'plantId': params.plantId,
        },
      );
      final List<dynamic> items = (response.data?['data']?['data']) ?? [];
      return items.map((e) => WarehouseModel.fromJson(e)).toList();
    });
  }
}

