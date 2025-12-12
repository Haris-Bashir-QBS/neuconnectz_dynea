import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_item_params.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/usecases/delete_reservation_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/usecases/get_reservation_list_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/usecases/get_reservation_items_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/usecases/get_completed_reservation_items_usecase.dart';

part 'reservation_event.dart';
part 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final GetReservationListUseCase getReservationListUseCase;
  final GetReservationItemsUseCase getReservationItemsUseCase;
  final GetCompletedReservationItemsUseCase
      getCompletedReservationItemsUseCase;
  final DeleteReservationUseCase deleteReservationUseCase;

  ReservationBloc({
    required this.getReservationListUseCase,
    required this.getReservationItemsUseCase,
    required this.getCompletedReservationItemsUseCase,
    required this.deleteReservationUseCase,
  }) : super(const ReservationState()) {
    on<LoadReservationListEvent>(_onLoadReservationList);
    on<LoadReservationItemsEvent>(_onLoadReservationItems);
    on<LoadCompletedReservationItemsEvent>(_onLoadCompletedReservationItems);
    on<DeleteReservationEvent>(_onDeleteReservation);
  }

  Future<void> _onLoadReservationList(
    LoadReservationListEvent event,
    Emitter<ReservationState> emit,
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

    final result = await getReservationListUseCase(params);

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

  Future<void> _onLoadReservationItems(
    LoadReservationItemsEvent event,
    Emitter<ReservationState> emit,
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

    final result = await getReservationItemsUseCase(params);

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

  Future<void> _onLoadCompletedReservationItems(
    LoadCompletedReservationItemsEvent event,
    Emitter<ReservationState> emit,
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

    final result = await getCompletedReservationItemsUseCase(params);

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

  Future<void> _onDeleteReservation(
    DeleteReservationEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(
      state.copyWith(
        isDeleting: true,
        deleteError: null,
        deleteResponse: null,
      ),
    );

    final result = await deleteReservationUseCase(docNum: event.docNum);

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




