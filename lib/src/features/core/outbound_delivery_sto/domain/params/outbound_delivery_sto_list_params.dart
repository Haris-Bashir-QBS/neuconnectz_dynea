import 'package:equatable/equatable.dart';

class OutboundDeliveryStoListParams extends Equatable {
  final String plant;
  final String storageLocation;
  //final String movementType;
  final int lastCount;
  final int skipRecords;

  const OutboundDeliveryStoListParams({
    required this.plant,
    required this.storageLocation,
    //required this.movementType,
    this.lastCount = 10,
    this.skipRecords = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'plant': plant,
      'storageLocation': storageLocation,
      //'movementType': movementType,
      'lastCount': lastCount,
      'skipRecords': skipRecords,
    };
  }

  @override
  List<Object?> get props => [
    plant,
    storageLocation,
    // movementType,
    lastCount,
    skipRecords,
  ];
}
