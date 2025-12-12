import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_result_entity.dart';

class ProductionReceiptListResponseModel {
  final ProductionReceiptListResultModel? data;

  ProductionReceiptListResponseModel({required this.data});

  factory ProductionReceiptListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductionReceiptListResponseModel(
      data: json['data'] == null
          ? null
          : ProductionReceiptListResultModel.fromJson(
              json['data'] as Map<String, dynamic>,
            ),
    );
  }
}

class ProductionReceiptListResultModel {
  final int totalRows;
  final List<ProductionReceiptItemModel> data;

  ProductionReceiptListResultModel({required this.totalRows, required this.data});

  factory ProductionReceiptListResultModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final items = (json['data'] as List<dynamic>? ?? [])
        .map((e) => ProductionReceiptItemModel.fromJson(e))
        .toList();

    return ProductionReceiptListResultModel(
      totalRows: json['totalRows'] ?? 0,
      data: items,
    );
  }
}

class ProductionReceiptItemModel {
  final String warehouseNumber;
  final int trNumber;
  final String user;
  final String createdOn;
  final String timeOfCreation;
  final String requirementNumber;
  final String materialDocument;
  final String plant;
  final String storageLocation;

  ProductionReceiptItemModel({
    required this.warehouseNumber,
    required this.trNumber,
    required this.user,
    required this.createdOn,
    required this.timeOfCreation,
    required this.requirementNumber,
    required this.materialDocument,
    required this.plant,
    required this.storageLocation,
  });

  factory ProductionReceiptItemModel.fromJson(Map<String, dynamic> json) {
    return ProductionReceiptItemModel(
      warehouseNumber: json['warehouseNumber'] ?? '',
      trNumber: json['trNumber'] ?? 0,
      user: json['user'] ?? '',
      createdOn: json['createdOn'] ?? '',
      timeOfCreation: json['timeOfCreation'] ?? '',
      requirementNumber: json['requirementNumber'] ?? '',
      materialDocument: json['materialDocument'] ?? '',
      plant: json['plant'] ?? '',
      storageLocation: json['storageLocation'] ?? '',
    );
  }

  ProductionReceiptEntity toEntity() {
    return ProductionReceiptEntity(
      warehouseNumber: warehouseNumber,
      trNumber: trNumber,
      user: user,
      createdOn: createdOn,
      timeOfCreation: timeOfCreation,
      requirementNumber: requirementNumber,
      materialDocument: materialDocument,
      plant: plant,
      storageLocation: storageLocation,
    );
  }
}

