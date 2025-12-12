import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/repositories/inbound_delivery_repository.dart';

class DeletePutawayAgainstInboundDeliveryStoUseCase {
  final InboundDeliveryRepository repository;

  DeletePutawayAgainstInboundDeliveryStoUseCase(this.repository);

  Future<Either<Failure, ApiResponse<bool>>> call({required int docNum}) async {
    return await repository.deletePutawayAgainstInboundDeliverySto(docNum: docNum);
  }
}

