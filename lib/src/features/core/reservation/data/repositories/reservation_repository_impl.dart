import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/datasources/remote/reservation_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_items_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/repositories/reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationRemoteDataSource remoteDataSource;

  ReservationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ReservationResultEntity>> listAllReservations(
    ReservationListParams params,
  ) async {
    try {
      final response = await remoteDataSource.listAllReservations(
        params: params,
      );
      return Right(response.toEntity());
    } on Failure catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<Failure, ReservationItemsResultEntity>> listReservationItems(
    ReservationItemParams params,
  ) async {
    try {
      final response = await remoteDataSource.listReservationItems(
        params: params,
      );
      return Right(response.toEntity());
    } on Failure catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<Failure, ReservationItemsResultEntity>>
  listCompletedReservationItems(ReservationItemParams params) async {
    try {
      final response = await remoteDataSource.listCompletedReservationItems(
        params: params,
      );
      return Right(response.toEntity());
    } on Failure catch (error) {
      return Left(error);
    }
  }
}
