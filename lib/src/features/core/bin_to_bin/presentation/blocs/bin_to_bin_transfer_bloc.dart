import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/get_bin_transfer_report_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/process_bin_to_bin_transfer_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/usecases/process_bin_to_bin_transfer_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_event.dart';

part 'bin_to_bin_transfer_event.dart';
part 'bin_to_bin_transfer_state.dart';

class BinToBinTransferBloc
    extends Bloc<BinToBinTransferEvent, BinToBinTransferState> {
  BinToBinTransferBloc({
    required this.binTransferReportBloc,
    required this.useCase,
  }) : super(BinToBinTransferInitial()) {
    on<ProcessBinToBinTransferEvent>(_onProcessTransfer);
  }

  final ProcessBinToBinTransferUseCase useCase;
  final BinTransferReportBloc binTransferReportBloc;
  Future<void> _onProcessTransfer(
    ProcessBinToBinTransferEvent event,
    Emitter<BinToBinTransferState> emit,
  ) async {
    emit(BinToBinTransferLoading());

    final params = ProcessBinToBinTransferParams(
      plant: event.plant,
      warehouseNumber: event.warehouseNumber,
      storageLocation: event.storageLocation,
      destinationStorageBin: event.destinationStorageBin,
      destinationStorageType: event.destinationStorageType,
      destinationStorageSection: event.destinationStorageSection,
      sourceMaterials:
          event.sourceMaterials
              .map((m) => SourceMaterial(id: m['id'], quantity: m['quantity']))
              .toList(),
    );

    final result = await useCase(params);

    result.fold(
      (failure) => emit(BinToBinTransferFailure(message: failure.message)),
      (data) {
        emit(BinToBinTransferSuccess(response: data));
        binTransferReportBloc.add(
          LoadBinTransferReportEvent(params: GetBinTransferReportParams()),
        );
      },
    );
  }
}
