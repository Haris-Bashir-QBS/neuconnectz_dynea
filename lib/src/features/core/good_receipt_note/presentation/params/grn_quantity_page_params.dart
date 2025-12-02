import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';

class GrnQuantityPageParams {
  final GrnEntity grn;
  final GrnItemEntity item;

  GrnQuantityPageParams({
    required this.grn,
    required this.item,
  });
}

