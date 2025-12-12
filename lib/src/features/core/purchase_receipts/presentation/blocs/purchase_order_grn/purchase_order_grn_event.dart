part of 'purchase_order_grn_bloc.dart';

class PurchaseOrderGrnEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPendingPurchaseOrderGrnEvent extends PurchaseOrderGrnEvent {
  final PurchaseOrderGrnListParams params;
  final bool refresh;

  LoadPendingPurchaseOrderGrnEvent({
    required this.params,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [params, refresh];
}

class LoadPurchaseOrderGrnItemsEvent extends PurchaseOrderGrnEvent {
  final PurchaseOrderGrnItemQueryParams params;
  final bool refresh;

  LoadPurchaseOrderGrnItemsEvent({required this.params, this.refresh = false});

  @override
  List<Object?> get props => [params, refresh];
}

class LoadCompletedPurchaseOrderGrnItemsEvent extends PurchaseOrderGrnEvent {
  final PurchaseOrderGrnItemQueryParams params;
  final bool refresh;

  LoadCompletedPurchaseOrderGrnItemsEvent({
    required this.params,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [params, refresh];
}

class DeletePutAwayOfPurchaseOrderGrnEvent extends PurchaseOrderGrnEvent {
  final int docNum;

  DeletePutAwayOfPurchaseOrderGrnEvent({required this.docNum});

  @override
  List<Object?> get props => [docNum];
}