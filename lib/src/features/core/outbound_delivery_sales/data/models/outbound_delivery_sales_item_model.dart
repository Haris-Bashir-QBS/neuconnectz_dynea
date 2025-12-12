import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_items_result_entity.dart';

class OutboundDeliverySalesItemResponseModel
    extends ApiResponse<List<OutboundDeliverySalesItemEntity>> {
  OutboundDeliverySalesItemResponseModel({
    required super.data,
    required super.isApiHandled,
    required super.isRequestSuccess,
    required super.statusCode,
    required super.message,
    required super.exception,
  });

  factory OutboundDeliverySalesItemResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
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

    return OutboundDeliverySalesItemResponseModel(
      data:
          dataList
              ?.map((e) => OutboundDeliverySalesItemModel.fromJson(e))
              .map((model) => model.toEntity())
              .toList() ??
          [],
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      exception: json['exception'] ?? [],
    );
  }

  OutboundDeliverySalesItemsResultEntity toEntity() {
    return OutboundDeliverySalesItemsResultEntity(
      totalCount: data?.length ?? 0,
      data: data ?? [],
    );
  }
}

class OutboundDeliverySalesItemModel {
  final String delivery;
  final int item;
  final String material;
  final String itemDescription;
  final String itemCategory;
  final String batch;
  final String plant;
  final String storageLocation;
  final String? warehouseNo;
  final double deliveryQuantity;
  final String baseUom;
  final String salesUnit;
  final String referenceDocument;
  final String movementType;
  final String materialType;
  final String precedingDocCateg;
  final String itemOverallStatus;
  final String itemMovementSts;
  final List<OutboundDeliverySalesItemBinDetailModel> binDetails;
  final List<CompletedSalesItemBinDetailModel>? completedBinDetails;
  final int? docNum;

  OutboundDeliverySalesItemModel({
    required this.delivery,
    required this.item,
    required this.material,
    required this.itemDescription,
    required this.itemCategory,
    required this.batch,
    required this.plant,
    required this.storageLocation,
    this.warehouseNo,
    required this.deliveryQuantity,
    required this.baseUom,
    required this.salesUnit,
    required this.referenceDocument,
    required this.movementType,
    required this.materialType,
    required this.precedingDocCateg,
    required this.itemOverallStatus,
    required this.itemMovementSts,
    required this.binDetails,
    this.completedBinDetails,
    this.docNum,
  });

  factory OutboundDeliverySalesItemModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    // Handle item as both int and string
    int itemValue = 0;
    if (json['item'] is int) {
      itemValue = json['item'] as int;
    } else if (json['item'] is String) {
      itemValue = int.tryParse(json['item'] as String) ?? 0;
    }

    final rawBinDetails =
        (json['additionalBinDetails'] ??
                json['binDetails'] ??
                json['salesOrderBinDetails'])
            as List<dynamic>? ??
        const [];

    final rawCompletedBinDetails = json['binDetails'] as List<dynamic>?;

    return OutboundDeliverySalesItemModel(
      delivery: json['delivery']?.toString() ?? '',
      item: itemValue,
      material: json['material']?.toString() ?? '',
      itemDescription: json['itemDescription']?.toString() ?? '',
      itemCategory: json['itemCategory']?.toString() ?? '',
      batch: json['batch']?.toString() ?? '',
      plant: json['plant']?.toString() ?? '',
      storageLocation: json['storageLocation']?.toString() ?? '',
      warehouseNo: json['warehouseNo']?.toString(),
      deliveryQuantity: toDouble(json['deliveryQuantity']),
      baseUom: json['baseUom']?.toString() ?? '',
      salesUnit: json['salesUnit']?.toString() ?? '',
      referenceDocument: json['referenceDocument']?.toString() ?? '',
      movementType: json['movementType']?.toString() ?? '',
      materialType: json['materialType']?.toString() ?? '',
      precedingDocCateg: json['precedingDocCateg']?.toString() ?? '',
      itemOverallStatus: json['itemOverallStatus']?.toString() ?? '',
      itemMovementSts: json['itemMovementSts']?.toString() ?? '',
      binDetails:
          rawBinDetails
              .map(
                (e) => OutboundDeliverySalesItemBinDetailModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      completedBinDetails:
          rawCompletedBinDetails
              ?.map(
                (e) => CompletedSalesItemBinDetailModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      docNum: json['docNum'],
    );
  }

  OutboundDeliverySalesItemEntity toEntity() => OutboundDeliverySalesItemEntity(
    delivery: delivery,
    item: item,
    material: material,
    itemDescription: itemDescription,
    itemCategory: itemCategory,
    batch: batch,
    plant: plant,
    storageLocation: storageLocation,
    warehouseNo: warehouseNo,
    deliveryQuantity: deliveryQuantity,
    baseUom: baseUom,
    salesUnit: salesUnit,
    referenceDocument: referenceDocument,
    movementType: movementType,
    materialType: materialType,
    precedingDocCateg: precedingDocCateg,
    itemOverallStatus: itemOverallStatus,
    itemMovementSts: itemMovementSts,
    binDetails: binDetails.map((bin) => bin.toEntity()).toList(),
    completedBinDetails:
        completedBinDetails?.map((bin) => bin.toEntity()).toList(),
    docNum: docNum,
  );
}

class OutboundDeliverySalesItemBinDetailModel {
  final String binCode;
  final String storageType;
  final String storageSection;
  final double proposedQuantity;
  final double actualQuantity;

  OutboundDeliverySalesItemBinDetailModel({
    required this.binCode,
    required this.storageType,
    required this.storageSection,
    required this.proposedQuantity,
    required this.actualQuantity,
  });

  factory OutboundDeliverySalesItemBinDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    return OutboundDeliverySalesItemBinDetailModel(
      binCode: json['binCode']?.toString() ?? '',
      storageType: json['storageType']?.toString() ?? '',
      storageSection: json['storageSection']?.toString() ?? '',
      proposedQuantity: _toDouble(json['proposedQuantity'] ?? json['quantity']),
      actualQuantity: _toDouble(json['actualQuantity'] ?? json['qty']),
    );
  }

  OutboundDeliverySalesItemBinDetailEntity toEntity() =>
      OutboundDeliverySalesItemBinDetailEntity(
        binCode: binCode,
        storageType: storageType,
        storageSection: storageSection,
        proposedQuantity: proposedQuantity,
        actualQuantity: actualQuantity,
      );
}

class CompletedSalesItemBinDetailModel {
  final String sourceStorageBin;
  final String sourceStorageType;
  final String sourceStorageSection;
  final List<CompletedSalesItemBatchDetailModel> batches;

  CompletedSalesItemBinDetailModel({
    required this.sourceStorageBin,
    required this.sourceStorageType,
    required this.sourceStorageSection,
    required this.batches,
  });

  factory CompletedSalesItemBinDetailModel.fromJson(Map<String, dynamic> json) {
    return CompletedSalesItemBinDetailModel(
      sourceStorageBin: json['sourceStorageBin']?.toString() ?? '',
      sourceStorageType: json['sourceStorageType']?.toString() ?? '',
      sourceStorageSection: json['sourceStorageSection']?.toString() ?? '',
      batches:
          (json['batches'] as List<dynamic>? ?? [])
              .map(
                (e) => CompletedSalesItemBatchDetailModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  CompletedSalesItemBinDetail toEntity() => CompletedSalesItemBinDetail(
    sourceStorageBin: sourceStorageBin,
    sourceStorageType: sourceStorageType,
    sourceStorageSection: sourceStorageSection,
    batches: batches.map((batch) => batch.toEntity()).toList(),
  );
}

class CompletedSalesItemBatchDetailModel {
  final String batchName;
  final double quantity;

  CompletedSalesItemBatchDetailModel({
    required this.batchName,
    required this.quantity,
  });

  factory CompletedSalesItemBatchDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    return CompletedSalesItemBatchDetailModel(
      batchName: json['batchName']?.toString() ?? '',
      quantity: _toDouble(json['quantity']),
    );
  }

  CompletedSalesItemBatchDetail toEntity() =>
      CompletedSalesItemBatchDetail(batchName: batchName, quantity: quantity);
}
