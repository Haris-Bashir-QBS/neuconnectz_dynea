import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/usecases/get_completed_outbound_delivery_sales_items_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/usecases/get_outbound_delivery_sales_items_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/usecases/get_outbound_delivery_sales_list_usecase.dart';

part 'outbound_delivery_sales_event.dart';
part 'outbound_delivery_sales_state.dart';

class OutboundDeliverySalesBloc
    extends Bloc<OutboundDeliverySalesEvent, OutboundDeliverySalesState> {
  final GetOutboundDeliverySalesListUseCase getOutboundDeliverySalesListUseCase;
  final GetOutboundDeliverySalesItemsUseCase
      getOutboundDeliverySalesItemsUseCase;
  final GetCompletedOutboundDeliverySalesItemsUseCase
      getCompletedOutboundDeliverySalesItemsUseCase;

  OutboundDeliverySalesBloc({
    required this.getOutboundDeliverySalesListUseCase,
    required this.getOutboundDeliverySalesItemsUseCase,
    required this.getCompletedOutboundDeliverySalesItemsUseCase,
  }) : super(const OutboundDeliverySalesState()) {
    on<LoadOutboundDeliverySalesListEvent>(_onLoadOutboundDeliverySalesList);
    on<LoadOutboundDeliverySalesItemsEvent>(_onLoadOutboundDeliverySalesItems);
    on<LoadCompletedOutboundDeliverySalesItemsEvent>(
        _onLoadCompletedOutboundDeliverySalesItems);
  }

  Future<void> _onLoadOutboundDeliverySalesList(
    LoadOutboundDeliverySalesListEvent event,
    Emitter<OutboundDeliverySalesState> emit,
  ) async {
    if (event.refresh) {
      emit(
        state.copyWith(
          listLoading: true,
          listError: null,
          listItems: const [],
          listSkipRecords: 0,
          listTotalRows: 0,
          listIsLoadingMore: false,
        ),
      );
    } else {
      if (state.listIsLoadingMore || !state.listHasMore) return;
      emit(
        state.copyWith(
          listIsLoadingMore: true,
          listError: null,
        ),
      );
    }

    final params = event.params.copyWith(
      lastCount: event.params.lastCount,
      skipRecords: event.refresh ? 0 : state.listSkipRecords,
    );

    final result = await getOutboundDeliverySalesListUseCase(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            listLoading: false,
            listIsLoadingMore: false,
            listError: failure.message,
          ),
        );
      },
      (data) {
        final newItems = event.refresh
            ? data.data
            : [...state.listItems, ...data.data];
        emit(
          state.copyWith(
            listLoading: false,
            listIsLoadingMore: false,
            listError: null,
            listItems: newItems,
            listTotalRows: data.totalCount,
            listSkipRecords: newItems.length,
          ),
        );
      },
    );
  }

  Future<void> _onLoadOutboundDeliverySalesItems(
    LoadOutboundDeliverySalesItemsEvent event,
    Emitter<OutboundDeliverySalesState> emit,
  ) async {
    if (event.refresh) {
      emit(
        state.copyWith(
          pendingLoading: true,
          pendingError: null,
          pendingItems: const [],
          pendingSkipRecords: 0,
          pendingTotalRows: 0,
          pendingIsLoadingMore: false,
        ),
      );
    } else {
      if (state.pendingIsLoadingMore || !state.pendingHasMore) return;
      emit(
        state.copyWith(
          pendingIsLoadingMore: true,
          pendingError: null,
        ),
      );
    }

    final params = event.params.copyWith(
      skipRecords: event.refresh ? 0 : state.pendingSkipRecords,
    );

    final result = await getOutboundDeliverySalesItemsUseCase(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            pendingLoading: false,
            pendingIsLoadingMore: false,
            pendingError: failure.message,
          ),
        );
      },
      (data) {
        final newItems = event.refresh
            ? data.data
            : [...state.pendingItems, ...data.data];
        emit(
          state.copyWith(
            pendingLoading: false,
            pendingIsLoadingMore: false,
            pendingError: null,
            pendingItems: newItems,
            pendingTotalRows: data.totalCount,
            pendingSkipRecords: newItems.length,
          ),
        );
      },
    );
  }

  Future<void> _onLoadCompletedOutboundDeliverySalesItems(
    LoadCompletedOutboundDeliverySalesItemsEvent event,
    Emitter<OutboundDeliverySalesState> emit,
  ) async {
    if (event.refresh) {
      emit(
        state.copyWith(
          completedLoading: true,
          completedError: null,
          completedItems: const [],
          completedSkipRecords: 0,
          completedTotalRows: 0,
          completedIsLoadingMore: false,
        ),
      );
    } else {
      if (state.completedIsLoadingMore || !state.completedHasMore) return;
      emit(
        state.copyWith(
          completedIsLoadingMore: true,
          completedError: null,
        ),
      );
    }

    final params = event.params.copyWith(
      skipRecords: event.refresh ? 0 : state.completedSkipRecords,
    );

    final result = await getCompletedOutboundDeliverySalesItemsUseCase(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            completedLoading: false,
            completedIsLoadingMore: false,
            completedError: failure.message,
          ),
        );
      },
      (data) {
        final newItems = event.refresh
            ? data.data
            : [...state.completedItems, ...data.data];
        emit(
          state.copyWith(
            completedLoading: false,
            completedIsLoadingMore: false,
            completedError: null,
            completedItems: newItems,
            completedTotalRows: data.totalCount,
            completedSkipRecords: newItems.length,
          ),
        );
      },
    );
  }
}

