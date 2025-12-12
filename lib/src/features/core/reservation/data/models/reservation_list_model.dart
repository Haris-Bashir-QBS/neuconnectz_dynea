import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_result_entity.dart';

class ReservationListResponseModel {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final ReservationListDataModel? data;
  final List<dynamic> exception;

  ReservationListResponseModel({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    required this.exception,
  });

  factory ReservationListResponseModel.fromJson(Map<String, dynamic> json) {
    return ReservationListResponseModel(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? ReservationListDataModel.fromJson(
                json['data'] as Map<String, dynamic>,
              )
              : null,
      exception: json['exception'] ?? [],
    );
  }

  ReservationResultEntity toEntity() {
    return ReservationResultEntity(
      totalCount: data?.totalRows ?? 0,
      data: data?.data.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

class ReservationListDataModel {
  final int totalRows; // totalCount se totalRows
  final List<ReservationModel> data;

  ReservationListDataModel({required this.totalRows, required this.data});

  factory ReservationListDataModel.fromJson(Map<String, dynamic> json) {
    return ReservationListDataModel(
      totalRows: json['totalRows'] ?? json['totalCount'] ?? 0,
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((e) => ReservationModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class ReservationModel {
  final int reservation;
  final String requirementType;
  final String reservStatus;
  final String movementType;
  final String requirementsDate;
  final String purchaseRequisition;
  final int itemOfRequisition;
  final String order;
  final String receivingPlant;
  final String receivingStorLoc;
  final double quantity;

  ReservationModel({
    required this.reservation,
    required this.requirementType,
    required this.reservStatus,
    required this.movementType,
    required this.requirementsDate,
    required this.purchaseRequisition,
    required this.itemOfRequisition,
    required this.order,
    required this.receivingPlant,
    required this.receivingStorLoc,
    required this.quantity,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      reservation: json['reservation'] ?? 0,
      requirementType: json['requirementType'] ?? '',
      reservStatus: json['reservStatus'] ?? '',
      movementType: json['movementType'] ?? '',
      requirementsDate: json['requirementsDate'] ?? '',
      purchaseRequisition: json['purchaseRequisition'] ?? '',
      itemOfRequisition: json['itemOfRequisition'] ?? 0,
      order: json['order'] ?? '',
      receivingPlant: json['receivingPlant'] ?? '',
      receivingStorLoc: json['receivingStorLoc'] ?? '',
      quantity:
          (json['quantity'] ?? json['requirementQuantity'] ?? 0).toDouble(),
    );
  }

  ReservationEntity toEntity() => ReservationEntity(
    reservation: reservation,
    requirementType: requirementType,
    reservStatus: reservStatus,
    movementType: movementType,
    requirementsDate: requirementsDate,
    purchaseRequisition: purchaseRequisition,
    itemOfRequisition: itemOfRequisition,
    order: order,
    receivingPlant: receivingPlant,
    receivingStorLoc: receivingStorLoc,
    quantity: quantity,
  );
}


