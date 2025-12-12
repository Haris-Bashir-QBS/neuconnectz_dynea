import 'package:equatable/equatable.dart';

class ProductionReceiptItemEntity extends Equatable {
  final String warehouseNumber;
  final int trNumber;
  final int trItem;
  final String material;
  final String? materialDescription;
  final String plant;
  final String batch;
  final double trQuantity;
  final String alternativeUOM;
  final String storageLocation;
  final List<ProductionReceiptItemBinDetailEntity> binDetails;
  final int? docNum;

  const ProductionReceiptItemEntity({
    required this.warehouseNumber,
    required this.trNumber,
    required this.trItem,
    required this.material,
    this.materialDescription,
    required this.plant,
    required this.batch,
    required this.trQuantity,
    required this.alternativeUOM,
    required this.storageLocation,
    this.binDetails = const [],
    this.docNum,
  });

  @override
  List<Object?> get props => [
        warehouseNumber,
        trNumber,
        trItem,
        material,
        materialDescription,
        plant,
        batch,
        trQuantity,
        alternativeUOM,
        storageLocation,
        binDetails,
        docNum,
      ];
}

class ProductionReceiptItemBinDetailEntity extends Equatable {
  final String binCode;
  final String storageType;
  final String storageSection;
  final double quantity;

  const ProductionReceiptItemBinDetailEntity({
    required this.binCode,
    required this.storageType,
    required this.storageSection,
    required this.quantity,
  });

  @override
  List<Object?> get props => [binCode, storageType, storageSection, quantity];
}

