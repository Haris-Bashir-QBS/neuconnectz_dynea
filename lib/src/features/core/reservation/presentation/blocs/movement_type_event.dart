part of 'movement_type_bloc.dart';

abstract class MovementTypeEvent extends Equatable {
  const MovementTypeEvent();

  @override
  List<Object?> get props => [];
}

class MovementTypeFetchEvent extends MovementTypeEvent {
  final String? keyword;

  const MovementTypeFetchEvent({this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class MovementTypeLoadMoreEvent extends MovementTypeEvent {
  const MovementTypeLoadMoreEvent();
}

