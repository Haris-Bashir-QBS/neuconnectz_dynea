import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/models/create_putaway_request_model.dart';

abstract class PutAwayRepository {
  Future<Either<Failure, bool>> createPutAwayAgainstGr(
    CreatePutAwayRequestModel request,
  );
}

