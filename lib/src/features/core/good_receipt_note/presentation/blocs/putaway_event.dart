part of 'putaway_bloc.dart';

abstract class PutAwayEvent extends Equatable {
  const PutAwayEvent();

  @override
  List<Object?> get props => [];
}

class CreatePutAwayAgainstGrEvent extends PutAwayEvent {
  final CreatePutAwayRequestModel request;

  const CreatePutAwayAgainstGrEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

