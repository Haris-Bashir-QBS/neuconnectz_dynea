import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/entities/bin_transfer_report_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/data/models/bin_transfer_report_material_model.dart';

class BinTransferReportModel extends BinTransferReportEntity {
  const BinTransferReportModel({
    required super.plant,
    required super.warehouseNumber,
    required super.storageLocation,
    required super.sourceStorageType,
    required super.sourceStorageSection,
    required super.sourceStorageBin,
    required super.destinationStorageType,
    required super.destinationStorageSection,
    required super.destinationStorageBin,
    required super.totalMaterials,
    required super.totalQuantity,
    required super.materials,
    super.transferDate,
  });

  factory BinTransferReportModel.fromJson(Map<String, dynamic> json) {
    final materialsList = (json['materials'] as List<dynamic>?)
            ?.map((item) => BinTransferReportMaterialModel.fromJson(
                item as Map<String, dynamic>))
            .toList() ??
        [];

    return BinTransferReportModel(
      plant: json['plant'] as String? ?? '',
      warehouseNumber: json['warehouseNumber'] as String? ?? '',
      storageLocation: json['storageLocation'] as String? ?? '',
      sourceStorageType: json['sourceStorageType'] as String? ?? '',
      sourceStorageSection: json['sourceStorageSection'] as String? ?? '',
      sourceStorageBin: json['sourceStorageBin'] as String? ?? '',
      destinationStorageType: json['destinationStorageType'] as String? ?? '',
      destinationStorageSection:
          json['destinationStorageSection'] as String? ?? '',
      destinationStorageBin: json['destinationStorageBin'] as String? ?? '',
      totalMaterials: (json['totalMaterials'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['totalQuantity'] as num?)?.toInt() ?? 0,
      materials: materialsList,
    );
  }
}


