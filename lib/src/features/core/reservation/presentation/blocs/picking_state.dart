part of 'picking_bloc.dart';

class PickingState extends Equatable {
  const PickingState();

  @override
  List<Object?> get props => [];
}

class PickingInitial extends PickingState {}

class CreatePickingLoading extends PickingState {}

class CreatePickingSuccess extends PickingState {
  final ApiResponse<bool> response;

  const CreatePickingSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class CreatePickingFailure extends PickingState {
  final String message;

  const CreatePickingFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

