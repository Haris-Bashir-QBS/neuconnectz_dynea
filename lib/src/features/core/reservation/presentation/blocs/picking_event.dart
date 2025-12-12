part of 'picking_bloc.dart';

class PickingEvent extends Equatable {
  const PickingEvent();

  @override
  List<Object?> get props => [];
}

class CreatePickingEvent extends PickingEvent {
  final CreatePickingRequestModel request;

  const CreatePickingEvent({required this.request});

  @override
  List<Object?> get props => [request];
}



