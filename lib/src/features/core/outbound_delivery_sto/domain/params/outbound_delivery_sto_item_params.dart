import 'package:equatable/equatable.dart';

class OutboundDeliveryStoItemParams extends Equatable {
  final String deliveryNo;
  final String itemNo;
  final String material;
  final String plant;
  final String storageLocation;
  final String movementType;
  final int lastCount;
  final int skipRecords;

  const OutboundDeliveryStoItemParams({
    required this.deliveryNo,
    required this.itemNo,
    required this.material,
    required this.plant,
    required this.storageLocation,
    required this.movementType,
    this.lastCount = 10,
    this.skipRecords = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'deliveryNo': deliveryNo,
      'itemNo': itemNo,
      'material': material,
      'plant': plant,
      'storageLocation': storageLocation,
      'movementType': "641",
      'lastCount': lastCount,
      'skipRecords': skipRecords,
    };
  }

  @override
  List<Object?> get props => [
    deliveryNo,
    itemNo,
    material,
    plant,
    storageLocation,
    movementType,
    lastCount,
    skipRecords,
  ];
}
