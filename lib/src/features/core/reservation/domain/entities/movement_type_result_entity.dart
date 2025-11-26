import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/movement_type_entity.dart';

class MovementTypeResultEntity extends Equatable {
  final int totalCount;
  final List<MovementTypeEntity> items;

  const MovementTypeResultEntity({
    required this.totalCount,
    required this.items,
  });

  @override
  List<Object?> get props => [totalCount, items];
}

