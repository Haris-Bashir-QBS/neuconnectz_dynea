import 'package:equatable/equatable.dart';

class ReservationEntity extends Equatable {
  final int reservation;
  final String requirementType;
  final String reservStatus;
  final String movementType;
  final String requirementsDate;
  final String purchaseRequisition;
  final int itemOfRequisition;
  final String order;
  final String receivingPlant;
  final String receivingStorLoc;
  final double quantity;

  const ReservationEntity({
    required this.reservation,
    required this.requirementType,
    required this.reservStatus,
    required this.movementType,
    required this.requirementsDate,
    required this.purchaseRequisition,
    required this.itemOfRequisition,
    required this.order,
    required this.receivingPlant,
    required this.receivingStorLoc,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
        reservation,
        requirementType,
        reservStatus,
        movementType,
        requirementsDate,
        purchaseRequisition,
        itemOfRequisition,
        order,
        receivingPlant,
        receivingStorLoc,
        quantity,
      ];
}

