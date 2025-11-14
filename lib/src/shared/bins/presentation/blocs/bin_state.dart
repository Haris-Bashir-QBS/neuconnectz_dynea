part of 'bin_bloc.dart';

abstract class BinState extends Equatable {
  const BinState();

  @override
  List<Object?> get props => [];
}

class BinInitial extends BinState {}

class BinLoading extends BinState {}

class BinSuccess extends BinState {
  final List<BinEntity> bins;

  const BinSuccess({required this.bins});

  @override
  List<Object?> get props => [bins];
}

class BinFailure extends BinState {
  final String message;

  const BinFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

