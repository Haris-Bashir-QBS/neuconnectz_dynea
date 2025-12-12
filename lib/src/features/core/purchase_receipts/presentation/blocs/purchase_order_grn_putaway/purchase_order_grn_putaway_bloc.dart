import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/models/purchase_order_grn_create_putaway_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/usecases/create_putaway_against_purchase_order_grn_usecase.dart';

part 'purchase_order_grn_putaway_event.dart';
part 'purchase_order_grn_putaway_state.dart';

class PurchaseOrderGrnPutAwayBloc
    extends Bloc<PurchaseOrderGrnPutAwayEvent, PurchaseOrderGrnPutAwayState> {
  final CreatePutAwayAgainstPurchaseOrderGrnUseCase createPutAwayUseCase;

  PurchaseOrderGrnPutAwayBloc({required this.createPutAwayUseCase})
    : super(PurchaseOrderPutAwayInitial()) {
    on<CreatePutAwayAgainstGrEvent>(_onCreatePutAway);
  }

  Future<void> _onCreatePutAway(
    CreatePutAwayAgainstGrEvent event,
    Emitter<PurchaseOrderGrnPutAwayState> emit,
  ) async {
    emit(CreatePurchaseOrderGrnPutAwayLoading());
    final result = await createPutAwayUseCase(event.request);
    result.fold(
      (failure) =>
          emit(CreatePurchaseOrderGrnPutAwayFailure(message: failure.message)),
      (ApiResponse<bool> response) =>
          emit(CreatePurchaseOrderGrnPutAwaySuccess(response: response)),
    );
  }
}
