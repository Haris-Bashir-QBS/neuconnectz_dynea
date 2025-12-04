import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/create_stock_transfer_order_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/get_and_update_stocks_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_list_params.dart';

abstract class OutboundDeliveryStoEvent extends Equatable {
  const OutboundDeliveryStoEvent();

  @override
  List<Object> get props => [];
}

class LoadOutboundDeliveryStoListEvent extends OutboundDeliveryStoEvent {
  final OutboundDeliveryStoListParams params;
  final bool refresh;

  const LoadOutboundDeliveryStoListEvent({
    required this.params,
    this.refresh = false,
  });

  @override
  List<Object> get props => [params, refresh];
}

class CreateStockTransferOrderEvent extends OutboundDeliveryStoEvent {
  final CreateStockTransferOrderRequestModel request;

  const CreateStockTransferOrderEvent({required this.request});

  @override
  List<Object> get props => [request];
}

class GetAndUpdateStocksFromSapEvent extends OutboundDeliveryStoEvent {
  final GetAndUpdateStocksRequestModel request;

  const GetAndUpdateStocksFromSapEvent({required this.request});

  @override
  List<Object> get props => [request];
}
