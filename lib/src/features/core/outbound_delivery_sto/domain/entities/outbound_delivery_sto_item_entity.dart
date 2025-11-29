import 'package:equatable/equatable.dart';

class OutboundDeliveryStoItemEntity extends Equatable {
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
  final String referenceDocument;
  final String movementType;
  final String precedingDocCateg;
  final String itemOverallStatus;
  final String itemGoodsMovementSts;
  final List<BinDetail>? binDetails; // For completed items

  const OutboundDeliveryStoItemEntity({
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
    required this.referenceDocument,
    required this.movementType,
    required this.precedingDocCateg,
    required this.itemOverallStatus,
    required this.itemGoodsMovementSts,
    this.binDetails,
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
        referenceDocument,
        movementType,
        precedingDocCateg,
        itemOverallStatus,
        itemGoodsMovementSts,
        binDetails,
      ];
}

class BinDetail extends Equatable {
  final String binCode;
  final double quantity;

  const BinDetail({
    required this.binCode,
    required this.quantity,
  });

  @override
  List<Object?> get props => [binCode, quantity];
}
