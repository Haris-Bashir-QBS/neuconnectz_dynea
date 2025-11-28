import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_item_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';

class CreatePickingRequestModel {
  final int reservationNumber;
  final String receivingPlant;
  final String receivingStorageLocation;
  final String selectedPlant;
  final String selectedStorageLocation;
  final String selectedMovementType;
  final int itemNumberOfReservation;
  final String material;
  final String baseUnitOfMeasure;
  final List<BinQuantityModel> binQuantities;

  CreatePickingRequestModel({
    required this.reservationNumber,
    required this.receivingPlant,
    required this.receivingStorageLocation,
    required this.selectedPlant,
    required this.selectedStorageLocation,
    required this.selectedMovementType,
    required this.itemNumberOfReservation,
    required this.material,
    required this.baseUnitOfMeasure,
    required this.binQuantities,
  });

  factory CreatePickingRequestModel.fromEntities({
    required ReservationItemEntity item,
    required String selectedPlant,
    required String selectedStorageLocation,
    required String selectedMovementType,
    required String receivingPlant,
    required String receivingStorageLocation,
    required List<BinEntity> bins,
  }) {
    final binModels = bins
        .where((bin) => bin.selectedQuantity > 0)
        .map(
          (bin) => BinQuantityModel(
            id: bin.id,
            quantity: bin.selectedQuantity,
          ),
        )
        .toList();

    return CreatePickingRequestModel(
      reservationNumber: item.reservation,
      receivingPlant: receivingPlant,
      receivingStorageLocation: receivingStorageLocation,
      selectedPlant: selectedPlant,
      selectedStorageLocation: selectedStorageLocation,
      selectedMovementType: selectedMovementType,
      itemNumberOfReservation: item.itemNumberOfReservation,
      material: item.material,
      baseUnitOfMeasure: item.baseUnitOfMeasure,
      binQuantities: binModels,
    );
  }

  Map<String, dynamic> toJson() => {
        "reservationNumber": reservationNumber,
        "receivingPlant": receivingPlant,
        "receivingStorageLocation": receivingStorageLocation,
        "selectedPlant": selectedPlant,
        "selectedStorageLocation": selectedStorageLocation,
        "selectedMovementType": selectedMovementType,
        "itemNumberOfReservation": itemNumberOfReservation,
        "material": material,
        "baseUnitOfMeasure": baseUnitOfMeasure,
        "binQuantities": binQuantities.map((bin) => bin.toJson()).toList(),
      };
}

class BinQuantityModel {
  final String id;
  final double quantity;

  BinQuantityModel({required this.id, required this.quantity});

  Map<String, dynamic> toJson() => {"id": id, "quantity": quantity};
}

