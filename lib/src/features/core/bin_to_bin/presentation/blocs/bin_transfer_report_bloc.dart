import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/get_bin_transfer_report_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/usecases/delete_bin_record_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/usecases/get_bin_transfer_report_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_event.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_state.dart';

class BinTransferReportBloc
    extends Bloc<BinTransferReportEvent, BinTransferReportState> {
  BinTransferReportBloc({
    required this.getBinTransferReportUseCase,
    required this.deleteBinRecordUseCase,
  }) : super(BinTransferReportInitial()) {
    on<LoadBinTransferReportEvent>(_onLoadBinTransferReport);
    on<DeleteBinRecordEvent>(_onDeleteBinRecord);
  }

  final GetBinTransferReportUseCase getBinTransferReportUseCase;
  final DeleteBinRecordUseCase deleteBinRecordUseCase;
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

  Future<void> _onDeleteBinRecord(
    DeleteBinRecordEvent event,
    Emitter<BinTransferReportState> emit,
  ) async {
    emit(DeleteBinRecordLoading());

    final result = await deleteBinRecordUseCase(docNum: event.docNum);

    result.fold(
      (failure) => emit(DeleteBinRecordFailure(message: failure.message)),
      (success) {
        emit(DeleteBinRecordSuccess(apiResponse: success));
        // Automatically reload the report list after successful delete
        add(const LoadBinTransferReportEvent(params: GetBinTransferReportParams()));
      },
    );
  }
}


