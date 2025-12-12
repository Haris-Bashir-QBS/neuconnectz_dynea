import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/stocks_by_storage_bin_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/usecases/get_stocks_by_storage_bin_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_entity.dart';

part 'source_bin_material_listing_event.dart';
part 'source_bin_material_listing_state.dart';

class SourceBinMaterialListingBloc
    extends Bloc<SourceBinMaterialListingEvent, SourceBinMaterialListingState> {
  SourceBinMaterialListingBloc({required this.useCase})
      : super(SourceBinMaterialListingInitial()) {
    on<LoadSourceBinMaterialsEvent>(_onLoadMaterials);
    on<LoadMoreSourceBinMaterialsEvent>(_onLoadMore);
  }

  final GetStocksByStorageBinUseCase useCase;
  final int _pageSize = 20;
  int _skipRecords = 0;
  List<StockEntity> _allLoadedItems = [];
  int _totalCount = 0;

  Future<void> _onLoadMaterials(
    LoadSourceBinMaterialsEvent event,
    Emitter<SourceBinMaterialListingState> emit,
  ) async {
    _skipRecords = 0;
    _allLoadedItems = [];

    emit(SourceBinMaterialListingLoading());

    final params = StocksByStorageBinParams(
      plant: event.plant,
      whsCode: event.whsCode,
      storageLocation: event.storageLocation,
      material: '', 
      storageBin: event.storageBin,
      storageType: event.storageType,
      storageSection: event.storageSection,
      keyword: event.searchQuery,
      lastCount: event.loadAll ? null : _pageSize,
      skipRecords: event.loadAll ? null : _skipRecords,
    );

    final result = await useCase(params);

    result.fold(
      (failure) => emit(
        SourceBinMaterialListingFailure(message: failure.message),
      ),
      (data) {
        _allLoadedItems = data.items;
        _totalCount = data.totalCount;
        _skipRecords = data.items.length;
        
        emit(
          SourceBinMaterialListingSuccess(
            items: _allLoadedItems,
            totalCount: _totalCount,
            hasMore: _allLoadedItems.length < _totalCount,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMore(
    LoadMoreSourceBinMaterialsEvent event,
    Emitter<SourceBinMaterialListingState> emit,
  ) async {
    if (state is! SourceBinMaterialListingSuccess) return;
    final currentState = state as SourceBinMaterialListingSuccess;
    if (currentState.isLoadingMore || !currentState.hasMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final params = StocksByStorageBinParams(
      plant: event.plant,
      whsCode: event.whsCode,
      storageLocation: event.storageLocation,
      material: '', 
      storageBin: event.storageBin,
      storageType: event.storageType,
      storageSection: event.storageSection,
      keyword: event.searchQuery,
      lastCount: _pageSize,
      skipRecords: _skipRecords,
    );

    final result = await useCase(params);

    result.fold(
      (failure) => emit(
        currentState.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        ),
      ),
      (data) {
        _allLoadedItems = [..._allLoadedItems, ...data.items];
        _skipRecords = _allLoadedItems.length;
        
        emit(
          currentState.copyWith(
            items: _allLoadedItems,
            isLoadingMore: false,
            hasMore: _allLoadedItems.length < _totalCount,
          ),
        );
      },
    );
  }
}

