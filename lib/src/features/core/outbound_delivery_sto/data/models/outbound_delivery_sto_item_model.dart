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
    final dataMap = json['data'] as Map<String, dynamic>?;
    final dataList = dataMap?['data'] as List<dynamic>?;

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
    return OutboundDeliveryStoItemModel(
      delivery: json['delivery']?.toString() ?? '',
      item: json['item'] ?? 0,
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
    required super.binCode,
    required super.quantity,
  });

  factory BinDetailModel.fromJson(Map<String, dynamic> json) {
    return BinDetailModel(
      binCode: json['binCode']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
