import 'package:equatable/equatable.dart';

class OutboundDeliveryStoItemsPageParams extends Equatable {
  final String delivery;
  final String plant;
  final String storageLocation;
  final String movementType;

  const OutboundDeliveryStoItemsPageParams({
    required this.delivery,
    required this.plant,
    required this.storageLocation,
    required this.movementType,
  });

  @override
  List<Object?> get props => [delivery, plant, storageLocation, movementType];
}
