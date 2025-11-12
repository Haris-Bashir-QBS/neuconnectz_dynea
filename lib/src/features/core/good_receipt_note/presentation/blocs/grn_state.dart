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
  final List<GrnListItemEntity> items;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const PendingGrnSuccess({
    required this.items,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [items, currentPage, hasMore, isLoadingMore];
}

class PendingGrnFailure extends GrnState {
  final String message;

  const PendingGrnFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

