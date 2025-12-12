import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_entity.dart';

class InboundDeliveryItemResultEntity extends Equatable {
  final List<InboundDeliveryItemEntity> items;
  final int totalRows;

  const InboundDeliveryItemResultEntity({
    required this.items,
    required this.totalRows,
  });

  @override
  List<Object?> get props => [items, totalRows];
}



