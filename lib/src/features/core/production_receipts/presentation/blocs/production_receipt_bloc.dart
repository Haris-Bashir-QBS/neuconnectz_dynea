import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/data/models/create_production_receipt_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/repositories/production_receipt_repository.dart';

part 'production_receipt_event.dart';
part 'production_receipt_state.dart';

class ProductionReceiptBloc
    extends Bloc<ProductionReceiptEvent, ProductionReceiptState> {
  final ProductionReceiptRepository repository;

  ProductionReceiptBloc({required this.repository})
      : super(const ProductionReceiptInitial()) {
    on<LoadProductionReceiptsEvent>(_onLoadHeaders);
    on<LoadProductionReceiptItemsEvent>(_onLoadItems);
    on<LoadCompletedProductionReceiptItemsEvent>(_onLoadCompletedItems);
    on<CreateProductionReceiptEvent>(_onCreateProductionReceipt);
  }

  Future<void> _onLoadHeaders(
    LoadProductionReceiptsEvent event,
    Emitter<ProductionReceiptState> emit,
  ) async {
    if (event.reset) {
      emit(
        ProductionReceiptHeaderListLoading(
          pendingSection: state.pendingSection,
          completedSection: state.completedSection,
        ),
      );

      final params = ProductionReceiptListParams(
        plant: event.params.plant,
        warehouseNumber: event.params.warehouseNumber,
        storageLocation: event.params.storageLocation,
        lastCount: event.params.lastCount,
        skipRecords: 0,
        keyword: event.params.keyword,
      );

      final result = await repository.listProductionReceiptsFromSAP(params);

      result.fold(
        (failure) {
          emit(
            ProductionReceiptHeaderListFetchFailure(
              message: failure.message,
              pendingSection: state.pendingSection,
              completedSection: state.completedSection,
            ),
          );
        },
        (data) {
          emit(
            ProductionReceiptHeaderListFetched(
              headers: data.items,
              headersTotalRows: data.totalRows,
              skipRecords: data.items.length,
              pendingSection: state.pendingSection,
              completedSection: state.completedSection,
            ),
          );
        },
      );
    } else {
      final currentState = state;
      if (currentState is ProductionReceiptHeaderListFetched) {
        if (currentState.isLoadingMore || !currentState.hasMore) return;

        emit(
          ProductionReceiptHeaderListFetched(
            headers: currentState.headers,
            headersTotalRows: currentState.headersTotalRows,
            skipRecords: currentState.skipRecords,
            isLoadingMore: true,
            pendingSection: state.pendingSection,
            completedSection: state.completedSection,
          ),
        );

        final params = ProductionReceiptListParams(
          plant: event.params.plant,
          warehouseNumber: event.params.warehouseNumber,
          storageLocation: event.params.storageLocation,
          lastCount: event.params.lastCount,
          skipRecords: currentState.skipRecords,
          keyword: event.params.keyword,
        );

        final result = await repository.listProductionReceiptsFromSAP(params);

        result.fold(
          (failure) {
            emit(
              ProductionReceiptHeaderListFetchFailure(
                message: failure.message,
                pendingSection: state.pendingSection,
                completedSection: state.completedSection,
              ),
            );
          },
          (data) {
            final updatedHeaders = [...currentState.headers, ...data.items];
            emit(
              ProductionReceiptHeaderListFetched(
                headers: updatedHeaders,
                headersTotalRows: data.totalRows,
                skipRecords: updatedHeaders.length,
                isLoadingMore: false,
                pendingSection: state.pendingSection,
                completedSection: state.completedSection,
              ),
            );
          },
        );
      }
    }
  }

  Future<void> _onLoadItems(
    LoadProductionReceiptItemsEvent event,
    Emitter<ProductionReceiptState> emit,
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
        ProductionReceiptItemsLoading(
          pendingSection: pendingSnapshot,
          completedSection: state.completedSection,
          isHeadersLoading: state.isHeadersLoading,
          headers: state.headers,
          headersTotalRows: state.headersTotalRows,
        ),
      );

      final params = ProductionReceiptItemQueryParams(
        plant: event.params.plant,
        warehouseNumber: event.params.warehouseNumber,
        storageLocation: event.params.storageLocation,
        trNumber: event.params.trNumber,
        lastCount: event.params.lastCount,
        skipRecords: 0,
      );

      final result = await repository.listProductionReceiptItemsFromSAP(params);

      result.fold(
        (failure) {
          emit(
            ProductionReceiptItemsFailure(
              message: failure.message,
              pendingSection: pendingSnapshot.copyWith(
                isLoading: false,
                errorMessage: failure.message,
              ),
              completedSection: state.completedSection,
              isHeadersLoading: state.isHeadersLoading,
              headers: state.headers,
              headersTotalRows: state.headersTotalRows,
            ),
          );
        },
        (data) {
          emit(
            ProductionReceiptItemsSuccess(
              pendingSection: pendingSnapshot.copyWith(
                isLoading: false,
                items: data.items,
                totalRows: data.totalRows,
                skipRecords: data.items.length,
                errorMessage: null,
              ),
              completedSection: state.completedSection,
              isHeadersLoading: state.isHeadersLoading,
              headers: state.headers,
              headersTotalRows: state.headersTotalRows,
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
        ProductionReceiptItemsSuccess(
          pendingSection: loadingMoreSnapshot,
          completedSection: state.completedSection,
          isHeadersLoading: state.isHeadersLoading,
          headers: state.headers,
          headersTotalRows: state.headersTotalRows,
        ),
      );

      final params = ProductionReceiptItemQueryParams(
        plant: event.params.plant,
        warehouseNumber: event.params.warehouseNumber,
        storageLocation: event.params.storageLocation,
        trNumber: event.params.trNumber,
        lastCount: event.params.lastCount,
        skipRecords: pendingState.skipRecords,
      );

      final result = await repository.listProductionReceiptItemsFromSAP(params);

      result.fold(
        (failure) {
          emit(
            ProductionReceiptItemsFailure(
              message: failure.message,
              pendingSection: loadingMoreSnapshot.copyWith(
                isLoadingMore: false,
                errorMessage: failure.message,
              ),
              completedSection: state.completedSection,
              isHeadersLoading: state.isHeadersLoading,
              headers: state.headers,
              headersTotalRows: state.headersTotalRows,
            ),
          );
        },
        (data) {
          final updatedItems = [...pendingState.items, ...data.items];
          emit(
            ProductionReceiptItemsSuccess(
              pendingSection: loadingMoreSnapshot.copyWith(
                items: updatedItems,
                totalRows: data.totalRows,
                skipRecords: updatedItems.length,
                isLoadingMore: false,
                errorMessage: null,
              ),
              completedSection: state.completedSection,
              isHeadersLoading: state.isHeadersLoading,
              headers: state.headers,
              headersTotalRows: state.headersTotalRows,
            ),
          );
        },
      );
    }
  }

  Future<void> _onLoadCompletedItems(
    LoadCompletedProductionReceiptItemsEvent event,
    Emitter<ProductionReceiptState> emit,
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
        ProductionReceiptItemsLoading(
          pendingSection: state.pendingSection,
          completedSection: completedSnapshot,
          isHeadersLoading: state.isHeadersLoading,
          headers: state.headers,
          headersTotalRows: state.headersTotalRows,
        ),
      );

      final params = ProductionReceiptItemQueryParams(
        plant: event.params.plant,
        warehouseNumber: event.params.warehouseNumber,
        storageLocation: event.params.storageLocation,
        trNumber: event.params.trNumber,
        lastCount: event.params.lastCount,
        skipRecords: 0,
      );

      final result =
          await repository.listCompletedProductionReceiptItems(params);

      result.fold(
        (failure) {
          emit(
            ProductionReceiptItemsFailure(
              message: failure.message,
              pendingSection: state.pendingSection,
              completedSection: completedSnapshot.copyWith(
                isLoading: false,
                errorMessage: failure.message,
              ),
              isHeadersLoading: state.isHeadersLoading,
              headers: state.headers,
              headersTotalRows: state.headersTotalRows,
            ),
          );
        },
        (data) {
          emit(
            ProductionReceiptItemsSuccess(
              pendingSection: state.pendingSection,
              completedSection: completedSnapshot.copyWith(
                isLoading: false,
                items: data.items,
                totalRows: data.totalRows,
                skipRecords: data.items.length,
                errorMessage: null,
              ),
              isHeadersLoading: state.isHeadersLoading,
              headers: state.headers,
              headersTotalRows: state.headersTotalRows,
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
        ProductionReceiptItemsSuccess(
          pendingSection: state.pendingSection,
          completedSection: loadingMoreSnapshot,
          isHeadersLoading: state.isHeadersLoading,
          headers: state.headers,
          headersTotalRows: state.headersTotalRows,
        ),
      );

      final params = ProductionReceiptItemQueryParams(
        plant: event.params.plant,
        warehouseNumber: event.params.warehouseNumber,
        storageLocation: event.params.storageLocation,
        trNumber: event.params.trNumber,
        requirementNumber: event.params.requirementNumber,
        lastCount: event.params.lastCount,
        skipRecords: completedState.skipRecords,
      );

      final result =
          await repository.listCompletedProductionReceiptItems(params);

      result.fold(
        (failure) {
          emit(
            ProductionReceiptItemsFailure(
              message: failure.message,
              pendingSection: state.pendingSection,
              completedSection: loadingMoreSnapshot.copyWith(
                isLoadingMore: false,
                errorMessage: failure.message,
              ),
              isHeadersLoading: state.isHeadersLoading,
              headers: state.headers,
              headersTotalRows: state.headersTotalRows,
            ),
          );
        },
        (data) {
          final updatedItems = [...completedState.items, ...data.items];
          emit(
            ProductionReceiptItemsSuccess(
              pendingSection: state.pendingSection,
              completedSection: loadingMoreSnapshot.copyWith(
                items: updatedItems,
                totalRows: data.totalRows,
                skipRecords: updatedItems.length,
                isLoadingMore: false,
                errorMessage: null,
              ),
              isHeadersLoading: state.isHeadersLoading,
              headers: state.headers,
              headersTotalRows: state.headersTotalRows,
            ),
          );
        },
      );
    }
  }

  Future<void> _onCreateProductionReceipt(
    CreateProductionReceiptEvent event,
    Emitter<ProductionReceiptState> emit,
  ) async {
    emit(
      ProductionReceiptItemsSuccess(
        pendingSection: state.pendingSection,
        completedSection: state.completedSection,
        isHeadersLoading: state.isHeadersLoading,
        headers: state.headers,
        headersTotalRows: state.headersTotalRows,
        isCreating: true,
        createError: null,
      ),
    );
    final result = await repository.createProductionReceipt(event.request);
    result.fold(
      (failure) {
        emit(
          ProductionReceiptItemsFailure(
            message: failure.message,
            pendingSection: state.pendingSection,
            completedSection: state.completedSection,
            isHeadersLoading: state.isHeadersLoading,
            headers: state.headers,
            headersTotalRows: state.headersTotalRows,
            isCreating: false,
            createError: failure.message,
          ),
        );
      },
      (response) {
        emit(
          ProductionReceiptItemsSuccess(
            pendingSection: state.pendingSection,
            completedSection: state.completedSection,
            isHeadersLoading: state.isHeadersLoading,
            headers: state.headers,
            headersTotalRows: state.headersTotalRows,
            isCreating: false,
            createResponse: response,
            createError: null,
          ),
        );
      },
    );
  }
}

