import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class OutboundDeliverySalesListingPageParams {
  final String plant;
  final String storageLocation;
  final String warehouseCode;
  final WarehouseEntity warehouse;

  const OutboundDeliverySalesListingPageParams({
    required this.plant,
    required this.storageLocation,
    required this.warehouseCode,
    required this.warehouse,
  });
}



