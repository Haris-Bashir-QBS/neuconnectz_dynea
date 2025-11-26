part of 'movement_type_bloc.dart';

abstract class MovementTypeState extends Equatable {
  const MovementTypeState();

  @override
  List<Object?> get props => [];
}

class MovementTypeInitial extends MovementTypeState {
  const MovementTypeInitial();
}

class MovementTypeLoading extends MovementTypeState {
  const MovementTypeLoading();
}

class MovementTypeSuccess extends MovementTypeState {
  final List<MovementTypeEntity> items;
  final int totalCount;

  const MovementTypeSuccess({
    required this.items,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [items, totalCount];
}

class MovementTypeFailure extends MovementTypeState {
  final String message;

  const MovementTypeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}


