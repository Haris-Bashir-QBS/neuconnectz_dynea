import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';

class GrnListResultEntity extends Equatable {
  final List<GrnEntity> items;
  final int totalRows;

  const GrnListResultEntity({required this.items, required this.totalRows});

  @override
  List<Object?> get props => [items, totalRows];
}
