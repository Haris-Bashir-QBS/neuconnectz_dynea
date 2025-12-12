import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';

class CreateProductionReceiptRequestModel {
  final String plant;
  final String warehouse;
  final String storageLocation;
  final int trNumber;
  final String requirementNumber;
  final String materialDocument;
  final int trItem;
  final String material;
  final String batch;
  final String uom;
  final List<BinQuantityModel> binQuantities;

  CreateProductionReceiptRequestModel({
    required this.plant,
    required this.warehouse,
    required this.storageLocation,
    required this.trNumber,
    required this.requirementNumber,
    required this.materialDocument,
    required this.trItem,
    required this.material,
    required this.batch,
    required this.uom,
    required this.binQuantities,
  });

  factory CreateProductionReceiptRequestModel.fromEntities({
    required ProductionReceiptEntity header,
    required ProductionReceiptItemEntity item,
    required List<BinEntity> bins,
    required String plant,
    required String warehouse,
    required String storageLocation,
  }) {
    final binModels = bins
        .map(
          (bin) => BinQuantityModel(
            id: bin.id,
            quantity: bin.selectedQuantity,
          ),
        )
        .toList();

    return CreateProductionReceiptRequestModel(
      plant: plant,
      warehouse: warehouse,
      storageLocation: storageLocation,
      trNumber: header.trNumber,
      requirementNumber: header.requirementNumber,
      materialDocument: header.materialDocument,
      trItem: item.trItem,
      material: item.material,
      batch: item.batch,
      uom: item.alternativeUOM,
      binQuantities: binModels,
    );
  }

  Map<String, dynamic> toJson() => {
        "plant": plant,
        "warehouse": warehouse,
        "storageLocation": storageLocation,
        "trNumber": trNumber,
        "requirementNumber": requirementNumber,
        "materialDocument": materialDocument,
        "trItem": trItem,
        "material": material,
        "batch": batch,
        "uom": uom,
        "binQuantities": binQuantities.map((bin) => bin.toJson()).toList(),
      };
}

class BinQuantityModel {
  final String id;
  final double quantity;

  BinQuantityModel({required this.id, required this.quantity});

  Map<String, dynamic> toJson() => {"id": id, "quantity": quantity};
}

