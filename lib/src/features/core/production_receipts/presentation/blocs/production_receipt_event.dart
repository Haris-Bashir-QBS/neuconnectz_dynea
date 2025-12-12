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
  final bool reset;

  const LoadProductionReceiptItemsEvent({
    required this.params,
    this.reset = false,
  });

  @override
  List<Object?> get props => [params, reset];
}

