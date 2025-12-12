import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_item_entity.dart';

class ProductionReceiptListResultEntity extends Equatable {
  final List<ProductionReceiptEntity> items;
  final int totalRows;

  const ProductionReceiptListResultEntity({
    required this.items,
    required this.totalRows,
  });

  @override
  List<Object?> get props => [items, totalRows];
}

