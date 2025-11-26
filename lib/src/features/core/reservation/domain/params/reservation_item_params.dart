import 'package:equatable/equatable.dart';

class ReservationItemParams extends Equatable {
  final String reservationNo;
  final int lastCount;
  final int skipRecords;

  const ReservationItemParams({
    required this.reservationNo,
    this.lastCount = 10,
    this.skipRecords = 0,
  });

  ReservationItemParams copyWith({
    String? reservationNo,
    int? lastCount,
    int? skipRecords,
  }) {
    return ReservationItemParams(
      reservationNo: reservationNo ?? this.reservationNo,
      lastCount: lastCount ?? this.lastCount,
      skipRecords: skipRecords ?? this.skipRecords,
    );
  }

  @override
  List<Object?> get props => [reservationNo, lastCount, skipRecords];
}

