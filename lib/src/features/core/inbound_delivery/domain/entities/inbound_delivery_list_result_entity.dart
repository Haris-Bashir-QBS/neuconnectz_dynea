import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_list_item_entity.dart';

class InboundDeliveryListResultEntity extends Equatable {
  final List<InboundDeliveryEntity> items;
  final int totalRows;

  const InboundDeliveryListResultEntity({
    required this.items,
    required this.totalRows,
  });

  @override
  List<Object?> get props => [items, totalRows];
}



