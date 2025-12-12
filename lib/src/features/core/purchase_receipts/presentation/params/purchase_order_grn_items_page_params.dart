import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_list_item_entity.dart';

class PurchaseOrderGrnItemsPageParams {
  final PurchaseOrderGrnEntity grn;
  final String plant;
  final String warehouseCode;
  final String location;

  PurchaseOrderGrnItemsPageParams({
    required this.grn,
    required this.plant,
    required this.warehouseCode,
    required this.location,
  });
}
