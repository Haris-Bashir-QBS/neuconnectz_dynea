import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class ReservationItemParams extends Equatable {
  final String reservationNo;
  final WarehouseEntity warehouse;
  final String plant;
  final String storageLocation;
  final String movementType;
  final String warehouseCode;
  final int lastCount;
  final int skipRecords;

  const ReservationItemParams({
    required this.reservationNo,
    required this.plant,
    required this.storageLocation,
    required this.warehouseCode,
    required this.movementType,
    required this.warehouse,
    this.lastCount = 10,
    this.skipRecords = 0,
  });

  ReservationItemParams copyWith({
    String? reservationNo,
    String? plant,
    String? storageLocation,
    String? movementType,
    int? lastCount,
    String? warehouseCode,
    WarehouseEntity? warehouse,

    int? skipRecords,
  }) {
    return ReservationItemParams(
      reservationNo: reservationNo ?? this.reservationNo,
      plant: plant ?? this.plant,
      storageLocation: storageLocation ?? this.storageLocation,
      movementType: movementType ?? this.movementType,
      lastCount: lastCount ?? this.lastCount,
      skipRecords: skipRecords ?? this.skipRecords,
      warehouseCode: warehouseCode ?? this.warehouseCode,
      warehouse: warehouse ?? this.warehouse,
    );
  }

  @override
  List<Object?> get props => [
    reservationNo,
    plant,
    storageLocation,
    movementType,
    lastCount,
    skipRecords,
    warehouse,
  ];
}


