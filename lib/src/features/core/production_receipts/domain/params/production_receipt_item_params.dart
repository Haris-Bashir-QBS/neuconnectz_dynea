class ProductionReceiptItemQueryParams {
  final String plant;
  final String warehouseNumber;
  final String storageLocation;
  final int trNumber;
  final int lastCount;
  final int skipRecords;

  ProductionReceiptItemQueryParams({
    required this.plant,
    required this.warehouseNumber,
    required this.storageLocation,
    required this.trNumber,
    required this.lastCount,
    required this.skipRecords,
  });
}

