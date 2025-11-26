import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/params/bin_params.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/usecases/get_bins_usecase.dart';

part 'bin_event.dart';
part 'bin_state.dart';

class BinBloc extends Bloc<BinEvent, BinState> {
  final GetBinsUseCase getBinsUseCase;

  BinBloc({required this.getBinsUseCase}) : super(BinInitial()) {
    on<LoadBinsEvent>(_onLoadBins);
  }

  Future<void> _onLoadBins(LoadBinsEvent event, Emitter<BinState> emit) async {
    emit(BinLoading());

    final params = BinParams(
      // plant: event.plant,
      storageType: event.storageType,
      keyword: event.keyword,
      warehouseCode: event.warehouseCode,
      lastCount: event.lastCount,
      skipRecords: event.skipRecords,
    );

    final result = await getBinsUseCase(params);

    result.fold(
      (failure) => emit(BinFailure(message: failure.message)),
      (bins) => emit(BinSuccess(bins: bins)),
    );
  }
}
