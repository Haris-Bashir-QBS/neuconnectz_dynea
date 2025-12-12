import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/create_picking_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_items_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_list_params.dart';

abstract class ReservationRepository {
  Future<Either<Failure, ReservationResultEntity>> listAllReservations(
    ReservationListParams params,
  );

  Future<Either<Failure, ReservationItemsResultEntity>> listReservationItems(
    ReservationItemParams params,
  );

  Future<Either<Failure, ReservationItemsResultEntity>>
      listCompletedReservationItems(
    ReservationItemParams params,
  );

  Future<Either<Failure, ApiResponse<bool>>> createPickingAgainstReservation(
    CreatePickingRequestModel request,
  );
}



