part of 'putaway_bloc.dart';

abstract class InboundDeliveryPutAwayEvent extends Equatable {
  const InboundDeliveryPutAwayEvent();

  @override
  List<Object?> get props => [];
}

class CreatePutAwayAgainstInboundDeliveryEvent
    extends InboundDeliveryPutAwayEvent {
  final CreatePutAwayInboundStoRequestModel request;

  const CreatePutAwayAgainstInboundDeliveryEvent({required this.request});

  @override
  List<Object?> get props => [request];
}



