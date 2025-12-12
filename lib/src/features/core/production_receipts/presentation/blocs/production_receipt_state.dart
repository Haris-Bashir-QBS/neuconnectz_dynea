part of 'production_receipt_bloc.dart';

class ProductionReceiptState extends Equatable {
  final bool isHeadersLoading;
  final bool isItemsLoading;
  final bool isLoadingMore;
  final List<ProductionReceiptEntity> headers;
  final List<ProductionReceiptItemEntity> items;
  final int headersTotalRows;
  final int itemsTotalRows;
  final String? headersError;
  final String? itemsError;

  const ProductionReceiptState({
    required this.isHeadersLoading,
    required this.isItemsLoading,
    this.isLoadingMore = false,
    required this.headers,
    required this.items,
    required this.headersTotalRows,
    required this.itemsTotalRows,
    this.headersError,
    this.itemsError,
  });

  const ProductionReceiptState.initial()
      : isHeadersLoading = false,
        isItemsLoading = false,
        isLoadingMore = false,
        headers = const [],
        items = const [],
        headersTotalRows = 0,
        itemsTotalRows = 0,
        headersError = null,
        itemsError = null;

  ProductionReceiptState copyWith({
    bool? isHeadersLoading,
    bool? isItemsLoading,
    bool? isLoadingMore,
    List<ProductionReceiptEntity>? headers,
    List<ProductionReceiptItemEntity>? items,
    int? headersTotalRows,
    int? itemsTotalRows,
    String? headersError,
    String? itemsError,
  }) {
    return ProductionReceiptState(
      isHeadersLoading: isHeadersLoading ?? this.isHeadersLoading,
      isItemsLoading: isItemsLoading ?? this.isItemsLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      headers: headers ?? this.headers,
      items: items ?? this.items,
      headersTotalRows: headersTotalRows ?? this.headersTotalRows,
      itemsTotalRows: itemsTotalRows ?? this.itemsTotalRows,
      headersError: headersError,
      itemsError: itemsError,
    );
  }

  bool get hasMore => headers.length < headersTotalRows;

  @override
  List<Object?> get props => [
        isHeadersLoading,
        isItemsLoading,
        isLoadingMore,
        headers,
        items,
        headersTotalRows,
        itemsTotalRows,
        headersError,
        itemsError,
      ];
}

