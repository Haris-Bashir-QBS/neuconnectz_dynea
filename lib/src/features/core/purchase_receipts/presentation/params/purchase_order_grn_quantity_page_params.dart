import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_list_item_entity.dart';

class PurchaseOrderGrnQuantityPageParams {
  final PurchaseOrderGrnEntity grn;
  final PurchaseOrderGrnItemEntity item;

  PurchaseOrderGrnQuantityPageParams({required this.grn, required this.item});
}
