import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/datasources/remote/putaway_remote_datasource.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/models/create_putaway_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/repositories/putaway_repository.dart';

class PutAwayRepositoryImpl implements PutAwayRepository {
  final PutAwayRemoteDataSource remoteDataSource;

  PutAwayRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ApiResponse<bool>>> createPutAwayAgainstGr(
    CreatePutAwayRequestModel request,
  ) async {
    try {
      final success = await remoteDataSource.createPutAwayAgainstGr(
        request: request,
      );
      return right(success);
    } on Failure catch (failure) {
      return left(failure);
    }
  }
}
