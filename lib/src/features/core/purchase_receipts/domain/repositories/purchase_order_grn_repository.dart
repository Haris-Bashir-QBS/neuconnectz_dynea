import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_ordr_grn_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/params/purchase_order_grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/params/purchase_order_grn_list_params.dart';

abstract class PurchaseOrderGrnRepository {
  Future<Either<Failure, PurchaseOrderGrnListResultEntity>> listAllGrDocFromSAP(
    PurchaseOrderGrnListParams params,
  );

  Future<Either<Failure, PurchaseOrderGrnItemResultEntity>>
  listAllGrItemsFromSAP(PurchaseOrderGrnItemQueryParams params);

  Future<Either<Failure, PurchaseOrderGrnItemResultEntity>>
  listCompletedGrnItems(PurchaseOrderGrnItemQueryParams params);
}
