import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/models/create_putaway_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/repositories/putaway_repository.dart';

class CreatePutAwayAgainstGrUseCase
    extends UseCase<ApiResponse<bool>, CreatePutAwayRequestModel> {
  final PutAwayRepository repository;

  CreatePutAwayAgainstGrUseCase(this.repository);

  @override
  Future<Either<Failure, ApiResponse<bool>>> call(
    CreatePutAwayRequestModel params,
  ) {
    return repository.createPutAwayAgainstGr(params);
  }
}
