import 'package:equatable/equatable.dart';

class WarehouseEntity extends Equatable {
  final String id;
  final String code;
  final String name;
  final bool isReceiver;
  final String? storageLocationCode;
  final String? plantCode;

  const WarehouseEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.isReceiver,
    this.storageLocationCode,
    this.plantCode,
  });

  @override
  List<Object?> get props =>
      [id, code, name, isReceiver, storageLocationCode, plantCode];
}


