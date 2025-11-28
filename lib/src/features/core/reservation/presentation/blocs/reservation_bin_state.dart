part of 'reservation_bin_bloc.dart';

class ReservationBinState extends Equatable {
  const ReservationBinState();

  @override
  List<Object?> get props => [];
}

class ReservationBinInitial extends ReservationBinState {}

class ReservationBinLoading extends ReservationBinState {}

class ReservationBinSuccess extends ReservationBinState {
  final List<BinEntity> bins;
  final Map<String, double> proposedQuantities; // binId -> proposedQuantity

  const ReservationBinSuccess({
    required this.bins,
    required this.proposedQuantities,
  });

  @override
  List<Object?> get props => [bins, proposedQuantities];
}

class ReservationBinFailure extends ReservationBinState {
  final String message;

  const ReservationBinFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

