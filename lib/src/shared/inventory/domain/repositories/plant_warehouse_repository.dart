import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/params/plant_warehouse_params.dart';

abstract class PlantWarehouseRepository {
  Future<Either<Failure, List<PlantEntity>>> getPlants(
    PlantQueryParams params,
  );
  Future<Either<Failure, List<WarehouseEntity>>> getWarehouses(
    WarehouseQueryParams params,
  );
}
