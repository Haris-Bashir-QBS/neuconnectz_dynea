import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class OutboundDeliverySalesItemsPageParams extends Equatable {
  final String delivery;
  final String plant;
  final String storageLocation;
  final String warehouseCode;
  final WarehouseEntity warehouse;

  const OutboundDeliverySalesItemsPageParams({
    required this.delivery,
    required this.plant,
    required this.storageLocation,
    required this.warehouseCode,
    required this.warehouse,
  });

  @override
  List<Object?> get props => [
        delivery,
        plant,
        storageLocation,
        warehouseCode,
        warehouse,
      ];
}



