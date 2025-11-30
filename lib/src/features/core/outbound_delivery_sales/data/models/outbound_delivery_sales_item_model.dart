import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_items_result_entity.dart';

class OutboundDeliverySalesItemResponseModel {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final OutboundDeliverySalesItemDataModel? data;
  final List<dynamic> exception;

  OutboundDeliverySalesItemResponseModel({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    required this.exception,
  });

  factory OutboundDeliverySalesItemResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OutboundDeliverySalesItemResponseModel(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? OutboundDeliverySalesItemDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
      exception: json['exception'] ?? [],
    );
  }

  OutboundDeliverySalesItemsResultEntity toEntity() {
    return OutboundDeliverySalesItemsResultEntity(
      totalCount: data?.totalRows ?? 0,
      data: data?.data.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

class OutboundDeliverySalesItemDataModel {
  final int totalRows;
  final List<OutboundDeliverySalesItemModel> data;

  OutboundDeliverySalesItemDataModel({
    required this.totalRows,
    required this.data,
  });

  factory OutboundDeliverySalesItemDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OutboundDeliverySalesItemDataModel(
      totalRows: json['totalRows'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => OutboundDeliverySalesItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
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

  OutboundDeliverySalesItemModel({
    required this.delivery,
    required this.item,
    required this.material,
    required this.itemDescription,
    required this.itemCategory,
    required this.batch,
    required this.plant,
    required this.storageLocation,
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
  });

  factory OutboundDeliverySalesItemModel.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    final rawBinDetails =
        (json['additionalBinDetails'] ??
                json['binDetails'] ??
                json['salesOrderBinDetails']) as List<dynamic>? ??
            const [];

    return OutboundDeliverySalesItemModel(
      delivery: json['delivery']?.toString() ?? '',
      item: json['item'] ?? 0,
      material: json['material']?.toString() ?? '',
      itemDescription: json['itemDescription']?.toString() ?? '',
      itemCategory: json['itemCategory']?.toString() ?? '',
      batch: json['batch']?.toString() ?? '',
      plant: json['plant']?.toString() ?? '',
      storageLocation: json['storageLocation']?.toString() ?? '',
      deliveryQuantity: _toDouble(json['deliveryQuantity']),
      baseUom: json['baseUom']?.toString() ?? '',
      salesUnit: json['salesUnit']?.toString() ?? '',
      referenceDocument: json['referenceDocument']?.toString() ?? '',
      movementType: json['movementType']?.toString() ?? '',
      materialType: json['materialType']?.toString() ?? '',
      precedingDocCateg: json['precedingDocCateg']?.toString() ?? '',
      itemOverallStatus: json['itemOverallStatus']?.toString() ?? '',
      itemMovementSts: json['itemMovementSts']?.toString() ?? '',
      binDetails: rawBinDetails
          .map(
            (e) => OutboundDeliverySalesItemBinDetailModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
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

