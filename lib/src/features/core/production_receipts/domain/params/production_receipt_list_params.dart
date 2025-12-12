class ProductionReceiptListParams {
  final String plant;
  final String warehouseNumber;
  final String storageLocation;
  final int lastCount;
  final int skipRecords;
  final String? keyword;

  ProductionReceiptListParams({
    required this.plant,
    required this.warehouseNumber,
    required this.storageLocation,
    required this.lastCount,
    required this.skipRecords,
    this.keyword,
  });
}

