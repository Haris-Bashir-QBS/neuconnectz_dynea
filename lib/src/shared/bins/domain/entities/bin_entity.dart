import 'package:equatable/equatable.dart';

class BinEntity extends Equatable {
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
  final double selectedQuantity;

  const BinEntity({
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
    this.selectedQuantity = 0.0,
  });

  BinEntity copyWith({
    double? selectedQuantity,
  }) {
    return BinEntity(
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
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
    );
  }

  @override
  List<Object?> get props => [
        id,
        absEntry,
        binCode,
        storageType,
        whsCode,
        storageSection,
        createdBy,
        updatedBy,
        createdDate,
        updatedDate,
        isActive,
        isArchived,
        selectedQuantity,
      ];
}



