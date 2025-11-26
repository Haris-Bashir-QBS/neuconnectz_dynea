import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/movement_type_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/movement_type_result_entity.dart';

class MovementTypeResponseModel {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final MovementTypeDataModel? data;
  final List<dynamic> exception;

  MovementTypeResponseModel({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    required this.exception,
  });

  factory MovementTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return MovementTypeResponseModel(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? MovementTypeDataModel.fromJson(
                json['data'] as Map<String, dynamic>,
              )
              : null,
      exception: json['exception'] ?? [],
    );
  }

  MovementTypeResultEntity toEntity() {
    return MovementTypeResultEntity(
      totalCount: data?.totalCount ?? 0,
      items: data?.data.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

class MovementTypeDataModel {
  final int totalCount;
  final List<MovementTypeModel> data;

  MovementTypeDataModel({
    required this.totalCount,
    required this.data,
  });

  factory MovementTypeDataModel.fromJson(Map<String, dynamic> json) {
    return MovementTypeDataModel(
      totalCount: json['totalCount'] ?? 0,
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((e) => MovementTypeModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class MovementTypeModel {
  final String id;
  final String movementType;
  final String description;

  MovementTypeModel({
    required this.id,
    required this.movementType,
    required this.description,
  });

  factory MovementTypeModel.fromJson(Map<String, dynamic> json) {
    return MovementTypeModel(
      id: json['id'] ?? '',
      movementType: json['movementType'] ?? '',
      description: json['description'] ?? '',
    );
  }

  MovementTypeEntity toEntity() => MovementTypeEntity(
        id: id,
        movementType: movementType,
        description: description,
      );
}

