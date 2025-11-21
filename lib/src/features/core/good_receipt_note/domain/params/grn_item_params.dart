class GrnItemQueryParams {
  final String plant;
  final String location;
  final String materialDoc;
  final int materialDocYear;
  final int lastCount;
  final int skipRecords;

  const GrnItemQueryParams({
    required this.plant,
    required this.location,
    required this.materialDoc,
    required this.materialDocYear,
    this.lastCount = 10,
    this.skipRecords = 0,
  });
}
