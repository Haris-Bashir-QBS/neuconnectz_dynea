class PurchaseOrderGrnListParams {
  final String plant;
  final String location;
  final int lastCount;
  final int skipRecords;
  final String? keyword;

  const PurchaseOrderGrnListParams({
    required this.plant,
    required this.location,
    this.lastCount = 10,
    this.skipRecords = 0,
    this.keyword,
  });
}
