part of 'movement_type_bloc.dart';

abstract class MovementTypeEvent extends Equatable {
  const MovementTypeEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovementTypesEvent extends MovementTypeEvent {
  final String? keyword;
  final int lastCount;

  const LoadMovementTypesEvent({
    this.keyword,
    this.lastCount = 50,
  });

  @override
  List<Object?> get props => [keyword, lastCount];
}


