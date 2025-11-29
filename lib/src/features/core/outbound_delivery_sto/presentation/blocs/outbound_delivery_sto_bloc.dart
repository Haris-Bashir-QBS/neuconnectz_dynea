import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/usecases/get_outbound_delivery_sto_list_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/outbound_delivery_sto_event.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/outbound_delivery_sto_state.dart';

class OutboundDeliveryStoBloc
    extends Bloc<OutboundDeliveryStoEvent, OutboundDeliveryStoState> {
  final GetOutboundDeliveryStoListUseCase getOutboundDeliveryStoListUseCase;

  OutboundDeliveryStoBloc({required this.getOutboundDeliveryStoListUseCase})
      : super(const OutboundDeliveryStoState()) {
    on<LoadOutboundDeliveryStoListEvent>(_onLoadList);
  }

  Future<void> _onLoadList(
    LoadOutboundDeliveryStoListEvent event,
    Emitter<OutboundDeliveryStoState> emit,
  ) async {
    if (event.refresh) {
      emit(state.copyWith(
        loading: true,
        items: [],
        totalRows: 0,
        skipRecords: 0,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(loadingMore: true));
    }

    final result = await getOutboundDeliveryStoListUseCase(event.params);

    result.fold(
      (failure) {
        if (event.refresh) {
          emit(state.copyWith(
            loading: false,
            error: failure.message,
          ));
        } else {
          emit(state.copyWith(
            loadingMore: false,
            error: failure.message,
          ));
        }
      },
      (response) {
        final newItems = event.refresh
            ? response
            : [...state.items, ...response];

        emit(state.copyWith(
          loading: false,
          loadingMore: false,
          items: newItems,
          totalRows: response.length,
          skipRecords: newItems.length,
          clearError: true,
        ));
      },
    );
  }
}
