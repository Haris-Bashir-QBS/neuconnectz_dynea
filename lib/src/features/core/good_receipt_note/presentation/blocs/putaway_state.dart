part of 'putaway_bloc.dart';

abstract class PutAwayState extends Equatable {
  const PutAwayState();

  @override
  List<Object?> get props => [];
}

class PutAwayInitial extends PutAwayState {}

class CreatePutAwayLoading extends PutAwayState {}

class CreatePutAwaySuccess extends PutAwayState {}

class CreatePutAwayFailure extends PutAwayState {
  final String message;

  const CreatePutAwayFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

