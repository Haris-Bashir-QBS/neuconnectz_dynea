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
      emit(
        GrnHeaderListLoading(
          pendingSection: state.pendingSection,
          completedSection: state.completedSection,
        ),
      );

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
          emit(
            GrnHeaderListFetchFailure(
              message: failure.message,
              pendingSection: state.pendingSection,
              completedSection: state.completedSection,
            ),
          );
        },
        (result) {
          emit(
            GrnHeaderListFetched(
              items: result.items,
              totalRows: result.totalRows,
              skipRecords: result.items.length,
              pendingSection: state.pendingSection,
              completedSection: state.completedSection,
            ),
          );
        },
      );
    } else {
      // Load more: append to existing items
      final currentState = state;
      if (currentState is! GrnHeaderListFetched) return;
      if (currentState.isLoadingMore || !currentState.hasMore) return;

      emit(
        GrnHeaderListFetched(
          items: currentState.items,
          totalRows: currentState.totalRows,
          skipRecords: currentState.skipRecords,
          isLoadingMore: true,
          pendingSection: state.pendingSection,
          completedSection: state.completedSection,
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
            GrnHeaderListFetched(
              items: currentState.items,
              totalRows: currentState.totalRows,
              skipRecords: currentState.skipRecords,
              isLoadingMore: false,
              pendingSection: state.pendingSection,
              completedSection: state.completedSection,
            ),
          );
          // Could emit failure here, but keeping items visible
        },
        (newResult) {
          final updatedItems = [...currentState.items, ...newResult.items];
          emit(
            GrnHeaderListFetched(
              items: updatedItems,
              totalRows: newResult.totalRows,
              skipRecords: updatedItems.length,
              isLoadingMore: false,
              pendingSection: state.pendingSection,
              completedSection: state.completedSection,
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
      final pendingSnapshot = state.pendingSection.copyWith(
        isLoading: true,
        isLoadingMore: false,
        items: const [],
        totalRows: 0,
        skipRecords: 0,
        errorMessage: null,
      );
      emit(
        GrnItemsLoading(
          pendingSection: pendingSnapshot,
          completedSection: state.completedSection,
        ),
      );

      final params = GrnItemQueryParams(
        plant: event.params.plant,
        location: event.params.location,
        materialDoc: event.params.materialDoc,
        materialDocYear: event.params.materialDocYear,
        lastCount: event.params.lastCount,
        trNumber: event.params.trNumber,
        skipRecords: 0, // Start from beginning
      );

      final result = await getGrnItemsUseCase(params);

      result.fold(
        (failure) {
          emit(
            GrnItemsFailure(
              message: failure.message,
              pendingSection: pendingSnapshot.copyWith(
                isLoading: false,
                errorMessage: failure.message,
              ),
              completedSection: state.completedSection,
            ),
          );
        },
        (result) {
          emit(
            GrnItemsSuccess(
              pendingSection: pendingSnapshot.copyWith(
                isLoading: false,
                items: result.items,
                totalRows: result.totalRows,
                skipRecords: result.items.length,
                errorMessage: null,
              ),
              completedSection: state.completedSection,
            ),
          );
        },
      );
    } else {
      final pendingState = state.pendingSection;
      if (pendingState.isLoadingMore || !pendingState.hasMore) return;

      final loadingMoreSnapshot = pendingState.copyWith(
        isLoadingMore: true,
        errorMessage: null,
      );
      emit(
        GrnItemsSuccess(
          pendingSection: loadingMoreSnapshot,
          completedSection: state.completedSection,
        ),
      );

      final params = GrnItemQueryParams(
        plant: event.params.plant,
        location: event.params.location,
        materialDoc: event.params.materialDoc,
        materialDocYear: event.params.materialDocYear,
        trNumber: event.params.trNumber,
        lastCount: event.params.lastCount,
        skipRecords: pendingState.skipRecords,
      );

      final result = await getGrnItemsUseCase(params);

      result.fold(
        (failure) {
          emit(
            GrnItemsFailure(
              message: failure.message,
              pendingSection: loadingMoreSnapshot.copyWith(
                isLoadingMore: false,
                errorMessage: failure.message,
              ),
              completedSection: state.completedSection,
            ),
          );
        },
        (newResult) {
          final updatedItems = [...pendingState.items, ...newResult.items];
          emit(
            GrnItemsSuccess(
              pendingSection: loadingMoreSnapshot.copyWith(
                items: updatedItems,
                totalRows: newResult.totalRows,
                skipRecords: updatedItems.length,
                isLoadingMore: false,
                errorMessage: null,
              ),
              completedSection: state.completedSection,
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
      final completedSnapshot = state.completedSection.copyWith(
        isLoading: true,
        isLoadingMore: false,
        items: const [],
        totalRows: 0,
        skipRecords: 0,
        errorMessage: null,
      );
      emit(
        CompletedGrnItemsLoading(
          pendingSection: state.pendingSection,
          completedSection: completedSnapshot,
        ),
      );

      final params = GrnItemQueryParams(
        plant: event.params.plant,
        location: event.params.location,
        materialDoc: event.params.materialDoc,
        materialDocYear: event.params.materialDocYear,
        trNumber: event.params.trNumber,
        lastCount: event.params.lastCount,
        skipRecords: 0,
      );

      final result = await getCompletedGrnItemsUseCase(params);

      result.fold(
        (failure) {
          emit(
            CompletedGrnItemsFailure(
              message: failure.message,
              pendingSection: state.pendingSection,
              completedSection: completedSnapshot.copyWith(
                isLoading: false,
                errorMessage: failure.message,
              ),
            ),
          );
        },
        (data) {
          emit(
            CompletedGrnItemsSuccess(
              pendingSection: state.pendingSection,
              completedSection: completedSnapshot.copyWith(
                isLoading: false,
                items: data.items,
                totalRows: data.totalRows,
                skipRecords: data.items.length,
                errorMessage: null,
              ),
            ),
          );
        },
      );
    } else {
      final completedState = state.completedSection;
      if (completedState.isLoadingMore || !completedState.hasMore) return;

      final loadingMoreSnapshot = completedState.copyWith(
        isLoadingMore: true,
        errorMessage: null,
      );
      emit(
        CompletedGrnItemsSuccess(
          pendingSection: state.pendingSection,
          completedSection: loadingMoreSnapshot,
        ),
      );

      final params = GrnItemQueryParams(
        plant: event.params.plant,
        location: event.params.location,
        materialDoc: event.params.materialDoc,
        materialDocYear: event.params.materialDocYear,
        lastCount: event.params.lastCount,
        trNumber: event.params.trNumber,
        skipRecords: completedState.skipRecords,
      );

      final result = await getCompletedGrnItemsUseCase(params);

      result.fold(
        (failure) {
          emit(
            CompletedGrnItemsFailure(
              message: failure.message,
              pendingSection: state.pendingSection,
              completedSection: loadingMoreSnapshot.copyWith(
                isLoadingMore: false,
                errorMessage: failure.message,
              ),
            ),
          );
        },
        (data) {
          final updatedItems = [...completedState.items, ...data.items];
          emit(
            CompletedGrnItemsSuccess(
              pendingSection: state.pendingSection,
              completedSection: loadingMoreSnapshot.copyWith(
                items: updatedItems,
                totalRows: data.totalRows,
                skipRecords: updatedItems.length,
                isLoadingMore: false,
                errorMessage: null,
              ),
            ),
          );
        },
      );
    }
  }
}
