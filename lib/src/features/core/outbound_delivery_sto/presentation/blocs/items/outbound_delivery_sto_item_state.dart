part of 'outbound_delivery_sto_item_bloc.dart';

class StoItemsSectionState extends Equatable {
  final List<OutboundDeliveryStoItemEntity> items;
  final int totalRows;
  final int skipRecords;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const StoItemsSectionState({
    this.items = const [],
    this.totalRows = 0,
    this.skipRecords = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get hasMore => items.length < totalRows;

  StoItemsSectionState copyWith({
    List<OutboundDeliveryStoItemEntity>? items,
    int? totalRows,
    int? skipRecords,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return StoItemsSectionState(
      items: items ?? this.items,
      totalRows: totalRows ?? this.totalRows,
      skipRecords: skipRecords ?? this.skipRecords,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        items,
        totalRows,
        skipRecords,
        isLoading,
        isLoadingMore,
        errorMessage,
      ];
}

class OutboundDeliveryStoItemState extends Equatable {
  final StoItemsSectionState pendingSection;
  final StoItemsSectionState completedSection;
  final bool isDeleting;
  final String? deleteError;
  final ApiResponse<bool>? deleteResponse;

  const OutboundDeliveryStoItemState({
    this.pendingSection = const StoItemsSectionState(),
    this.completedSection = const StoItemsSectionState(),
    this.isDeleting = false,
    this.deleteError,
    this.deleteResponse,
  });

  OutboundDeliveryStoItemState copyWith({
    StoItemsSectionState? pendingSection,
    StoItemsSectionState? completedSection,
    bool? isDeleting,
    String? deleteError,
    bool clearDeleteError = false,
    ApiResponse<bool>? deleteResponse,
  }) {
    return OutboundDeliveryStoItemState(
      pendingSection: pendingSection ?? this.pendingSection,
      completedSection: completedSection ?? this.completedSection,
      isDeleting: isDeleting ?? this.isDeleting,
      deleteError: clearDeleteError ? null : (deleteError ?? this.deleteError),
      deleteResponse: deleteResponse ?? this.deleteResponse,
    );
  }

  @override
  List<Object?> get props => [
        pendingSection,
        completedSection,
        isDeleting,
        deleteError,
        deleteResponse,
      ];
}


