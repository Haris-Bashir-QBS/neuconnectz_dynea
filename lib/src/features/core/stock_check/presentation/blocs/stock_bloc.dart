import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/stock_entity.dart';
import '../../domain/params/stock_query_params.dart';
import '../../domain/usecases/get_stocks_usecase.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  StockBloc({
    required this.getStocksUseCase,
  }) : super(StockState.initial()) {
    on<LoadStocksEvent>(_onLoad);
    on<LoadMoreStocksEvent>(_onLoadMore);
    on<ChangeStockFilterEvent>(_onChangeFilter);
    on<SearchStockEvent>(_onSearch);
  }

  final GetStocksUseCase getStocksUseCase;

  Future<void> _onLoad(
    LoadStocksEvent event,
    Emitter<StockState> emit,
  ) async {
    final query = event.params.copyWith(skipRecords: 0);
    emit(
      state.copyWith(
        params: query,
        isLoading: true,
        items: const [],
        totalCount: 0,
        clearError: true,
      ),
    );

    final result = await getStocksUseCase(query);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          items: const [],
          totalCount: 0,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          isLoading: false,
          items: data.items,
          totalCount: data.totalCount,
          params: query,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    LoadMoreStocksEvent event,
    Emitter<StockState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    final params = state.params.copyWith(skipRecords: state.items.length);
    final result = await getStocksUseCase(params);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          isLoadingMore: false,
          items: [...state.items, ...data.items],
          totalCount: data.totalCount,
          params: params,
          clearError: true,
        ),
      ),
    );
  }

  void _onChangeFilter(
    ChangeStockFilterEvent event,
    Emitter<StockState> emit,
  ) {
    final params = state.params.copyWith(
      filterType: event.filterType,
      searchQuery: null,
      skipRecords: 0,
    );
    add(LoadStocksEvent(params: params));
  }

  void _onSearch(
    SearchStockEvent event,
    Emitter<StockState> emit,
  ) {
    final query = event.query?.trim();
    final params = state.params.copyWith(
      searchQuery: (query == null || query.isEmpty) ? null : query,
      skipRecords: 0,
    );
    add(LoadStocksEvent(params: params));
  }
}

