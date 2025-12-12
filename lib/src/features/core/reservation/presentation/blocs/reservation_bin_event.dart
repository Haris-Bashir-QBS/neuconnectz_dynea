part of 'reservation_bin_bloc.dart';

class ReservationBinEvent extends Equatable {
  const ReservationBinEvent();

  @override
  List<Object?> get props => [];
}

class LoadWarehouseBinsByMaterialEvent extends ReservationBinEvent {
  final String warehouseCode;
  final String material;

  const LoadWarehouseBinsByMaterialEvent({
    required this.warehouseCode,
    required this.material,
  });

  @override
  List<Object?> get props => [warehouseCode, material];
}



