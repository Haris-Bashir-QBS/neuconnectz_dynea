import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';

class BinModel {
  final String id;
  final String absEntry;
  final String binCode;
  final String storageType;
  final String whsCode;
  final String storageSection;
  final String createdBy;
  final String updatedBy;
  final String createdDate;
  final String updatedDate;
  final bool isActive;
  final bool isArchived;

  const BinModel({
    required this.id,
    required this.absEntry,
    required this.binCode,
    required this.storageType,
    required this.whsCode,
    required this.storageSection,
    required this.createdBy,
    required this.updatedBy,
    required this.createdDate,
    required this.updatedDate,
    required this.isActive,
    required this.isArchived,
  });

  factory BinModel.fromJson(Map<String, dynamic> json) {
    return BinModel(
      id: json['id'] ?? '',
      absEntry: json['absEntry'] ?? '',
      binCode: json['binCode'] ?? '',
      storageType: json['storageType'] ?? '',
      whsCode: json['whsCode'] ?? '',
      storageSection: json['storageSection'] ?? '',
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      isActive: json['isActive'] ?? false,
      isArchived: json['isArchived'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'absEntry': absEntry,
      'binCode': binCode,
      'storageType': storageType,
      'whsCode': whsCode,
      'storageSection': storageSection,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'isActive': isActive,
      'isArchived': isArchived,
    };
  }

  BinEntity toEntity() => BinEntity(
        id: id,
        absEntry: absEntry,
        binCode: binCode,
        storageType: storageType,
        whsCode: whsCode,
        storageSection: storageSection,
        createdBy: createdBy,
        updatedBy: updatedBy,
        createdDate: createdDate,
        updatedDate: updatedDate,
        isActive: isActive,
        isArchived: isArchived,
        selectedQuantity: 0.0,
      );
}

