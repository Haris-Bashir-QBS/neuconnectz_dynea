import 'package:equatable/equatable.dart';

class BinTransferReportMaterialEntity extends Equatable {
  final String material;
  final String batch;
  final int quantity;

  const BinTransferReportMaterialEntity({
    required this.material,
    required this.batch,
    required this.quantity,
  });

  @override
  List<Object?> get props => [material, batch, quantity];
}

class BinTransferReportEntity extends Equatable {
  final String plant;
  final String warehouseNumber;
  final String storageLocation;
  final String sourceStorageType;
  final String sourceStorageSection;
  final String sourceStorageBin;
  final String destinationStorageType;
  final String destinationStorageSection;
  final String destinationStorageBin;
  final int totalMaterials;
  final int totalQuantity;
  final List<BinTransferReportMaterialEntity> materials;
  final DateTime? transferDate; // Will be extracted from response if available
  final int? docNum;

  const BinTransferReportEntity({
    required this.plant,
    required this.warehouseNumber,
    required this.storageLocation,
    required this.sourceStorageType,
    required this.sourceStorageSection,
    required this.sourceStorageBin,
    required this.destinationStorageType,
    required this.destinationStorageSection,
    required this.destinationStorageBin,
    required this.totalMaterials,
    required this.totalQuantity,
    required this.materials,
    this.transferDate,
    this.docNum,
  });

  @override
  List<Object?> get props => [
        plant,
        warehouseNumber,
        storageLocation,
        sourceStorageType,
        sourceStorageSection,
        sourceStorageBin,
        destinationStorageType,
        destinationStorageSection,
        destinationStorageBin,
        totalMaterials,
        totalQuantity,
        materials,
        transferDate,
        docNum,
      ];
}


