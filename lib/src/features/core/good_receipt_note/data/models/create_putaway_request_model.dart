import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';

class CreatePutAwayRequestModel {
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
  final String supplierName;
  final String purchaseOrder;
  final String materialDocItem;
  final String material;
  final String materialDescription;
  final String plant;
  final String storageLocation;
  final String batch;
  final String specialStock;
  final String baseUOM;
  final List<BinQuantityModel> binQuantities;

  CreatePutAwayRequestModel({
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
    required this.supplierName,
    required this.purchaseOrder,
    required this.materialDocItem,
    required this.material,
    required this.materialDescription,
    required this.plant,
    required this.storageLocation,
    required this.batch,
    required this.specialStock,
    required this.baseUOM,
    required this.binQuantities,
  });

  factory CreatePutAwayRequestModel.fromEntities({
    required GrnEntity grn,
    required GrnItemEntity item,
    required List<BinEntity> bins,
  }) {
    final binModels = bins
        .map(
          (bin) => BinQuantityModel(
            id: bin.id,
            quantity: bin.selectedQuantity,
          ),
        )
        .toList();

    return CreatePutAwayRequestModel(
      warehouseNumber: grn.warehouseNumber,
      trNumber: grn.trNumber,
      headerStatus: grn.headerStatus,
      shipmentType: grn.shipmentType,
      user: grn.user,
      createdOn: grn.createdOn,
      timeOfCreation: grn.timeOfCreation,
      requirementType: grn.requirementType,
      requirementNumber: grn.requirementNumber,
      movementType: item.movementType,
      sourceStorageType: grn.sourceStorageType,
      sourceStorageBin: grn.sourceStorageBin,
      dynamicSourceBin: grn.dynamicSourceBin,
      destStorageType: grn.destStorageType,
      destStorageBin: grn.destStorageBin,
      dynamicStorageBin: grn.dynamicStorageBin,
      materialDocument: grn.materialDocument,
      materialDocYear: grn.materialDocYear,
      numberOfItems: grn.numberOfItems,
      reservation: grn.reservation,
      supplier: grn.supplier,
      supplierName: grn.name,
      purchaseOrder: grn.purchaseOrder,
      materialDocItem: item.materialDocItem.toString().padLeft(5, '0'),
      material: item.material,
      materialDescription: item.materialDescription,
      plant: item.plant,
      storageLocation: item.storageLocation,
      batch: item.batch,
      specialStock: item.specialStock,
      baseUOM: item.baseUOM,
      binQuantities: binModels,
    );
  }

  Map<String, dynamic> toJson() => {
        "warehouseNumber": warehouseNumber,
        "trNumber": trNumber,
        "headerStatus": headerStatus,
        "shipmentType": shipmentType,
        "user": user,
        "createdOn": createdOn,
        "timeOfCreation": timeOfCreation,
        "requirementType": requirementType,
        "requirementNumber": requirementNumber,
        "movementType": movementType,
        "sourceStorageType": sourceStorageType,
        "sourceStorageBin": sourceStorageBin,
        "dynamicSourceBin": dynamicSourceBin,
        "destStorageType": destStorageType,
        "destStorageBin": destStorageBin,
        "dynamicStorageBin": dynamicStorageBin,
        "materialDocument": materialDocument,
        "materialDocYear": materialDocYear,
        "numberOfItems": numberOfItems,
        "reservation": reservation,
        "supplier": supplier,
        "supplierName": supplierName,
        "purchaseOrder": purchaseOrder,
        "materialDocItem": materialDocItem,
        "material": material,
        "materialDescription": materialDescription,
        "plant": plant,
        "storageLocation": storageLocation,
        "batch": batch,
        "specialStock": specialStock,
        "baseUOM": baseUOM,
        "binQuantities": binQuantities.map((bin) => bin.toJson()).toList(),
      };
}

class BinQuantityModel {
  final String id;
  final double quantity;

  BinQuantityModel({
    required this.id,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
      };
}

