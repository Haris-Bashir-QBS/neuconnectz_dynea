import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/repositories/purchase_order_putaway_repository.dart';

class DeletePutAwayOfPurchaseOrderGrnUseCase {
  final PurchaseOrderGrnPutAwayRepository repository;

  DeletePutAwayOfPurchaseOrderGrnUseCase(this.repository);

  Future<Either<Failure, ApiResponse<bool>>> call({required int docNum}) async {
    return await repository.deletePutAwayOfPurchaseOrderGrn(docNum: docNum);
  }
}
