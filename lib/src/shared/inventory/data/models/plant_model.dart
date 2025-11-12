import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';

class PlantModel {
  final String id;
  final String plantCode;
  final String plantName;
  final String companyCode;

  const PlantModel({
    required this.id,
    required this.plantCode,
    required this.plantName,
    required this.companyCode,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'] ?? '',
      plantCode: json['plantCode'] ?? '',
      plantName: json['plantName'] ?? '',
      companyCode: json['companyCode'] ?? '',
    );
  }

  PlantEntity toEntity() => PlantEntity(
    id: id,
    code: plantCode,
    name: plantName,
    companyCode: companyCode,
  );
}
