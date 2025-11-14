import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_entity.dart';

class GrnItemResultEntity extends Equatable {
  final List<GrnItemEntity> items;
  final int totalRows;

  const GrnItemResultEntity({
    required this.items,
    required this.totalRows,
  });

  @override
  List<Object?> get props => [items, totalRows];
}

