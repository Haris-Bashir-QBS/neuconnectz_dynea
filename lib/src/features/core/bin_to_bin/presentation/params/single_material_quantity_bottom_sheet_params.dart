import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class SingleMaterialQuantityBottomSheetParams {
  final PlantEntity plant;
  final WarehouseEntity warehouse;
  final BinEntity sourceBin;
  final StockEntity stock;

  const SingleMaterialQuantityBottomSheetParams({
    required this.plant,
    required this.warehouse,
    required this.sourceBin,
    required this.stock,
  });
}
