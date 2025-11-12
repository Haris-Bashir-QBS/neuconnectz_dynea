import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class WarehouseModel {
  final String id;
  final String whsCode;
  final String whsName;
  final bool isReceiver;
  final String? slcCode;
  final String? pCode;

  const WarehouseModel({
    required this.id,
    required this.whsCode,
    required this.whsName,
    required this.isReceiver,
    this.slcCode,
    this.pCode,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json['id'] ?? '',
      whsCode: json['whsCode'] ?? '',
      whsName: json['whsName'] ?? '',
      isReceiver: json['isReceiver'] ?? false,
      slcCode: json['slcCode'],
      pCode: json['pCode'],
    );
  }

  WarehouseEntity toEntity() => WarehouseEntity(
    id: id,
    code: whsCode,
    name: whsName,
    isReceiver: isReceiver,
    storageLocationCode: slcCode,
    plantCode: pCode,
  );
}
