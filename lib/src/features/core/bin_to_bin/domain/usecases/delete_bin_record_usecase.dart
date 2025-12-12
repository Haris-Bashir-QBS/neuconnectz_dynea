import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/repositories/bin_transfer_report_repository.dart';

class DeleteBinRecordUseCase {
  final BinTransferReportRepository repository;

  DeleteBinRecordUseCase(this.repository);

  Future<Either<Failure, ApiResponse<bool>>> call({required int docNum}) async {
    return await repository.deleteBinRecord(docNum: docNum);
  }
}

