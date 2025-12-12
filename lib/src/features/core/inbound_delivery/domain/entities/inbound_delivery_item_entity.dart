import 'package:equatable/equatable.dart';

class InboundDeliveryItemEntity extends Equatable {
  final String stoNo;
  final int stoItemNo;
  final String outboundDeliveryNo;
  final int deliveryItemNo;
  final String batchNo;
  final double quantity;
  final String? materialNo;
  final String? materialDescription;
  final String? uom;
  final List<InboundDeliveryItemBinDetailEntity> binDetails;

  const InboundDeliveryItemEntity({
    required this.stoNo,
    required this.stoItemNo,
    required this.outboundDeliveryNo,
    required this.deliveryItemNo,
    this.uom,
    required this.batchNo,
    required this.quantity,
    this.materialNo,
    this.materialDescription,
    this.binDetails = const [],
  });

  @override
  List<Object?> get props => [
    stoNo,
    stoItemNo,
    outboundDeliveryNo,
    deliveryItemNo,
    batchNo,
    quantity,
    materialNo,
    materialDescription,
    binDetails,
    uom,
  ];
}

class InboundDeliveryItemBinDetailEntity extends Equatable {
  final String binCode;
  final String storageType;
  final String storageSection;
  final double quantity;

  const InboundDeliveryItemBinDetailEntity({
    required this.binCode,
    required this.storageType,
    required this.storageSection,
    required this.quantity,
  });

  @override
  List<Object?> get props => [binCode, storageType, storageSection, quantity];
}
