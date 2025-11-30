import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/repositories/outbound_delivery_sales_repository.dart';

class GetOutboundDeliverySalesListUseCase {
  final OutboundDeliverySalesRepository repository;

  GetOutboundDeliverySalesListUseCase(this.repository);

  Future<Either<Failure, OutboundDeliverySalesResultEntity>> call(
    OutboundDeliverySalesListParams params,
  ) {
    return repository.listAllSalesOrderDocFromSAP(params);
  }
}

