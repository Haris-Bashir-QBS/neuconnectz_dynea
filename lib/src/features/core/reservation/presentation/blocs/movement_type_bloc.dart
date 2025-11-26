import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/movement_type_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/movement_type_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/usecases/get_movement_types_usecase.dart';

part 'movement_type_event.dart';
part 'movement_type_state.dart';

class MovementTypeBloc extends Bloc<MovementTypeEvent, MovementTypeState> {
  final GetMovementTypesUseCase getMovementTypesUseCase;

  MovementTypeBloc({required this.getMovementTypesUseCase})
      : super(MovementTypeInitial()) {
    on<LoadMovementTypesEvent>(_onLoadMovementTypes);
  }

  Future<void> _onLoadMovementTypes(
    LoadMovementTypesEvent event,
    Emitter<MovementTypeState> emit,
  ) async {
    emit(MovementTypeLoading());

    final params = MovementTypeQueryParams(
      keyword: event.keyword,
      lastCount: event.lastCount,
      skipRecords: 0,
    );

    final result = await getMovementTypesUseCase.call(params);

    result.fold(
      (failure) => emit(MovementTypeFailure(message: failure.message)),
      (success) => emit(
        MovementTypeSuccess(
          items: success.items,
          totalCount: success.totalCount,
        ),
      ),
    );
  }
}


