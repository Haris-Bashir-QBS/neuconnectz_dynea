import 'package:equatable/equatable.dart';

class InboundDeliveryEntity extends Equatable {
  final String stoNo;
  final String outboundDeliveryNo;
  final String materialNo;
  final String materialDescription;
  final String issuingPlant;
  final int totalItem;

  const InboundDeliveryEntity({
    required this.stoNo,
    required this.outboundDeliveryNo,
    required this.materialNo,
    required this.materialDescription,
    required this.issuingPlant,
    required this.totalItem,
  });

  @override
  List<Object?> get props => [
        stoNo,
        outboundDeliveryNo,
        materialNo,
        materialDescription,
        issuingPlant,
        totalItem,
      ];
}



