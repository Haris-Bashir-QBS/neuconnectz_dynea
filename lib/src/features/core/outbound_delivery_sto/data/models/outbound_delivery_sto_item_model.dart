import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_item_entity.dart';

class OutboundDeliveryStoItemResponseModel
    extends ApiResponse<List<OutboundDeliveryStoItemEntity>> {
  OutboundDeliveryStoItemResponseModel({
    required super.data,
    required super.isApiHandled,
    required super.isRequestSuccess,
    required super.statusCode,
    required super.message,
    required super.exception,
  });

  factory OutboundDeliveryStoItemResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    // Handle both old format (with data.data) and new format (with data array directly)
    List<dynamic>? dataList;
    int totalRows = 0;
    
    if (json['data'] is List) {
      // New format: data is directly a list
      dataList = json['data'] as List<dynamic>?;
      totalRows = json['totalRows'] as int? ?? (dataList?.length ?? 0);
    } else if (json['data'] is Map) {
      // Old format: data is a map with data and totalRows
      final dataMap = json['data'] as Map<String, dynamic>?;
      dataList = dataMap?['data'] as List<dynamic>?;
      totalRows = dataMap?['totalRows'] as int? ?? (dataList?.length ?? 0);
    }

    return OutboundDeliveryStoItemResponseModel(
      data: dataList
              ?.map((e) => OutboundDeliveryStoItemModel.fromJson(e))
              .toList() ??
          [],
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      exception: json['exception'] ?? [],
    );
  }

  bool get success => isRequestSuccess;
}

class OutboundDeliveryStoItemModel extends OutboundDeliveryStoItemEntity {
  const OutboundDeliveryStoItemModel({
    required super.delivery,
    required super.item,
    required super.material,
    required super.itemDescription,
    required super.itemCategory,
    required super.batch,
    required super.plant,
    required super.storageLocation,
    required super.deliveryQuantity,
    required super.baseUom,
    required super.referenceDocument,
    required super.movementType,
    required super.precedingDocCateg,
    required super.itemOverallStatus,
    required super.itemGoodsMovementSts,
    super.binDetails,
  });

  factory OutboundDeliveryStoItemModel.fromJson(Map<String, dynamic> json) {
    // Handle item as both int and string
    int itemValue = 0;
    if (json['item'] is int) {
      itemValue = json['item'] as int;
    } else if (json['item'] is String) {
      itemValue = int.tryParse(json['item'] as String) ?? 0;
    }

    return OutboundDeliveryStoItemModel(
      delivery: json['delivery']?.toString() ?? '',
      item: itemValue,
      material: json['material']?.toString() ?? '',
      itemDescription: json['itemDescription']?.toString() ?? '',
      itemCategory: json['itemCategory']?.toString() ?? '',
      batch: json['batch']?.toString() ?? '',
      plant: json['plant']?.toString() ?? '',
      storageLocation: json['storageLocation']?.toString() ?? '',
      deliveryQuantity: (json['deliveryQuantity'] as num?)?.toDouble() ?? 0.0,
      baseUom: json['baseUom']?.toString() ?? '',
      referenceDocument: json['referenceDocument']?.toString() ?? '',
      movementType: json['movementType']?.toString() ?? '',
      precedingDocCateg: json['precedingDocCateg']?.toString() ?? '',
      itemOverallStatus: json['itemOverallStatus']?.toString() ?? '',
      itemGoodsMovementSts: json['itemGoodsMovementSts']?.toString() ?? '',
      binDetails: (json['binDetails'] as List<dynamic>?)
          ?.map((e) => BinDetailModel.fromJson(e))
          .toList(),
    );
  }
}

class BinDetailModel extends BinDetail {
  const BinDetailModel({
    required super.sourceStorageBin,
    required super.quantity,
    super.sourceStorageSection,
    super.sourceStorageType,
    super.batches,
  });

  factory BinDetailModel.fromJson(Map<String, dynamic> json) {
    return BinDetailModel(
      sourceStorageBin: json['sourceStorageBin']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      sourceStorageSection: json['sourceStorageSection']?.toString(),
      sourceStorageType: json['sourceStorageType']?.toString(),
      batches: (json['batches'] as List<dynamic>?)
          ?.map((e) => BatchDetailModel.fromJson(e))
          .toList(),
    );
  }
}

class BatchDetailModel extends BatchDetail {
  const BatchDetailModel({
    required super.batchName,
    required super.quantity,
  });

  factory BatchDetailModel.fromJson(Map<String, dynamic> json) {
    return BatchDetailModel(
      batchName: json['batchName']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
    );
  }
}


