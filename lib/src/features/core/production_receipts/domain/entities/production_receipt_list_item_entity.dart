import 'package:equatable/equatable.dart';

class ProductionReceiptEntity extends Equatable {
  final String warehouseNumber;
  final int trNumber;
  final String user;
  final String createdOn;
  final String timeOfCreation;
  final String requirementNumber;
  final String materialDocument;
  final String plant;
  final String storageLocation;

  const ProductionReceiptEntity({
    required this.warehouseNumber,
    required this.trNumber,
    required this.user,
    required this.createdOn,
    required this.timeOfCreation,
    required this.requirementNumber,
    required this.materialDocument,
    required this.plant,
    required this.storageLocation,
  });

  @override
  List<Object?> get props => [
        warehouseNumber,
        trNumber,
        user,
        createdOn,
        timeOfCreation,
        requirementNumber,
        materialDocument,
        plant,
        storageLocation,
      ];
}

