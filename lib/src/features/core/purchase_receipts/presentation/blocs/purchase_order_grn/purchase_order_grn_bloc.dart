import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/params/purchase_order_grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/params/purchase_order_grn_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/usecases/delete_putaway_of_purchase_order_grn_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/usecases/get_completed_purchase_order_grn_items_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/usecases/get_purchase_order_grn_items_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/usecases/get_purchase_order_grn_list_usecase.dart';

part 'purchase_order_grn_event.dart';
part 'purchase_order_grn_state.dart';

class PurchaseOrderGrnBloc
    extends Bloc<PurchaseOrderGrnEvent, PurchaseOrderGrnState> {
  final GetPurchaseOrderGrnListUseCase getGrnListUseCase;
  final GetPurchaseOrderGrnItemsUseCase getGrnItemsUseCase;
  final GetCompletedPurchaseOrderGrnItemsUseCase getCompletedGrnItemsUseCase;
  final DeletePutAwayOfPurchaseOrderGrnUseCase deletePutAwayOfPurchaseOrderGrnUseCase;

  PurchaseOrderGrnBloc({
    required this.getGrnListUseCase,
    required this.getGrnItemsUseCase,
    required this.getCompletedGrnItemsUseCase,
    required this.deletePutAwayOfPurchaseOrderGrnUseCase,
  }) : super(PurchaseOrderGrnInitial()) {
    on<LoadPendingPurchaseOrderGrnEvent>(_onLoadPendingGrn);
    on<LoadPurchaseOrderGrnItemsEvent>(_onLoadGrnItems);
    on<LoadCompletedPurchaseOrderGrnItemsEvent>(_onLoadCompletedGrnItems);
    on<DeletePutAwayOfPurchaseOrderGrnEvent>(_onDeletePutAwayOfPurchaseOrderGrn);
  }

  Future<void> _onLoadPendingGrn(
    LoadPendingPurchaseOrderGrnEvent event,
    Emitter<PurchaseOrderGrnState> emit,
  ) async {
    if (event.refresh) {
      // Refresh: reset skipRecords to 0
      emit(
        PurchaseOrderGrnHeaderListLoading(
          pendingSection: state.pendingSection,
          completedSection: state.completedSection,
        ),
      );

      final params = PurchaseOrderGrnListParams(
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
            PurchaseOrderGrnHeaderListFetchFailure(
              message: failure.message,
              pendingSection: state.pendingSection,
              completedSection: state.completedSection,
            ),
          );
        },
        (result) {
          emit(
            PurchaseOrderGrnHeaderListFetched(
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
      if (currentState is! PurchaseOrderGrnHeaderListFetched) return;
      if (currentState.isLoadingMore || !currentState.hasMore) return;

      emit(
        PurchaseOrderGrnHeaderListFetched(
          items: currentState.items,
          totalRows: currentState.totalRows,
          skipRecords: currentState.skipRecords,
          isLoadingMore: true,
          pendingSection: state.pendingSection,
          completedSection: state.completedSection,
        ),
      );

      final nextSkipRecords = currentState.skipRecords;
      final params = PurchaseOrderGrnListParams(
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
            PurchaseOrderGrnHeaderListFetched(
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
            PurchaseOrderGrnHeaderListFetched(
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
    LoadPurchaseOrderGrnItemsEvent event,
    Emitter<PurchaseOrderGrnState> emit,
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
        PurchaseOrderGrnItemsLoading(
          pendingSection: pendingSnapshot,
          completedSection: state.completedSection,
        ),
      );

      final params = PurchaseOrderGrnItemQueryParams(
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
            PurchaseOrderGrnItemsFailure(
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
            PurchaseOrderGrnItemsSuccess(
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
        PurchaseOrderGrnItemsSuccess(
          pendingSection: loadingMoreSnapshot,
          completedSection: state.completedSection,
        ),
      );

      final params = PurchaseOrderGrnItemQueryParams(
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
            PurchaseOrderGrnItemsFailure(
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
            PurchaseOrderGrnItemsSuccess(
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
    LoadCompletedPurchaseOrderGrnItemsEvent event,
    Emitter<PurchaseOrderGrnState> emit,
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
        PurchaseOrderCompletedGrnItemsLoading(
          pendingSection: state.pendingSection,
          completedSection: completedSnapshot,
        ),
      );

      final params = PurchaseOrderGrnItemQueryParams(
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
            PurchaseOrderCompletedGrnItemsFailure(
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
            PurchaseOrderCompletedGrnItemsSuccess(
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
        PurchaseOrderCompletedGrnItemsSuccess(
          pendingSection: state.pendingSection,
          completedSection: loadingMoreSnapshot,
        ),
      );

      final params = PurchaseOrderGrnItemQueryParams(
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
            PurchaseOrderCompletedGrnItemsFailure(
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
            PurchaseOrderCompletedGrnItemsSuccess(
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

  Future<void> _onDeletePutAwayOfPurchaseOrderGrn(
    DeletePutAwayOfPurchaseOrderGrnEvent event,
    Emitter<PurchaseOrderGrnState> emit,
  ) async {
    emit(
      DeletePutAwayOfPurchaseOrderGrnLoading(
        pendingSection: state.pendingSection,
        completedSection: state.completedSection,
      ),
    );

    final result = await deletePutAwayOfPurchaseOrderGrnUseCase(docNum: event.docNum);

    result.fold(
      (failure) {
        emit(
          DeletePutAwayOfPurchaseOrderGrnFailure(
            message: failure.message,
            pendingSection: state.pendingSection,
            completedSection: state.completedSection,
          ),
        );
      },
      (success) {
        emit(
          DeletePutAwayOfPurchaseOrderGrnSuccess(
            apiResponse: success,
            pendingSection: state.pendingSection,
            completedSection: state.completedSection,
          ),
        );
      },
    );
  }
}
