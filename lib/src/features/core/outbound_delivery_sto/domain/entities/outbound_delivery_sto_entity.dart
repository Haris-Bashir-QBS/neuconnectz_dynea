import 'package:equatable/equatable.dart';

class OutboundDeliveryStoEntity extends Equatable {
  final String delivery;
  final String salesOrganization;
  final String deliveryType;
  final String orderCombination;
  final String receivingPlant;
  final String overallStatus;
  final String goodsMovementSts;
  final String plant;
  final String storageLocation;

  const OutboundDeliveryStoEntity({
    required this.delivery,
    required this.salesOrganization,
    required this.deliveryType,
    required this.orderCombination,
    required this.receivingPlant,
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
        orderCombination,
        receivingPlant,
        overallStatus,
        goodsMovementSts,
        plant,
        storageLocation,
      ];
}


