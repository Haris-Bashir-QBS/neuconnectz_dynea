import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';

class GrnItemsPageParams {
  final GrnEntity grn;
  final String plant;
  final String warehouseCode;
  final String location;

  GrnItemsPageParams({
    required this.grn,
    required this.plant,
    required this.warehouseCode,
    required this.location,
  });
}
