import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/models/grn_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/models/grn_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_list_params.dart';

abstract class GrnRemoteDataSource {
  Future<GrnListResponseModel> listAllGrDocFromSAP({
    required GrnListParams params,
  });

  Future<GrnItemResponseModel> listAllGrItemsFromSAP({
    required GrnItemQueryParams params,
  });
}
