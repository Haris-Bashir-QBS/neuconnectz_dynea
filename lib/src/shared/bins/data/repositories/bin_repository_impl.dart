import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/shared/bins/data/datasources/bin_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/params/bin_params.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/repositories/bin_repository.dart';

class BinRepositoryImpl implements BinRepository {
  final BinRemoteDataSource remoteDataSource;

  BinRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BinEntity>>> listAllBins(
    BinParams params,
  ) async {
    try {
      final model = await remoteDataSource.listAllBins(params: params);
      if (model.data == null || !model.isRequestSuccess) {
        return right([]);
      }
      return right(
        model.data!.data.map((item) => item.toEntity()).toList(),
      );
    } on Failure catch (failure) {
      return left(failure);
    }
  }
}

