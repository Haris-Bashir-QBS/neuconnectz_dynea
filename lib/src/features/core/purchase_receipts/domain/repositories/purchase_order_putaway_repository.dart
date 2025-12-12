import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/models/purchase_order_grn_create_putaway_request_model.dart';

abstract class PurchaseOrderGrnPutAwayRepository {
  Future<Either<Failure, ApiResponse<bool>>> createPutAwayAgainstGr(
    CreatePurchaseOrderGrnPutAwayRequestModel request,
  );

  Future<Either<Failure, ApiResponse<bool>>> deletePutAwayOfPurchaseOrderGrn({
    required int docNum,
  });
}
