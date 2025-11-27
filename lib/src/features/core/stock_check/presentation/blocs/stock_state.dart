part of 'stock_bloc.dart';

class StockState extends Equatable {
  final List<StockEntity> items;
  final int totalCount;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final StockQueryParams params;

  const StockState({
    required this.items,
    required this.totalCount,
    required this.isLoading,
    required this.isLoadingMore,
    required this.errorMessage,
    required this.params,
  });

  factory StockState.initial() => StockState(
        items: const [],
        totalCount: 0,
        isLoading: false,
        isLoadingMore: false,
        errorMessage: null,
        params: const StockQueryParams(plant: '', warehouseNumber: ''),
      );

  bool get hasMore => items.length < totalCount;

  StockState copyWith({
    List<StockEntity>? items,
    int? totalCount,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
    StockQueryParams? params,
  }) {
    return StockState(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      params: params ?? this.params,
    );
  }

  @override
  List<Object?> get props => [
        items,
        totalCount,
        isLoading,
        isLoadingMore,
        errorMessage,
        params,
      ];
}

