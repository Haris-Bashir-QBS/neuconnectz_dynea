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

  const OutboundDeliverySalesItemEntity({
    required this.delivery,
    required this.item,
    required this.material,
    required this.itemDescription,
    required this.itemCategory,
    required this.batch,
    required this.plant,
    required this.storageLocation,
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

