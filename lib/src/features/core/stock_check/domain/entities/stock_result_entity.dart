import 'package:equatable/equatable.dart';

import 'stock_entity.dart';

class StockResultEntity extends Equatable {
  final List<StockEntity> items;
  final int totalCount;

  const StockResultEntity({
    required this.items,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [items, totalCount];
}



