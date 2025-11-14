part of 'grn_bloc.dart';

class GrnEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPendingGrnEvent extends GrnEvent {
  final GrnListParams params;
  final bool refresh;

  LoadPendingGrnEvent({required this.params, this.refresh = false});

  @override
  List<Object?> get props => [params, refresh];
}

class LoadGrnItemsEvent extends GrnEvent {
  final GrnItemParams params;
  final bool refresh;

  LoadGrnItemsEvent({required this.params, this.refresh = false});

  @override
  List<Object?> get props => [params, refresh];
}
