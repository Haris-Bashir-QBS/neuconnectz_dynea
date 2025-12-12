import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/entities/bin_transfer_report_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/get_bin_transfer_report_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/repositories/bin_transfer_report_repository.dart';

class GetBinTransferReportUseCase {
  GetBinTransferReportUseCase({required this.repository});

  final BinTransferReportRepository repository;

  Future<Either<Failure, List<BinTransferReportEntity>>> call(
    GetBinTransferReportParams params,
  ) async {
    return await repository.getBinTransferReport(params);
  }
}


