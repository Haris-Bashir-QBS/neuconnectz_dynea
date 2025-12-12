import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/movement_type_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/movement_type_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/usecases/get_movement_types_usecase.dart';

part 'movement_type_event.dart';
part 'movement_type_state.dart';

class MovementTypeBloc extends Bloc<MovementTypeEvent, MovementTypeState> {
  MovementTypeBloc({required this.getMovementTypesUseCase})
    : super(MovementTypeState.initial()) {
    on<MovementTypeFetchEvent>(_onFetch);
    on<MovementTypeLoadMoreEvent>(_onLoadMore);
  }

  final GetMovementTypesUseCase getMovementTypesUseCase;
  static const int _pageSize = 50;

  Future<void> _onFetch(
    MovementTypeFetchEvent event,
    Emitter<MovementTypeState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        items: const [],
        totalCount: 0,
        keyword: event.keyword,
        clearError: true,
      ),
    );

    final result = await getMovementTypesUseCase(
      MovementTypeQueryParams(
        keyword: event.keyword,
        lastCount: _pageSize,
        skipRecords: 0,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          items: const [],
          totalCount: 0,
        ),
      ),
      (data) => emit(
        state.copyWith(
          isLoading: false,
          items: data.items,
          totalCount: data.totalCount,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    MovementTypeLoadMoreEvent event,
    Emitter<MovementTypeState> emit,
  ) async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    final result = await getMovementTypesUseCase(
      MovementTypeQueryParams(
        keyword: state.keyword,
        lastCount: _pageSize,
        skipRecords: state.items.length,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMore: false, errorMessage: failure.message),
      ),
      (data) => emit(
        state.copyWith(
          isLoadingMore: false,
          items: [...state.items, ...data.items],
          totalCount: data.totalCount,
          clearError: true,
        ),
      ),
    );
  }
}


