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

  const OutboundDeliveryStoItemState({
    this.pendingSection = const StoItemsSectionState(),
    this.completedSection = const StoItemsSectionState(),
  });

  OutboundDeliveryStoItemState copyWith({
    StoItemsSectionState? pendingSection,
    StoItemsSectionState? completedSection,
  }) {
    return OutboundDeliveryStoItemState(
      pendingSection: pendingSection ?? this.pendingSection,
      completedSection: completedSection ?? this.completedSection,
    );
  }

  @override
  List<Object?> get props => [pendingSection, completedSection];
}
