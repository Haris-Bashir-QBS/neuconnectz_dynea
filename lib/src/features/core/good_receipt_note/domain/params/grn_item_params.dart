class GrnItemParams {
  final String plant;
  final String location;
  final String materialDoc;
  final int materialDocYear;
  final int lastCount;
  final int skipRecords;

  const GrnItemParams({
    required this.plant,
    required this.location,
    required this.materialDoc,
    required this.materialDocYear,
    this.lastCount = 10,
    this.skipRecords = 0,
  });
}
