import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_items_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/repositories/outbound_delivery_sales_repository.dart';

class GetCompletedOutboundDeliverySalesItemsUseCase {
  final OutboundDeliverySalesRepository repository;

  GetCompletedOutboundDeliverySalesItemsUseCase(this.repository);

  Future<Either<Failure, OutboundDeliverySalesItemsResultEntity>> call(
    OutboundDeliverySalesItemParams params,
  ) {
    return repository.listCompletedSalesOrderItems(params);
  }
}



