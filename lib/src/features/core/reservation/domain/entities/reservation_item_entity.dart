import 'package:equatable/equatable.dart';

class ReservationItemEntity extends Equatable {
  final int reservation;
  final int itemNumberOfReservation;
  final String itemDeleted;
  final String movementAllowed;
  final String finalIssue;
  final String material;
  final String plant;
  final String storageLocation;
  final String batch;
  final String distrDifferences;
  final String specialStock;
  final double requirementQuantity;
  final String baseUnitOfMeasure;
  final double qtyInUnitOfEntry;
  final String unitOfEntry;
  final double quantityWithdrawn;

  const ReservationItemEntity({
    required this.reservation,
    required this.itemNumberOfReservation,
    required this.itemDeleted,
    required this.movementAllowed,
    required this.finalIssue,
    required this.material,
    required this.plant,
    required this.storageLocation,
    required this.batch,
    required this.distrDifferences,
    required this.specialStock,
    required this.requirementQuantity,
    required this.baseUnitOfMeasure,
    required this.qtyInUnitOfEntry,
    required this.unitOfEntry,
    required this.quantityWithdrawn,
  });

  @override
  List<Object?> get props => [
        reservation,
        itemNumberOfReservation,
        itemDeleted,
        movementAllowed,
        finalIssue,
        material,
        plant,
        storageLocation,
        batch,
        distrDifferences,
        specialStock,
        requirementQuantity,
        baseUnitOfMeasure,
        qtyInUnitOfEntry,
        unitOfEntry,
        quantityWithdrawn,
      ];
}

