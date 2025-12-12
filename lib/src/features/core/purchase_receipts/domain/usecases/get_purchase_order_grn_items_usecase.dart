import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_ordr_grn_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/params/purchase_order_grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/repositories/purchase_order_grn_repository.dart';

class GetPurchaseOrderGrnItemsUseCase
    extends
        UseCase<
          PurchaseOrderGrnItemResultEntity,
          PurchaseOrderGrnItemQueryParams
        > {
  final PurchaseOrderGrnRepository repository;

  GetPurchaseOrderGrnItemsUseCase(this.repository);

  @override
  Future<Either<Failure, PurchaseOrderGrnItemResultEntity>> call(
    PurchaseOrderGrnItemQueryParams params,
  ) {
    return repository.listAllGrItemsFromSAP(params);
  }
}
