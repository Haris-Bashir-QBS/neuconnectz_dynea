part of 'plant_warehouse_bloc.dart';

class WarehouseAndPlantState extends Equatable {
  final List<PlantEntity> plants;
  final List<WarehouseEntity> warehouses;
  final bool isLoading;
  final String? errorMessage;

  const WarehouseAndPlantState({
    this.plants = const [],
    this.warehouses = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  WarehouseAndPlantState copyWith({
    List<PlantEntity>? plants,
    List<WarehouseEntity>? warehouses,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WarehouseAndPlantState(
      plants: plants ?? this.plants,
      warehouses: warehouses ?? this.warehouses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  @override
  List<Object?> get props => [plants, warehouses, isLoading, errorMessage];
}


