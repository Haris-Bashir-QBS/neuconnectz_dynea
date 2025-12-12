part of 'stocks_by_storage_bin_bloc.dart';

class LoadStocksByStorageBinEvent extends StocksByStorageBinEvent {
  final StocksByStorageBinParams params;

  LoadStocksByStorageBinEvent({required this.params});
}

abstract class StocksByStorageBinEvent {}



