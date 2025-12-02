import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/stocks_by_storage_bin_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/usecases/get_stocks_by_storage_bin_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_entity.dart';

part 'stocks_by_storage_bin_event.dart';
part 'stocks_by_storage_bin_state.dart';

class StocksByStorageBinBloc
    extends Bloc<StocksByStorageBinEvent, StocksByStorageBinState> {
  StocksByStorageBinBloc({required this.useCase})
    : super(StocksByStorageBinInitial()) {
    on<LoadStocksByStorageBinEvent>(_onLoadStocks);
  }

  final GetStocksByStorageBinUseCase useCase;

  Future<void> _onLoadStocks(
    LoadStocksByStorageBinEvent event,
    Emitter<StocksByStorageBinState> emit,
  ) async {
    emit(StocksByStorageBinLoading());

    final result = await useCase(event.params);

    result.fold(
      (failure) => emit(StocksByStorageBinFailure(failure.message)),
      (data) => emit(
        StocksByStorageBinSuccess(
          stocks: data.items,
          totalCount: data.totalCount,
        ),
      ),
    );
  }
}
