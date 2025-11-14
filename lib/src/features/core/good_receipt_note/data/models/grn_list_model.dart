import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';

class GrnListResponseModel {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final GrnListDataModel? data;
  final List<dynamic> exception;

  GrnListResponseModel({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    required this.exception,
  });

  factory GrnListResponseModel.fromJson(Map<String, dynamic> json) {
    return GrnListResponseModel(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? GrnListDataModel.fromJson(json['data'] as Map<String, dynamic>)
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

class GrnListDataModel {
  final int totalRows;
  final List<GrnListItemModel> data;

  GrnListDataModel({required this.totalRows, required this.data});

  factory GrnListDataModel.fromJson(Map<String, dynamic> json) {
    return GrnListDataModel(
      totalRows: json['totalRows'] ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => GrnListItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'totalRows': totalRows,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class GrnListItemModel {
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

  GrnListItemModel({
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

  factory GrnListItemModel.fromJson(Map<String, dynamic> json) {
    return GrnListItemModel(
      warehouseNumber: json['warehouseNumber'] ?? '',
      trNumber: json['trNumber'] ?? 0,
      headerStatus: json['headerStatus'] ?? '',
      shipmentType: json['shipmentType'] ?? '',
      user: json['user'] ?? '',
      createdOn: json['createdOn'] ?? '',
      timeOfCreation: json['timeOfCreation'] ?? '',
      requirementType: json['requirementType'] ?? '',
      requirementNumber: json['requirementNumber'] ?? '',
      movementType: json['movementType'] ?? '',
      sourceStorageType: json['sourceStorageType'] ?? '',
      sourceStorageBin: json['sourceStorageBin'] ?? '',
      dynamicSourceBin: json['dynamicSourceBin'] ?? '',
      destStorageType: json['destStorageType'] ?? '',
      destStorageBin: json['destStorageBin'] ?? '',
      dynamicStorageBin: json['dynamicStorageBin'] ?? '',
      materialDocument: json['materialDocument'] ?? '',
      materialDocYear: json['materialDocYear'] ?? 0,
      numberOfItems: json['numberOfItems'] ?? 0,
      reservation: json['reservation'] ?? 0,
      supplier: json['supplier'] ?? '',
      name: json['name'] ?? '',
      purchaseOrder: json['purchaseOrder'] ?? '',
    );
  }

  GrnEntity toEntity() => GrnEntity(
    warehouseNumber: warehouseNumber,
    trNumber: trNumber,
    headerStatus: headerStatus,
    shipmentType: shipmentType,
    user: user,
    createdOn: createdOn,
    timeOfCreation: timeOfCreation,
    requirementType: requirementType,
    requirementNumber: requirementNumber,
    movementType: movementType,
    sourceStorageType: sourceStorageType,
    sourceStorageBin: sourceStorageBin,
    dynamicSourceBin: dynamicSourceBin,
    destStorageType: destStorageType,
    destStorageBin: destStorageBin,
    dynamicStorageBin: dynamicStorageBin,
    materialDocument: materialDocument,
    materialDocYear: materialDocYear,
    numberOfItems: numberOfItems,
    reservation: reservation,
    supplier: supplier,
    name: name,
    purchaseOrder: purchaseOrder,
  );

  Map<String, dynamic> toJson() => {
    'warehouseNumber': warehouseNumber,
    'trNumber': trNumber,
    'headerStatus': headerStatus,
    'shipmentType': shipmentType,
    'user': user,
    'createdOn': createdOn,
    'timeOfCreation': timeOfCreation,
    'requirementType': requirementType,
    'requirementNumber': requirementNumber,
    'movementType': movementType,
    'sourceStorageType': sourceStorageType,
    'sourceStorageBin': sourceStorageBin,
    'dynamicSourceBin': dynamicSourceBin,
    'destStorageType': destStorageType,
    'destStorageBin': destStorageBin,
    'dynamicStorageBin': dynamicStorageBin,
    'materialDocument': materialDocument,
    'materialDocYear': materialDocYear,
    'numberOfItems': numberOfItems,
    'reservation': reservation,
    'supplier': supplier,
    'name': name,
    'purchaseOrder': purchaseOrder,
  };
}
