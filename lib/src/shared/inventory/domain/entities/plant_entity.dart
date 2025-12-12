import 'package:equatable/equatable.dart';

class PlantEntity extends Equatable {
  final String id;
  final String code;
  final String name;
  final String companyCode;

  const PlantEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.companyCode,
  });

  @override
  List<Object?> get props => [id, code, name, companyCode];
}




