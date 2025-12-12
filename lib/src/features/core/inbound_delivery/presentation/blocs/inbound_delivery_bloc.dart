import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/params/inbound_delivery_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/params/inbound_delivery_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/repositories/inbound_delivery_repository.dart';

part 'inbound_delivery_event.dart';
part 'inbound_delivery_state.dart';

class InboundDeliveryBloc
    extends Bloc<InboundDeliveryEvent, InboundDeliveryState> {
  final InboundDeliveryRepository repository;

  InboundDeliveryBloc({required this.repository}) : super(InboundDeliveryInitial()) {
    on<LoadPendingInboundDeliveryEvent>(_onLoadPendingInboundDelivery);
    on<LoadInboundDeliveryItemsEvent>(_onLoadInboundDeliveryItems);
    on<LoadCompletedInboundDeliveryItemsEvent>(
      _onLoadCompletedInboundDeliveryItems,
    );
  }

  Future<void> _onLoadPendingInboundDelivery(
    LoadPendingInboundDeliveryEvent event,
    Emitter<InboundDeliveryState> emit,
  ) async {
    if (event.refresh) {
      emit(
        InboundDeliveryHeaderListLoading(
          pendingSection: state.pendingSection,
          completedSection: state.completedSection,
        ),
      );

      final params = InboundDeliveryListParams(
        plant: event.params.plant,
        storageLocation: event.params.storageLocation,
        lastCount: event.params.lastCount,
        skipRecords: 0,
        keyword: event.params.keyword,
      );

      final result = await repository.listAllInboundDeliveryFromSAP(params);

      result.fold(
        (failure) {
          emit(
            InboundDeliveryHeaderListFetchFailure(
              message: failure.message,
              pendingSection: state.pendingSection,
              completedSection: state.completedSection,
            ),
          );
        },
        (result) {
          emit(
            InboundDeliveryHeaderListFetched(
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
      final currentState = state;
      if (currentState is! InboundDeliveryHeaderListFetched) return;
      if (currentState.isLoadingMore || !currentState.hasMore) return;

      emit(
        InboundDeliveryHeaderListFetched(
          items: currentState.items,
          totalRows: currentState.totalRows,
          skipRecords: currentState.skipRecords,
          isLoadingMore: true,
          pendingSection: state.pendingSection,
          completedSection: state.completedSection,
        ),
      );

      final nextSkipRecords = currentState.skipRecords;
      final params = InboundDeliveryListParams(
        plant: event.params.plant,
        storageLocation: event.params.storageLocation,
        lastCount: event.params.lastCount,
        skipRecords: nextSkipRecords,
        keyword: event.params.keyword,
      );

      final result = await repository.listAllInboundDeliveryFromSAP(params);

      result.fold(
        (failure) {
          emit(
            InboundDeliveryHeaderListFetched(
              items: currentState.items,
              totalRows: currentState.totalRows,
              skipRecords: currentState.skipRecords,
              isLoadingMore: false,
              pendingSection: state.pendingSection,
              completedSection: state.completedSection,
            ),
          );
        },
        (newResult) {
          final updatedItems = [...currentState.items, ...newResult.items];
          emit(
            InboundDeliveryHeaderListFetched(
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

  Future<void> _onLoadInboundDeliveryItems(
    LoadInboundDeliveryItemsEvent event,
    Emitter<InboundDeliveryState> emit,
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
        InboundDeliveryItemsLoading(
          pendingSection: pendingSnapshot,
          completedSection: state.completedSection,
        ),
      );

      final params = InboundDeliveryItemQueryParams(
        plant: event.params.plant,
        storageLocation: event.params.storageLocation,
        outboundDeliveryNo: event.params.outboundDeliveryNo,
        stoNo: event.params.stoNo,
        lastCount: event.params.lastCount,
        skipRecords: 0,
      );

      final result = await repository.listAllInboundDeliveryItemsFromSAP(params);

      result.fold(
        (failure) {
          emit(
            InboundDeliveryItemsFailure(
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
            InboundDeliveryItemsSuccess(
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
        InboundDeliveryItemsSuccess(
          pendingSection: loadingMoreSnapshot,
          completedSection: state.completedSection,
        ),
      );

      final params = InboundDeliveryItemQueryParams(
        plant: event.params.plant,
        storageLocation: event.params.storageLocation,
        outboundDeliveryNo: event.params.outboundDeliveryNo,
        stoNo: event.params.stoNo,
        lastCount: event.params.lastCount,
        skipRecords: pendingState.skipRecords,
      );

      final result = await repository.listAllInboundDeliveryItemsFromSAP(params);

      result.fold(
        (failure) {
          emit(
            InboundDeliveryItemsFailure(
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
            InboundDeliveryItemsSuccess(
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

  Future<void> _onLoadCompletedInboundDeliveryItems(
    LoadCompletedInboundDeliveryItemsEvent event,
    Emitter<InboundDeliveryState> emit,
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
        CompletedInboundDeliveryItemsLoading(
          pendingSection: state.pendingSection,
          completedSection: completedSnapshot,
        ),
      );

      final params = InboundDeliveryItemQueryParams(
        plant: event.params.plant,
        storageLocation: event.params.storageLocation,
        outboundDeliveryNo: event.params.outboundDeliveryNo,
        stoNo: event.params.stoNo,
        lastCount: event.params.lastCount,
        skipRecords: 0,
      );

      final result = await repository.listCompletedInboundDeliveryItems(params);

      result.fold(
        (failure) {
          emit(
            CompletedInboundDeliveryItemsFailure(
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
            CompletedInboundDeliveryItemsSuccess(
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
        CompletedInboundDeliveryItemsSuccess(
          pendingSection: state.pendingSection,
          completedSection: loadingMoreSnapshot,
        ),
      );

      final params = InboundDeliveryItemQueryParams(
        plant: event.params.plant,
        storageLocation: event.params.storageLocation,
        outboundDeliveryNo: event.params.outboundDeliveryNo,
        stoNo: event.params.stoNo,
        lastCount: event.params.lastCount,
        skipRecords: completedState.skipRecords,
      );

      final result = await repository.listCompletedInboundDeliveryItems(params);

      result.fold(
        (failure) {
          emit(
            CompletedInboundDeliveryItemsFailure(
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
            CompletedInboundDeliveryItemsSuccess(
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


