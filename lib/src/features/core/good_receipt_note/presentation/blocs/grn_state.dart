part of 'grn_bloc.dart';

abstract class GrnState extends Equatable {
  const GrnState();

  @override
  List<Object?> get props => [];
}

class GrnInitial extends GrnState {
  const GrnInitial();
}

class PendingGrnLoading extends GrnState {
  const PendingGrnLoading();
}

class PendingGrnSuccess extends GrnState {
  final List<GrnEntity> items;
  final int totalRows;
  final int skipRecords;
  final bool isLoadingMore;

  const PendingGrnSuccess({
    required this.items,
    required this.totalRows,
    required this.skipRecords,
    this.isLoadingMore = false,
  });

  bool get hasMore => items.length < totalRows;

  @override
  List<Object?> get props => [items, totalRows, skipRecords, isLoadingMore];
}

class PendingGrnFailure extends GrnState {
  final String message;

  const PendingGrnFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class GrnItemsLoading extends GrnState {
  const GrnItemsLoading();
}

class GrnItemsSuccess extends GrnState {
  final List<GrnItemEntity> items;
  final int totalRows;
  final int skipRecords;
  final bool isLoadingMore;

  const GrnItemsSuccess({
    required this.items,
    required this.totalRows,
    required this.skipRecords,
    this.isLoadingMore = false,
  });

  bool get hasMore => items.length < totalRows;

  @override
  List<Object?> get props => [items, totalRows, skipRecords, isLoadingMore];
}

class GrnItemsFailure extends GrnState {
  final String message;

  const GrnItemsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class CompletedGrnItemsLoading extends GrnState {
  const CompletedGrnItemsLoading();
}

class CompletedGrnItemsSuccess extends GrnState {
  final List<GrnItemEntity> items;
  final int totalRows;
  final int skipRecords;
  final bool isLoadingMore;

  const CompletedGrnItemsSuccess({
    required this.items,
    required this.totalRows,
    required this.skipRecords,
    this.isLoadingMore = false,
  });

  bool get hasMore => items.length < totalRows;

  @override
  List<Object?> get props => [items, totalRows, skipRecords, isLoadingMore];
}

class CompletedGrnItemsFailure extends GrnState {
  final String message;

  const CompletedGrnItemsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}