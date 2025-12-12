import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_items_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/repositories/reservation_repository.dart';

class GetReservationItemsUseCase {
  final ReservationRepository repository;

  GetReservationItemsUseCase(this.repository);

  Future<Either<Failure, ReservationItemsResultEntity>> call(
    ReservationItemParams params,
  ) {
    return repository.listReservationItems(params);
  }
}



