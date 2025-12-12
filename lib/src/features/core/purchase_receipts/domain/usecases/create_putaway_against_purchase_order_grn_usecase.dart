import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/models/purchase_order_grn_create_putaway_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/repositories/purchase_order_putaway_repository.dart';

class CreatePutAwayAgainstPurchaseOrderGrnUseCase
    extends
        UseCase<ApiResponse<bool>, CreatePurchaseOrderGrnPutAwayRequestModel> {
  final PurchaseOrderGrnPutAwayRepository repository;

  CreatePutAwayAgainstPurchaseOrderGrnUseCase(this.repository);

  @override
  Future<Either<Failure, ApiResponse<bool>>> call(
    CreatePurchaseOrderGrnPutAwayRequestModel params,
  ) {
    return repository.createPutAwayAgainstGr(params);
  }
}
