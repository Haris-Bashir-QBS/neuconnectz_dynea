import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_entity.dart';

class InboundDeliveryItemResponseModel {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final InboundDeliveryItemDataModel? data;
  final List<dynamic> exception;

  InboundDeliveryItemResponseModel({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    required this.exception,
  });

  factory InboundDeliveryItemResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle wrapped response structure (check for wrapper keys first)
    if (json.containsKey('isApiHandled') || json.containsKey('isRequestSuccess')) {
      return InboundDeliveryItemResponseModel(
        isApiHandled: json['isApiHandled'] ?? false,
        isRequestSuccess: json['isRequestSuccess'] ?? false,
        statusCode: json['statusCode'] ?? 0,
        message: json['message'] ?? '',
        data:
            json['data'] != null && json['data'] is Map<String, dynamic>
                ? InboundDeliveryItemDataModel.fromJson(
                  json['data'] as Map<String, dynamic>,
                )
                : null,
        exception: json['exception'] ?? [],
      );
    }

    // Handle direct response structure (without wrapper)
    return InboundDeliveryItemResponseModel(
      isApiHandled: true,
      isRequestSuccess: true,
      statusCode: 200,
      message: 'Success',
      data: InboundDeliveryItemDataModel.fromJson(json),
      exception: [],
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

class InboundDeliveryItemDataModel {
  final int totalRows;
  final List<InboundDeliveryItemModel> data;

  InboundDeliveryItemDataModel({required this.totalRows, required this.data});

  factory InboundDeliveryItemDataModel.fromJson(Map<String, dynamic> json) {
    try {
      return InboundDeliveryItemDataModel(
        totalRows: json['totalRecords'] ?? json['totalRows'] ?? 0,
        data:
            json['data'] != null && json['data'] is List<dynamic>
                ? (json['data'] as List<dynamic>)
                    .map(
                      (e) => InboundDeliveryItemModel.fromJson(
                        e as Map<String, dynamic>,
                      ),
                    )
                    .toList()
                : [],
      );
    } catch (e) {
      // Return empty data if parsing fails
      return InboundDeliveryItemDataModel(totalRows: 0, data: []);
    }
  }

  Map<String, dynamic> toJson() => {
    'totalRecords': totalRows,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class InboundDeliveryItemModel {
  final int? docNum;
  final String? receivingPlant;
  final String? receivingStorageLocation;
  final String? receivingWarehouse;
  final String stoNo;
  final int stoItemNo;
  final String outboundDeliveryNo;
  final int deliveryItemNo;
  final String? issuingPlant;
  final String batchNo;
  final double quantity;
  final double? totalQuantity;
  final String? materialNo;
  final String? uom;
  final String? materialDescription;
  final List<InboundDeliveryItemBinDetailModel> binQuantities;

  InboundDeliveryItemModel({
    this.docNum,
    this.receivingPlant,
    this.receivingStorageLocation,
    this.receivingWarehouse,
    required this.stoNo,
    required this.stoItemNo,
    required this.outboundDeliveryNo,
    required this.deliveryItemNo,
    this.issuingPlant,
    required this.batchNo,
    required this.quantity,
    this.totalQuantity,
    this.materialNo,
    this.uom,
    this.materialDescription,
    this.binQuantities = const [],
  });

  factory InboundDeliveryItemModel.fromJson(Map<String, dynamic> json) {
    List<InboundDeliveryItemBinDetailModel> binDetails = [];
    if (json['binQuantities'] != null && json['binQuantities'] is List) {
      binDetails = (json['binQuantities'] as List<dynamic>)
          .map((e) => InboundDeliveryItemBinDetailModel.fromJson(
                e as Map<String, dynamic>,
              ))
          .toList();
    }

    return InboundDeliveryItemModel(
      docNum: json['docNum'],
      receivingPlant: json['receivingPlant'],
      receivingStorageLocation: json['receivingStorageLocation'],
      receivingWarehouse: json['receivingWarehouse'],
      stoNo: json['stoNo'] ?? '',
      stoItemNo: json['stoItemNo'] ?? 0,
      outboundDeliveryNo: json['outboundDeliveryNo'] ?? '',
      deliveryItemNo: json['deliveryItemNo'] ?? 0,
      issuingPlant: json['issuingPlant'],
      batchNo: json['batchNo'] ?? '',
      quantity: (json['quantity'] ?? json['totalQuantity'] ?? 0).toDouble(),
      totalQuantity: json['totalQuantity'] != null
          ? (json['totalQuantity'] as num).toDouble()
          : null,
      materialNo: json['materialNo'],
      materialDescription: json['materialDescription'],
      uom: json['uom'],
      binQuantities: binDetails,
    );
  }

  InboundDeliveryItemEntity toEntity() => InboundDeliveryItemEntity(
    stoNo: stoNo,
    stoItemNo: stoItemNo,
    outboundDeliveryNo: outboundDeliveryNo,
    deliveryItemNo: deliveryItemNo,
    batchNo: batchNo,
    quantity: totalQuantity ?? quantity,
    materialNo: materialNo,
    materialDescription: materialDescription,
    uom: uom,
    binDetails: binQuantities
        .map((bin) => InboundDeliveryItemBinDetailEntity(
              binCode: bin.binCode,
              storageType: bin.storageType,
              storageSection: bin.storageSection,
              quantity: bin.quantity,
            ))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'docNum': docNum,
    'receivingPlant': receivingPlant,
    'receivingStorageLocation': receivingStorageLocation,
    'receivingWarehouse': receivingWarehouse,
    'stoNo': stoNo,
    'stoItemNo': stoItemNo,
    'outboundDeliveryNo': outboundDeliveryNo,
    'deliveryItemNo': deliveryItemNo,
    'issuingPlant': issuingPlant,
    'batchNo': batchNo,
    'quantity': quantity,
    'totalQuantity': totalQuantity,
    'materialNo': materialNo,
    'materialDescription': materialDescription,
    'uom': uom,
    'binQuantities': binQuantities.map((bin) => bin.toJson()).toList(),
  };
}

class InboundDeliveryItemBinDetailModel {
  final String binCode;
  final String storageType;
  final String storageSection;
  final double quantity;

  InboundDeliveryItemBinDetailModel({
    required this.binCode,
    required this.storageType,
    required this.storageSection,
    required this.quantity,
  });

  factory InboundDeliveryItemBinDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return InboundDeliveryItemBinDetailModel(
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
}
