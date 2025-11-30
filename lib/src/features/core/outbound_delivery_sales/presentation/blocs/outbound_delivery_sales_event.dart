part of 'outbound_delivery_sales_bloc.dart';

abstract class OutboundDeliverySalesEvent extends Equatable {
  const OutboundDeliverySalesEvent();

  @override
  List<Object?> get props => [];
}

class LoadOutboundDeliverySalesListEvent extends OutboundDeliverySalesEvent {
  final OutboundDeliverySalesListParams params;
  final bool refresh;

  const LoadOutboundDeliverySalesListEvent({
    required this.params,
    this.refresh = true,
  });

  @override
  List<Object?> get props => [params, refresh];
}

class LoadOutboundDeliverySalesItemsEvent extends OutboundDeliverySalesEvent {
  final OutboundDeliverySalesItemParams params;
  final bool refresh;

  const LoadOutboundDeliverySalesItemsEvent({
    required this.params,
    this.refresh = true,
  });

  @override
  List<Object?> get props => [params, refresh];
}

class LoadCompletedOutboundDeliverySalesItemsEvent
    extends OutboundDeliverySalesEvent {
  final OutboundDeliverySalesItemParams params;
  final bool refresh;

  const LoadCompletedOutboundDeliverySalesItemsEvent({
    required this.params,
    this.refresh = true,
  });

  @override
  List<Object?> get props => [params, refresh];
}

