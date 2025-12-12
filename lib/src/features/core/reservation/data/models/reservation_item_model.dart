import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_items_result_entity.dart';

class ReservationItemsResponseModel {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final ReservationItemsDataModel? data;
  final List<dynamic> exception;

  ReservationItemsResponseModel({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    required this.exception,
  });

  factory ReservationItemsResponseModel.fromJson(Map<String, dynamic> json) {
    return ReservationItemsResponseModel(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? ReservationItemsDataModel.fromJson(
                json['data'] as Map<String, dynamic>,
              )
              : null,
      exception: json['exception'] ?? [],
    );
  }

  ReservationItemsResultEntity toEntity() {
    return ReservationItemsResultEntity(
      totalCount: data?.totalCount ?? 0,
      data: data?.data.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

class ReservationItemsDataModel {
  final int totalCount;
  final List<ReservationItemModel> data;

  ReservationItemsDataModel({required this.totalCount, required this.data});

  factory ReservationItemsDataModel.fromJson(Map<String, dynamic> json) {
    return ReservationItemsDataModel(
      totalCount: json['totalCount'] ?? 0,
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map(
                (e) => ReservationItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}

class ReservationItemModel {
  final int reservation;
  final int itemNumberOfReservation;
  final String itemDeleted;
  final String movementAllowed;
  final String finalIssue;
  final String material;
  final String plant;
  final String storageLocation;
  final String batch;
  final String distrDifferences;
  final String specialStock;
  final double requirementQuantity;
  final String baseUnitOfMeasure;
  final double qtyInUnitOfEntry;
  final String unitOfEntry;
  final double quantityWithdrawn;
  final double remainingQuantity;
  final double quantity;
  final List<ReservationBinDetailModel> binDetails;

  ReservationItemModel({
    required this.reservation,
    required this.itemNumberOfReservation,
    required this.itemDeleted,
    required this.movementAllowed,
    required this.finalIssue,
    required this.material,
    required this.plant,
    required this.storageLocation,
    required this.batch,
    required this.distrDifferences,
    required this.specialStock,
    required this.requirementQuantity,
    required this.baseUnitOfMeasure,
    required this.qtyInUnitOfEntry,
    required this.unitOfEntry,
    required this.quantityWithdrawn,
    required this.remainingQuantity,
    required this.binDetails,
    this.quantity = 0,
  });

  factory ReservationItemModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    final rawBinDetails =
        (json['additionalBinDetails'] ??
                json['binDetails'] ??
                json['reservationBinDetails'])
            as List<dynamic>? ??
        const [];

    return ReservationItemModel(
      reservation: json['reservation'] ?? 0,
      itemNumberOfReservation: json['itemNumberOfReservation'] ?? 0,
      itemDeleted: json['itemDeleted'] ?? '',
      movementAllowed: json['movementAllowed'] ?? '',
      finalIssue: json['finalIssue'] ?? '',
      material: json['material'] ?? '',
      plant: json['plant'] ?? '',
      storageLocation: json['storageLocation'] ?? '',
      batch: json['batch'] ?? '',
      distrDifferences: json['distrDifferences'] ?? '',
      specialStock: json['specialStock'] ?? '',
      requirementQuantity: toDouble(json['requirementQuantity']),
      baseUnitOfMeasure: json['baseUnitOfMeasure'] ?? '',
      qtyInUnitOfEntry: toDouble(json['qtyInUnitOfEntry']),
      unitOfEntry: json['unitOfEntry'] ?? '',
      quantityWithdrawn: toDouble(json['quantityWithdrawn']),
      remainingQuantity: toDouble(json['remainingQuantity']),
      quantity: toDouble(json['quantity']),
      binDetails:
          rawBinDetails
              .map(
                (e) => ReservationBinDetailModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  ReservationItemEntity toEntity() => ReservationItemEntity(
    reservation: reservation,
    itemNumberOfReservation: itemNumberOfReservation,
    itemDeleted: itemDeleted,
    movementAllowed: movementAllowed,
    finalIssue: finalIssue,
    material: material,
    plant: plant,
    storageLocation: storageLocation,
    batch: batch,
    distrDifferences: distrDifferences,
    specialStock: specialStock,
    requirementQuantity: requirementQuantity,
    baseUnitOfMeasure: baseUnitOfMeasure,
    qtyInUnitOfEntry: qtyInUnitOfEntry,
    unitOfEntry: unitOfEntry,
    quantityWithdrawn: quantityWithdrawn,
    remainingQuantity: remainingQuantity,
    quantity: quantity,
    binDetails: binDetails.map((bin) => bin.toEntity()).toList(),
  );
}

class ReservationBinDetailModel {
  final String binCode;
  final String storageType;
  final String storageSection;
  final double proposedQuantity;
  final double actualQuantity;

  ReservationBinDetailModel({
    required this.binCode,
    required this.storageType,
    required this.storageSection,
    required this.proposedQuantity,
    required this.actualQuantity,
  });

  factory ReservationBinDetailModel.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    return ReservationBinDetailModel(
      binCode: json['binCode'] ?? '',
      storageType: json['storageType'] ?? '',
      storageSection: json['storageSection'] ?? '',
      proposedQuantity: _toDouble(json['proposedQuantity'] ?? json['quantity']),
      actualQuantity: _toDouble(json['actualQuantity'] ?? json['qty']),
    );
  }

  ReservationItemBinDetailEntity toEntity() => ReservationItemBinDetailEntity(
    binCode: binCode,
    storageType: storageType,
    storageSection: storageSection,
    proposedQuantity: proposedQuantity,
    actualQuantity: actualQuantity,
  );
}


