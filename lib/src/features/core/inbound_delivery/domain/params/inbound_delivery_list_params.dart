class InboundDeliveryListParams {
  final String plant;
  final String storageLocation;
  final int lastCount;
  final int skipRecords;
  final String? keyword;

  const InboundDeliveryListParams({
    required this.plant,
    required this.storageLocation,
    this.lastCount = 10,
    this.skipRecords = 0,
    this.keyword,
  });
}



