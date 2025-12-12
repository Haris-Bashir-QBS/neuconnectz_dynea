import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/data/models/create_sales_order_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/repositories/outbound_delivery_sales_repository.dart';

class CreateSalesOrderUseCase {
  final OutboundDeliverySalesRepository repository;

  CreateSalesOrderUseCase(this.repository);

  Future<Either<Failure, ApiResponse<bool>>> call({
    required CreateSalesOrderRequestModel request,
  }) {
    return repository.createSalesOrder(request: request);
  }
}



