part of 'stock_bloc.dart';

abstract class StockEvent extends Equatable {
  const StockEvent();

  @override
  List<Object?> get props => [];
}

class LoadStocksEvent extends StockEvent {
  final StockQueryParams params;
  final bool clearExisting;

  const LoadStocksEvent({
    required this.params,
    this.clearExisting = true,
  });

  @override
  List<Object?> get props => [params, clearExisting];
}

class LoadMoreStocksEvent extends StockEvent {
  const LoadMoreStocksEvent();
}

class ChangeStockFilterEvent extends StockEvent {
  final StockFilterType filterType;

  const ChangeStockFilterEvent(this.filterType);

  @override
  List<Object?> get props => [filterType];
}

class SearchStockEvent extends StockEvent {
  final String? query;

  const SearchStockEvent(this.query);

  @override
  List<Object?> get props => [query];
}

