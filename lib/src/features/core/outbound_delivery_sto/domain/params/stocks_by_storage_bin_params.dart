class StocksByStorageBinParams {
  final String plant;
  final String whsCode;
  final String storageLocation;
  final String material;
  final String storageBin;
  final String? storageType;
  final String? storageSection;
  final String? keyword;
  final int? lastCount;
  final int? skipRecords;

  const StocksByStorageBinParams({
    required this.plant,
    required this.whsCode,
    required this.storageLocation,
    required this.material,
    required this.storageBin,
    this.storageType,
    this.storageSection,
    this.keyword,
    this.lastCount,
    this.skipRecords,
  });

  Map<String, dynamic> toJson() {
    return {
      'plant': plant,
      'whsCode': whsCode,
      'storageLocation': storageLocation,
      'storageBin': storageBin,
      if (material.isNotEmpty) 'material': material,
      if (storageType?.isNotEmpty ?? false) 'storageType': storageType,
      if (storageSection?.isNotEmpty ?? false) 'storageSection': storageSection,
      if (keyword?.isNotEmpty ?? false) 'keyword': keyword,
      if (lastCount != null) 'lastCount': lastCount,
      if (skipRecords != null) 'skipRecords': skipRecords,
    };
  }
}