import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/movement_type_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/movement_type_params.dart';

abstract class MovementTypeRepository {
  Future<Either<Failure, MovementTypeResultEntity>> listMovementTypes(
    MovementTypeQueryParams params,
  );
}



