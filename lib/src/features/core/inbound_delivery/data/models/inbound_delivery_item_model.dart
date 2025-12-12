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

  factory InboundDeliveryItemResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return InboundDeliveryItemResponseModel(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? InboundDeliveryItemDataModel.fromJson(
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

class InboundDeliveryItemDataModel {
  final int totalRows;
  final List<InboundDeliveryItemModel> data;

  InboundDeliveryItemDataModel({required this.totalRows, required this.data});

  factory InboundDeliveryItemDataModel.fromJson(Map<String, dynamic> json) {
    try {
      return InboundDeliveryItemDataModel(
        totalRows: json['totalRecords'] ?? json['totalRows'] ?? 0,
        data: json['data'] != null && json['data'] is List<dynamic>
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
  final String stoNo;
  final int stoItemNo;
  final String outboundDeliveryNo;
  final int deliveryItemNo;
  final String batchNo;
  final double quantity;
  final String? materialNo;
  final String? materialDescription;

  InboundDeliveryItemModel({
    required this.stoNo,
    required this.stoItemNo,
    required this.outboundDeliveryNo,
    required this.deliveryItemNo,
    required this.batchNo,
    required this.quantity,
    this.materialNo,
    this.materialDescription,
  });

  factory InboundDeliveryItemModel.fromJson(Map<String, dynamic> json) {
    return InboundDeliveryItemModel(
      stoNo: json['stoNo'] ?? '',
      stoItemNo: json['stoItemNo'] ?? 0,
      outboundDeliveryNo: json['outboundDeliveryNo'] ?? '',
      deliveryItemNo: json['deliveryItemNo'] ?? 0,
      batchNo: json['batchNo'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      materialNo: json['materialNo'],
      materialDescription: json['materialDescription'],
    );
  }

  InboundDeliveryItemEntity toEntity() => InboundDeliveryItemEntity(
        stoNo: stoNo,
        stoItemNo: stoItemNo,
        outboundDeliveryNo: outboundDeliveryNo,
        deliveryItemNo: deliveryItemNo,
        batchNo: batchNo,
        quantity: quantity,
        materialNo: materialNo,
        materialDescription: materialDescription,
      );

  Map<String, dynamic> toJson() => {
        'stoNo': stoNo,
        'stoItemNo': stoItemNo,
        'outboundDeliveryNo': outboundDeliveryNo,
        'deliveryItemNo': deliveryItemNo,
        'batchNo': batchNo,
        'quantity': quantity,
        'materialNo': materialNo,
        'materialDescription': materialDescription,
      };
}

