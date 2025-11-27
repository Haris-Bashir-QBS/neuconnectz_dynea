import 'package:equatable/equatable.dart';

enum StockFilterType { all, material, storageType, storageBin }

class StockQueryParams extends Equatable {
  final String plant;
  final String warehouseNumber;
  final StockFilterType filterType;
  final String? searchQuery;
  final int lastCount;
  final int skipRecords;

  const StockQueryParams({
    required this.plant,
    required this.warehouseNumber,
    this.filterType = StockFilterType.all,
    this.searchQuery,
    this.lastCount = 10,
    this.skipRecords = 0,
  });

  StockQueryParams copyWith({
    String? plant,
    String? warehouseNumber,
    StockFilterType? filterType,
    String? searchQuery,
    int? lastCount,
    int? skipRecords,
  }) {
    return StockQueryParams(
      plant: plant ?? this.plant,
      warehouseNumber: warehouseNumber ?? this.warehouseNumber,
      filterType: filterType ?? this.filterType,
      searchQuery: searchQuery ?? this.searchQuery,
      lastCount: lastCount ?? this.lastCount,
      skipRecords: skipRecords ?? this.skipRecords,
    );
  }

  @override
  List<Object?> get props => [
        plant,
        warehouseNumber,
        filterType,
        searchQuery,
        lastCount,
        skipRecords,
      ];
}

