class InboundDeliveryItemQueryParams {
  final String plant;
  final String storageLocation;
  final String? warehouseNumber;
  final String outboundDeliveryNo;
  final String stoNo;
  final int lastCount;
  final int skipRecords;

  const InboundDeliveryItemQueryParams({
    required this.plant,
    required this.storageLocation,
    this.warehouseNumber,
    required this.outboundDeliveryNo,
    required this.stoNo,
    this.lastCount = 10,
    this.skipRecords = 0,
  });
}



