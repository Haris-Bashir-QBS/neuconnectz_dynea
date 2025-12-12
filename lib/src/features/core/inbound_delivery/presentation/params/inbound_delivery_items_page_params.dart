import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_list_item_entity.dart';

class InboundDeliveryItemsPageParams {
  final InboundDeliveryEntity inboundDelivery;
  final String plant;
  final String warehouseCode;
  final String location;

  InboundDeliveryItemsPageParams({
    required this.inboundDelivery,
    required this.plant,
    required this.warehouseCode,
    required this.location,
  });
}



