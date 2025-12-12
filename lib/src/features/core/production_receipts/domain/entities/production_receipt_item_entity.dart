import 'package:equatable/equatable.dart';

class ProductionReceiptItemEntity extends Equatable {
  final String warehouseNumber;
  final int trNumber;
  final int trItem;
  final String material;
  final String plant;
  final String batch;
  final double trQuantity;
  final String alternativeUOM;
  final String storageLocation;

  const ProductionReceiptItemEntity({
    required this.warehouseNumber,
    required this.trNumber,
    required this.trItem,
    required this.material,
    required this.plant,
    required this.batch,
    required this.trQuantity,
    required this.alternativeUOM,
    required this.storageLocation,
  });

  @override
  List<Object?> get props => [
        warehouseNumber,
        trNumber,
        trItem,
        material,
        plant,
        batch,
        trQuantity,
        alternativeUOM,
        storageLocation,
      ];
}

