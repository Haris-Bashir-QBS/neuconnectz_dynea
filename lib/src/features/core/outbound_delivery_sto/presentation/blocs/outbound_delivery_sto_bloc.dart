import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/usecases/create_stock_transfer_order_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/usecases/get_and_update_stocks_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/usecases/get_outbound_delivery_sto_list_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/operation_state.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/outbound_delivery_sto_event.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/outbound_delivery_sto_state.dart';

class OutboundDeliveryStoBloc
    extends Bloc<OutboundDeliveryStoEvent, OutboundDeliveryStoState> {
  final GetOutboundDeliveryStoListUseCase getOutboundDeliveryStoListUseCase;
  final CreateStockTransferOrderUseCase createStockTransferOrderUseCase;
  final GetAndUpdateStocksUseCase getAndUpdateStocksUseCase;

  OutboundDeliveryStoBloc({
    required this.getOutboundDeliveryStoListUseCase,
    required this.createStockTransferOrderUseCase,
    required this.getAndUpdateStocksUseCase,
  }) : super(const OutboundDeliveryStoState()) {
    on<LoadOutboundDeliveryStoListEvent>(_onLoadList);
    on<CreateStockTransferOrderEvent>(_onCreateStockTransferOrder);
    on<GetAndUpdateStocksFromSapEvent>(_onGetAndUpdateStocksFromSap);
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

  Future<void> _onCreateStockTransferOrder(
    CreateStockTransferOrderEvent event,
    Emitter<OutboundDeliveryStoState> emit,
  ) async {
    emit(state.copyWith(
      createStockTransferOrder: state.createStockTransferOrder.copyWith(
        status: OperationStatus.loading,
        clearError: true,
        clearData: true,
      ),
    ));

    final result = await createStockTransferOrderUseCase(event.request);

    result.fold(
      (failure) => emit(state.copyWith(
        createStockTransferOrder: state.createStockTransferOrder.copyWith(
          status: OperationStatus.error,
          error: failure.message,
        ),
      )),
      (response) => emit(state.copyWith(
        createStockTransferOrder: state.createStockTransferOrder.copyWith(
          status: OperationStatus.success,
          data: response,
        ),
      )),
    );
  }

  Future<void> _onGetAndUpdateStocksFromSap(
    GetAndUpdateStocksFromSapEvent event,
    Emitter<OutboundDeliveryStoState> emit,
  ) async {
    emit(state.copyWith(
      syncStocks: const OperationState<ApiResponse<bool>>(
        status: OperationStatus.loading,
      ),
    ));

    final result = await getAndUpdateStocksUseCase(event.request);

    result.fold(
      (failure) => emit(state.copyWith(
        syncStocks: OperationState<ApiResponse<bool>>(
          status: OperationStatus.error,
          error: failure.message,
        ),
      )),
      (response) => emit(state.copyWith(
        syncStocks: OperationState<ApiResponse<bool>>(
          status: OperationStatus.success,
          data: response,
        ),
      )),
    );
  }
}


