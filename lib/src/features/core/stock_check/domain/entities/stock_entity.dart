import 'package:equatable/equatable.dart';

class StockEntity extends Equatable {
  final String id;
  final String plant;
  final String storageLocation;
  final String warehouseNumber;
  final String material;
  final String description;
  final String storageType;
  final String storageBin;
  final String stockCategory;
  final String batch;
  final double quant;
  final double availableStock;

  const StockEntity({
    required this.id,
    required this.plant,
    required this.storageLocation,
    required this.warehouseNumber,
    required this.material,
    required this.description,
    required this.storageType,
    required this.storageBin,
    required this.stockCategory,
    required this.batch,
    required this.quant,
    required this.availableStock,
  });

  @override
  List<Object?> get props => [
    id,
    plant,
    storageLocation,
    warehouseNumber,
    material,
    description,
    storageType,
    storageBin,
    stockCategory,
    batch,
    quant,
    availableStock,
  ];
}


