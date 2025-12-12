import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/models/purchase_order_grn_create_putaway_request_model.dart';

abstract class PurchaseOrderGrnPutAwayRemoteDataSource {
  Future<ApiResponse<bool>> createPutAwayAgainstGr({
    required CreatePurchaseOrderGrnPutAwayRequestModel request,
  });

  Future<ApiResponse<bool>> deletePutAwayOfPurchaseOrderGrn({
    required int docNum,
  });
}
