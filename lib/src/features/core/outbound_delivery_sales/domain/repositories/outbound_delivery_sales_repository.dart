import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_items_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_list_params.dart';

abstract class OutboundDeliverySalesRepository {
  Future<Either<Failure, OutboundDeliverySalesResultEntity>>
      listAllSalesOrderDocFromSAP(
    OutboundDeliverySalesListParams params,
  );

  Future<Either<Failure, OutboundDeliverySalesItemsResultEntity>>
      listAllSalesOrderItemFromSAP(
    OutboundDeliverySalesItemParams params,
  );

  Future<Either<Failure, OutboundDeliverySalesItemsResultEntity>>
      listCompletedSalesOrderItems(
    OutboundDeliverySalesItemParams params,
  );
}

