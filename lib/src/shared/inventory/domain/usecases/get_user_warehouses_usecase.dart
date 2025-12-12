import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/params/plant_warehouse_params.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/repositories/plant_warehouse_repository.dart';

class GetUserWarehousesUseCase
    extends UseCase<List<WarehouseEntity>, WarehouseQueryParams> {
  final PlantWarehouseRepository repository;

  GetUserWarehousesUseCase(this.repository);

  @override
  Future<Either<Failure, List<WarehouseEntity>>> call(
    WarehouseQueryParams params,
  ) {
    return repository.getWarehouses(params);
  }
}



