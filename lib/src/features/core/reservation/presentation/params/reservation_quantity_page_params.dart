import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_item_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class ReservationQuantityPageParams {
  final ReservationItemEntity item;
  final String plant;
  final String storageLocation;
  final String movementType;
  final String warehouseCode;
  final WarehouseEntity warehouse;

  const ReservationQuantityPageParams({
    required this.item,
    required this.plant,
    required this.storageLocation,
    required this.movementType,
    required this.warehouseCode,
    required this.warehouse,
  });
}



