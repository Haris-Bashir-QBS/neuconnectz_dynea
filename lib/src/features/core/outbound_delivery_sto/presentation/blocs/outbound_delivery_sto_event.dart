import 'package:equatable/equatable.dart';
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
