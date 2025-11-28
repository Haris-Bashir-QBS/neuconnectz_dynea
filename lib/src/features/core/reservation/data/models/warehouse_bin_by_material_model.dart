import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';

class WarehouseBinByMaterialResponseModel {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final WarehouseBinByMaterialDataModel? data;
  final List<dynamic> exception;

  WarehouseBinByMaterialResponseModel({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    required this.exception,
  });

  factory WarehouseBinByMaterialResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WarehouseBinByMaterialResponseModel(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? WarehouseBinByMaterialDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
      exception: json['exception'] ?? [],
    );
  }
}

class WarehouseBinByMaterialDataModel {
  final String warehouseCode;
  final String material;
  final int totalBins;
  final List<WarehouseBinByMaterialItemModel> bins;

  WarehouseBinByMaterialDataModel({
    required this.warehouseCode,
    required this.material,
    required this.totalBins,
    required this.bins,
  });

  factory WarehouseBinByMaterialDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WarehouseBinByMaterialDataModel(
      warehouseCode: json['warehouseCode'] ?? '',
      material: json['material'] ?? '',
      totalBins: json['totalBins'] ?? 0,
      bins: (json['bins'] as List<dynamic>?)
              ?.map(
                (item) => WarehouseBinByMaterialItemModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class WarehouseBinByMaterialItemModel {
  final String id;
  final String plant;
  final String storageLocation;
  final String warehouseNumber;
  final String material;
  final String description;
  final String storageType;
  final String storageBin;
  final String stockCategory;
  final String batch;
  final double quant;
  final double availableStock;

  WarehouseBinByMaterialItemModel({
    required this.id,
    required this.plant,
    required this.storageLocation,
    required this.warehouseNumber,
    required this.material,
    required this.description,
    required this.storageType,
    required this.storageBin,
    required this.stockCategory,
    required this.batch,
    required this.quant,
    required this.availableStock,
  });

  factory WarehouseBinByMaterialItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WarehouseBinByMaterialItemModel(
      id: json['id']?.toString() ?? '',
      plant: json['plant']?.toString() ?? '',
      storageLocation: json['storageLocation']?.toString() ?? '',
      warehouseNumber: json['warehouseNumber']?.toString() ?? '',
      material: json['material']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      storageType: json['storageType']?.toString() ?? '',
      storageBin: json['storageBin']?.toString() ?? '',
      stockCategory: json['stockCategory']?.toString() ?? '',
      batch: json['batch']?.toString() ?? '',
      quant: (json['quant'] ?? 0).toDouble(),
      availableStock: (json['availableStock'] ?? 0).toDouble(),
    );
  }

  /// Maps to BinEntity for compatibility with existing bin widgets
  BinEntity toBinEntity() {
    return BinEntity(
      id: id,
      absEntry: '',
      binCode: storageBin,
      storageType: storageType,
      whsCode: warehouseNumber,
      storageSection: '',
      createdBy: '',
      updatedBy: '',
      createdDate: '',
      updatedDate: '',
      isActive: true,
      isArchived: false,
      selectedQuantity: 0.0,
    );
  }
}

