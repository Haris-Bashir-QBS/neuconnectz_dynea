import 'package:equatable/equatable.dart';

class MovementTypeEntity extends Equatable {
  final String id;
  final String movementType;
  final String description;

  const MovementTypeEntity({
    required this.id,
    required this.movementType,
    required this.description,
  });

  @override
  List<Object?> get props => [id, movementType, description];
}



