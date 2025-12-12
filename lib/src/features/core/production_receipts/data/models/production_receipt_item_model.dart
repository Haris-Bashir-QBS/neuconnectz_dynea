import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_result_entity.dart';

class ProductionReceiptItemResponseModel {
  final ProductionReceiptItemResultModel? data;

  ProductionReceiptItemResponseModel({required this.data});

  factory ProductionReceiptItemResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductionReceiptItemResponseModel(
      data: json['data'] == null
          ? null
          : ProductionReceiptItemResultModel.fromJson(
              json['data'] as Map<String, dynamic>,
            ),
    );
  }
}

class ProductionReceiptItemResultModel {
  final int totalRows;
  final List<ProductionReceiptItemModel> data;

  ProductionReceiptItemResultModel({required this.totalRows, required this.data});

  factory ProductionReceiptItemResultModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final items = (json['data'] as List<dynamic>? ?? [])
        .map((e) => ProductionReceiptItemModel.fromJson(e))
        .toList();

    return ProductionReceiptItemResultModel(
      totalRows: json['totalRows'] ?? 0,
      data: items,
    );
  }
}

class ProductionReceiptItemModel {
  final String warehouseNumber;
  final int trNumber;
  final int trItem;
  final String material;
  final String plant;
  final String batch;
  final double trQuantity;
  final String alternativeUOM;
  final String storageLocation;

  ProductionReceiptItemModel({
    required this.warehouseNumber,
    required this.trNumber,
    required this.trItem,
    required this.material,
    required this.plant,
    required this.batch,
    required this.trQuantity,
    required this.alternativeUOM,
    required this.storageLocation,
  });

  factory ProductionReceiptItemModel.fromJson(Map<String, dynamic> json) {
    return ProductionReceiptItemModel(
      warehouseNumber: json['warehouseNumber'] ?? '',
      trNumber: json['trNumber'] ?? 0,
      trItem: json['trItem'] ?? 0,
      material: json['material'] ?? '',
      plant: json['plant'] ?? '',
      batch: json['batch'] ?? '',
      trQuantity: (json['trQuantity'] ?? 0).toDouble(),
      alternativeUOM: json['alternativeUOM'] ?? '',
      storageLocation: json['storageLocation'] ?? '',
    );
  }

  ProductionReceiptItemEntity toEntity() {
    return ProductionReceiptItemEntity(
      warehouseNumber: warehouseNumber,
      trNumber: trNumber,
      trItem: trItem,
      material: material,
      plant: plant,
      batch: batch,
      trQuantity: trQuantity,
      alternativeUOM: alternativeUOM,
      storageLocation: storageLocation,
    );
  }
}

