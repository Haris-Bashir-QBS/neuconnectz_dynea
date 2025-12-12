import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/params/purchase_order_grn_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/repositories/purchase_order_grn_repository.dart';

class GetPurchaseOrderGrnListUseCase
    extends
        UseCase<PurchaseOrderGrnListResultEntity, PurchaseOrderGrnListParams> {
  final PurchaseOrderGrnRepository repository;

  GetPurchaseOrderGrnListUseCase(this.repository);

  @override
  Future<Either<Failure, PurchaseOrderGrnListResultEntity>> call(
    PurchaseOrderGrnListParams params,
  ) {
    return repository.listAllGrDocFromSAP(params);
  }
}
