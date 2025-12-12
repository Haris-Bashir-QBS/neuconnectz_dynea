import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_result_entity.dart';

class ProductionReceiptItemResponseModel {
  final ProductionReceiptItemResultModel? data;

  ProductionReceiptItemResponseModel({required this.data});

  factory ProductionReceiptItemResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    // Check if response is wrapped
    if (json.containsKey('isApiHandled') || json.containsKey('data')) {
      final dataJson = json['data'] as Map<String, dynamic>?;
      if (dataJson != null) {
        return ProductionReceiptItemResponseModel(
          data: ProductionReceiptItemResultModel.fromJson(dataJson),
        );
      }
    }
    
    // Direct response
    return ProductionReceiptItemResponseModel(
      data: ProductionReceiptItemResultModel.fromJson(json),
    );
  }

  factory ProductionReceiptItemResponseModel.fromCompletedJson(
    Map<String, dynamic> json,
  ) {
    // Check if response is wrapped
    if (json.containsKey('isApiHandled') || json.containsKey('data')) {
      final dataJson = json['data'] as Map<String, dynamic>?;
      if (dataJson != null) {
        return ProductionReceiptItemResponseModel(
          data: ProductionReceiptItemResultModel.fromCompletedJson(dataJson),
        );
      }
    }
    
    // Direct response
    return ProductionReceiptItemResponseModel(
      data: ProductionReceiptItemResultModel.fromCompletedJson(json),
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

  factory ProductionReceiptItemResultModel.fromCompletedJson(
    Map<String, dynamic> json,
  ) {
    final items = (json['data'] as List<dynamic>? ?? [])
        .map((e) => ProductionReceiptItemModel.fromCompletedJson(e))
        .toList();

    return ProductionReceiptItemResultModel(
      totalRows: json['totalRecords'] ?? 0, // Completed API uses 'totalRecords'
      data: items,
    );
  }
}

class ProductionReceiptItemModel {
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
  final List<ProductionReceiptItemBinDetailModel> binQuantities;
  final int? docNum;

  ProductionReceiptItemModel({
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
    this.binQuantities = const [],
    this.docNum,
  });

  factory ProductionReceiptItemModel.fromJson(Map<String, dynamic> json) {
    return ProductionReceiptItemModel(
      warehouseNumber: json['warehouseNumber'] ?? '',
      trNumber: json['trNumber'] ?? 0,
      trItem: json['trItem'] ?? 0,
      material: json['material'] ?? '',
      materialDescription: json['materialDescription'],
      plant: json['plant'] ?? '',
      batch: json['batch'] ?? '',
      trQuantity: (json['trQuantity'] ?? 0).toDouble(),
      alternativeUOM: json['alternativeUOM'] ?? '',
      storageLocation: json['storageLocation'] ?? '',
      docNum: json['docNum'],
    );
  }

  factory ProductionReceiptItemModel.fromCompletedJson(Map<String, dynamic> json) {
    final binQuantities = (json['binQuantities'] as List<dynamic>? ?? [])
        .map((e) => ProductionReceiptItemBinDetailModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ProductionReceiptItemModel(
      warehouseNumber: json['warehouse'] ?? '', // Completed API uses 'warehouse'
      trNumber: json['trNumber'] ?? 0,
      trItem: json['trItem'] ?? 0,
      material: json['material'] ?? '',
      materialDescription: json['materialDescription'],
      plant: json['plant'] ?? '',
      batch: json['batch'] ?? '',
      trQuantity: (json['totalQuantity'] ?? 0).toDouble(), // Completed API uses 'totalQuantity'
      alternativeUOM: json['uom'] ?? '', // Completed API uses 'uom'
      storageLocation: json['storageLocation'] ?? '',
      binQuantities: binQuantities,
      docNum: json['docNum'],
    );
  }

  ProductionReceiptItemEntity toEntity() {
    return ProductionReceiptItemEntity(
      warehouseNumber: warehouseNumber,
      trNumber: trNumber,
      trItem: trItem,
      material: material,
      materialDescription: materialDescription,
      plant: plant,
      batch: batch,
      trQuantity: trQuantity,
      alternativeUOM: alternativeUOM,
      storageLocation: storageLocation,
      binDetails: binQuantities.map((bin) => bin.toEntity()).toList(),
      docNum: docNum,
    );
  }
}

class ProductionReceiptItemBinDetailModel {
  final String binCode;
  final String storageType;
  final String storageSection;
  final double quantity;

  ProductionReceiptItemBinDetailModel({
    required this.binCode,
    required this.storageType,
    required this.storageSection,
    required this.quantity,
  });

  factory ProductionReceiptItemBinDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductionReceiptItemBinDetailModel(
      binCode: json['binCode'] ?? '',
      storageType: json['storageType'] ?? '',
      storageSection: json['storageSection'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
    );
  }

  ProductionReceiptItemBinDetailEntity toEntity() {
    return ProductionReceiptItemBinDetailEntity(
      binCode: binCode,
      storageType: storageType,
      storageSection: storageSection,
      quantity: quantity,
    );
  }
}

