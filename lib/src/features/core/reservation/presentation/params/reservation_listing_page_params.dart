import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class ReservationListingPageParams {
  final String plant;
  final String storageLocation;
  final String movementType;
  final String warehouseCode;
  final WarehouseEntity warehouse;

  const ReservationListingPageParams({
    required this.plant,
    required this.storageLocation,
    required this.movementType,
    required this.warehouseCode,
    required this.warehouse,
  });
}


