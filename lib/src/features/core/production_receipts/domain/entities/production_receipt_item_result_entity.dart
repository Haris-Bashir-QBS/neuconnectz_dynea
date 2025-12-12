import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_entity.dart';

class ProductionReceiptItemResultEntity extends Equatable {
  final List<ProductionReceiptItemEntity> items;
  final int totalRows;

  const ProductionReceiptItemResultEntity({
    required this.items,
    required this.totalRows,
  });

  @override
  List<Object?> get props => [items, totalRows];
}

