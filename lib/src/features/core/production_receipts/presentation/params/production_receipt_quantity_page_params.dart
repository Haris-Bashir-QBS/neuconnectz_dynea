import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_item_entity.dart';

class ProductionReceiptQuantityPageParams {
  final ProductionReceiptEntity header;
  final ProductionReceiptItemEntity item;
  final String warehouseCode;
  final String plant;
  final String storageLocation;

  ProductionReceiptQuantityPageParams({
    required this.header,
    required this.item,
    required this.warehouseCode,
    required this.plant,
    required this.storageLocation,
  });
}

