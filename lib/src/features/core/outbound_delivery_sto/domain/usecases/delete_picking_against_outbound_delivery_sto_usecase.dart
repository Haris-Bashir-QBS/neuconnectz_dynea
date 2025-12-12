import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/repositories/outbound_delivery_sto_item_repository.dart';

class DeletePickingAgainstOutboundDeliveryStoUseCase {
  final OutboundDeliveryStoItemRepository repository;

  DeletePickingAgainstOutboundDeliveryStoUseCase(this.repository);

  Future<Either<Failure, ApiResponse<bool>>> call({required int docNum}) async {
    return await repository.deletePickingAgainstOutboundDeliverySto(docNum: docNum);
  }
}

