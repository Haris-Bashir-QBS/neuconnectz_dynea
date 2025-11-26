import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/movement_type_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/movement_type_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/repositories/movement_type_repository.dart';

class GetMovementTypesUseCase {
  final MovementTypeRepository repository;

  GetMovementTypesUseCase(this.repository);

  Future<Either<Failure, MovementTypeResultEntity>> call(
    MovementTypeQueryParams params,
  ) {
    return repository.listMovementTypes(params);
  }
}

