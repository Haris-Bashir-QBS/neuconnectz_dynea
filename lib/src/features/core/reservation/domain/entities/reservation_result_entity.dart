import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_entity.dart';

class ReservationResultEntity extends Equatable {
  final int totalCount;
  final List<ReservationEntity> data;

  const ReservationResultEntity({
    required this.totalCount,
    required this.data,
  });

  @override
  List<Object?> get props => [totalCount, data];
}



