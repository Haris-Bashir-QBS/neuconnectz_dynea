import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/data/datasources/remote/bin_transfer_report_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/entities/bin_transfer_report_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/get_bin_transfer_report_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/repositories/bin_transfer_report_repository.dart';

class BinTransferReportRepositoryImpl implements BinTransferReportRepository {
  BinTransferReportRepositoryImpl({required this.remoteDataSource});

  final BinTransferReportRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<BinTransferReportEntity>>> getBinTransferReport(
    GetBinTransferReportParams params,
  ) async {
    try {
      final response = await remoteDataSource.getBinTransferReport(params);

      if (response.isRequestSuccess && response.data != null) {
        return Right(response.data!);
      }

      return Left(Failure(message: response.message));
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
