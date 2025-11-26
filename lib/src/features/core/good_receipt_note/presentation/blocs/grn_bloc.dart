import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/usecases/get_grn_list_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/usecases/get_grn_items_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/usecases/get_completed_grn_items_usecase.dart';

part 'grn_event.dart';
part 'grn_state.dart';

class GrnBloc extends Bloc<GrnEvent, GrnState> {
  final GetGrnListUseCase getGrnListUseCase;
  final GetGrnItemsUseCase getGrnItemsUseCase;
  final GetCompletedGrnItemsUseCase getCompletedGrnItemsUseCase;

  GrnBloc({
    required this.getGrnListUseCase,
    required this.getGrnItemsUseCase,
    required this.getCompletedGrnItemsUseCase,
  }) : super(GrnInitial()) {
    on<LoadPendingGrnEvent>(_onLoadPendingGrn);
    on<LoadGrnItemsEvent>(_onLoadGrnItems);
    on<LoadCompletedGrnItemsEvent>(_onLoadCompletedGrnItems);
  }

  Future<void> _onLoadPendingGrn(
    LoadPendingGrnEvent event,
    Emitter<GrnState> emit,
  ) async {
    if (event.refresh) {
      // Refresh: reset skipRecords to 0
      emit(PendingGrnLoading());

      final params = GrnListParams(
        plant: event.params.plant,
        location: event.params.location,
        lastCount: event.params.lastCount,
        skipRecords: 0,
        keyword: event.params.keyword,
      );

      final result = await getGrnListUseCase(params);

      result.fold(
        (failure) {
          emit(PendingGrnFailure(message: failure.message));
        },
        (result) {
          emit(
            PendingGrnSuccess(
              items: result.items,
              totalRows: result.totalRows,
              skipRecords: result.items.length,
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
          totalRows: currentState.totalRows,
          skipRecords: currentState.skipRecords,
          isLoadingMore: true,
        ),
      );

      final nextSkipRecords = currentState.skipRecords;
      final params = GrnListParams(
        plant: event.params.plant,
        location: event.params.location,
        lastCount: event.params.lastCount,
        skipRecords: nextSkipRecords,
        keyword: event.params.keyword,
      );

      final result = await getGrnListUseCase(params);

      result.fold(
        (failure) {
          emit(
            PendingGrnSuccess(
              items: currentState.items,
              totalRows: currentState.totalRows,
              skipRecords: currentState.skipRecords,
              isLoadingMore: false,
            ),
          );
          // Could emit failure here, but keeping items visible
        },
        (newResult) {
          final updatedItems = [...currentState.items, ...newResult.items];
          emit(
            PendingGrnSuccess(
              items: updatedItems,
              totalRows: newResult.totalRows,
              skipRecords: updatedItems.length,
              isLoadingMore: false,
            ),
          );
        },
      );
    }
  }

  Future<void> _onLoadGrnItems(
    LoadGrnItemsEvent event,
    Emitter<GrnState> emit,
  ) async {
    if (event.refresh) {
      // Always emit loading state first when refreshing
      emit(GrnItemsLoading());

      final params = GrnItemQueryParams(
        plant: event.params.plant,
        location: event.params.location,
        materialDoc: event.params.materialDoc,
        materialDocYear: event.params.materialDocYear,
        lastCount: event.params.lastCount,
        skipRecords: 0, // Start from beginning
      );

      final result = await getGrnItemsUseCase(params);

      result.fold(
        (failure) {
          emit(GrnItemsFailure(message: failure.message));
        },
        (result) {
          emit(
            GrnItemsSuccess(
              items: result.items,
              totalRows: result.totalRows,
              skipRecords: result.items.length, // Track how many items we have
            ),
          );
        },
      );
    } else {
      // Load more - pagination logic
      final currentState = state;
      if (currentState is! GrnItemsSuccess) return;
      if (currentState.isLoadingMore || !currentState.hasMore) return;

      // Show loading indicator for pagination
      emit(
        GrnItemsSuccess(
          items: currentState.items,
          totalRows: currentState.totalRows,
          skipRecords: currentState.skipRecords,
          isLoadingMore: true,
        ),
      );

      final params = GrnItemQueryParams(
        plant: event.params.plant,
        location: event.params.location,
        materialDoc: event.params.materialDoc,
        materialDocYear: event.params.materialDocYear,
        lastCount: event.params.lastCount,
        skipRecords:
            currentState.skipRecords, // Continue from where we left off
      );

      final result = await getGrnItemsUseCase(params);

      result.fold(
        (failure) {
          // Revert to previous state on failure
          emit(
            GrnItemsSuccess(
              items: currentState.items,
              totalRows: currentState.totalRows,
              skipRecords: currentState.skipRecords,
              isLoadingMore: false,
            ),
          );
        },
        (newResult) {
          // Append new items to existing list
          final updatedItems = [...currentState.items, ...newResult.items];
          emit(
            GrnItemsSuccess(
              items: updatedItems,
              totalRows: newResult.totalRows,
              skipRecords: updatedItems.length, // Update skip count
              isLoadingMore: false,
            ),
          );
        },
      );
    }
  }

  Future<void> _onLoadCompletedGrnItems(
    LoadCompletedGrnItemsEvent event,
    Emitter<GrnState> emit,
  ) async {
    if (event.refresh) {
      emit(CompletedGrnItemsLoading());

      final params = GrnItemQueryParams(
        plant: event.params.plant,
        location: event.params.location,
        materialDoc: event.params.materialDoc,
        materialDocYear: event.params.materialDocYear,
        lastCount: event.params.lastCount,
        skipRecords: 0,
      );

      final result = await getCompletedGrnItemsUseCase(params);

      result.fold(
        (failure) => emit(CompletedGrnItemsFailure(message: failure.message)),
        (data) => emit(
          CompletedGrnItemsSuccess(
            items: data.items,
            totalRows: data.totalRows,
            skipRecords: data.items.length,
          ),
        ),
      );
    } else {
      final currentState = state;
      if (currentState is! CompletedGrnItemsSuccess) return;
      if (currentState.isLoadingMore || !currentState.hasMore) return;

      emit(
        CompletedGrnItemsSuccess(
          items: currentState.items,
          totalRows: currentState.totalRows,
          skipRecords: currentState.skipRecords,
          isLoadingMore: true,
        ),
      );

      final params = GrnItemQueryParams(
        plant: event.params.plant,
        location: event.params.location,
        materialDoc: event.params.materialDoc,
        materialDocYear: event.params.materialDocYear,
        lastCount: event.params.lastCount,
        skipRecords: currentState.skipRecords,
      );

      final result = await getCompletedGrnItemsUseCase(params);

      result.fold(
        (failure) {
          emit(
            CompletedGrnItemsSuccess(
              items: currentState.items,
              totalRows: currentState.totalRows,
              skipRecords: currentState.skipRecords,
              isLoadingMore: false,
            ),
          );
        },
        (data) {
          final updatedItems = [...currentState.items, ...data.items];
          emit(
            CompletedGrnItemsSuccess(
              items: updatedItems,
              totalRows: data.totalRows,
              skipRecords: updatedItems.length,
              isLoadingMore: false,
            ),
          );
        },
      );
    }
  }
}
