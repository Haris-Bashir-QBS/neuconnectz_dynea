import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_item_entity.dart';

class OutboundDeliveryStoQuantityPageParams {
  final OutboundDeliveryStoItemEntity item;
  final String plant;
  final String storageLocation;
  final String warehouseCode;

  const OutboundDeliveryStoQuantityPageParams({
    required this.item,
    required this.plant,
    required this.storageLocation,
    required this.warehouseCode,
  });
}



