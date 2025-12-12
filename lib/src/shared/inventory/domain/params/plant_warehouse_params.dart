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
  final String? plantCode;

  const WarehouseQueryParams({this.userId, this.plantCode});

  WarehouseQueryParams copyWith({String? userId, String? plantId}) {
    return WarehouseQueryParams(
      userId: userId ?? this.userId,
      plantCode: plantId ?? this.plantCode,
    );
  }

  @override
  List<Object?> get props => [userId, plantCode];
}


