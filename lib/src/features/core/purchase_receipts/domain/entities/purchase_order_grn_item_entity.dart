import 'package:equatable/equatable.dart';

class PurchaseOrderGrnItemEntity extends Equatable {
  final String materialDocument;
  final int materialDocYear;
  final int materialDocItem;
  final String movementType;
  final String material;
  final String materialDescription;
  final String plant;
  final String storageLocation;
  final String batch;
  final String specialStock;
  final double quantity;
  final String baseUOM;
  final List<PurchaseOrderGrnItemBinDetailEntity> binDetails;
  final int? docNum;

  const PurchaseOrderGrnItemEntity({
    required this.materialDocument,
    required this.materialDocYear,
    required this.materialDocItem,
    required this.movementType,
    required this.material,
    required this.materialDescription,
    required this.plant,
    required this.storageLocation,
    required this.batch,
    required this.specialStock,
    required this.quantity,
    required this.baseUOM,
    this.binDetails = const [],
    this.docNum,
  });

  @override
  List<Object?> get props => [
    materialDocument,
    materialDocYear,
    materialDocItem,
    movementType,
    material,
    materialDescription,
    plant,
    storageLocation,
    batch,
    specialStock,
    quantity,
    baseUOM,
    binDetails,
    docNum,
  ];
}

class PurchaseOrderGrnItemBinDetailEntity extends Equatable {
  final String binCode;
  final String storageType;
  final String storageSection;
  final double quantity;

  const PurchaseOrderGrnItemBinDetailEntity({
    required this.binCode,
    required this.storageType,
    required this.storageSection,
    required this.quantity,
  });

  @override
  List<Object?> get props => [binCode, storageType, storageSection, quantity];
}
