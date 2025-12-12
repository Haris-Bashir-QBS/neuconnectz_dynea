part of 'stocks_by_storage_bin_bloc.dart';

abstract class StocksByStorageBinState {}

class StocksByStorageBinInitial extends StocksByStorageBinState {}

class StocksByStorageBinLoading extends StocksByStorageBinState {}

class StocksByStorageBinSuccess extends StocksByStorageBinState {
  final List<StockEntity> stocks;
  final int totalCount;

  StocksByStorageBinSuccess({
    required this.stocks,
    required this.totalCount,
  });
}

class StocksByStorageBinFailure extends StocksByStorageBinState {
  final String message;

  StocksByStorageBinFailure(this.message);
}



