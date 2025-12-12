import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/repositories/production_receipt_repository.dart';

part 'production_receipt_event.dart';
part 'production_receipt_state.dart';

class ProductionReceiptBloc
    extends Bloc<ProductionReceiptEvent, ProductionReceiptState> {
  final ProductionReceiptRepository repository;

  ProductionReceiptBloc({required this.repository})
      : super(const ProductionReceiptState.initial()) {
    on<LoadProductionReceiptsEvent>(_onLoadHeaders);
    on<LoadProductionReceiptItemsEvent>(_onLoadItems);
  }

  Future<void> _onLoadHeaders(
    LoadProductionReceiptsEvent event,
    Emitter<ProductionReceiptState> emit,
  ) async {
    final current = state;
    emit(
      current.copyWith(
        isHeadersLoading: event.reset ? true : false,
        isLoadingMore: event.reset ? false : true,
        headersError: null,
      ),
    );
    final result =
        await repository.listProductionReceiptsFromSAP(event.params);
    result.fold(
      (failure) => emit(
        current.copyWith(
          isHeadersLoading: false,
          isLoadingMore: false,
          headersError: failure.message,
        ),
      ),
      (data) => emit(
        current.copyWith(
          isHeadersLoading: false,
          isLoadingMore: false,
          headers: event.reset
              ? data.items
              : [...current.headers, ...data.items],
          headersTotalRows: data.totalRows,
        ),
      ),
    );
  }

  Future<void> _onLoadItems(
    LoadProductionReceiptItemsEvent event,
    Emitter<ProductionReceiptState> emit,
  ) async {
    final current = state;
    emit(
      current.copyWith(
        isItemsLoading: event.reset ? true : false,
        isLoadingMore: event.reset ? false : true,
        itemsError: null,
      ),
    );
    final result =
        await repository.listProductionReceiptItemsFromSAP(event.params);
    result.fold(
      (failure) => emit(
        current.copyWith(
          isItemsLoading: false,
          isLoadingMore: false,
          itemsError: failure.message,
        ),
      ),
      (data) => emit(
        current.copyWith(
          isItemsLoading: false,
          isLoadingMore: false,
          items: event.reset ? data.items : [...current.items, ...data.items],
          itemsTotalRows: data.totalRows,
        ),
      ),
    );
  }
}

