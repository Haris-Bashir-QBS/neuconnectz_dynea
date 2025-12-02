class StocksByStorageBinParams {
  final String plant;
  final String whsCode;
  final String storageLocation;
  final String material;
  final String storageBin;

  const StocksByStorageBinParams({
    required this.plant,
    required this.whsCode,
    required this.storageLocation,
    required this.material,
    required this.storageBin,
  });

  Map<String, dynamic> toJson() => {
        'plant': plant,
        'whsCode': whsCode,
        'storageLocation': storageLocation,
        'material': material,
        'storageBin': storageBin,
      };
}

