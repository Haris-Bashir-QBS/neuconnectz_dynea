import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/models/create_putaway_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/usecases/create_putaway_against_gr_usecase.dart';

part 'putaway_event.dart';
part 'putaway_state.dart';

class PutAwayBloc extends Bloc<PutAwayEvent, PutAwayState> {
  final CreatePutAwayAgainstGrUseCase createPutAwayUseCase;

  PutAwayBloc({required this.createPutAwayUseCase})
      : super(PutAwayInitial()) {
    on<CreatePutAwayAgainstGrEvent>(_onCreatePutAway);
  }

  Future<void> _onCreatePutAway(
    CreatePutAwayAgainstGrEvent event,
    Emitter<PutAwayState> emit,
  ) async {
    emit(CreatePutAwayLoading());
    final result = await createPutAwayUseCase(event.request);
    result.fold(
      (failure) => emit(CreatePutAwayFailure(message: failure.message)),
      (_) => emit(CreatePutAwaySuccess()),
    );
  }
}

