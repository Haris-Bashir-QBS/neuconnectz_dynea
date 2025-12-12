part of 'inbound_delivery_bloc.dart';

class InboundDeliveryItemsSectionState extends Equatable {
  final List<InboundDeliveryItemEntity> items;
  final int totalRows;
  final int skipRecords;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const InboundDeliveryItemsSectionState({
    this.items = const [],
    this.totalRows = 0,
    this.skipRecords = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get hasMore => items.length < totalRows;

  InboundDeliveryItemsSectionState copyWith({
    List<InboundDeliveryItemEntity>? items,
    int? totalRows,
    int? skipRecords,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return InboundDeliveryItemsSectionState(
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

abstract class InboundDeliveryState extends Equatable {
  final InboundDeliveryItemsSectionState pendingSection;
  final InboundDeliveryItemsSectionState completedSection;

  const InboundDeliveryState({
    this.pendingSection = const InboundDeliveryItemsSectionState(),
    this.completedSection = const InboundDeliveryItemsSectionState(),
  });

  List<Object?> get baseProps => [pendingSection, completedSection];

  @override
  List<Object?> get props => baseProps;
}

class InboundDeliveryInitial extends InboundDeliveryState {
  const InboundDeliveryInitial({
    super.pendingSection,
    super.completedSection,
  });
}

class InboundDeliveryHeaderListLoading extends InboundDeliveryState {
  const InboundDeliveryHeaderListLoading({
    super.pendingSection,
    super.completedSection,
  });
}

class InboundDeliveryHeaderListFetched extends InboundDeliveryState {
  final List<InboundDeliveryEntity> items;
  final int totalRows;
  final int skipRecords;
  final bool isLoadingMore;

  const InboundDeliveryHeaderListFetched({
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

class InboundDeliveryHeaderListFetchFailure extends InboundDeliveryState {
  final String message;

  const InboundDeliveryHeaderListFetchFailure({
    required this.message,
    super.pendingSection,
    super.completedSection,
  });

  @override
  List<Object?> get props => [...baseProps, message];
}

class InboundDeliveryItemsLoading extends InboundDeliveryState {
  const InboundDeliveryItemsLoading({
    super.pendingSection,
    super.completedSection,
  });
}

class InboundDeliveryItemsSuccess extends InboundDeliveryState {
  const InboundDeliveryItemsSuccess({
    super.pendingSection,
    super.completedSection,
  });
}

class InboundDeliveryItemsFailure extends InboundDeliveryState {
  final String message;

  const InboundDeliveryItemsFailure({
    required this.message,
    super.pendingSection,
    super.completedSection,
  });

  @override
  List<Object?> get props => [...baseProps, message];
}

class CompletedInboundDeliveryItemsLoading extends InboundDeliveryState {
  const CompletedInboundDeliveryItemsLoading({
    super.pendingSection,
    super.completedSection,
  });
}

class CompletedInboundDeliveryItemsSuccess extends InboundDeliveryState {
  const CompletedInboundDeliveryItemsSuccess({
    super.pendingSection,
    super.completedSection,
  });
}

class CompletedInboundDeliveryItemsFailure extends InboundDeliveryState {
  final String message;

  const CompletedInboundDeliveryItemsFailure({
    required this.message,
    super.pendingSection,
    super.completedSection,
  });

  @override
  List<Object?> get props => [...baseProps, message];
}



