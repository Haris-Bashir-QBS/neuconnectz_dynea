import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/get_bin_transfer_report_params.dart';

abstract class BinTransferReportEvent extends Equatable {
  const BinTransferReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadBinTransferReportEvent extends BinTransferReportEvent {
  final GetBinTransferReportParams params;

  const LoadBinTransferReportEvent({required this.params});

  @override
  List<Object?> get props => [params];
}


