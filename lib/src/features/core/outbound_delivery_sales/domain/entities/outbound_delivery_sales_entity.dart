import 'package:equatable/equatable.dart';

class OutboundDeliverySalesEntity extends Equatable {
  final String delivery;
  final String salesOrganization;
  final String deliveryType;
  final String receivingPlant;
  final String deliveryBlock;
  final String overallStatus;
  final String goodsMovementSts;
  final String plant;
  final String storageLocation;

  const OutboundDeliverySalesEntity({
    required this.delivery,
    required this.salesOrganization,
    required this.deliveryType,
    required this.receivingPlant,
    required this.deliveryBlock,
    required this.overallStatus,
    required this.goodsMovementSts,
    required this.plant,
    required this.storageLocation,
  });

  @override
  List<Object?> get props => [
        delivery,
        salesOrganization,
        deliveryType,
        receivingPlant,
        deliveryBlock,
        overallStatus,
        goodsMovementSts,
        plant,
        storageLocation,
      ];
}



