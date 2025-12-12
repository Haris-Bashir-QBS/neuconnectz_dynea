import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_list_item_entity.dart';

class PurchaseOrderGrnListResultEntity extends Equatable {
  final List<PurchaseOrderGrnEntity> items;
  final int totalRows;

  const PurchaseOrderGrnListResultEntity({
    required this.items,
    required this.totalRows,
  });

  @override
  List<Object?> get props => [items, totalRows];
}
