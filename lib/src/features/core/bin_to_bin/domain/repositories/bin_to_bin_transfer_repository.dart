import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/process_bin_to_bin_transfer_params.dart';

abstract class BinToBinTransferRepository {
  Future<Either<Failure, ApiResponse<bool>>> processBinToBinTransfer(
    ProcessBinToBinTransferParams params,
  );
}


