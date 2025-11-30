import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_entity.dart';

class OutboundDeliverySalesResultEntity extends Equatable {
  final int totalCount;
  final List<OutboundDeliverySalesEntity> data;

  const OutboundDeliverySalesResultEntity({
    required this.totalCount,
    required this.data,
  });

  @override
  List<Object?> get props => [totalCount, data];
}

