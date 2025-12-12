part of 'putaway_bloc.dart';

abstract class InboundDeliveryPutAwayState extends Equatable {
  const InboundDeliveryPutAwayState();

  @override
  List<Object?> get props => [];
}

class InboundDeliveryPutAwayInitial extends InboundDeliveryPutAwayState {}

class CreatePutAwayLoading extends InboundDeliveryPutAwayState {}

class CreatePutAwaySuccess extends InboundDeliveryPutAwayState {
  final ApiResponse<bool> response;

  const CreatePutAwaySuccess({required this.response});
}

class CreatePutAwayFailure extends InboundDeliveryPutAwayState {
  final String message;

  const CreatePutAwayFailure({required this.message});

  @override
  List<Object?> get props => [message];
}



