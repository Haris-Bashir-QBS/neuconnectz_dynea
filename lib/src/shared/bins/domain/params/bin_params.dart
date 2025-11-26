class BinParams {
  final String? plant;
  final String? warehouseCode;
  final String? storageType;

  /// Search keyword (bin code)
  final String? keyword;

  /// Pagination: how many records to fetch in one call
  final int? lastCount;

  /// Pagination: how many records to skip
  final int? skipRecords;

  const BinParams({
    this.plant,
    this.storageType,
    this.warehouseCode,
    this.keyword,
    this.lastCount,
    this.skipRecords,
  });
}

