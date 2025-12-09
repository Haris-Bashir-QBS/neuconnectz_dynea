part of 'source_bin_material_listing_bloc.dart';

abstract class SourceBinMaterialListingState extends Equatable {
  const SourceBinMaterialListingState();
}

class SourceBinMaterialListingInitial extends SourceBinMaterialListingState {
  @override
  List<Object?> get props => [];
}

class SourceBinMaterialListingLoading extends SourceBinMaterialListingState {
  @override
  List<Object?> get props => [];
}

class SourceBinMaterialListingSuccess extends SourceBinMaterialListingState {
  final List<StockEntity> items;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const SourceBinMaterialListingSuccess({
    required this.items,
    required this.totalCount,
    required this.hasMore,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  SourceBinMaterialListingSuccess copyWith({
    List<StockEntity>? items,
    int? totalCount,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return SourceBinMaterialListingSuccess(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    items,
    totalCount,
    hasMore,
    isLoadingMore,
    errorMessage,
  ];
}

class SourceBinMaterialListingFailure extends SourceBinMaterialListingState {
  final String message;

  const SourceBinMaterialListingFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
