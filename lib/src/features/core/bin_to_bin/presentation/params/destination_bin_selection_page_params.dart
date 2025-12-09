import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class DestinationBinSelectionPageParams {
  final PlantEntity plant;
  final WarehouseEntity warehouse;
  final List<Map<String, dynamic>> sourceMaterials; // List of {id, quantity}
  final BinEntity sourceBin; // Source bin to validate against

  const DestinationBinSelectionPageParams({
    required this.plant,
    required this.warehouse,
    required this.sourceMaterials,
    required this.sourceBin,
  });
}
