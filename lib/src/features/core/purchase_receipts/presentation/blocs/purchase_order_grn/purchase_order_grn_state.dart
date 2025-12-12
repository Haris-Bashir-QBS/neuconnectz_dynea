part of 'purchase_order_grn_bloc.dart';

class PurchaseOrderGrnItemsSectionState extends Equatable {
  final List<PurchaseOrderGrnItemEntity> items;
  final int totalRows;
  final int skipRecords;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const PurchaseOrderGrnItemsSectionState({
    this.items = const [],
    this.totalRows = 0,
    this.skipRecords = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get hasMore => items.length < totalRows;

  PurchaseOrderGrnItemsSectionState copyWith({
    List<PurchaseOrderGrnItemEntity>? items,
    int? totalRows,
    int? skipRecords,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return PurchaseOrderGrnItemsSectionState(
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

abstract class PurchaseOrderGrnState extends Equatable {
  final PurchaseOrderGrnItemsSectionState pendingSection;
  final PurchaseOrderGrnItemsSectionState completedSection;

  const PurchaseOrderGrnState({
    this.pendingSection = const PurchaseOrderGrnItemsSectionState(),
    this.completedSection = const PurchaseOrderGrnItemsSectionState(),
  });

  List<Object?> get baseProps => [pendingSection, completedSection];

  @override
  List<Object?> get props => baseProps;
}

class PurchaseOrderGrnInitial extends PurchaseOrderGrnState {
  const PurchaseOrderGrnInitial({super.pendingSection, super.completedSection});
}

class PurchaseOrderGrnHeaderListLoading extends PurchaseOrderGrnState {
  const PurchaseOrderGrnHeaderListLoading({
    super.pendingSection,
    super.completedSection,
  });
}

class PurchaseOrderGrnHeaderListFetched extends PurchaseOrderGrnState {
  final List<PurchaseOrderGrnEntity> items;
  final int totalRows;
  final int skipRecords;
  final bool isLoadingMore;

  const PurchaseOrderGrnHeaderListFetched({
    required this.items,
    required this.totalRows,
    required this.skipRecords,
    this.isLoadingMore = false,
    super.pendingSection,
    super.completedSection,
  });

  bool get hasMore => items.length < totalRows;

  @override
  List<Object?> get props => [
    ...baseProps,
    items,
    totalRows,
    skipRecords,
    isLoadingMore,
  ];
}

class PurchaseOrderGrnHeaderListFetchFailure extends PurchaseOrderGrnState {
  final String message;

  const PurchaseOrderGrnHeaderListFetchFailure({
    required this.message,
    super.pendingSection,
    super.completedSection,
  });

  @override
  List<Object?> get props => [...baseProps, message];
}

class PurchaseOrderGrnItemsLoading extends PurchaseOrderGrnState {
  const PurchaseOrderGrnItemsLoading({
    super.pendingSection,
    super.completedSection,
  });
}

class PurchaseOrderGrnItemsSuccess extends PurchaseOrderGrnState {
  const PurchaseOrderGrnItemsSuccess({
    super.pendingSection,
    super.completedSection,
  });
}

class PurchaseOrderGrnItemsFailure extends PurchaseOrderGrnState {
  final String message;

  const PurchaseOrderGrnItemsFailure({
    required this.message,
    super.pendingSection,
    super.completedSection,
  });

  @override
  List<Object?> get props => [...baseProps, message];
}

class PurchaseOrderCompletedGrnItemsLoading extends PurchaseOrderGrnState {
  const PurchaseOrderCompletedGrnItemsLoading({
    super.pendingSection,
    super.completedSection,
  });
}

class PurchaseOrderCompletedGrnItemsSuccess extends PurchaseOrderGrnState {
  const PurchaseOrderCompletedGrnItemsSuccess({
    super.pendingSection,
    super.completedSection,
  });
}

class PurchaseOrderCompletedGrnItemsFailure extends PurchaseOrderGrnState {
  final String message;

  const PurchaseOrderCompletedGrnItemsFailure({
    required this.message,
    super.pendingSection,
    super.completedSection,
  });

  @override
  List<Object?> get props => [...baseProps, message];
}
