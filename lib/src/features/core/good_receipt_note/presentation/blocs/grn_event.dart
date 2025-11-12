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
