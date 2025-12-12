import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/usecases/delete_picking_against_outbound_delivery_sto_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/usecases/get_completed_sto_items_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/usecases/get_stock_doc_item_from_sap_usecase.dart';

part 'outbound_delivery_sto_item_event.dart';
part 'outbound_delivery_sto_item_state.dart';

class OutboundDeliveryStoItemBloc
    extends Bloc<OutboundDeliveryStoItemEvent, OutboundDeliveryStoItemState> {
  final GetStockDocItemFromSAPUseCase getStockDocItemFromSAPUseCase;
  final GetCompletedStoItemsUseCase getCompletedStoItemsUseCase;
  final DeletePickingAgainstOutboundDeliveryStoUseCase
  deletePickingAgainstOutboundDeliveryStoUseCase;

  OutboundDeliveryStoItemBloc({
    required this.getStockDocItemFromSAPUseCase,
    required this.getCompletedStoItemsUseCase,
    required this.deletePickingAgainstOutboundDeliveryStoUseCase,
  }) : super(const OutboundDeliveryStoItemState()) {
    on<LoadStoItemsEvent>(_onLoadStoItems);
    on<LoadCompletedStoItemsEvent>(_onLoadCompletedStoItems);
    on<DeletePickingAgainstOutboundDeliveryStoEvent>(
      _onDeletePickingAgainstOutboundDeliverySto,
    );
  }

  Future<void> _onLoadStoItems(
    LoadStoItemsEvent event,
    Emitter<OutboundDeliveryStoItemState> emit,
  ) async {
    if (event.refresh) {
      emit(
        state.copyWith(
          pendingSection: state.pendingSection.copyWith(
            isLoading: true,
            items: [],
            totalRows: 0,
            skipRecords: 0,
            errorMessage: null,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          pendingSection: state.pendingSection.copyWith(isLoadingMore: true),
        ),
      );
    }

    final result = await getStockDocItemFromSAPUseCase(event.params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            pendingSection: state.pendingSection.copyWith(
              isLoading: false,
              isLoadingMore: false,
              errorMessage: failure.message,
            ),
          ),
        );
      },
      (items) {
        final newItems =
            event.refresh ? items : [...state.pendingSection.items, ...items];

        emit(
          state.copyWith(
            pendingSection: state.pendingSection.copyWith(
              isLoading: false,
              isLoadingMore: false,
              items: newItems,
              totalRows: items.length,
              skipRecords: newItems.length,
              errorMessage: null,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onLoadCompletedStoItems(
    LoadCompletedStoItemsEvent event,
    Emitter<OutboundDeliveryStoItemState> emit,
  ) async {
    if (event.refresh) {
      emit(
        state.copyWith(
          completedSection: state.completedSection.copyWith(
            isLoading: true,
            items: [],
            totalRows: 0,
            skipRecords: 0,
            errorMessage: null,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          completedSection: state.completedSection.copyWith(
            isLoadingMore: true,
          ),
        ),
      );
    }

    final result = await getCompletedStoItemsUseCase(event.params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            completedSection: state.completedSection.copyWith(
              isLoading: false,
              isLoadingMore: false,
              errorMessage: failure.message,
            ),
          ),
        );
      },
      (items) {
        final newItems =
            event.refresh ? items : [...state.completedSection.items, ...items];

        emit(
          state.copyWith(
            completedSection: state.completedSection.copyWith(
              isLoading: false,
              isLoadingMore: false,
              items: newItems,
              totalRows: items.length,
              skipRecords: newItems.length,
              errorMessage: null,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onDeletePickingAgainstOutboundDeliverySto(
    DeletePickingAgainstOutboundDeliveryStoEvent event,
    Emitter<OutboundDeliveryStoItemState> emit,
  ) async {
    emit(
      state.copyWith(isDeleting: true, deleteError: null, deleteResponse: null),
    );

    final result = await deletePickingAgainstOutboundDeliveryStoUseCase(
      docNum: event.docNum,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isDeleting: false,
            deleteError: failure.message,
            deleteResponse: null,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            isDeleting: false,
            deleteError: null,
            deleteResponse: success,
          ),
        );
      },
    );
  }
}
