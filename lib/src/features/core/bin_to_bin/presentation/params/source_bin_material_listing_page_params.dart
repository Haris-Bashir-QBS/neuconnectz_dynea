import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class SourceBinMaterialListingPageParams {
  final PlantEntity plant;
  final WarehouseEntity warehouse;
  final BinEntity selectedBin;

  const SourceBinMaterialListingPageParams({
    required this.plant,
    required this.warehouse,
    required this.selectedBin,
  });
}

