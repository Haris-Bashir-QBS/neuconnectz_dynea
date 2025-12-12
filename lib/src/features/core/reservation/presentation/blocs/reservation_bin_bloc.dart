import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/usecases/get_warehouse_bins_by_material_usecase.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';

part 'reservation_bin_event.dart';
part 'reservation_bin_state.dart';

class ReservationBinBloc
    extends Bloc<ReservationBinEvent, ReservationBinState> {
  final GetWarehouseBinsByMaterialUseCase getWarehouseBinsByMaterialUseCase;

  ReservationBinBloc({
    required this.getWarehouseBinsByMaterialUseCase,
  }) : super(ReservationBinInitial()) {
    on<LoadWarehouseBinsByMaterialEvent>(_onLoadWarehouseBinsByMaterial);
  }

  Future<void> _onLoadWarehouseBinsByMaterial(
    LoadWarehouseBinsByMaterialEvent event,
    Emitter<ReservationBinState> emit,
  ) async {
    emit(ReservationBinLoading());

    final params = GetWarehouseBinsByMaterialParams(
      warehouseCode: event.warehouseCode,
      material: event.material,
    );

    final result = await getWarehouseBinsByMaterialUseCase(params);

    result.fold(
      (failure) => emit(
        ReservationBinFailure(message: failure.message),
      ),
      (binResult) => emit(
        ReservationBinSuccess(
          bins: binResult.bins,
          proposedQuantities: binResult.proposedQuantities,
        ),
      ),
    );
  }
}



