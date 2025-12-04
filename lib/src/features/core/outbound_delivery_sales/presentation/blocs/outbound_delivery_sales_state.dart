part of 'outbound_delivery_sales_bloc.dart';

class OutboundDeliverySalesState extends Equatable {
  // Sales order list (header) state
  final bool listLoading;
  final bool listIsLoadingMore;
  final List<OutboundDeliverySalesEntity> listItems;
  final int listTotalRows;
  final int listSkipRecords;
  final String? listError;

  // Pending sales order items
  final bool pendingLoading;
  final bool pendingIsLoadingMore;
  final List<OutboundDeliverySalesItemEntity> pendingItems;
  final int pendingTotalRows;
  final int pendingSkipRecords;
  final String? pendingError;

  // Completed sales order items
  final bool completedLoading;
  final bool completedIsLoadingMore;
  final List<OutboundDeliverySalesItemEntity> completedItems;
  final int completedTotalRows;
  final int completedSkipRecords;
  final String? completedError;

  final OperationState<ApiResponse<bool>> createSalesOrder;
  final OperationState<ApiResponse<bool>> syncStocks;

  const OutboundDeliverySalesState({
    this.listLoading = false,
    this.listIsLoadingMore = false,
    this.listItems = const [],
    this.listTotalRows = 0,
    this.listSkipRecords = 0,
    this.listError,
    this.pendingLoading = false,
    this.pendingIsLoadingMore = false,
    this.pendingItems = const [],
    this.pendingTotalRows = 0,
    this.pendingSkipRecords = 0,
    this.pendingError,
    this.completedLoading = false,
    this.completedIsLoadingMore = false,
    this.completedItems = const [],
    this.completedTotalRows = 0,
    this.completedSkipRecords = 0,
    this.completedError,
    this.createSalesOrder = const OperationState(),
    this.syncStocks = const OperationState(),
  });

  bool get listHasMore => listItems.length < listTotalRows;
  bool get pendingHasMore => pendingItems.length < pendingTotalRows;
  bool get completedHasMore => completedItems.length < completedTotalRows;

  OutboundDeliverySalesState copyWith({
    bool? listLoading,
    bool? listIsLoadingMore,
    List<OutboundDeliverySalesEntity>? listItems,
    int? listTotalRows,
    int? listSkipRecords,
    String? listError,
    bool clearListError = false,
    bool? pendingLoading,
    bool? pendingIsLoadingMore,
    List<OutboundDeliverySalesItemEntity>? pendingItems,
    int? pendingTotalRows,
    int? pendingSkipRecords,
    String? pendingError,
    bool clearPendingError = false,
    bool? completedLoading,
    bool? completedIsLoadingMore,
    List<OutboundDeliverySalesItemEntity>? completedItems,
    int? completedTotalRows,
    int? completedSkipRecords,
    String? completedError,
    bool clearCompletedError = false,
    OperationState<ApiResponse<bool>>? createSalesOrder,
    OperationState<ApiResponse<bool>>? syncStocks,
  }) {
    return OutboundDeliverySalesState(
      listLoading: listLoading ?? this.listLoading,
      listIsLoadingMore: listIsLoadingMore ?? this.listIsLoadingMore,
      listItems: listItems ?? this.listItems,
      listTotalRows: listTotalRows ?? this.listTotalRows,
      listSkipRecords: listSkipRecords ?? this.listSkipRecords,
      listError: clearListError ? null : (listError ?? this.listError),
      pendingLoading: pendingLoading ?? this.pendingLoading,
      pendingIsLoadingMore: pendingIsLoadingMore ?? this.pendingIsLoadingMore,
      pendingItems: pendingItems ?? this.pendingItems,
      pendingTotalRows: pendingTotalRows ?? this.pendingTotalRows,
      pendingSkipRecords: pendingSkipRecords ?? this.pendingSkipRecords,
      pendingError:
          clearPendingError ? null : (pendingError ?? this.pendingError),
      completedLoading: completedLoading ?? this.completedLoading,
      completedIsLoadingMore:
          completedIsLoadingMore ?? this.completedIsLoadingMore,
      completedItems: completedItems ?? this.completedItems,
      completedTotalRows: completedTotalRows ?? this.completedTotalRows,
      completedSkipRecords: completedSkipRecords ?? this.completedSkipRecords,
      completedError:
          clearCompletedError ? null : (completedError ?? this.completedError),
      createSalesOrder: createSalesOrder ?? this.createSalesOrder,
      syncStocks: syncStocks ?? this.syncStocks,
    );
  }

  @override
  List<Object?> get props => [
    listLoading,
    listIsLoadingMore,
    listItems,
    listTotalRows,
    listSkipRecords,
    listError,
    pendingLoading,
    pendingIsLoadingMore,
    pendingItems,
    pendingTotalRows,
    pendingSkipRecords,
    pendingError,
    completedLoading,
    completedIsLoadingMore,
    completedItems,
    completedTotalRows,
    completedSkipRecords,
    completedError,
    createSalesOrder,
    syncStocks,
  ];
}
