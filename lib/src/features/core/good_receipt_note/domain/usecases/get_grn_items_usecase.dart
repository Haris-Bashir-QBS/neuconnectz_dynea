import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/repositories/grn_repository.dart';

class GetGrnItemsUseCase
    extends UseCase<GrnItemResultEntity, GrnItemQueryParams> {
  final GrnRepository repository;

  GetGrnItemsUseCase(this.repository);

  @override
  Future<Either<Failure, GrnItemResultEntity>> call(GrnItemQueryParams params) {
    return repository.listAllGrItemsFromSAP(params);
  }
}
