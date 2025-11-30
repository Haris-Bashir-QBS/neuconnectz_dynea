import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_result_entity.dart';

class OutboundDeliverySalesListResponseModel {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final OutboundDeliverySalesListDataModel? data;
  final List<dynamic> exception;

  OutboundDeliverySalesListResponseModel({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    required this.exception,
  });

  factory OutboundDeliverySalesListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OutboundDeliverySalesListResponseModel(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? OutboundDeliverySalesListDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
      exception: json['exception'] ?? [],
    );
  }

  OutboundDeliverySalesResultEntity toEntity() {
    return OutboundDeliverySalesResultEntity(
      totalCount: data?.totalRows ?? 0,
      data: data?.data.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

class OutboundDeliverySalesListDataModel {
  final int totalRows;
  final List<OutboundDeliverySalesModel> data;

  OutboundDeliverySalesListDataModel({
    required this.totalRows,
    required this.data,
  });

  factory OutboundDeliverySalesListDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OutboundDeliverySalesListDataModel(
      totalRows: json['totalRows'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => OutboundDeliverySalesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OutboundDeliverySalesModel extends OutboundDeliverySalesEntity {
  const OutboundDeliverySalesModel({
    required super.delivery,
    required super.salesOrganization,
    required super.deliveryType,
    required super.receivingPlant,
    required super.deliveryBlock,
    required super.overallStatus,
    required super.goodsMovementSts,
    required super.plant,
    required super.storageLocation,
  });

  factory OutboundDeliverySalesModel.fromJson(Map<String, dynamic> json) {
    return OutboundDeliverySalesModel(
      delivery: json['delivery']?.toString() ?? '',
      salesOrganization: json['salesOrganization']?.toString() ?? '',
      deliveryType: json['deliveryType']?.toString() ?? '',
      receivingPlant: json['receivingPlant']?.toString() ?? '',
      deliveryBlock: json['deliveryBlock']?.toString() ?? '',
      overallStatus: json['overallStatus']?.toString() ?? '',
      goodsMovementSts: json['goodsMovementSts']?.toString() ?? '',
      plant: json['plant']?.toString() ?? '',
      storageLocation: json['storageLocation']?.toString() ?? '',
    );
  }

  OutboundDeliverySalesEntity toEntity() => OutboundDeliverySalesEntity(
        delivery: delivery,
        salesOrganization: salesOrganization,
        deliveryType: deliveryType,
        receivingPlant: receivingPlant,
        deliveryBlock: deliveryBlock,
        overallStatus: overallStatus,
        goodsMovementSts: goodsMovementSts,
        plant: plant,
        storageLocation: storageLocation,
      );
}

