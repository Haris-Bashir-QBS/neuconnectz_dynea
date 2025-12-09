import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/data/datasources/remote/bin_to_bin_transfer_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/process_bin_to_bin_transfer_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/repositories/bin_to_bin_transfer_repository.dart';

class BinToBinTransferRepositoryImpl
    implements BinToBinTransferRepository {
  BinToBinTransferRepositoryImpl({required this.remoteDataSource});

  final BinToBinTransferRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, ApiResponse<bool>>> processBinToBinTransfer(
    ProcessBinToBinTransferParams params,
  ) async {
    try {
      final response = await remoteDataSource.processBinToBinTransfer(params);
      return Right(response);
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
