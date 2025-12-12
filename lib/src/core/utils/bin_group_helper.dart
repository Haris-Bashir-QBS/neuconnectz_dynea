import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_entity.dart';

/// Helper class to represent a bin group with associated stocks
class BinGroup {
  final String storageBin;
  final String storageType;
  final String storageSection;
  final List<StockEntity> stocks;

  BinGroup({
    required this.storageBin,
    required this.storageType,
    required this.storageSection,
    required this.stocks,
  });

  /// Groups stocks by storageBin, storageType, and storageSection
  static List<BinGroup> groupStocks(List<StockEntity> stocks) {
    final Map<String, List<StockEntity>> groups = {};

    for (var stock in stocks) {
      // Create a unique key based on storageBin, storageType, and storageSection
      // Since storageSection is not in StockEntity, we'll use empty string for now
      final key = '${stock.storageBin}_${stock.storageType}_';

      groups.putIfAbsent(key, () => []);
      final list = groups[key];
      if (list != null) {
        list.add(stock);
      }
    }

    return groups.entries
        .where((entry) => entry.value.isNotEmpty)
        .map((entry) {
          final stocks = entry.value;
          if (stocks.isEmpty) {
            throw StateError('Empty stock list should be filtered out');
          }
          final firstStock = stocks.first;
          return BinGroup(
            storageBin: firstStock.storageBin,
            storageType: firstStock.storageType,
            storageSection: '', // Not available in StockEntity currently
            stocks: stocks,
          );
        })
        .toList()
      ..sort((a, b) => a.storageBin.compareTo(b.storageBin));
  }
}



