class GetAndUpdateStocksRequestModel {
  final String plant;
  final String storageLocation;
  final String warehouseNumber;
  final String material;

  GetAndUpdateStocksRequestModel({
    required this.plant,
    required this.storageLocation,
    required this.warehouseNumber,
    required this.material,
  });

  Map<String, dynamic> toJson() => {
        "plant": plant,
        "storageLocation": storageLocation,
        "warehouseNumber": warehouseNumber,
        "material": material,
      };
}

