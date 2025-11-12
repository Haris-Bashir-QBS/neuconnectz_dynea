import 'package:equatable/equatable.dart';

class PlantQueryParams extends Equatable {
  final String? userId;

  const PlantQueryParams({this.userId});

  PlantQueryParams copyWith({String? userId}) {
    return PlantQueryParams(userId: userId ?? this.userId);
  }

  @override
  List<Object?> get props => [userId];
}

class WarehouseQueryParams extends Equatable {
  final String? userId;
  final String? plantId;

  const WarehouseQueryParams({this.userId, this.plantId});

  WarehouseQueryParams copyWith({String? userId, String? plantId}) {
    return WarehouseQueryParams(
      userId: userId ?? this.userId,
      plantId: plantId ?? this.plantId,
    );
  }

  @override
  List<Object?> get props => [userId, plantId];
}


