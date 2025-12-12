import 'package:equatable/equatable.dart';

class OutboundDeliverySalesItemEntity extends Equatable {
  final String delivery;
  final int item;
  final String material;
  final String itemDescription;
  final String itemCategory;
  final String batch;
  final String plant;
  final String storageLocation;
  final String? warehouseNo;
  final double deliveryQuantity;
  final String baseUom;
  final String salesUnit;
  final String referenceDocument;
  final String movementType;
  final String materialType;
  final String precedingDocCateg;
  final String itemOverallStatus;
  final String itemMovementSts;
  final List<OutboundDeliverySalesItemBinDetailEntity> binDetails;
  final List<CompletedSalesItemBinDetail>? completedBinDetails; // For completed items

  const OutboundDeliverySalesItemEntity({
    required this.delivery,
    required this.item,
    required this.material,
    required this.itemDescription,
    required this.itemCategory,
    required this.batch,
    required this.plant,
    required this.storageLocation,
    this.warehouseNo,
    required this.deliveryQuantity,
    required this.baseUom,
    required this.salesUnit,
    required this.referenceDocument,
    required this.movementType,
    required this.materialType,
    required this.precedingDocCateg,
    required this.itemOverallStatus,
    required this.itemMovementSts,
    this.binDetails = const [],
    this.completedBinDetails,
  });

  @override
  List<Object?> get props => [
        delivery,
        item,
        material,
        itemDescription,
        itemCategory,
        batch,
        plant,
        storageLocation,
        warehouseNo,
        deliveryQuantity,
        baseUom,
        salesUnit,
        referenceDocument,
        movementType,
        materialType,
        precedingDocCateg,
        itemOverallStatus,
        itemMovementSts,
        binDetails,
        completedBinDetails,
      ];
}

class OutboundDeliverySalesItemBinDetailEntity extends Equatable {
  final String binCode;
  final String storageType;
  final String storageSection;
  final double proposedQuantity;
  final double actualQuantity;

  const OutboundDeliverySalesItemBinDetailEntity({
    required this.binCode,
    required this.storageType,
    required this.storageSection,
    required this.proposedQuantity,
    required this.actualQuantity,
  });

  @override
  List<Object?> get props => [
        binCode,
        storageType,
        storageSection,
        proposedQuantity,
        actualQuantity,
      ];
}

class CompletedSalesItemBinDetail extends Equatable {
  final String sourceStorageBin;
  final String sourceStorageType;
  final String sourceStorageSection;
  final List<CompletedSalesItemBatchDetail> batches;

  const CompletedSalesItemBinDetail({
    required this.sourceStorageBin,
    required this.sourceStorageType,
    required this.sourceStorageSection,
    required this.batches,
  });

  @override
  List<Object?> get props => [
        sourceStorageBin,
        sourceStorageType,
        sourceStorageSection,
        batches,
      ];
}

class CompletedSalesItemBatchDetail extends Equatable {
  final String batchName;
  final double quantity;

  const CompletedSalesItemBatchDetail({
    required this.batchName,
    required this.quantity,
  });

  @override
  List<Object?> get props => [batchName, quantity];
}



