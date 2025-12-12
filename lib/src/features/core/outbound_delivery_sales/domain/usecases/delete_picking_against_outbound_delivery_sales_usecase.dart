import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/repositories/outbound_delivery_sales_repository.dart';

class DeletePickingAgainstOutboundDeliverySalesUseCase {
  final OutboundDeliverySalesRepository repository;

  DeletePickingAgainstOutboundDeliverySalesUseCase(this.repository);

  Future<Either<Failure, ApiResponse<bool>>> call({required int docNum}) async {
    return await repository.deletePickingAgainstOutboundDeliverySales(docNum: docNum);
  }
}

