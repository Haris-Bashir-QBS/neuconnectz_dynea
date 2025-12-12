import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class PurchaseOrderGrnListingPageParams {
  final PlantEntity plant;
  final WarehouseEntity warehouse;

  const PurchaseOrderGrnListingPageParams({
    required this.plant,
    required this.warehouse,
  });
}
