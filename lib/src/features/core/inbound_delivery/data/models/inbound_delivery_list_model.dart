import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_list_item_entity.dart';

class InboundDeliveryListResponseModel {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final InboundDeliveryListDataModel? data;
  final List<dynamic> exception;

  InboundDeliveryListResponseModel({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    required this.exception,
  });

  factory InboundDeliveryListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return InboundDeliveryListResponseModel(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? InboundDeliveryListDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
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

class InboundDeliveryListDataModel {
  final int totalRows;
  final List<InboundDeliveryListItemModel> data;

  InboundDeliveryListDataModel({
    required this.totalRows,
    required this.data,
  });

  factory InboundDeliveryListDataModel.fromJson(Map<String, dynamic> json) {
    return InboundDeliveryListDataModel(
      totalRows: json['totalRows'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map(
                (e) => InboundDeliveryListItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'totalRows': totalRows,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class InboundDeliveryListItemModel {
  final String stoNo;
  final String outboundDeliveryNo;
  final String materialNo;
  final String materialDescription;
  final String issuingPlant;
  final int totalItem;

  InboundDeliveryListItemModel({
    required this.stoNo,
    required this.outboundDeliveryNo,
    required this.materialNo,
    required this.materialDescription,
    required this.issuingPlant,
    required this.totalItem,
  });

  factory InboundDeliveryListItemModel.fromJson(Map<String, dynamic> json) {
    return InboundDeliveryListItemModel(
      stoNo: json['stoNo'] ?? '',
      outboundDeliveryNo: json['outboundDeliveryNo'] ?? '',
      materialNo: json['materialNo'] ?? '',
      materialDescription: json['materialDescription'] ?? '',
      issuingPlant: json['issuingPlant'] ?? '',
      totalItem: json['totalItem'] ?? 0,
    );
  }

  InboundDeliveryEntity toEntity() => InboundDeliveryEntity(
        stoNo: stoNo,
        outboundDeliveryNo: outboundDeliveryNo,
        materialNo: materialNo,
        materialDescription: materialDescription,
        issuingPlant: issuingPlant,
        totalItem: totalItem,
      );

  Map<String, dynamic> toJson() => {
        'stoNo': stoNo,
        'outboundDeliveryNo': outboundDeliveryNo,
        'materialNo': materialNo,
        'materialDescription': materialDescription,
        'issuingPlant': issuingPlant,
        'totalItem': totalItem,
      };
}



