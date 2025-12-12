part of 'production_receipt_bloc.dart';

abstract class ProductionReceiptEvent extends Equatable {
  const ProductionReceiptEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductionReceiptsEvent extends ProductionReceiptEvent {
  final ProductionReceiptListParams params;
  final bool reset;

  const LoadProductionReceiptsEvent({
    required this.params,
    this.reset = false,
  });

  @override
  List<Object?> get props => [params, reset];
}

class LoadProductionReceiptItemsEvent extends ProductionReceiptEvent {
  final ProductionReceiptItemQueryParams params;
  final bool refresh;

  const LoadProductionReceiptItemsEvent({
    required this.params,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [params, refresh];
}

class LoadCompletedProductionReceiptItemsEvent extends ProductionReceiptEvent {
  final ProductionReceiptItemQueryParams params;
  final bool refresh;

  const LoadCompletedProductionReceiptItemsEvent({
    required this.params,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [params, refresh];
}

class CreateProductionReceiptEvent extends ProductionReceiptEvent {
  final CreateProductionReceiptRequestModel request;

  const CreateProductionReceiptEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

