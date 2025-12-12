import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_entity.dart';

class OutboundDeliveryStoListResponseModel
    extends ApiResponse<List<OutboundDeliveryStoEntity>> {
  OutboundDeliveryStoListResponseModel({
    required super.data,
    required super.isApiHandled,
    required super.isRequestSuccess,
    required super.statusCode,
    required super.message,
    required super.exception,
  });

  factory OutboundDeliveryStoListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    // The actual list is nested inside data.data
    final dataMap = json['data'] as Map<String, dynamic>?;
    final dataList = dataMap?['data'] as List<dynamic>?;
    
    return OutboundDeliveryStoListResponseModel(
      data: dataList
              ?.map((e) => OutboundDeliveryStoModel.fromJson(e))
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

class OutboundDeliveryStoModel extends OutboundDeliveryStoEntity {
  const OutboundDeliveryStoModel({
    required super.delivery,
    required super.salesOrganization,
    required super.deliveryType,
    required super.orderCombination,
    required super.receivingPlant,
    required super.overallStatus,
    required super.goodsMovementSts,
    required super.plant,
    required super.storageLocation,
  });

  factory OutboundDeliveryStoModel.fromJson(Map<String, dynamic> json) {
    return OutboundDeliveryStoModel(
      delivery: json['delivery']?.toString() ?? '',
      salesOrganization: json['salesOrganization']?.toString() ?? '',
      deliveryType: json['deliveryType']?.toString() ?? '',
      orderCombination: json['orderCombination']?.toString() ?? '',
      receivingPlant: json['receivingPlant']?.toString() ?? '',
      overallStatus: json['overallStatus']?.toString() ?? '',
      goodsMovementSts: json['goodsMovementSts']?.toString() ?? '',
      plant: json['plant']?.toString() ?? '',
      storageLocation: json['storageLocation']?.toString() ?? '',
    );
  }
}


