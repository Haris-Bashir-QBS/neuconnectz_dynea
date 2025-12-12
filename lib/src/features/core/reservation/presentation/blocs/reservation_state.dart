part of 'reservation_bloc.dart';

class ReservationState extends Equatable {
  // Reservation list (header) state
  final bool listLoading;
  final bool listIsLoadingMore;
  final List<ReservationEntity> listItems;
  final int listTotalRows;
  final int listSkipRecords;
  final String? listError;

  // Pending reservation items
  final bool pendingLoading;
  final bool pendingIsLoadingMore;
  final List<ReservationItemEntity> pendingItems;
  final int pendingTotalRows;
  final int pendingSkipRecords;
  final String? pendingError;

  // Completed reservation items
  final bool completedLoading;
  final bool completedIsLoadingMore;
  final List<ReservationItemEntity> completedItems;
  final int completedTotalRows;
  final int completedSkipRecords;
  final String? completedError;

  // Delete reservation state
  final bool isDeleting;
  final String? deleteError;
  final ApiResponse<bool>? deleteResponse;

  const ReservationState({
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
    this.isDeleting = false,
    this.deleteError,
    this.deleteResponse,
  });

  bool get listHasMore => listItems.length < listTotalRows;
  bool get pendingHasMore => pendingItems.length < pendingTotalRows;
  bool get completedHasMore => completedItems.length < completedTotalRows;

  ReservationState copyWith({
    bool? listLoading,
    bool? listIsLoadingMore,
    List<ReservationEntity>? listItems,
    int? listTotalRows,
    int? listSkipRecords,
    String? listError,
    bool clearListError = false,
    bool? pendingLoading,
    bool? pendingIsLoadingMore,
    List<ReservationItemEntity>? pendingItems,
    int? pendingTotalRows,
    int? pendingSkipRecords,
    String? pendingError,
    bool clearPendingError = false,
    bool? completedLoading,
    bool? completedIsLoadingMore,
    List<ReservationItemEntity>? completedItems,
    int? completedTotalRows,
    int? completedSkipRecords,
    String? completedError,
    bool clearCompletedError = false,
    bool? isDeleting,
    String? deleteError,
    bool clearDeleteError = false,
    ApiResponse<bool>? deleteResponse,
  }) {
    return ReservationState(
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
      completedSkipRecords:
          completedSkipRecords ?? this.completedSkipRecords,
      completedError:
          clearCompletedError ? null : (completedError ?? this.completedError),
      isDeleting: isDeleting ?? this.isDeleting,
      deleteError: clearDeleteError ? null : (deleteError ?? this.deleteError),
      deleteResponse: deleteResponse ?? this.deleteResponse,
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
        isDeleting,
        deleteError,
        deleteResponse,
      ];
}




