import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/repositories/outbound_delivery_sto_item_repository.dart';

class GetCompletedStoItemsUseCase
    extends UseCase<List<OutboundDeliveryStoItemEntity>,
        OutboundDeliveryStoItemParams> {
  final OutboundDeliveryStoItemRepository repository;

  GetCompletedStoItemsUseCase(this.repository);

  @override
  Future<Either<Failure, List<OutboundDeliveryStoItemEntity>>> call(
    OutboundDeliveryStoItemParams params,
  ) async {
    return await repository.getCompletedStoItems(params: params);
  }
}


