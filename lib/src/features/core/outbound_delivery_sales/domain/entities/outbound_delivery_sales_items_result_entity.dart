import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_item_entity.dart';

class OutboundDeliverySalesItemsResultEntity extends Equatable {
  final int totalCount;
  final List<OutboundDeliverySalesItemEntity> data;

  const OutboundDeliverySalesItemsResultEntity({
    required this.totalCount,
    required this.data,
  });

  @override
  List<Object?> get props => [totalCount, data];
}

