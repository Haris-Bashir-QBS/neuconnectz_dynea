class ProcessBinToBinTransferParams {
  final String plant;
  final String warehouseNumber;
  final String storageLocation;
  final String destinationStorageBin;
  final String destinationStorageType;
  final String destinationStorageSection;
  final List<SourceMaterial> sourceMaterials;

  const ProcessBinToBinTransferParams({
    required this.plant,
    required this.warehouseNumber,
    required this.storageLocation,
    required this.destinationStorageBin,
    required this.destinationStorageType,
    required this.destinationStorageSection,
    required this.sourceMaterials,
  });

  Map<String, dynamic> toJson() {
    return {
      'plant': plant,
      'warehouseNumber': warehouseNumber,
      'storageLocation': storageLocation,
      'destinationStorageBin': destinationStorageBin,
      'destinationStorageType': destinationStorageType,
      'destinationStorageSection': destinationStorageSection,
      'sourceMaterials': sourceMaterials.map((m) => m.toJson()).toList(),
    };
  }
}

class SourceMaterial {
  final String id;
  final int quantity;

  const SourceMaterial({
    required this.id,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }
}
