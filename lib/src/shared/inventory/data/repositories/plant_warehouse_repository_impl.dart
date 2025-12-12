import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/data/data_sources/remote/plant_warehouse_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/params/plant_warehouse_params.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/repositories/plant_warehouse_repository.dart';

class PlantWarehouseRepositoryImpl implements PlantWarehouseRepository {
  final PlantWarehouseRemoteDataSource remoteDataSource;
  PlantWarehouseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PlantEntity>>> getPlants(
    PlantQueryParams params,
  ) async {
    try {
      final models = await remoteDataSource.listPlantsAssignedToUser(
        params: params,
      );
      return right(models.map((model) => model.toEntity()).toList());
    } on Failure catch (failure) {
      return left(failure);
    }
  }

  @override
  Future<Either<Failure, List<WarehouseEntity>>> getWarehouses(
    WarehouseQueryParams params,
  ) async {
    try {
      final models = await remoteDataSource.listWarehousesByUserPlants(
        params: params,
      );
      return right(models.map((model) => model.toEntity()).toList());
    } on Failure catch (failure) {
      return left(failure);
    }
  }
}

