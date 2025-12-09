import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/process_bin_to_bin_transfer_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/repositories/bin_to_bin_transfer_repository.dart';

class ProcessBinToBinTransferUseCase
    implements UseCase<ApiResponse<bool>, ProcessBinToBinTransferParams> {
  final BinToBinTransferRepository repository;

  ProcessBinToBinTransferUseCase(this.repository);

  @override
  Future<Either<Failure, ApiResponse<bool>>> call(
    ProcessBinToBinTransferParams params,
  ) {
    return repository.processBinToBinTransfer(params);
  }
}
