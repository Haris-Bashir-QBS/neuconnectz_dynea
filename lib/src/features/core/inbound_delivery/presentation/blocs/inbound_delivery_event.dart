part of 'inbound_delivery_bloc.dart';

class InboundDeliveryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPendingInboundDeliveryEvent extends InboundDeliveryEvent {
  final InboundDeliveryListParams params;
  final bool refresh;

  LoadPendingInboundDeliveryEvent({required this.params, this.refresh = false});

  @override
  List<Object?> get props => [params, refresh];
}

class LoadInboundDeliveryItemsEvent extends InboundDeliveryEvent {
  final InboundDeliveryItemQueryParams params;
  final bool refresh;

  LoadInboundDeliveryItemsEvent({required this.params, this.refresh = false});

  @override
  List<Object?> get props => [params, refresh];
}

class LoadCompletedInboundDeliveryItemsEvent extends InboundDeliveryEvent {
  final InboundDeliveryItemQueryParams params;
  final bool refresh;

  LoadCompletedInboundDeliveryItemsEvent({
    required this.params,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [params, refresh];
}

class DeletePutawayAgainstInboundDeliveryStoEvent extends InboundDeliveryEvent {
  final int docNum;

  DeletePutawayAgainstInboundDeliveryStoEvent({required this.docNum});

  @override
  List<Object?> get props => [docNum];
}
