import 'package:equatable/equatable.dart';

class GrnItemEntity extends Equatable {
  final String materialDocument;
  final int materialDocYear;
  final int materialDocItem;
  final String movementType;
  final String material;
  final String materialDescription;
  final String plant;
  final String storageLocation;
  final String batch;
  final String specialStock;
  final double quantity;
  final String baseUOM;

  const GrnItemEntity({
    required this.materialDocument,
    required this.materialDocYear,
    required this.materialDocItem,
    required this.movementType,
    required this.material,
    required this.materialDescription,
    required this.plant,
    required this.storageLocation,
    required this.batch,
    required this.specialStock,
    required this.quantity,
    required this.baseUOM,
  });

  @override
  List<Object?> get props => [
        materialDocument,
        materialDocYear,
        materialDocItem,
        movementType,
        material,
        materialDescription,
        plant,
        storageLocation,
        batch,
        specialStock,
        quantity,
        baseUOM,
      ];
}

