import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/data/models/create_putaway_inbound_sto_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/repositories/inbound_delivery_repository.dart';

part 'putaway_event.dart';
part 'putaway_state.dart';

class InboundDeliveryPutAwayBloc
    extends Bloc<InboundDeliveryPutAwayEvent, InboundDeliveryPutAwayState> {
  final InboundDeliveryRepository repository;

  InboundDeliveryPutAwayBloc({required this.repository})
      : super(InboundDeliveryPutAwayInitial()) {
    on<CreatePutAwayAgainstInboundDeliveryEvent>(_onCreatePutAway);
  }

  Future<void> _onCreatePutAway(
    CreatePutAwayAgainstInboundDeliveryEvent event,
    Emitter<InboundDeliveryPutAwayState> emit,
  ) async {
    emit(CreatePutAwayLoading());
    final result = await repository.createPutAwayAgainstInboundDelivery(event.request);
    result.fold(
      (failure) => emit(CreatePutAwayFailure(message: failure.message)),
      (ApiResponse<bool> response) =>
          emit(CreatePutAwaySuccess(response: response)),
    );
  }
}


