part of 'purchase_order_grn_putaway_bloc.dart';

abstract class PurchaseOrderGrnPutAwayState extends Equatable {
  const PurchaseOrderGrnPutAwayState();

  @override
  List<Object?> get props => [];
}

class PurchaseOrderPutAwayInitial extends PurchaseOrderGrnPutAwayState {}

class CreatePurchaseOrderGrnPutAwayLoading
    extends PurchaseOrderGrnPutAwayState {}

class CreatePurchaseOrderGrnPutAwaySuccess
    extends PurchaseOrderGrnPutAwayState {
  final ApiResponse<bool> response;

  const CreatePurchaseOrderGrnPutAwaySuccess({required this.response});
}

class CreatePurchaseOrderGrnPutAwayFailure
    extends PurchaseOrderGrnPutAwayState {
  final String message;

  const CreatePurchaseOrderGrnPutAwayFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
