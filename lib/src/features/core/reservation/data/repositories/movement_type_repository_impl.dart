import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/datasources/remote/movement_type_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/movement_type_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/movement_type_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/repositories/movement_type_repository.dart';

class MovementTypeRepositoryImpl implements MovementTypeRepository {
  final MovementTypeRemoteDataSource remoteDataSource;

  MovementTypeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MovementTypeResultEntity>> listMovementTypes(
    MovementTypeQueryParams params,
  ) async {
    try {
      final response = await remoteDataSource.listMovementTypes(params: params);
      return Right(response.toEntity());
    } on Failure catch (error) {
      return Left(error);
    }
  }
}
