import '../../domain/entities/stock_entity.dart';
import '../../domain/entities/stock_result_entity.dart';

class StockResponseModel {
  final bool isRequestSuccess;
  final String message;
  final StockListModel data;

  const StockResponseModel({
    required this.isRequestSuccess,
    required this.message,
    required this.data,
  });

  factory StockResponseModel.fromJson(Map<String, dynamic> json) {
    return StockResponseModel(
      isRequestSuccess: json['isRequestSuccess'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: StockListModel.fromJson(
        (json['data'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
    );
  }

  StockResultEntity toEntity() {
    final items = data.items.map((e) => e.toEntity()).toList();
    return StockResultEntity(items: items, totalCount: data.totalCount);
  }
}

class StockListModel {
  final List<StockItemModel> items;
  final int totalCount;

  const StockListModel({required this.items, required this.totalCount});

  factory StockListModel.fromJson(Map<String, dynamic> json) {
    final list =
        (json['data'] as List<dynamic>? ?? [])
            .map((e) => StockItemModel.fromJson(e as Map<String, dynamic>))
            .toList();

    return StockListModel(
      items: list,
      totalCount: json['totalCount'] as int? ?? list.length,
    );
  }
}

class StockItemModel {
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

  const StockItemModel({
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

  factory StockItemModel.fromJson(Map<String, dynamic> json) {
    return StockItemModel(
      id: json['id'] as String? ?? '',
      plant: json['plant'] as String? ?? '',
      storageLocation: json['storageLocation'] as String? ?? '',
      warehouseNumber: json['warehouseNumber'] as String? ?? '',
      material: json['material'] as String? ?? '',
      description: json['description'] as String? ?? '',
      storageType: json['storageType'] as String? ?? '',
      storageBin: json['storageBin'] as String? ?? '',
      stockCategory: json['stockCategory'] as String? ?? '',
      batch: json['batch'] as String? ?? '',
      quant: (json['quant'] as num?)?.toDouble() ?? 0,
      availableStock: (json['availableStock'] as num?)?.toDouble() ?? 0,
    );
  }

  StockEntity toEntity() => StockEntity(
    id: id,
    plant: plant,
    storageLocation: storageLocation,
    warehouseNumber: warehouseNumber,
    material: material,
    description: description,
    storageType: storageType,
    storageBin: storageBin,
    stockCategory: stockCategory,
    batch: batch,
    quant: quant,
    availableStock: availableStock,
  );
}
