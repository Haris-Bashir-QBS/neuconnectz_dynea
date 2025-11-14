import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/repositories/grn_repository.dart';

class GetGrnListUseCase extends UseCase<GrnListResultEntity, GrnListParams> {
  final GrnRepository repository;

  GetGrnListUseCase(this.repository);

  @override
  Future<Either<Failure, GrnListResultEntity>> call(
    GrnListParams params,
  ) {
    return repository.listAllGrDocFromSAP(params);
  }
}

