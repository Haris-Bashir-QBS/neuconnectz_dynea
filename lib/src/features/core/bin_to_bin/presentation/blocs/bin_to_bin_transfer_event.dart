part of 'bin_to_bin_transfer_bloc.dart';

abstract class BinToBinTransferEvent extends Equatable {
  const BinToBinTransferEvent();

  @override
  List<Object?> get props => [];
}

class ProcessBinToBinTransferEvent extends BinToBinTransferEvent {
  final String plant;
  final String warehouseNumber;
  final String storageLocation;
  final String destinationStorageBin;
  final String destinationStorageType;
  final String destinationStorageSection;
  final List<Map<String, dynamic>> sourceMaterials;

  const ProcessBinToBinTransferEvent({
    required this.plant,
    required this.warehouseNumber,
    required this.storageLocation,
    required this.destinationStorageBin,
    required this.destinationStorageType,
    required this.destinationStorageSection,
    required this.sourceMaterials,
  });

  @override
  List<Object?> get props => [
        plant,
        warehouseNumber,
        storageLocation,
        destinationStorageBin,
        destinationStorageType,
        destinationStorageSection,
        sourceMaterials,
      ];
}


