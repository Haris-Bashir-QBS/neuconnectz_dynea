import 'package:equatable/equatable.dart';

enum StockFilterType { all, material, storageType, storageBin, batch }

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
    bool clearSearchQuery = false,
  }) {
    // If clearSearchQuery is true, always set to null
    // If searchQuery is explicitly provided (not null), use it
    // If searchQuery is null and clearSearchQuery is false, preserve current value
    String? finalSearchQuery;
    if (clearSearchQuery) {
      finalSearchQuery = null;
    } else if (searchQuery != null) {
      // Explicitly provided non-null value
      finalSearchQuery = searchQuery;
    } else {
      // Not provided, preserve current value
      finalSearchQuery = this.searchQuery;
    }
    
    return StockQueryParams(
      plant: plant ?? this.plant,
      warehouseNumber: warehouseNumber ?? this.warehouseNumber,
      filterType: filterType ?? this.filterType,
      searchQuery: finalSearchQuery,
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

