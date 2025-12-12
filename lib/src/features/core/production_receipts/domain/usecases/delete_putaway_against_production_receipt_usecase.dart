import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/repositories/production_receipt_repository.dart';

class DeletePutawayAgainstProductionReceiptUseCase {
  final ProductionReceiptRepository repository;

  DeletePutawayAgainstProductionReceiptUseCase(this.repository);

  Future<Either<Failure, ApiResponse<bool>>> call({required int docNum}) async {
    return await repository.deletePutawayAgainstProductionReceipt(docNum: docNum);
  }
}

