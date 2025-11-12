import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/params/plant_warehouse_params.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/repositories/plant_warehouse_repository.dart';

class GetUserPlantsUseCase
    extends UseCase<List<PlantEntity>, PlantQueryParams> {
  final PlantWarehouseRepository repository;

  GetUserPlantsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PlantEntity>>> call(
    PlantQueryParams params,
  ) {
    return repository.getPlants(params);
  }
}

