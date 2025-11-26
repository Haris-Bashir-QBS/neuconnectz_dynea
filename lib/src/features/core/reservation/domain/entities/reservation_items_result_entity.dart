import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_item_entity.dart';

class ReservationItemsResultEntity extends Equatable {
  final int totalCount;
  final List<ReservationItemEntity> data;

  const ReservationItemsResultEntity({
    required this.totalCount,
    required this.data,
  });

  @override
  List<Object?> get props => [totalCount, data];
}

