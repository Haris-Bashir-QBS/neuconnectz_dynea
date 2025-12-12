import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_list_item_entity.dart';

class InboundDeliveryQuantityPageParams {
  final InboundDeliveryEntity inboundDelivery;
  final InboundDeliveryItemEntity item;
  final String warehouseCode;
  final String plant;
  final String storageLocation;

  InboundDeliveryQuantityPageParams({
    required this.inboundDelivery,
    required this.item,
    required this.warehouseCode,
    required this.plant,
    required this.storageLocation,
  });
}



