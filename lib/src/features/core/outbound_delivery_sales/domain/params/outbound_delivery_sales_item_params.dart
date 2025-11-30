import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class OutboundDeliverySalesItemParams extends Equatable {
  final String deliveryNo;
  final String plant;
  final String storageLocation;
  final WarehouseEntity warehouse;
  final String warehouseCode;
  final int lastCount;
  final int skipRecords;

  const OutboundDeliverySalesItemParams({
    required this.deliveryNo,
    required this.plant,
    required this.storageLocation,
    required this.warehouse,
    required this.warehouseCode,
    this.lastCount = 10,
    this.skipRecords = 0,
  });

  OutboundDeliverySalesItemParams copyWith({
    String? deliveryNo,
    String? plant,
    String? storageLocation,
    WarehouseEntity? warehouse,
    String? warehouseCode,
    int? lastCount,
    int? skipRecords,
  }) {
    return OutboundDeliverySalesItemParams(
      deliveryNo: deliveryNo ?? this.deliveryNo,
      plant: plant ?? this.plant,
      storageLocation: storageLocation ?? this.storageLocation,
      warehouse: warehouse ?? this.warehouse,
      warehouseCode: warehouseCode ?? this.warehouseCode,
      lastCount: lastCount ?? this.lastCount,
      skipRecords: skipRecords ?? this.skipRecords,
    );
  }

  @override
  List<Object?> get props => [
        deliveryNo,
        plant,
        storageLocation,
        warehouse,
        warehouseCode,
        lastCount,
        skipRecords,
      ];
}

