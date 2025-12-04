import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_item_entity.dart';

class OutboundDeliverySalesQuantityPageParams {
  final OutboundDeliverySalesItemEntity item;
  final String plant;
  final String storageLocation;
  final String warehouseCode;

  const OutboundDeliverySalesQuantityPageParams({
    required this.item,
    required this.plant,
    required this.storageLocation,
    required this.warehouseCode,
  });
}

