import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/params/bin_params.dart';

abstract class BinRepository {
  Future<Either<Failure, List<BinEntity>>> listAllBins(
    BinParams params,
  );
}

