part of 'grn_bloc.dart';

class GrnItemsSectionState extends Equatable {
  final List<GrnItemEntity> items;
  final int totalRows;
  final int skipRecords;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const GrnItemsSectionState({
    this.items = const [],
    this.totalRows = 0,
    this.skipRecords = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get hasMore => items.length < totalRows;

  GrnItemsSectionState copyWith({
    List<GrnItemEntity>? items,
    int? totalRows,
    int? skipRecords,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return GrnItemsSectionState(
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

abstract class GrnState extends Equatable {
  final GrnItemsSectionState pendingSection;
  final GrnItemsSectionState completedSection;

  const GrnState({
    this.pendingSection = const GrnItemsSectionState(),
    this.completedSection = const GrnItemsSectionState(),
  });

  List<Object?> get baseProps => [pendingSection, completedSection];

  @override
  List<Object?> get props => baseProps;
}

class GrnInitial extends GrnState {
  const GrnInitial({super.pendingSection, super.completedSection});
}

class GrnHeaderListLoading extends GrnState {
  const GrnHeaderListLoading({super.pendingSection, super.completedSection});
}

class GrnHeaderListFetched extends GrnState {
  final List<GrnEntity> items;
  final int totalRows;
  final int skipRecords;
  final bool isLoadingMore;

  const GrnHeaderListFetched({
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

class GrnHeaderListFetchFailure extends GrnState {
  final String message;

  const GrnHeaderListFetchFailure({
    required this.message,
    super.pendingSection,
    super.completedSection,
  });

  @override
  List<Object?> get props => [...baseProps, message];
}

class GrnItemsLoading extends GrnState {
  const GrnItemsLoading({super.pendingSection, super.completedSection});
}

class GrnItemsSuccess extends GrnState {
  const GrnItemsSuccess({super.pendingSection, super.completedSection});
}

class GrnItemsFailure extends GrnState {
  final String message;

  const GrnItemsFailure({
    required this.message,
    super.pendingSection,
    super.completedSection,
  });

  @override
  List<Object?> get props => [...baseProps, message];
}

class CompletedGrnItemsLoading extends GrnState {
  const CompletedGrnItemsLoading({
    super.pendingSection,
    super.completedSection,
  });
}

class CompletedGrnItemsSuccess extends GrnState {
  const CompletedGrnItemsSuccess({
    super.pendingSection,
    super.completedSection,
  });
}

class CompletedGrnItemsFailure extends GrnState {
  final String message;

  const CompletedGrnItemsFailure({
    required this.message,
    super.pendingSection,
    super.completedSection,
  });

  @override
  List<Object?> get props => [...baseProps, message];
}
