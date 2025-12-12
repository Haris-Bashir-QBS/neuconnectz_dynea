import 'package:equatable/equatable.dart';

class OutboundDeliverySalesListParams extends Equatable {
  final String plant;
  final String storageLocation;
  final String? deliveryNo;
  final int lastCount;
  final int skipRecords;

  const OutboundDeliverySalesListParams({
    required this.plant,
    required this.storageLocation,
    this.deliveryNo,
    this.lastCount = 10,
    this.skipRecords = 0,
  });

  OutboundDeliverySalesListParams copyWith({
    String? plant,
    String? storageLocation,
    String? deliveryNo,
    int? lastCount,
    int? skipRecords,
  }) {
    return OutboundDeliverySalesListParams(
      plant: plant ?? this.plant,
      storageLocation: storageLocation ?? this.storageLocation,
      deliveryNo: deliveryNo ?? this.deliveryNo,
      lastCount: lastCount ?? this.lastCount,
      skipRecords: skipRecords ?? this.skipRecords,
    );
  }

  @override
  List<Object?> get props => [
        plant,
        storageLocation,
        deliveryNo,
        lastCount,
        skipRecords,
      ];
}



