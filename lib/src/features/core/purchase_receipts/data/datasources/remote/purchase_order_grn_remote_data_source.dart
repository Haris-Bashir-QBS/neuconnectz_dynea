import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/models/purchase_order_grn_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/models/purchase_order_grn_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/params/purchase_order_grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/params/purchase_order_grn_list_params.dart';

abstract class PurchaseOrderGrnRemoteDataSource {
  Future<PurchaseOrderGrnListResponseModel> listAllGrDocFromSAP({
    required PurchaseOrderGrnListParams params,
  });

  Future<PurchaseOrderGrnItemResponseModel> listAllGrItemsFromSAP({
    required PurchaseOrderGrnItemQueryParams params,
  });

  Future<PurchaseOrderGrnItemResponseModel> listCompletedGrnItems({
    required PurchaseOrderGrnItemQueryParams params,
  });
}
