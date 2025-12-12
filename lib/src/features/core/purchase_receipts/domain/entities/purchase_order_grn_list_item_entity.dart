import 'package:equatable/equatable.dart';

class PurchaseOrderGrnEntity extends Equatable {
  final String warehouseNumber;
  final int trNumber;
  final String headerStatus;
  final String shipmentType;
  final String user;
  final String createdOn;
  final String timeOfCreation;
  final String requirementType;
  final String requirementNumber;
  final String movementType;
  final String sourceStorageType;
  final String sourceStorageBin;
  final String dynamicSourceBin;
  final String destStorageType;
  final String destStorageBin;
  final String dynamicStorageBin;
  final String materialDocument;
  final int materialDocYear;
  final int numberOfItems;
  final int reservation;
  final String supplier;
  final String name;
  final String purchaseOrder;

  const PurchaseOrderGrnEntity({
    required this.warehouseNumber,
    required this.trNumber,
    required this.headerStatus,
    required this.shipmentType,
    required this.user,
    required this.createdOn,
    required this.timeOfCreation,
    required this.requirementType,
    required this.requirementNumber,
    required this.movementType,
    required this.sourceStorageType,
    required this.sourceStorageBin,
    required this.dynamicSourceBin,
    required this.destStorageType,
    required this.destStorageBin,
    required this.dynamicStorageBin,
    required this.materialDocument,
    required this.materialDocYear,
    required this.numberOfItems,
    required this.reservation,
    required this.supplier,
    required this.name,
    required this.purchaseOrder,
  });

  @override
  List<Object?> get props => [
    warehouseNumber,
    trNumber,
    headerStatus,
    shipmentType,
    user,
    createdOn,
    timeOfCreation,
    requirementType,
    requirementNumber,
    movementType,
    sourceStorageType,
    sourceStorageBin,
    dynamicSourceBin,
    destStorageType,
    destStorageBin,
    dynamicStorageBin,
    materialDocument,
    materialDocYear,
    numberOfItems,
    reservation,
    supplier,
    name,
    purchaseOrder,
  ];
}
