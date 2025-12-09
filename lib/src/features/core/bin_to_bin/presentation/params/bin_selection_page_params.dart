import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class BinSelectionPageParams {
  final PlantEntity plant;
  final WarehouseEntity warehouse;

  const BinSelectionPageParams({
    required this.plant,
    required this.warehouse,
  });
}

