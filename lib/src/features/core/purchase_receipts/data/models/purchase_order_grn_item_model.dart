import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_item_entity.dart';

class PurchaseOrderGrnItemResponseModel {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final GrnItemDataModel? data;
  final List<dynamic> exception;

  PurchaseOrderGrnItemResponseModel({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    required this.exception,
  });

  factory PurchaseOrderGrnItemResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseOrderGrnItemResponseModel(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data:
          json['data'] != null && json['data'] is Map<String, dynamic>
              ? GrnItemDataModel.fromJson(json['data'] as Map<String, dynamic>)
              : null,
      exception: json['exception'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'isApiHandled': isApiHandled,
    'isRequestSuccess': isRequestSuccess,
    'statusCode': statusCode,
    'message': message,
    'data': data?.toJson(),
    'exception': exception,
  };
}

class GrnItemDataModel {
  final int totalRows;
  final List<GrnItemModel> data;

  GrnItemDataModel({required this.totalRows, required this.data});

  factory GrnItemDataModel.fromJson(Map<String, dynamic> json) {
    try {
      return GrnItemDataModel(
        totalRows: json['totalRecords'] ?? json['totalRows'] ?? 0,
        data:
            json['data'] != null && json['data'] is List<dynamic>
                ? (json['data'] as List<dynamic>)
                    .map(
                      (e) => GrnItemModel.fromJson(e as Map<String, dynamic>),
                    )
                    .toList()
                : [],
      );
    } catch (e) {
      // Return empty data if parsing fails
      return GrnItemDataModel(totalRows: 0, data: []);
    }
  }

  Map<String, dynamic> toJson() => {
    'totalRecords': totalRows,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class GrnItemModel {
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
  final List<GrnItemBinDetailModel> binDetails;
  final int? docNum;

  GrnItemModel({
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

  factory GrnItemModel.fromJson(Map<String, dynamic> json) {
    return GrnItemModel(
      materialDocument: json['materialDocument'] ?? '',
      materialDocYear: json['materialDocYear'] ?? 0,
      materialDocItem: json['materialDocItem'] ?? 0,
      movementType: json['movementType'] ?? '',
      material: json['material'] ?? '',
      materialDescription: json['materialDescription'] ?? '',
      plant: json['plant'] ?? '',
      storageLocation: json['storageLocation'] ?? '',
      batch: json['batch'] ?? '',
      specialStock: json['specialStock'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      baseUOM: json['baseUOM'] ?? '',
      binDetails:
          (json['binDetails'] as List<dynamic>?)
              ?.map(
                (e) =>
                    GrnItemBinDetailModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      docNum: json['docNum'],
    );
  }

  PurchaseOrderGrnItemEntity toEntity() => PurchaseOrderGrnItemEntity(
    materialDocument: materialDocument,
    materialDocYear: materialDocYear,
    materialDocItem: materialDocItem,
    movementType: movementType,
    material: material,
    materialDescription: materialDescription,
    plant: plant,
    storageLocation: storageLocation,
    batch: batch,
    specialStock: specialStock,
    quantity: quantity,
    baseUOM: baseUOM,
    binDetails: binDetails.map((e) => e.toEntity()).toList(),
    docNum: docNum,
  );

  Map<String, dynamic> toJson() => {
    'materialDocument': materialDocument,
    'materialDocYear': materialDocYear,
    'materialDocItem': materialDocItem,
    'movementType': movementType,
    'material': material,
    'materialDescription': materialDescription,
    'plant': plant,
    'storageLocation': storageLocation,
    'batch': batch,
    'specialStock': specialStock,
    'quantity': quantity,
    'baseUOM': baseUOM,
    'binDetails': binDetails.map((e) => e.toJson()).toList(),
    'docNum': docNum,
  };
}

class GrnItemBinDetailModel {
  final String binCode;
  final String storageType;
  final String storageSection;
  final double quantity;

  GrnItemBinDetailModel({
    required this.binCode,
    required this.storageType,
    required this.storageSection,
    required this.quantity,
  });

  factory GrnItemBinDetailModel.fromJson(Map<String, dynamic> json) {
    return GrnItemBinDetailModel(
      binCode: json['binCode'] ?? '',
      storageType: json['storageType'] ?? '',
      storageSection: json['storageSection'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'binCode': binCode,
    'storageType': storageType,
    'storageSection': storageSection,
    'quantity': quantity,
  };

  PurchaseOrderGrnItemBinDetailEntity toEntity() =>
      PurchaseOrderGrnItemBinDetailEntity(
        binCode: binCode,
        storageType: storageType,
        storageSection: storageSection,
        quantity: quantity,
      );
}
