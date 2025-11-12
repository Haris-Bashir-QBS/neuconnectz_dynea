part of 'plant_warehouse_bloc.dart';

abstract class PlantWarehouseEvent extends Equatable {
  const PlantWarehouseEvent();

  @override
  List<Object?> get props => [];
}

class LoadPlantsEvent extends PlantWarehouseEvent {
  final PlantQueryParams params;
  const LoadPlantsEvent({
    this.params = const PlantQueryParams(),
  });

  @override
  List<Object?> get props => [params];
}

class LoadWarehousesEvent extends PlantWarehouseEvent {
  final WarehouseQueryParams params;
  const LoadWarehousesEvent({
    this.params = const WarehouseQueryParams(),
  });

  @override
  List<Object?> get props => [params];
}

class SelectPlantEvent extends PlantWarehouseEvent {
  final WarehouseQueryParams params;
  const SelectPlantEvent({required this.params});

  @override
  List<Object?> get props => [params];
}


