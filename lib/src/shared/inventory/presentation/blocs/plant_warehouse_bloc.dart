import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:neuconnectz_dynea/src/core/services/session_service.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/params/plant_warehouse_params.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/usecases/get_user_plants_usecase.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/usecases/get_user_warehouses_usecase.dart';

part 'plant_warehouse_event.dart';
part 'plant_warehouse_state.dart';

class PlantWarehouseBloc
    extends Bloc<PlantWarehouseEvent, WarehouseAndPlantState> {
  final GetUserPlantsUseCase getUserPlantsUseCase;
  final GetUserWarehousesUseCase getUserWarehousesUseCase;

  PlantWarehouseBloc({
    required this.getUserPlantsUseCase,
    required this.getUserWarehousesUseCase,
  }) : super(const WarehouseAndPlantState()) {
    on<LoadPlantsEvent>(_onLoadPlants);
    on<LoadWarehousesEvent>(_onLoadWarehouses);
    on<SelectPlantEvent>(_onSelectPlant);
  }

  Future<void> _onLoadPlants(
    LoadPlantsEvent event,
    Emitter<WarehouseAndPlantState> emit,
  ) async {
    final userId = event.params.userId ?? SessionManager.userId;

    if (userId == null || userId.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Unable to fetch plants. User not available.',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getUserPlantsUseCase(
      event.params.copyWith(userId: userId),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (plants) {
        emit(state.copyWith(isLoading: false, plants: plants));
      },
    );
  }

  Future<void> _onLoadWarehouses(
    LoadWarehousesEvent event,
    Emitter<WarehouseAndPlantState> emit,
  ) async {
    final userId = event.params.userId ?? SessionManager.userId;

    if (userId == null || userId.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Unable to fetch warehouses. User not available.',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getUserWarehousesUseCase(
      event.params.copyWith(userId: userId),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (warehouses) {
        emit(state.copyWith(isLoading: false, warehouses: warehouses));
      },
    );
  }

  Future<void> _onSelectPlant(
    SelectPlantEvent event,
    Emitter<WarehouseAndPlantState> emit,
  ) async {
    emit(state.copyWith(warehouses: []));
    add(LoadWarehousesEvent(params: event.params));
  }
}
