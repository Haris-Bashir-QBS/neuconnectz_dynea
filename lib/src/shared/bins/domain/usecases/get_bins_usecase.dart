import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/params/bin_params.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/repositories/bin_repository.dart';

class GetBinsUseCase extends UseCase<List<BinEntity>, BinParams> {
  final BinRepository repository;

  GetBinsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BinEntity>>> call(BinParams params) {
    return repository.listAllBins(params);
  }
}

