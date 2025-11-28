import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/create_picking_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/repositories/reservation_repository.dart';

class CreatePickingAgainstReservationUseCase
    extends UseCase<ApiResponse<bool>, CreatePickingRequestModel> {
  final ReservationRepository repository;

  CreatePickingAgainstReservationUseCase(this.repository);

  @override
  Future<Either<Failure, ApiResponse<bool>>> call(
    CreatePickingRequestModel params,
  ) {
    return repository.createPickingAgainstReservation(params);
  }
}

