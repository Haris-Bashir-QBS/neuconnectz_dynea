part of 'outbound_delivery_sto_item_bloc.dart';

abstract class OutboundDeliveryStoItemEvent extends Equatable {
  const OutboundDeliveryStoItemEvent();

  @override
  List<Object> get props => [];
}

class LoadStoItemsEvent extends OutboundDeliveryStoItemEvent {
  final OutboundDeliveryStoItemParams params;
  final bool refresh;

  const LoadStoItemsEvent({
    required this.params,
    this.refresh = false,
  });

  @override
  List<Object> get props => [params, refresh];
}

class LoadCompletedStoItemsEvent extends OutboundDeliveryStoItemEvent {
  final OutboundDeliveryStoItemParams params;
  final bool refresh;

  const LoadCompletedStoItemsEvent({
    required this.params,
    this.refresh = false,
  });

  @override
  List<Object> get props => [params, refresh];
}


