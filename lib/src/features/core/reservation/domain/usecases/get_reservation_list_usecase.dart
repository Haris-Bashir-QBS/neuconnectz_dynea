import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/repositories/reservation_repository.dart';

class GetReservationListUseCase {
  final ReservationRepository repository;

  GetReservationListUseCase(this.repository);

  Future<Either<Failure, ReservationResultEntity>> call(
    ReservationListParams params,
  ) {
    return repository.listAllReservations(params);
  }
}

