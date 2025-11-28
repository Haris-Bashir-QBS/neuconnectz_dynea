import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/create_picking_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/usecases/create_picking_against_reservation_usecase.dart';

part 'picking_event.dart';
part 'picking_state.dart';

class PickingBloc extends Bloc<PickingEvent, PickingState> {
  final CreatePickingAgainstReservationUseCase
      createPickingAgainstReservationUseCase;

  PickingBloc({
    required this.createPickingAgainstReservationUseCase,
  }) : super(PickingInitial()) {
    on<CreatePickingEvent>(_onCreatePicking);
  }

  Future<void> _onCreatePicking(
    CreatePickingEvent event,
    Emitter<PickingState> emit,
  ) async {
    emit(CreatePickingLoading());

    final result = await createPickingAgainstReservationUseCase(event.request);

    result.fold(
      (failure) => emit(
        CreatePickingFailure(message: failure.message),
      ),
      (response) => emit(
        CreatePickingSuccess(response: response),
      ),
    );
  }
}

