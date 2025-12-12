import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_item_entity.dart';

class ProductionReceiptItemsPageParams {
  final ProductionReceiptEntity header;
  final String plant;
  final String warehouseCode;
  final String storageLocation;

  const ProductionReceiptItemsPageParams({
    required this.header,
    required this.plant,
    required this.warehouseCode,
    required this.storageLocation,
  });
}

