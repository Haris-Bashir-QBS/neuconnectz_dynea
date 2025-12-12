part of 'purchase_order_grn_putaway_bloc.dart';

abstract class PurchaseOrderGrnPutAwayEvent extends Equatable {
  const PurchaseOrderGrnPutAwayEvent();

  @override
  List<Object?> get props => [];
}

class CreatePutAwayAgainstGrEvent extends PurchaseOrderGrnPutAwayEvent {
  final CreatePurchaseOrderGrnPutAwayRequestModel request;

  const CreatePutAwayAgainstGrEvent({required this.request});

  @override
  List<Object?> get props => [request];
}
