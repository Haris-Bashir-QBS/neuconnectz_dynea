import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/usecases/get_bin_transfer_report_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_event.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_state.dart';

class BinTransferReportBloc
    extends Bloc<BinTransferReportEvent, BinTransferReportState> {
  BinTransferReportBloc({required this.getBinTransferReportUseCase})
    : super(BinTransferReportInitial()) {
    on<LoadBinTransferReportEvent>(_onLoadBinTransferReport);
  }

  final GetBinTransferReportUseCase getBinTransferReportUseCase;
  Future<void> _onLoadBinTransferReport(
    LoadBinTransferReportEvent event,
    Emitter<BinTransferReportState> emit,
  ) async {
    emit(BinTransferReportLoading());

    final result = await getBinTransferReportUseCase(event.params);

    result.fold(
      (failure) => emit(BinTransferReportFailure(message: failure.message)),
      (reports) => emit(BinTransferReportSuccess(reports: reports)),
    );
  }
}


