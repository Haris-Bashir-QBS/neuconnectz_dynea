import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/usecases/get_grn_list_usecase.dart';

part 'grn_event.dart';
part 'grn_state.dart';

class GrnBloc extends Bloc<GrnEvent, GrnState> {
  final GetGrnListUseCase getGrnListUseCase;

  GrnBloc({
    required this.getGrnListUseCase,
  }) : super(GrnInitial()) {
    on<LoadPendingGrnEvent>(_onLoadPendingGrn);
  }

  Future<void> _onLoadPendingGrn(
    LoadPendingGrnEvent event,
    Emitter<GrnState> emit,
  ) async {
    if (event.refresh) {
      // Refresh: reset to page 1
      emit(PendingGrnLoading());

      final params = GrnListParams(
        plant: event.params.plant,
        location: event.params.location,
        pageSize: event.params.pageSize,
        pageNumber: 1,
        keyword: event.params.keyword,
      );

      final result = await getGrnListUseCase(params);

      result.fold(
        (failure) {
          emit(PendingGrnFailure(message: failure.message));
        },
        (items) {
          emit(
            PendingGrnSuccess(
              items: items,
              currentPage: 1,
              hasMore: items.length >= event.params.pageSize,
            ),
          );
        },
      );
    } else {
      // Load more: append to existing items
      final currentState = state;
      if (currentState is! PendingGrnSuccess) return;
      if (currentState.isLoadingMore || !currentState.hasMore) return;

      emit(
        PendingGrnSuccess(
          items: currentState.items,
          currentPage: currentState.currentPage,
          hasMore: currentState.hasMore,
          isLoadingMore: true,
        ),
      );

      final nextPage = currentState.currentPage + 1;
      final params = GrnListParams(
        plant: event.params.plant,
        location: event.params.location,
        pageSize: event.params.pageSize,
        pageNumber: nextPage,
        keyword: event.params.keyword,
      );

      final result = await getGrnListUseCase(params);

      result.fold(
        (failure) {
          emit(
            PendingGrnSuccess(
              items: currentState.items,
              currentPage: currentState.currentPage,
              hasMore: currentState.hasMore,
              isLoadingMore: false,
            ),
          );
          // Could emit failure here, but keeping items visible
        },
        (newItems) {
          final updatedItems = [...currentState.items, ...newItems];
          emit(
            PendingGrnSuccess(
              items: updatedItems,
              currentPage: nextPage,
              hasMore: newItems.length >= event.params.pageSize,
              isLoadingMore: false,
            ),
          );
        },
      );
    }
  }
}

