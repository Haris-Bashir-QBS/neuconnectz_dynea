part of 'reservation_bloc.dart';

abstract class ReservationEvent extends Equatable {
  const ReservationEvent();

  @override
  List<Object?> get props => [];
}

class LoadReservationListEvent extends ReservationEvent {
  final ReservationListParams params;
  final bool refresh;

  const LoadReservationListEvent({
    required this.params,
    this.refresh = true,
  });

  @override
  List<Object?> get props => [params, refresh];
}

class LoadReservationItemsEvent extends ReservationEvent {
  final ReservationItemParams params;
  final bool refresh;

  const LoadReservationItemsEvent({
    required this.params,
    this.refresh = true,
  });

  @override
  List<Object?> get props => [params, refresh];
}

class LoadCompletedReservationItemsEvent extends ReservationEvent {
  final ReservationItemParams params;
  final bool refresh;

  const LoadCompletedReservationItemsEvent({
    required this.params,
    this.refresh = true,
  });

  @override
  List<Object?> get props => [params, refresh];
}

class DeleteReservationEvent extends ReservationEvent {
  final int docNum;

  const DeleteReservationEvent({required this.docNum});

  @override
  List<Object?> get props => [docNum];
}




