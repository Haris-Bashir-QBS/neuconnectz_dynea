import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_item_entity.dart';

class PurchaseOrderGrnItemResultEntity extends Equatable {
  final List<PurchaseOrderGrnItemEntity> items;
  final int totalRows;

  const PurchaseOrderGrnItemResultEntity({
    required this.items,
    required this.totalRows,
  });

  @override
  List<Object?> get props => [items, totalRows];
}
