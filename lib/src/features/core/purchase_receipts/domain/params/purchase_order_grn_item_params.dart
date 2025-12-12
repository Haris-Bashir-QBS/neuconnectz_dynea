class PurchaseOrderGrnItemQueryParams {
  final String plant;
  final String location;
  final String materialDoc;
  final int materialDocYear;
  final int lastCount;
  final int skipRecords;
  final int trNumber;

  const PurchaseOrderGrnItemQueryParams({
    required this.plant,
    required this.location,
    required this.materialDoc,
    required this.materialDocYear,
    required this.trNumber,
    this.lastCount = 10,
    this.skipRecords = 0,
  });
}
