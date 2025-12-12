class ProductionReceiptItemQueryParams {
  final String plant;
  final String warehouseNumber;
  final String storageLocation;
  final int trNumber;
  final String? requirementNumber;
  final int lastCount;
  final int skipRecords;

  ProductionReceiptItemQueryParams({
    required this.plant,
    required this.warehouseNumber,
    required this.storageLocation,
    required this.trNumber,
    this.requirementNumber,
    required this.lastCount,
    required this.skipRecords,
  });
}

